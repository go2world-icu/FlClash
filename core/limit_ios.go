//go:build ios && cgo

package main

import (
	"runtime/debug"
)

// The NE process has a hard 50MB jetsam limit. Keep the Go heap well below
// it so allocation spikes during config load trigger GC instead of a kill.
func init() {
	debug.SetMemoryLimit(25 << 20) // 25 MiB — NE has 50MB total, binary alone is 38MB
	debug.SetGCPercent(10)        // GC every 10% heap growth
}
