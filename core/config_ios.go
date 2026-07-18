//go:build ios && cgo

package main

import (
	"os"
	"regexp"
	"strings"

	"github.com/metacubex/mihomo/config"
	"github.com/metacubex/mihomo/hub/executor"
	"github.com/metacubex/mihomo/log"
)

// geodataRuleRE matches geodata rule lines — both inline format
// ("- GEOIP,CN,DIRECT") and quoted ("- 'GEOIP,CN,DIRECT'").
// Only strip GEOSITE/IP-ASN (large domain/ASN databases).
// Keep GEOIP — geoip.dat is smaller and may fit in the 50MB budget.
var geodataRuleRE = regexp.MustCompile(`(?im)^\s*- ?'?(GEOSITE|SRC-GEOIP|IP-ASN|SRC-IP-ASN),.*`)

// dnsGeodataKeyRE matches block-style DNS geodata keys (geosite only —
// geoip is kept to support GEOIP rules).
var dnsGeodataKeyRE = regexp.MustCompile(`(?im)^(\s+)(geosite)(:.*)?$`)

// dnsGeodataInlineRE strips geosite from inline DNS.  geoip and
// geoip-code are preserved so GEOIP rules can work.
var dnsGeodataInlineRE = regexp.MustCompile(`(geosite)\s*:\s*\[?[^\],}\s]*\]?,?\s*`)

func parseConfigPathFiltered(path string) (*config.Config, error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	ruleHits := len(geodataRuleRE.FindAll(b, -1))
	log.Infoln("[iOS filter] rule matches: %d", ruleHits)
	filtered := geodataRuleRE.ReplaceAll(b, []byte("# iOS: geodata rule filtered"))

	// Strip block-style DNS geodata keys (FlClash serializes DNS in block format).
	filtered = filterBlockDNSGeodata(filtered)
	// Also strip inline flow-style DNS geodata keys (original subscription format).
	filtered = dnsGeodataInlineRE.ReplaceAll(filtered, nil)

	log.Infoln("[iOS filter] config: %d→%d bytes", len(b), len(filtered))
	return executor.ParseWithBytes(filtered)
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
