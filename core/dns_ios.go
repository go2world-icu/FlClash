//go:build ios

package core

import (
	"github.com/metacubex/mihomo/log"
)

// On iOS system DNS is controlled through NEDNSSettings by the packet tunnel
// provider; mihomo's android-only system DNS patch does not apply — and does
// not even compile, since dns.UpdateSystemDNS is behind an android build tag.
func handleUpdateDns(value string) {
	log.Infoln("[DNS] updateDns ignored on ios: %s", value)
}
