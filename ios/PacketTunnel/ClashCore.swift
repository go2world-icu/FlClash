import Foundation

/// Swift facade over the Core, which `gomobile bind` turns into the
/// `Mobile.xcframework` both targets link.
///
/// It used to call a hand-built c-archive through C function pointers set at
/// startup; gomobile replaces those with the `MobileResultHandlerProtocol` interface and
/// a generated function per export, so there is no initialize step any more.
enum ClashCore {
    /// One handler per outstanding call. gomobile hands the Core's `[]byte`
    /// over as `Data`; throwing is how a handler reports a failure back into Go.
    ///
    /// gobind emits an abstract class *and* a protocol of the same name for a
    /// Go interface, so Swift renames the protocol to `<name>Protocol` and it
    /// is the one to conform to.
    final class ResultHandler: NSObject, MobileResultHandlerProtocol {
        private let completion: (String) -> Void

        init(_ completion: @escaping (String) -> Void) {
            self.completion = completion
        }

        func onResult(_ data: Data?) throws {
            completion(data.flatMap { String(data: $0, encoding: .utf8) } ?? "")
        }
    }

    static func invoke(action json: String, completion: @escaping (String) -> Void) {
        MobileInvokeMethod(json, ResultHandler(completion))
    }

    static func quickSetup(initParams: String, setupParams: String) async -> String {
        await withCheckedContinuation { continuation in
            MobileQuickSetup(
                initParams, setupParams,
                ResultHandler { continuation.resume(returning: $0) })
        }
    }

    static func setEventListener(_ sink: ((String) -> Void)?) {
        MobileSetEventListener(sink.map { ResultHandler($0) })
    }

    /// `options` carries the Core's TUN settings (`mtu`,
    /// `congestion-controller`); the Core rejects a descriptor it cannot
    /// unmarshal.
    @discardableResult
    static func startTun(
        fd: Int32, stack: String, address: String, dns: String, options: String
    ) -> Bool {
        // No protect/resolve handler: the packet tunnel provider owns the
        // routes, and iOS attributes no per-app traffic to hand back.
        MobileStartTun(fd, nil, stack, address, dns, options)
    }

    static func stopTun() {
        MobileStopTun()
    }

    static func suspend(_ suspended: Bool) {
        MobileSuspend(suspended)
    }

    static func forceGC() {
        MobileForceGC()
    }
}
