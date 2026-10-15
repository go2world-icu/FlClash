//go:build !ios

package core

import (
	"github.com/metacubex/mihomo/config"
	"github.com/metacubex/mihomo/constant/features"
)

// loadConfigForPlatform is how common.go reaches the profile config; the
// default side just delegates. common.go is an upstream file, so everything
// platform-specific about loading a config lives behind this build tag pair
// instead of inside it.
func loadConfigForPlatform(path string) (*config.Config, error) {
	return loadConfig(path)
}

// Upstream skips the TUN listener on Android; every other target recreates it.
const recreateTunOnReload = !features.Android
