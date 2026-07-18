import Flutter
import UIKit

/// iOS implementation of the `com.follow.clash/app` channel.
///
/// Mirrors the android `AppPlugin` contract consumed by `lib/plugins/app.dart`.
/// Android-only concepts (packages, battery optimization, recents) return
/// benign defaults so shared Dart code keeps working.
class AppChannel: NSObject {
    static let name = "com.follow.clash/app"
    static let appGroup = "group.uk.toworld.flclash"

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
        case "getPackageIcon":
            result(nil)
        case "openFile":
            result(false)
        case "initShortcuts", "updateExcludeFromRecents":
            result(true)
        case "isBatteryOptimizationDisabled":
            result(true)
        case "openBatteryOptimizationSettings":
            result(false)
        case "getContainerPath":
            // App Group container shared with the PacketTunnel extension.
            // Returns nil until the App Groups entitlement is configured.
            let url = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: Self.appGroup
            )
            result(url?.path)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
