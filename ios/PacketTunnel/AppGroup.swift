import Foundation

/// Constants shared between the Runner app and the PacketTunnel extension.
/// This file is compiled into both targets.
enum AppGroup {
    /// App Group identifier, derived from the main app's bundle id following
    /// the `group.<bundle id>` convention. This file is compiled into both the
    /// Runner app and the PacketTunnel extension, so the extension's
    /// `.PacketTunnel` suffix is stripped before deriving the group.
    static let identifier: String = {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let suffix = ".PacketTunnel"
        let mainBundleId = bundleId.hasSuffix(suffix)
            ? String(bundleId.dropLast(suffix.count))
            : bundleId
        return "group." + mainBundleId
    }()

    static var containerURL: URL {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: identifier
        )!
    }

    /// The core home directory (config.yaml, geodata, profiles) — the iOS
    /// counterpart of `appPath.homeDirPath` on other platforms.
    ///
    /// Must match `appName` in lib/common/constant.dart (the Dart side joins
    /// the container path with `appName`). Keep these in sync when renaming.
    static var homeDirectory: URL {
        containerURL.appendingPathComponent("ToWorld", isDirectory: true)
    }

    /// SharedState JSON persisted by the app's `syncState`/`saveState`
    /// channel calls; read by the NE at `startTunnel` for headless boot.
    ///
    /// Must match `appPath.sharedFilePath` in lib/common/path.dart (the Dart
    /// side deletes this file on logout).
    static var sharedStateURL: URL {
        homeDirectory.appendingPathComponent("shared.json")
    }
}
