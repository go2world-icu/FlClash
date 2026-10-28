import Flutter
import Foundation
import NetworkExtension
import Network
import dnssd
import os.log

/// NE-backed implementation of the `com.follow.clash/service` channel.
///
/// Mirrors the android `ServicePlugin` semantics consumed by
/// `lib/plugins/service.dart`:
/// - `init` loads/creates the NETunnelProviderManager
/// - `invokeAction` forwards Action JSON over `sendProviderMessage`
/// - `start`/`stop` toggle the tunnel
/// - `syncState`/`saveState` persist SharedState JSON into the App Group
/// - inbound `event` delivers core events (pumped from the NE ring buffer),
///   `crash` reports fatal errors, `status` reports NEVPNStatus transitions
///
/// It serves two channels. Upstream split the core calls onto their own
/// `com.follow.clash/core` channel (on a background queue) so the android UI
/// does not stall behind them; iOS has to answer on both names or every core
/// call throws `MissingPluginException` — `proxies`, `getIsInit`, the event
/// pump — while `ping` and `getCoreState` keep working, which is what makes
/// that failure hard to place.
class ServiceChannel: NSObject {
    static let name = "com.follow.clash/service"
    static let coreName = "com.follow.clash/core"
    static let providerBundleIdentifier =
        (Bundle.main.bundleIdentifier ?? "") + ".PacketTunnel"

