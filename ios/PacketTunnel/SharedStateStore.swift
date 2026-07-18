import Foundation

/// Typed view of the VpnOptions subset the tunnel needs. Field names mirror
/// the Dart `VpnOptions` freezed model (`lib/models/core.dart`).
struct VpnOptions: Decodable {
    var enable: Bool = true
    var port: Int = 7890
    var ipv6: Bool = false
    var dnsHijacking: Bool = true
    var allowBypass: Bool = true
    var systemProxy: Bool = true
    var bypassDomain: [String] = []
    var stack: String = "system"
    var routeAddress: [String] = []

    enum CodingKeys: String, CodingKey {
        case enable, port, ipv6, dnsHijacking, allowBypass, systemProxy,
             bypassDomain, stack, routeAddress
    }

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        enable = try c.decodeIfPresent(Bool.self, forKey: .enable) ?? true
        port = try c.decodeIfPresent(Int.self, forKey: .port) ?? 7890
        ipv6 = try c.decodeIfPresent(Bool.self, forKey: .ipv6) ?? false
        dnsHijacking =
            try c.decodeIfPresent(Bool.self, forKey: .dnsHijacking) ?? true
        allowBypass =
            try c.decodeIfPresent(Bool.self, forKey: .allowBypass) ?? true
        systemProxy =
            try c.decodeIfPresent(Bool.self, forKey: .systemProxy) ?? true
        bypassDomain =
            try c.decodeIfPresent([String].self, forKey: .bypassDomain) ?? []
        stack = try c.decodeIfPresent(String.self, forKey: .stack) ?? "system"
        routeAddress =
            try c.decodeIfPresent([String].self, forKey: .routeAddress) ?? []
    }
}

/// Loads the SharedState JSON persisted by the app (`syncState`/`saveState`).
///
/// `setupParams` is kept as a raw JSON string so the exact wire format the
/// Dart side produced (`selected-map`, `test-url` keys) reaches the Go core
/// unchanged via `quickSetup`.
struct SharedStateStore {
    let vpnOptions: VpnOptions
    let setupParamsJSON: String

    static func load() -> SharedStateStore {
        var options = VpnOptions()
        var setupParams = "{}"
        guard
            let data = try? Data(contentsOf: AppGroup.sharedStateURL),
            let root = try? JSONSerialization.jsonObject(with: data)
                as? [String: Any]
        else {
            return SharedStateStore(
                vpnOptions: options, setupParamsJSON: setupParams)
        }
        if let vpnDict = root["vpnOptions"] as? [String: Any],
           let vpnData = try? JSONSerialization.data(withJSONObject: vpnDict),
           let decoded = try? JSONDecoder().decode(
               VpnOptions.self, from: vpnData)
        {
            options = decoded
        }
        if let setupDict = root["setupParams"] as? [String: Any],
           let setupData = try? JSONSerialization.data(
               withJSONObject: setupDict),
           let json = String(data: setupData, encoding: .utf8)
        {
            setupParams = json
        }
        return SharedStateStore(
            vpnOptions: options, setupParamsJSON: setupParams)
    }
}
