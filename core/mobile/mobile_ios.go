//go:build ios

// The iOS half of the gomobile binding, in the same package as the Android one
// so `gomobile bind` produces one API for both. It is the counterpart of the
// c-archive the fork used to build by hand: same calls, generated headers.
package mobile

import "core"

// ResultHandler receives one answer per call. Returning an error rather than
// panicking matters here for the same reason it does on Android: gobind turns a
// panic into a terminated process.
type ResultHandler interface {
	OnResult(data []byte) error
}

// TunHandler is Android's protect/resolve contract. iOS has neither — the
// packet tunnel provider owns the routes and attributes no per-app traffic — so
// the Core never calls it, but StartTun keeps the signature the two platforms
// share. Pass nil.
type TunHandler interface {
	Protect(fd int32) (bool, error)
	ResolveUid(protocol int32, source, target string) (int32, error)
	ResolvePackage(uid int32) (string, error)
}

// tunCallbacks satisfies core.TunCallbacks without ever reaching the host.
type tunCallbacks struct{}

func (tunCallbacks) Protect(fd int) bool { return true }

func (tunCallbacks) ResolveUid(protocol int, source, target string) int { return -1 }

func (tunCallbacks) ResolvePackage(uid int) string { return "" }

func InvokeMethod(data string, handler ResultHandler) {
	core.InvokeMethod(data, func(result []byte) {
		_ = handler.OnResult(result)
	})
}

func StartTun(fd int32, handler TunHandler, stack, address, dns, options string) bool {
	return core.StartTun(tunCallbacks{}, int(fd), stack, address, dns, options)
}

func QuickSetup(initParams, setupParams string, handler ResultHandler) {
	core.QuickSetup(initParams, setupParams, func(message string) {
		_ = handler.OnResult([]byte(message))
	})
}

func SetEventListener(handler ResultHandler) {
	if handler == nil {
		core.SetEventListener(nil)
		return
	}
	core.SetEventListener(func(data []byte) {
		_ = handler.OnResult(data)
	})
}

func StopTun() {
	core.StopTun()
}

func StartListener() {
	core.StartListener()
}

func StopListener() {
	core.StopListener()
}

func ForceGC() {
	core.ForceGC()
}

// Suspend parks the tunnel while the packet tunnel provider is frozen.
func Suspend(suspended bool) {
	core.Suspend(suspended)
}

func UpdateDns(value string) {
	core.UpdateDns(value)
}

func ResetNetwork() {
	core.ResetNetwork()
}

func GetTraffic(onlyStatisticsProxy bool) string {
	return core.GetTraffic(onlyStatisticsProxy)
}

func GetTotalTraffic(onlyStatisticsProxy bool) string {
	return core.GetTotalTraffic(onlyStatisticsProxy)
}
