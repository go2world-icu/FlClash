//go:build ios

package tun

import LC "github.com/metacubex/mihomo/listener/config"

// iOS is handed a raw fd by the packet tunnel provider, and only the msgX
// syscall paths let the gVisor stack move packets off it.
func applyPlatformTunOptions(options *LC.Tun) {
	options.RecvMsgX = true
	options.SendMsgX = true
}
