package core

import "github.com/metacubex/mihomo/tunnel"

// Suspend parks or resumes the tunnel. iOS drives it from the packet tunnel
// provider's sleep()/wake(): the NE process is frozen along with the device, so
// the tunnel has to drop its connections rather than hold them open.
//
// It lives in its own file so the fork has nothing to re-apply inside an
// upstream one — upstream has no iOS and no equivalent call.
func Suspend(suspended bool) bool {
	if suspended {
		tunnel.OnSuspend()
	} else {
		tunnel.OnRunning()
	}
	return true
}
