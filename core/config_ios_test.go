//go:build ios

package core

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/metacubex/mihomo/config"
	"github.com/metacubex/mihomo/constant"
)

func iosConfigHome(t *testing.T, data string, geodata ...string) {
	t.Helper()
	previous := constant.Path.HomeDir()
	home := t.TempDir()
	constant.SetHomeDir(home)
	t.Cleanup(func() { constant.SetHomeDir(previous) })
	if err := os.WriteFile(filepath.Join(home, "config.yaml"), []byte(data), 0o600); err != nil {
		t.Fatal(err)
	}
	for _, name := range geodata {
		if err := os.WriteFile(filepath.Join(home, name), nil, 0o600); err != nil {
			t.Fatal(err)
		}
	}
}

func TestIOSConfigLimitsKeepsParsedConfigWhenGeodataAvailable(t *testing.T) {
	for _, test := range []struct {
		name    string
		geodata []string
	}{
		{"all", []string{geoSiteFileName, geoIpFileName, asnFileName}},
		{"without ASN", []string{geoSiteFileName, geoIpFileName}},
		{"without GeoIP", []string{geoSiteFileName, asnFileName}},
	} {
		t.Run(test.name, func(t *testing.T) {
			iosConfigHome(t, "mixed-port: 12345\n", test.geodata...)
			cfg := &config.Config{General: &config.General{MixedPort: 6789}}
			if got := loadConfigForPlatformLimits(cfg); got != cfg {
				t.Fatal("rebuilt an already parsed config without a geodata filter")
			}
		})
	}
}

func TestIOSConfigLimitsStillFiltersUnavailableGeodata(t *testing.T) {
	for _, test := range []struct {
		name    string
		rule    string
		geodata []string
	}{
		{"GeoSite", "GEOSITE,cn,DIRECT", []string{geoIpFileName, asnFileName}},
		{"GeoIP and ASN", "IP-ASN,12345,DIRECT", []string{geoSiteFileName}},
	} {
		t.Run(test.name, func(t *testing.T) {
			iosConfigHome(t, "mixed-port: 12345\nrules:\n  - "+test.rule+"\n  - MATCH,DIRECT\n", test.geodata...)
			cfg := &config.Config{General: &config.General{MixedPort: 6789}}
			got := loadConfigForPlatformLimits(cfg)
			if got == cfg {
				t.Fatal("did not filter a rule whose geodata is unavailable")
			}
			if got.General.MixedPort != 12345 || len(got.Rules) != 1 {
				t.Fatalf("filtered config port/rules = %d/%d", got.General.MixedPort, len(got.Rules))
			}
		})
	}
}
