//go:build android

package tun

import LC "github.com/metacubex/mihomo/listener/config"

// Android reads and writes the VpnService fd with plain read/write.
func applyPlatformTunOptions(options *LC.Tun) {}
