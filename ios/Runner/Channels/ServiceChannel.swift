import Flutter
import Foundation
import NetworkExtension
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
class ServiceChannel: NSObject {
    static let name = "com.follow.clash/service"
    static let providerBundleIdentifier = "uk.toworld.flclash.PacketTunnel"

    private let channel: FlutterMethodChannel
    private var manager: NETunnelProviderManager?
    private var statusObserver: NSObjectProtocol?
    private var eventTimer: Timer?
    private var eventSeq = 0
    private var pumpInFlight = false

    private var session: NETunnelProviderSession? {
        manager?.connection as? NETunnelProviderSession
    }

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: Self.name, binaryMessenger: messenger)
        super.init()
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call, result: result)
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
            result(persistSharedState(json))
            applyOnDemandRules()
        case "invokeAction":
            invokeAction(call.arguments as? String, result: result)
        case "start":
            start(result: result)
        case "stop":
            stop(result: result)
        case "getRunTime":
            result(runTimeMilliseconds())
        case "shutdown":
            result(true)
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
                self.attach(existing)
                result("")
                return
            }
            let manager = NETunnelProviderManager()
            let proto = NETunnelProviderProtocol()
            proto.providerBundleIdentifier = Self.providerBundleIdentifier
            proto.serverAddress = "FlClash"
            manager.protocolConfiguration = proto
            manager.localizedDescription = "FlClash"
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

    private func attach(_ manager: NETunnelProviderManager) {
        self.manager = manager
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

    private func invokeAction(_ json: String?, result: @escaping FlutterResult) {
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
                    result(text)
                }
            }
        } catch {
            result(nil)
        }
    }

    private func start(result: @escaping FlutterResult) {
        guard let manager else {
            result(false)
            return
        }
        manager.isEnabled = true
        manager.saveToPreferences { [weak self] error in
            guard let self else { return }
            if let error {
                self.reportCrash("saveToPreferences: \(error.localizedDescription)")
                result(false)
                return
            }
            manager.loadFromPreferences { error in
                if let error {
                    self.reportCrash("loadFromPreferences: \(error.localizedDescription)")
                    result(false)
                    return
                }
                do {
                    try self.session?.startVPNTunnel(options: nil)
                    result(true)
                } catch {
                    self.reportCrash("startVPNTunnel: \(error.localizedDescription)")
                    result(false)
                }
            }
        }
    }

    private func stop(result: @escaping FlutterResult) {
        session?.stopVPNTunnel()
        result(true)
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

    /// Reads the AccessControlProps from the persisted SharedState and applies
    /// NEOnDemandRules to the VPN manager so the tunnel auto-connects /
    /// disconnects based on WiFi SSID.
    private func applyOnDemandRules() {
        guard let manager else { return }
        let rules = buildOnDemandRules()
        manager.isOnDemandEnabled = !rules.isEmpty
        manager.onDemandRules = rules
        manager.saveToPreferences { _ in }
    }

    private func buildOnDemandRules() -> [NEOnDemandRule] {
        guard
            let data = try? Data(contentsOf: AppGroup.sharedStateURL),
            let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let vpnOptions = root["vpnOptions"] as? [String: Any],
            let accessControl = vpnOptions["accessControlProps"] as? [String: Any],
            let enabled = accessControl["enable"] as? Bool,
            enabled
        else {
            return []
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
        return rules
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
