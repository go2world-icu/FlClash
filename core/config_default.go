//go:build !ios

package core

import (
	"github.com/metacubex/mihomo/config"
	"github.com/metacubex/mihomo/constant/features"
)

func loadConfigForPlatform(path string) (*config.Config, error) {
	return loadConfig(path)
}

func loadConfigForPlatformLimits(cfg *config.Config) *config.Config {
	return cfg
}

// Upstream skips the TUN listener on Android; every other target recreates it.
const recreateTunOnReload = !features.Android
