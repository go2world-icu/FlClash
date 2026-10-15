package main

import "github.com/metacubex/mihomo/tunnel"

// handleSuspend parks or resumes the tunnel. iOS drives it from the packet
// tunnel provider's sleep()/wake(): the NE process is frozen along with the
// device, so the tunnel has to drop its connections rather than hold them open.
//
// It lives here rather than in hub.go so that the fork's only change to that
// file stays out of the way of upstream merges. Its sole caller is lib.go.
func handleSuspend(suspended bool) bool {
	if suspended {
		tunnel.OnSuspend()
	} else {
		tunnel.OnRunning()
	}
	return true
}
