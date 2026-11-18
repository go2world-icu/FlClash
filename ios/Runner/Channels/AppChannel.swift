import Flutter
import UIKit

/// iOS implementation of the `com.follow.clash/app` channel.
///
/// Mirrors the android `AppPlugin` contract consumed by `lib/plugins/app.dart`.
/// Android-only concepts (packages, battery optimization, recents) return
/// benign defaults so shared Dart code keeps working.
class AppChannel: NSObject {
    static let name = "com.follow.clash/app"

    private let channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: Self.name, binaryMessenger: messenger)
        super.init()
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call, result: result)
        }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "tip":
            // Snackbar-style toasts are rendered by Flutter itself on iOS.
            result(true)
        case "moveTaskToBack":
            result(false)
        case "openAppSettings":
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
                result(true)
            } else {
                result(false)
            }
        case "requestNotificationsPermission":
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                DispatchQueue.main.async {
                    result(granted)
                }
            }
        case "getPackages", "getChinaPackageNames":
            result("[]")
        // iOS cannot enumerate other apps, so there is no permission to hold or
        // to ask for. Answering "granted" keeps the shared access-control view
        // from offering a grant it could never deliver, and `getPackages`
        // answers empty either way.
        case "isInstalledAppsPermissionGranted", "requestInstalledAppsPermission":
            result(true)
        case "getPackageIcon":
            result(nil)
        case "openFile":
            result(false)
        case "initShortcuts", "updateExcludeFromRecents":
            result(true)
        case "isBatteryOptimizationDisabled":
            result(true)
        case "requestLocalNetworkPermission":
            result(true)
        case "openBatteryOptimizationSettings":
            result(false)
        case "extractAsset":
            extractAsset(call.arguments, result: result)
        case "clearDownloads":
            result(true)
        case "getContainerPath":
            // App Group container shared with the PacketTunnel extension.
            // Returns nil until the App Groups entitlement is configured.
            let url = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: AppGroup.identifier
            )
            result(url?.path)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func extractAsset(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let arguments = arguments as? [String: String],
              let asset = arguments["asset"],
              let path = arguments["path"], path.hasPrefix("/")
        else {
            result(FlutterError(
                code: "invalid_asset", message: "Expected an asset and destination", details: nil))
            return
        }

        let destination = URL(fileURLWithPath: path)
        let files = FileManager.default
        let container = files.containerURL(
            forSecurityApplicationGroupIdentifier: AppGroup.identifier
        ) ?? files.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let home = container?
            .appendingPathComponent(AppGroup.homeDirectoryName, isDirectory: true)
            .resolvingSymlinksInPath()
        guard asset == "assets/data/\(destination.lastPathComponent)",
              home?.path == destination.deletingLastPathComponent().resolvingSymlinksInPath().path
        else {
            result(FlutterError(
                code: "invalid_asset", message: "Unsupported asset destination", details: nil))
            return
        }

        let key = FlutterDartProject.lookupKey(forAsset: asset)
        guard let source = Bundle.main.url(forResource: key, withExtension: nil) else {
            result(FlutterError(
                code: "asset_not_found", message: asset, details: nil))
            return
        }

        DispatchQueue.global(qos: .utility).async {
            let response: Any
            do {
                let contents = try Data(contentsOf: source, options: .mappedIfSafe)
                try contents.write(to: destination, options: .atomic)
                response = true
            } catch {
                response = FlutterError(
                    code: "asset_extract_failed", message: error.localizedDescription, details: nil)
            }
            DispatchQueue.main.async { result(response) }
        }
    }
}
