//go:build android && cgo

package main

import (
	"core/platform"
	"errors"
	"net"
	"sync"
	"sync/atomic"
	"syscall"

	"github.com/metacubex/mihomo/component/dialer"
	"github.com/metacubex/mihomo/component/process"
	"github.com/metacubex/mihomo/constant"
	"github.com/metacubex/mihomo/log"
)

// protectFailing tracks whether the last protect call was refused, so a stuck
// VpnService produces one log line rather than one per connection.
var protectFailing atomic.Bool

func (th *TunHandler) handleProtect(fd int) error {
	th.mu.RLock()
	defer th.mu.RUnlock()

	if th.listener == nil || th.callback == nil {
		// The tun routes are already live at this point (Android establishes
		// them before it hands the fd over), so an unprotected socket would be
		// routed straight back into the tunnel and hang until it times out.
		// Failing it here costs nothing and is at least visible.
		return errTunNotReady
	}

	if !protect(th.callback, fd) {
		if protectFailing.CompareAndSwap(false, true) {
			logError("VpnService.protect refused a socket; connections would loop back into the tunnel")
		}
		return errProtectRefused
	}

	if protectFailing.CompareAndSwap(true, false) {
		log.Infoln("[TUN] VpnService.protect recovered")
	}
	return nil
}

func (th *TunHandler) handleResolveProcess(source, target net.Addr) (int, string) {
	th.mu.RLock()
	defer th.mu.RUnlock()

	// A released callback is a null jobject, and JNI aborts on a call through one.
	if th.listener == nil || th.callback == nil {
		return -1, ""
	}
	var protocol int
	switch source.Network() {
	case "udp", "udp4", "udp6":
		protocol = syscall.IPPROTO_UDP
	case "tcp", "tcp4", "tcp6":
		protocol = syscall.IPPROTO_TCP
	}
	var uid int
	if sdkVersion.Load() < 29 {
		uid = platform.QuerySocketUidFromProcFs(source, target)
	} else {
		uid = resolveUid(th.callback, protocol, source.String(), target.String())
	}
	if uid < 0 {
		return -1, ""
	}
	return uid, resolvePackage(th.callback, uid)
}

var (
	installHooksOnce sync.Once
	activeTunHandler atomic.Pointer[TunHandler]
)

func installHooks() {
	installHooksOnce.Do(func() {
		dialer.DefaultSocketHook = func(network, address string, conn syscall.RawConn) error {
			if platform.ShouldBlockConnection() {
				return errBlocked
			}
			th := activeTunHandler.Load()
			if th == nil {
				return nil
			}
			var protectErr error
			if err := conn.Control(func(fd uintptr) {
				protectErr = th.handleProtect(int(fd))
			}); err != nil {
				return err
			}
			return protectErr
		}
		process.DefaultPackageNameResolver = func(metadata *constant.Metadata) (string, error) {
			th := activeTunHandler.Load()
			if th == nil {
				return "", process.ErrInvalidNetwork
			}
			src, dst := metadata.RawSrcAddr, metadata.RawDstAddr
			if src == nil || dst == nil {
				return "", process.ErrInvalidNetwork
			}
			// Everywhere else mihomo fills Uid from its own procfs lookup, the one Android took away.
			uid, packageName := th.handleResolveProcess(src, dst)
			if uid >= 0 {
				metadata.Uid = uint32(uid)
			}
			return packageName, nil
		}
	})
}

func (th *TunHandler) initHook() {
	installHooks()
	activeTunHandler.Store(th)
}

// Swap the handler, never the hook: mihomo nil-checks DefaultSocketHook once and
// dereferences it again when the socket is created, so clearing it mid-dial
// calls a nil func value.
func (th *TunHandler) removeHook() {
	activeTunHandler.CompareAndSwap(th, nil)
}

var (
	errBlocked        = errors.New("blocked: the process is out of file descriptors")
	errTunNotReady    = errors.New("blocked: the tun listener is not ready")
	errProtectRefused = errors.New("blocked: VpnService.protect refused the socket")
)
