//go:build !(ios && cgo)

package main

import (
	"github.com/metacubex/mihomo/config"
	"github.com/metacubex/mihomo/hub/executor"
)

// parseConfigPathFiltered is a no-op on non-iOS — just delegate to the
// standard executor.  The symbol needs to exist because common.go
// references it, even though the runtime.GOOS guard prevents the call.
func parseConfigPathFiltered(path string) (*config.Config, error) {
	return executor.ParseWithPath(path)
}
