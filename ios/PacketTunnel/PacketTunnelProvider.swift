import NetworkExtension
import os.log

let tunnelLog = Logger(subsystem: "uk.toworld.flclash.PacketTunnel", category: "tunnel")

class PacketTunnelProvider: NEPacketTunnelProvider {
    // Network constants — keep in sync with the android VpnService
    // (android/service/src/main/java/com/follow/clash/service/VpnService.kt).
    private static let address = "172.19.0.1"
    private static let addressPrefix = "172.19.0.1/30"
    private static let address6 = "fdfe:dcba:9876::1"
    private static let address6Prefix = "fdfe:dcba:9876::1/126"
    private static let dns = "172.19.0.2"
    private static let dns6 = "fdfe:dcba:9876::2"
    private static let netAny = "0.0.0.0"

    private var memoryPressureSource: DispatchSourceMemoryPressure?

    override func startTunnel(options: [String: NSObject]?) async throws {
        // Go panics and mihomo logs go to stderr, which is invisible in a NE
        // process — redirect both into the App Group so the app can read them.
        redirectStandardStreams()
        tunnelLog.notice("startTunnel, available memory: \(Self.availableMemoryMB()) MB")
        guard FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: AppGroup.identifier) != nil
        else {
            tunnelLog.error("App Group container unavailable — check entitlements")
            throw NSError(
                domain: "uk.toworld.flclash.PacketTunnel", code: 3,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "App Group \(AppGroup.identifier) unavailable"
                ])
        }
        let state = SharedStateStore.load()
        let vpn = state.vpnOptions

        try FileManager.default.createDirectory(
            at: AppGroup.homeDirectory, withIntermediateDirectories: true)
        let configPath = AppGroup.homeDirectory
            .appendingPathComponent("config.yaml").path
        tunnelLog.notice(
            "homeDir: \(AppGroup.homeDirectory.path, privacy: .public), config.yaml exists: \(FileManager.default.fileExists(atPath: configPath))"
        )

        // 1. Boot the core headlessly (mirrors android State.setupAndStart).
        ClashCore.initialize()
        ClashCore.setEventListener { data in
            EventBuffer.shared.append(data)
        }
        let initParams: [String: Any] = [
            "home-dir": AppGroup.homeDirectory.path,
            "version": ProcessInfo.processInfo.operatingSystemVersion.majorVersion,
        ]
        let initJSON = String(
            data: try JSONSerialization.data(withJSONObject: initParams),
            encoding: .utf8)!
        let message = await ClashCore.quickSetup(
            initParams: initJSON, setupParams: state.setupParamsJSON)
        tunnelLog.notice("quickSetup done, available memory: \(Self.availableMemoryMB()) MB")
        guard message.isEmpty else {
            tunnelLog.error("quickSetup failed: \(message, privacy: .public)")
            throw NSError(
                domain: "uk.toworld.flclash.PacketTunnel", code: 1,
                userInfo: [NSLocalizedDescriptionKey: message])
        }

        // 2. Network settings (mirrors the android VpnService.Builder).
        let settings = NEPacketTunnelNetworkSettings(
            tunnelRemoteAddress: "127.0.0.1")
        settings.mtu = 9000

        let v4 = NEIPv4Settings(
            addresses: [Self.address], subnetMasks: ["255.255.255.252"])
        v4.includedRoutes = Self.ipv4Routes(vpn.routeAddress)
        settings.ipv4Settings = v4

        if vpn.ipv6 {
            let v6 = NEIPv6Settings(
                addresses: [Self.address6], networkPrefixLengths: [126])
            v6.includedRoutes = [NEIPv6Route.default()]
            settings.ipv6Settings = v6
        }

        let dnsSettings = NEDNSSettings(
            servers: vpn.ipv6 ? [Self.dns, Self.dns6] : [Self.dns])
        // Route every DNS query into the tunnel.
        dnsSettings.matchDomains = [""]
        settings.dnsSettings = dnsSettings

        if vpn.systemProxy {
            let proxy = NEProxySettings()
            proxy.httpEnabled = true
            proxy.httpsEnabled = true
            let server = NEProxyServer(address: "127.0.0.1", port: vpn.port)
            proxy.httpServer = server
            proxy.httpsServer = server
            proxy.exceptionList = vpn.bypassDomain.isEmpty
                ? nil : vpn.bypassDomain
            settings.proxySettings = proxy
        }

        try await setTunnelNetworkSettings(settings)

        // 3. Hand the utun fd to the core.
        guard let fd = tunnelFileDescriptor else {
            throw NSError(
                domain: "uk.toworld.flclash.PacketTunnel", code: 2,
                userInfo: [
                    NSLocalizedDescriptionKey: "Unable to locate utun fd"
                ])
        }
        let address = vpn.ipv6
            ? "\(Self.addressPrefix),\(Self.address6Prefix)"
            : Self.addressPrefix
        let dns = vpn.dnsHijacking
            ? Self.netAny
            : (vpn.ipv6 ? "\(Self.dns),\(Self.dns6)" : Self.dns)
        ClashCore.startTun(
            fd: fd, stack: vpn.stack, address: address, dns: dns)
        ClashCore.forceGC()
        observeMemoryPressure()
        tunnelLog.notice(
            "tunnel started (fd \(fd)), available memory: \(Self.availableMemoryMB()) MB")
    }

    private static func availableMemoryMB() -> Int {
        Int(os_proc_available_memory() / 1024 / 1024)
    }

    private func redirectStandardStreams() {
        guard FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: AppGroup.identifier) != nil
        else { return }
        try? FileManager.default.createDirectory(
            at: AppGroup.homeDirectory, withIntermediateDirectories: true)
        let path = AppGroup.homeDirectory
            .appendingPathComponent("ne_stderr.log").path
        // Truncate to keep only the latest launch.
        freopen(path, "w", stdout)
        freopen(path, "a", stderr)
        setvbuf(stdout, nil, _IONBF, 0)
        setvbuf(stderr, nil, _IONBF, 0)
    }

    override func stopTunnel(with reason: NEProviderStopReason) async {
        tunnelLog.notice("stopTunnel: \(String(describing: reason))")
        memoryPressureSource?.cancel()
        memoryPressureSource = nil
        ClashCore.stopTun()
        ClashCore.setEventListener(nil)
        EventBuffer.shared.clear()
    }

    override func handleAppMessage(_ messageData: Data) async -> Data? {
        guard
            let request = try? JSONSerialization.jsonObject(with: messageData)
                as? [String: Any],
            let method = request["method"] as? String
        else {
            return nil
        }

        // Extension-local methods never reach the Go core.
        switch method {
        case "getEvents":
            let after = request["data"] as? Int ?? 0
            let (events, seq) = EventBuffer.shared.drain(after: after)
            let response: [String: Any] = ["events": events, "seq": seq]
            return try? JSONSerialization.data(withJSONObject: response)
        case "ping":
            return Data("{}".utf8)
        default:
            break
        }

        guard let json = String(data: messageData, encoding: .utf8) else {
            return nil
        }
        let result: String = await withCheckedContinuation { continuation in
            ClashCore.invoke(action: json) { result in
                continuation.resume(returning: result)
            }
        }
        return Data(result.utf8)
    }

    override func sleep() async {
        ClashCore.suspend(true)
    }

    override func wake() {
        ClashCore.suspend(false)
    }

    private func observeMemoryPressure() {
        let source = DispatchSource.makeMemoryPressureSource(
            eventMask: [.warning, .critical], queue: .global())
        source.setEventHandler {
            tunnelLog.warning("memory pressure — forceGC")
            ClashCore.forceGC()
        }
        source.activate()
        memoryPressureSource = source
    }

    private static func ipv4Routes(_ routeAddress: [String]) -> [NEIPv4Route] {
        let cidrs = routeAddress
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { $0.contains(".") && $0.contains("/") }
        if cidrs.isEmpty {
            return [NEIPv4Route.default()]
        }
        return cidrs.compactMap { cidr in
            let parts = cidr.split(separator: "/")
            guard parts.count == 2, let prefix = Int(parts[1]),
                  (0...32).contains(prefix)
            else {
                return nil
            }
            return NEIPv4Route(
                destinationAddress: String(parts[0]),
                subnetMask: Self.subnetMask(prefix: prefix))
        }
    }

    private static func subnetMask(prefix: Int) -> String {
        let mask: UInt32 = prefix == 0 ? 0 : ~UInt32(0) << (32 - prefix)
        return [24, 16, 8, 0].map { String((mask >> $0) & 0xff) }
            .joined(separator: ".")
    }

    /// The utun fd behind packetFlow. Primary path reads the private
    /// `socket.fileDescriptor` key; fallback scans fds for a utun socket.
    private var tunnelFileDescriptor: Int32? {
        if let fd = packetFlow.value(forKeyPath: "socket.fileDescriptor")
            as? Int32
        {
            return fd
        }
        var buf = [CChar](repeating: 0, count: Int(IFNAMSIZ))
        for fd: Int32 in 0...1024 {
            var len = socklen_t(buf.count)
            if getsockopt(fd, 2 /* SYSPROTO_CONTROL */, 2 /* UTUN_OPT_IFNAME */, &buf, &len) == 0,
               String(cString: buf).hasPrefix("utun")
            {
                return fd
            }
        }
        return nil
    }
}
