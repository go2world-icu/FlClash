//go:build ios

package platform

import "net"

// The Android file descriptor ceiling and its probe are a workaround for
// Android's per-app fd limit; iOS has no equivalent, so the Core never blocks a
// connection and never has to ask the host about a socket's owner. Both exist
// only because core/lib.go — shared with Android — calls them.
func ShouldBlockConnection() bool {
	return false
}

func QuerySocketUidFromProcFs(source, _ net.Addr) int {
	return -1
}