    /// What Settings → VPN shows for this configuration. Read from the app's
    /// own Info.plist so the entry cannot drift from the app name the way a
    /// second literal would.
    static let displayName =
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String)
        ?? "ToWorld"

    private let channel: FlutterMethodChannel
    private let coreChannel: FlutterMethodChannel
    private var manager: NETunnelProviderManager?
    private var statusObserver: NSObjectProtocol?
    private var eventTimer: Timer?
    private var eventSeq = 0
    private var pumpInFlight = false
    private var runIntentRevision = 0
    private var onDemandSaveInFlight = false
    private var onDemandCompletions: [(Bool) -> Void] = []
    private var enableManagerRequested = false

    private var session: NETunnelProviderSession? {
        manager?.connection as? NETunnelProviderSession
    }

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: Self.name, binaryMessenger: messenger)
        coreChannel = FlutterMethodChannel(
            name: Self.coreName,
            binaryMessenger: messenger
        )
        super.init()
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call, result: result)
        }
        // Core calls arrive here now; the android side drains them off the
        // main thread, which iOS cannot do for `sendProviderMessage` anyway.
        coreChannel.setMethodCallHandler { [weak self] call, result in
            guard let self else {
                result(FlutterMethodNotImplemented)
                return
            }
            switch call.method {
            case "invokeMethod":
                self.invokeMethod(call.arguments as? String, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    deinit {
        if let observer = statusObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        eventTimer?.invalidate()
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        os_log("ServiceChannel.%{public}@ called", call.method)
        switch call.method {
        case "init":
            initManager(result: result)
        case "syncState", "saveState":
            let json = call.arguments as? String ?? "{}"
            let error = persistSharedState(json)
            guard error.isEmpty else {
                result(error)
                return
            }
            applyOnDemandRules { saved in
                result(saved ? "" : "Failed to save VPN on-demand preferences")
            }
        case "invokeMethod":
            invokeMethod(call.arguments as? String, result: result)
        case "start":
            start(result: result)
        case "stop":
            stop(result: result)
        case "getRunTime":
            result(runTimeMilliseconds())
        case "shutdown":
            result(true)
        case "setXboardDirectAddresses":
            setXboardDirectAddresses(call.arguments as? [String], result: result)
        case "resolveXboardHost":
            guard let host = call.arguments as? String,
                  !host.isEmpty, host.utf8.count <= 253
            else {
                result([])
                return
            }
            XBoardPhysicalDNS.resolve(host) { addresses in
                DispatchQueue.main.async { result(addresses) }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Manager lifecycle

    private func initManager(result: @escaping FlutterResult) {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            guard let self else { return }
            if let error {
                result(error.localizedDescription)
                return
            }
            if let existing = managers?.first(where: {
                ($0.protocolConfiguration as? NETunnelProviderProtocol)?
                    .providerBundleIdentifier == Self.providerBundleIdentifier
            }) {
                self.renameIfNeeded(existing)
                self.attach(existing)
                result("")
                return
            }
            let manager = NETunnelProviderManager()
            let proto = NETunnelProviderProtocol()
            proto.providerBundleIdentifier = Self.providerBundleIdentifier
            proto.serverAddress = Self.displayName
            manager.protocolConfiguration = proto
            manager.localizedDescription = Self.displayName
            manager.isEnabled = true
            manager.saveToPreferences { error in
                if let error {
                    result(error.localizedDescription)
                    return
                }
                // Reload so the connection object is usable.
                manager.loadFromPreferences { _ in
                    self.attach(manager)
                    result("")
                }
            }
        }
    }

    /// iOS persists the name with the configuration and reads it back from
    /// there, so an install that predates a rename keeps showing the old one in
    /// Settings until the profile is deleted. Rewrite it once instead — the
    /// in-memory manager carries the new values either way, so attach does not
    /// wait on the save.
    private func renameIfNeeded(_ manager: NETunnelProviderManager) {
        guard manager.localizedDescription != Self.displayName else { return }
        manager.localizedDescription = Self.displayName
        let proto = manager.protocolConfiguration as? NETunnelProviderProtocol
        proto?.serverAddress = Self.displayName
        manager.saveToPreferences { error in
            if let error {
                os_log(
                    "VPN rename failed: %{public}@",
                    error.localizedDescription
                )
            }
        }
    }

    private func attach(_ manager: NETunnelProviderManager) {
        self.manager = manager
        let defaults = UserDefaults(suiteName: AppGroup.identifier)
        if defaults?.object(forKey: AppGroup.vpnRunRequestedKey) == nil,
           manager.connection.status == .connected ||
               manager.connection.status == .connecting ||
               manager.connection.status == .reasserting
        {
            defaults?.set(true, forKey: AppGroup.vpnRunRequestedKey)
        }
        if let observer = statusObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        statusObserver = NotificationCenter.default.addObserver(
            forName: .NEVPNStatusDidChange,
            object: manager.connection,
            queue: .main
        ) { [weak self] _ in
            self?.handleStatusChange()
        }
        handleStatusChange()
    }

    private func handleStatusChange() {
        guard let session else { return }
        let status: String
        switch session.status {
        case .connected: status = "connected"
        case .connecting: status = "connecting"
        case .disconnecting: status = "disconnecting"
        case .disconnected: status = "disconnected"
        case .reasserting: status = "reasserting"
        case .invalid: status = "invalid"
        @unknown default: status = "unknown"
        }
        updateEventPump(connected: session.status == .connected)
        // Surface the NE-side failure reason into Dart (crash channel).
        if session.status == .disconnected, #available(iOS 16.0, *) {
            session.fetchLastDisconnectError { [weak self] error in
                guard let error else { return }
                DispatchQueue.main.async {
                    self?.reportCrash("tunnel: \(error.localizedDescription)")
                }
            }
        }
        let payload: [String: Any] = [
            "status": status,
            "runTime": runTimeMilliseconds(),
        ]
        if let data = try? JSONSerialization.data(withJSONObject: payload),
           let json = String(data: data, encoding: .utf8)
        {
            channel.invokeMethod("status", arguments: json)
        }
    }

    // MARK: - RPC bridge

    private func setXboardDirectAddresses(
        _ addresses: [String]?, result: @escaping FlutterResult
    ) {
        guard let addresses,
              !addresses.isEmpty,
              addresses.allSatisfy(AppGroup.validIPAddress),
              let defaults = UserDefaults(suiteName: AppGroup.identifier)
        else {
            result(false)
            return
        }
        let existing = defaults.stringArray(forKey: AppGroup.xboardDirectAddressesKey) ?? []
        let combined = Array(Set(existing + addresses)).sorted()
        guard combined.count <= 64 else {
            result(false)
            return
        }
        if combined == existing {
            result(true)
            return
        }

        if let session, session.status == .connected || session.status == .reasserting {
            let payload: [String: Any] = [
                "method": "setXboardDirectAddresses", "data": combined,
            ]
            guard let data = try? JSONSerialization.data(withJSONObject: payload) else {
                result(false)
                return
            }
            do {
                try session.sendProviderMessage(data) { response in
                    DispatchQueue.main.async {
                        let json = response.flatMap {
                            try? JSONSerialization.jsonObject(with: $0) as? [String: Any]
                        }
                        let applied = json?["ok"] as? Bool == true
                        if applied {
                            defaults.set(combined, forKey: AppGroup.xboardDirectAddressesKey)
                        }
                        result(applied)
                    }
                }
            } catch {
                result(false)
            }
        } else if session?.status == .connecting {
            result(false)
        } else {
            defaults.set(combined, forKey: AppGroup.xboardDirectAddressesKey)
            result(true)
        }
    }

    private func invokeMethod(_ json: String?, result: @escaping FlutterResult) {
        guard let json,
              let session,
              session.status == .connected || session.status == .reasserting,
              let data = json.data(using: .utf8)
        else {
            // Core unreachable — Dart treats nil as failure.
            result(nil)
            return
        }
        do {
            try session.sendProviderMessage(data) { response in
                DispatchQueue.main.async {
                    guard let response,
                          let text = String(data: response, encoding: .utf8)
                    else {
                        result(nil)
                        return
                    }
                    // The Dart side reads this channel as bytes — `invokeMethod<Uint8List>`,
                    // which is what the android plugin hands back. A Swift String makes
                    // that cast throw `type 'String' is not a subtype of type
                    // 'Uint8List?'`, so every call that reaches the core fails: no
                    // proxies, no events, while `ping` and `getCoreState` — answered by
                    // this extension without going near the core — keep working.
                    result(FlutterStandardTypedData(bytes: Data(text.utf8)))
                }
            }
        } catch {
            result(nil)
        }
    }

    private func start(result: @escaping FlutterResult) {
        guard manager != nil,
              let defaults = UserDefaults(suiteName: AppGroup.identifier)
        else {
            result(false)
            return
        }
        runIntentRevision += 1
        let revision = runIntentRevision
        let previousIntent = defaults.bool(forKey: AppGroup.vpnRunRequestedKey)
        defaults.set(true, forKey: AppGroup.vpnRunRequestedKey)
        enableManagerRequested = true
        applyOnDemandRules { [weak self] saved in
            guard let self, self.runIntentRevision == revision else {
                result(false)
                return
            }
            guard saved else {
                self.finishFailedStart(
                    previousIntent: previousIntent, defaults: defaults, result: result)
                return
            }
            self.startConfiguredTunnel(revision: revision) { started in
                guard self.runIntentRevision == revision else {
                    result(false)
                    return
                }
                if started {
                    result(true)
                } else {
                    self.finishFailedStart(
                        previousIntent: previousIntent, defaults: defaults,
                        result: result)
                }
            }
        }
    }

    private func finishFailedStart(
        previousIntent: Bool, defaults: UserDefaults,
        result: @escaping FlutterResult
    ) {
        defaults.set(previousIntent, forKey: AppGroup.vpnRunRequestedKey)
        applyOnDemandRules { _ in result(false) }
    }

    private func startConfiguredTunnel(
        revision: Int, completion: @escaping (Bool) -> Void
    ) {
        guard let manager else {
            completion(false)
            return
        }
        // A session that is already connected OR still connecting (relaunch,
        // on-demand, NE auto-restart, or the first start still in flight)
        // must NOT receive another startVPNTunnel — re-invoking it on a live
        // or pending session tears it down (connecting → disconnecting →
        // disconnected). Only start when the tunnel is fully idle.
        if let status = session?.status, status != .disconnected, status != .invalid {
            completion(true)
            return
        }
        manager.loadFromPreferences { [weak self] error in
            DispatchQueue.main.async {
                guard let self else {
                    completion(false)
                    return
                }
                guard self.runIntentRevision == revision else {
                    completion(false)
                    return
                }
                if let error {
                    self.reportCrash("loadFromPreferences: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                guard let session = self.session else {
                    completion(false)
                    return
                }
                if session.status != .disconnected && session.status != .invalid {
                    completion(true)
                    return
                }
                do {
                    try session.startVPNTunnel(options: nil)
                    completion(true)
                } catch {
                    self.reportCrash("startVPNTunnel: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }

    private func stop(result: @escaping FlutterResult) {
        runIntentRevision += 1
        let revision = runIntentRevision
        UserDefaults(suiteName: AppGroup.identifier)?
            .set(false, forKey: AppGroup.vpnRunRequestedKey)
        applyOnDemandRules { [weak self] saved in
            guard let self, self.runIntentRevision == revision else {
                result(false)
                return
            }
            self.session?.stopVPNTunnel()
            result(saved)
        }
    }

    /// Epoch milliseconds of the tunnel start (android `getRunTime` semantic:
    /// Dart restores it via `DateTime.fromMillisecondsSinceEpoch`); 0 = not running.
    private func runTimeMilliseconds() -> Int {
        guard let session, session.status == .connected,
              let date = session.connectedDate
        else {
            return 0
        }
        return Int(date.timeIntervalSince1970 * 1000)
    }

    // MARK: - On-Demand Rules

    /// Persist the requested run state as system-owned on-demand rules, with
    /// configured Wi-Fi exclusions taking precedence over the catch-all rule.
    private func applyOnDemandRules(completion: @escaping (Bool) -> Void) {
        onDemandCompletions.append(completion)
        saveOnDemandRulesIfNeeded()
    }

    private func saveOnDemandRulesIfNeeded() {
        guard !onDemandSaveInFlight else { return }
        guard let manager else {
            finishOnDemandUpdates(saved: false)
            return
        }
        let rules = buildOnDemandRules()
        let currentRules = manager.onDemandRules ?? []
        let unchanged = (!enableManagerRequested || manager.isEnabled) &&
            manager.isOnDemandEnabled == !rules.isEmpty &&
            currentRules.count == rules.count &&
            zip(currentRules, rules).allSatisfy { pair in
                ObjectIdentifier(type(of: pair.0)) == ObjectIdentifier(type(of: pair.1)) &&
                    pair.0.ssidMatch == pair.1.ssidMatch
            }
        if unchanged {
            enableManagerRequested = false
            finishOnDemandUpdates(saved: true)
            return
        }
        let enablingManager = enableManagerRequested
        enableManagerRequested = false
        if enablingManager {
            manager.isEnabled = true
        }
        manager.isOnDemandEnabled = !rules.isEmpty
        manager.onDemandRules = rules
        onDemandSaveInFlight = true
        manager.saveToPreferences { [weak self] error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.onDemandSaveInFlight = false
                if let error {
                    self.enableManagerRequested = enablingManager
                    os_log("VPN on-demand update failed: %{public}@", error.localizedDescription)
                    self.finishOnDemandUpdates(saved: false)
                    return
                }
                self.saveOnDemandRulesIfNeeded()
            }
        }
    }

    private func finishOnDemandUpdates(saved: Bool) {
        let completions = onDemandCompletions
        onDemandCompletions.removeAll()
        for completion in completions {
            completion(saved)
        }
    }

    private func buildOnDemandRules() -> [NEOnDemandRule] {
        guard UserDefaults(suiteName: AppGroup.identifier)?
            .bool(forKey: AppGroup.vpnRunRequestedKey) == true
        else {
            return []
        }
        guard
            let data = try? Data(contentsOf: AppGroup.sharedStateURL),
            let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let vpnOptions = root["vpnOptions"] as? [String: Any],
            let accessControl = vpnOptions["accessControlProps"] as? [String: Any],
            let enabled = accessControl["enable"] as? Bool,
            enabled
        else {
            return fallbackOnDemandRules()
        }
        let mode = accessControl["mode"] as? String ?? ""
        let acceptList = accessControl["acceptList"] as? [String] ?? []
        let rejectList = accessControl["rejectList"] as? [String] ?? []

        var rules: [NEOnDemandRule] = []
        switch mode {
        case "acceptSelected":
            // Connect only on listed SSIDs
            for ssid in acceptList where !ssid.isEmpty {
                let rule = NEOnDemandRuleConnect()
                rule.ssidMatch = [ssid]
                rules.append(rule)
            }
        case "rejectSelected":
            // Don't connect on listed SSIDs; connect on everything else
            for ssid in rejectList where !ssid.isEmpty {
                let rule = NEOnDemandRuleDisconnect()
                rule.ssidMatch = [ssid]
                rules.append(rule)
            }
            // Catch-all: connect on any other network
            if !rejectList.isEmpty {
                let catchAll = NEOnDemandRuleConnect()
                rules.append(catchAll)
            }
        default:
            break
        }
        return rules.isEmpty ? fallbackOnDemandRules() : rules
    }

    private func fallbackOnDemandRules() -> [NEOnDemandRule] {
        UserDefaults(suiteName: AppGroup.identifier)?
            .bool(forKey: AppGroup.vpnRunRequestedKey) == true
            ? [NEOnDemandRuleConnect()] : []
    }

    // MARK: - SharedState persistence

    private func persistSharedState(_ json: String) -> String {
        do {
            let url = AppGroup.sharedStateURL
            try FileManager.default.createDirectory(
                at: url.deletingLastPathComponent(),
                withIntermediateDirectories: true)
            try Data(json.utf8).write(to: url, options: .atomic)
            return ""
        } catch {
            return error.localizedDescription
        }
    }

    // MARK: - Event pump

    private func updateEventPump(connected: Bool) {
        if connected {
            guard eventTimer == nil else { return }
            eventSeq = 0
            let timer = Timer(timeInterval: 0.5, repeats: true) { [weak self] _ in
                self?.pumpEvents()
            }
            RunLoop.main.add(timer, forMode: .common)
            eventTimer = timer
        } else {
            eventTimer?.invalidate()
            eventTimer = nil
            pumpInFlight = false
        }
    }

    private func pumpEvents() {
        guard let session, session.status == .connected, !pumpInFlight else {
            return
        }
        let request: [String: Any] = ["method": "getEvents", "data": eventSeq]
        guard let data = try? JSONSerialization.data(withJSONObject: request)
        else {
            return
        }
        pumpInFlight = true
        do {
            try session.sendProviderMessage(data) { [weak self] response in
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.pumpInFlight = false
                    guard let response,
                          let root = try? JSONSerialization.jsonObject(
                              with: response) as? [String: Any]
                    else {
                        return
                    }
                    if let seq = root["seq"] as? Int {
                        self.eventSeq = seq
                    }
                    for event in root["events"] as? [String] ?? [] {
                        self.channel.invokeMethod("event", arguments: event)
                    }
                }
            }
        } catch {
            pumpInFlight = false
        }
    }

    private func reportCrash(_ message: String) {
        channel.invokeMethod("crash", arguments: message)
    }
}

private final class XBoardPhysicalDNS {
    private static let queue = DispatchQueue(label: "xboard.physical-dns")
    private let monitor = NWPathMonitor()
    private var queries: [DNSServiceRef] = []
    private var completion: (([String]) -> Void)?
    private var started = false

    static func resolve(_ host: String, completion: @escaping ([String]) -> Void) {
        let lookup = XBoardPhysicalDNS()
        lookup.completion = completion
        lookup.monitor.pathUpdateHandler = { path in
            guard !lookup.started, lookup.completion != nil else { return }
            lookup.started = true
            // A scoped query uses the physical interface's DNS, outside the VPN resolver.
            for interface in path.availableInterfaces where
                interface.type == .wifi || interface.type == .cellular
                || interface.type == .wiredEthernet
            {
                lookup.start(host, interface: UInt32(interface.index))
            }
            if lookup.queries.isEmpty { lookup.finish([]) }
        }
        lookup.monitor.start(queue: queue)
        queue.asyncAfter(deadline: .now() + 3) { lookup.finish([]) }
    }

    private func start(_ host: String, interface: UInt32) {
        var query: DNSServiceRef?
        let error = DNSServiceGetAddrInfo(
            &query, 0, interface, 0, host,
            { _, flags, _, error, _, address, _, context in
                guard error == kDNSServiceErr_NoError,
                      flags & UInt32(kDNSServiceFlagsAdd) != 0,
                      let address, let context
                else { return }
                var buffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                guard getnameinfo(
                    address, socklen_t(address.pointee.sa_len),
                    &buffer, socklen_t(buffer.count), nil, 0, NI_NUMERICHOST) == 0
                else { return }
                let lookup = Unmanaged<XBoardPhysicalDNS>.fromOpaque(context)
                    .takeUnretainedValue()
                lookup.finish([String(cString: buffer)])
            },
            Unmanaged.passUnretained(self).toOpaque())
        guard error == kDNSServiceErr_NoError, let query else { return }
        guard DNSServiceSetDispatchQueue(query, Self.queue) == kDNSServiceErr_NoError else {
            DNSServiceRefDeallocate(query)
            return
        }
        queries.append(query)
    }

    private func finish(_ addresses: [String]) {
        guard let completion else { return }
        self.completion = nil
        monitor.pathUpdateHandler = nil
        monitor.cancel()
        for query in queries { DNSServiceRefDeallocate(query) }
        queries.removeAll()
        completion(addresses)
    }
}
