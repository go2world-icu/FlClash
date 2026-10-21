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

// loadConfigForPlatformLimits is the second half of the same seam: iOS only
// parses a config once it has checked the geodata databases its rules need,
// which takes the bytes rather than the parsed config.
func loadConfigForPlatformLimits(cfg *config.Config) *config.Config {
	return cfg
}

// Upstream skips the TUN listener on Android; every other target recreates it.
const recreateTunOnReload = !features.Android
