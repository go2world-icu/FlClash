import Foundation

/// Box carried through the Go core as the opaque `void *callback` pointer.
///
/// Memory contract (mirrors the Android JNI global-ref lifecycle):
/// - `invokeAction`: Go invokes `result_func` once, then `release_object_func`
///   for every method except `message` → box is retained at the call site and
///   released by `release_object_func`.
/// - `quickSetup`: Go invokes `invokeResult` directly and never releases →
///   `selfReleasing` boxes release themselves after the first completion.
/// - event listener: retained until Go replaces/clears it via
///   `release_object_func`.
final class GoCallback {
    let selfReleasing: Bool
    let completion: (String) -> Void

    init(selfReleasing: Bool = false, completion: @escaping (String) -> Void) {
        self.selfReleasing = selfReleasing
        self.completion = completion
    }
}

/// Swift facade over the libclash.a c-archive exports (see libclash.h) and
/// the bride.h host callback function pointers.
enum ClashCore {
    private static var initialized = false

    /// Assign the bride.h function pointers. Must run before any other call.
    /// `protect_func` / `resolve_process_func` stay NULL on iOS — the hooks
    /// that would invoke them are compiled out (core/hook_ios.go).
    static func initialize() {
        guard !initialized else { return }
        initialized = true

        result_func = { iface, cstr in
            guard let iface, let cstr else { return }
            let data = String(cString: cstr)
            let box = Unmanaged<GoCallback>.fromOpaque(iface)
            let callback = box.takeUnretainedValue()
            callback.completion(data)
            if callback.selfReleasing {
                box.release()
            }
        }
        release_object_func = { obj in
            guard let obj else { return }
            Unmanaged<GoCallback>.fromOpaque(obj).release()
        }
        free_string_func = { ptr in
            free(ptr)
        }
    }

    /// Strings handed to Go are freed by Go through `free_string_func`,
    /// so they must be malloc-allocated.
    private static func goOwned(_ value: String) -> UnsafeMutablePointer<CChar> {
        strdup(value)
    }

    static func invoke(
        action json: String, completion: @escaping (String) -> Void
    ) {
        initialize()
        let box = Unmanaged.passRetained(GoCallback(completion: completion))
        invokeAction(box.toOpaque(), goOwned(json))
    }

    static func quickSetup(
        initParams: String, setupParams: String
    ) async -> String {
        initialize()
        return await withCheckedContinuation { continuation in
            let box = Unmanaged.passRetained(
                GoCallback(selfReleasing: true) { message in
                    continuation.resume(returning: message)
                })
            libclash.quickSetup(
                box.toOpaque(), goOwned(initParams), goOwned(setupParams))
        }
    }

    static func setEventListener(_ sink: ((String) -> Void)?) {
        initialize()
        if let sink {
            let box = Unmanaged.passRetained(GoCallback(completion: sink))
            libclash.setEventListener(box.toOpaque())
        } else {
            libclash.setEventListener(nil)
        }
    }

    @discardableResult
    static func startTun(
        fd: Int32, stack: String, address: String, dns: String
    ) -> Bool {
        initialize()
        // The TUN callback is only used by protect/resolve hooks (android);
        // pass a retained no-op box so the shared clear() path can release it.
        let box = Unmanaged.passRetained(GoCallback { _ in })
        return libclash.startTUN(
            box.toOpaque(), fd, goOwned(stack), goOwned(address), goOwned(dns)
        ) != 0
    }

    static func stopTun() {
        libclash.stopTun()
    }

    static func suspend(_ suspended: Bool) {
        libclash.suspend(suspended ? 1 : 0)
    }

    static func forceGC() {
        libclash.forceGC()
    }
}

/// Namespaced aliases for the raw C exports so wrapper methods with the same
/// name can call through without infinite recursion.
private enum libclash {
    static let quickSetup = PacketTunnel.quickSetup
    static let setEventListener = PacketTunnel.setEventListener
    static let startTUN = PacketTunnel.startTUN
    static let stopTun = PacketTunnel.stopTun
    static let suspend = PacketTunnel.suspend
    static let forceGC = PacketTunnel.forceGC
}
