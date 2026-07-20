import Flutter
import UIKit
import os.log

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  var serviceChannel: ServiceChannel?
  var appChannel: AppChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // Channels need the binary messenger, but the implicit engine bridge only
    // exposes the plugin registry, and `registrar(forPlugin:)` conflicts with
    // already-registered keys (duplicate key crash).  Wait for the engine to
    // fully start, then grab the messenger from the scene's view controller.
    // The actual registration is deferred to SceneDelegate.swift.
  }
}
