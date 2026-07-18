import Foundation

/// Constants shared between the Runner app and the PacketTunnel extension.
/// This file is compiled into both targets.
enum AppGroup {
    static let identifier = "group.uk.toworld.flclash"

    static var containerURL: URL {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: identifier
        )!
    }

    /// The core home directory (config.yaml, geodata, profiles) — the iOS
    /// counterpart of `appPath.homeDirPath` on other platforms.
    static var homeDirectory: URL {
        containerURL.appendingPathComponent("FlClash", isDirectory: true)
    }

    /// SharedState JSON persisted by the app's `syncState`/`saveState`
    /// channel calls; read by the NE at `startTunnel` for headless boot.
    static var sharedStateURL: URL {
        homeDirectory
            .appendingPathComponent("state", isDirectory: true)
            .appendingPathComponent("shared_state.json")
    }
}
