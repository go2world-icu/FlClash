//go:build android

package core

import (
	"strings"
	"sync"
	"sync/atomic"

	"github.com/metacubex/mihomo/dns"
	"github.com/metacubex/mihomo/log"
)

// Android only: mihomo's UpdateSystemDNS lives behind an android build tag, so
// this has to sit behind the same one rather than in lib.go, which both mobile
// platforms share.
var (
	dnsUpdateMu  sync.Mutex
	dnsUpdateSeq atomic.Uint64
)

func handleUpdateDns(value string) {
	// mihomo turns the [""] that Split returns for no servers into a "udp://:"
	// nameserver, which keeps the system resolver off its default fallback.
	var addr []string
	if value != "" {
		addr = strings.Split(value, ",")
	}
	seq := dnsUpdateSeq.Add(1)
	safeGo("updateDns", func() {
		dnsUpdateMu.Lock()
		defer dnsUpdateMu.Unlock()
		if seq != dnsUpdateSeq.Load() {
			return
		}
		log.Infoln("[DNS] updateDns %s", value)
		dns.UpdateSystemDNS(addr)
		dns.FlushCacheWithDefaultResolver()
	})
}
