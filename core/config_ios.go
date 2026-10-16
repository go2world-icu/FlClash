//go:build ios

package core

import (
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/metacubex/mihomo/config"
	"github.com/metacubex/mihomo/constant"
	"github.com/metacubex/mihomo/hub/executor"
	"github.com/metacubex/mihomo/log"
)

// Rule lines that read a geodata database — both the inline format
// ("- GEOSITE,cn,DIRECT") and the quoted one ("- 'GEOSITE,cn,DIRECT'").
//
// These are only stripped when the database they need is missing; see
// parseConfigPathFiltered. The two families are separate because they read
// different files.
var geoSiteRuleRE = regexp.MustCompile(`(?im)^\s*- ?'?GEOSITE,.*`)

var ipGeodataRuleRE = regexp.MustCompile(`(?im)^\s*- ?'?(SRC-GEOIP|IP-ASN|SRC-IP-ASN),.*`)

// dnsGeodataKeyRE matches block-style DNS geodata keys (geosite only —
// geoip is kept to support GEOIP rules).
var dnsGeodataKeyRE = regexp.MustCompile(`(?im)^(\s+)(geosite)(:.*)?$`)

// dnsGeodataInlineRE strips geosite from inline DNS.  geoip and
// geoip-code are preserved so GEOIP rules can work.
var dnsGeodataInlineRE = regexp.MustCompile(`(geosite)\s*:\s*\[?[^\],}\s]*\]?,?\s*`)

// loadConfigForPlatform is how common.go reaches the profile config.
//
// A missing file is not an error here: the app only writes config.yaml after
// the tunnel is up (IosManager.onServiceStatus → applyProfile), so a fresh
// install must still boot — on the default config, until the real profile is
// applied once the tunnel reports connected.
func loadConfigForPlatform(path string) (*config.Config, error) {
	cfg, err := parseConfigPathFiltered(path)
	if os.IsNotExist(err) {
		return config.ParseRawConfig(config.DefaultRawConfig())
	}
	return cfg, err
}

// The packet tunnel provider owns the TUN device, so a listener reload must
// not recreate one — that would fight the NE for the interface.
const recreateTunOnReload = false

func parseConfigPathFiltered(path string) (*config.Config, error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	// The databases are bundled and written into the home directory — the App
	// Group, shared with the packet tunnel — by CoreController.initGeo, which
	// runs at app startup, long before a tunnel ever applies a config. So the
	// usual case is that they are all here and nothing is stripped.
	//
	// The stripping stays for the case where that write failed: a rule whose
	// database is missing sends mihomo off to download it, and a download that
	// fails fails the whole config — which reaches the user as a tunnel that
	// reports connected and then serves nothing.
	filtered := b
	if geodataMissing(geoSiteFileName) {
		log.Warnln("[iOS filter] %s missing; dropping GEOSITE rules and DNS geosite keys", geoSiteFileName)
		filtered = geoSiteRuleRE.ReplaceAll(filtered, []byte("# iOS: geosite rule dropped (database missing)"))
		// Block-style DNS geodata keys (FlClash serializes DNS in block format)…
		filtered = filterBlockDNSGeodata(filtered)
		// …and the inline flow-style ones from the original subscription format.
		filtered = dnsGeodataInlineRE.ReplaceAll(filtered, nil)
	}
	if geodataMissing(geoIpFileName) && geodataMissing(asnFileName) {
		log.Warnln("[iOS filter] %s and %s missing; dropping IP-ASN / SRC-GEOIP rules", geoIpFileName, asnFileName)
		filtered = ipGeodataRuleRE.ReplaceAll(filtered, []byte("# iOS: ip geodata rule dropped (database missing)"))
	}

	if len(filtered) != len(b) {
		log.Infoln("[iOS filter] config: %d→%d bytes", len(b), len(filtered))
	}
	return executor.ParseWithBytes(filtered)
}

// The names CoreController.initGeo writes into the home directory
// (lib/common/constant.dart). mihomo finds them case-insensitively.
const (
	geoSiteFileName = "GEOSITE.dat"
	geoIpFileName   = "GEOIP.dat"
	asnFileName     = "ASN.mmdb"
)

func geodataMissing(name string) bool {
	_, err := os.Stat(filepath.Join(constant.Path.HomeDir(), name))
	return err != nil
}

// filterBlockDNSGeodata removes geosite/geoip-code/geoip key-value pairs
// from block-style YAML DNS sections (fallback-filter, nameserver-policy).
func filterBlockDNSGeodata(in []byte) []byte {
	lines := strings.Split(string(in), "\n")
	var out []string
	inFallback := false
	inPolicy := false
	baseIndent := 0

	for i := 0; i < len(lines); i++ {
		line := lines[i]
		trimmed := strings.TrimSpace(line)
		indent := len(line) - len(strings.TrimLeft(line, " \t"))

		// Detect section entry
		if strings.HasPrefix(trimmed, "fallback-filter:") {
			inFallback = true
			inPolicy = false
			baseIndent = indent
			out = append(out, line)
			continue
		}
		if strings.HasPrefix(trimmed, "nameserver-policy:") {
			inFallback = false
			inPolicy = true
			baseIndent = indent
			out = append(out, line)
			continue
		}

		// Detect section exit (indentation back to parent level)
		if (inFallback || inPolicy) && line != "" && indent <= baseIndent && trimmed != "" {
			inFallback = false
			inPolicy = false
		}

		if inFallback || inPolicy {
			// Check if this line is a geodata key (block style: "    geosite:" or "    geosite:")
			if dnsGeodataKeyRE.MatchString(line) {
				// Drop this key line + any following indented value lines
				for i+1 < len(lines) {
					nextIndent := len(lines[i+1]) - len(strings.TrimLeft(lines[i+1], " \t"))
					if lines[i+1] != "" && nextIndent > indent && strings.TrimSpace(lines[i+1]) != "" {
						i++ // skip value line
					} else {
						break
					}
				}
				continue // drop the key line itself
			}
		}

		out = append(out, line)
	}
	return []byte(strings.Join(out, "\n"))
}
