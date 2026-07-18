//go:build ios && cgo

package main

import (
	"github.com/metacubex/mihomo/log"
)

// On iOS system DNS is controlled through NEDNSSettings by the packet tunnel
// provider; mihomo's android-only system DNS patch does not apply.
func handleUpdateDns(value string) {
	log.Infoln("[DNS] updateDns ignored on ios: %s", value)
}
