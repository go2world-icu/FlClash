//go:build ios && cgo

package main

// On iOS the core runs inside a NEPacketTunnelProvider. Sockets originating
// from the tunnel provider process are automatically excluded from the tunnel
// by the system, so no protect() hook is required, and per-connection process
// attribution is not possible for third-party apps.
func (th *TunHandler) initHook() {}

func (th *TunHandler) removeHook() {}
