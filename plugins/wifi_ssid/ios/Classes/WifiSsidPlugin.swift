import CoreLocation
import Flutter
import NetworkExtension
import UIKit

// Permission values must match WifiSsidPermission enum index in Dart:
//   0 = granted, 1 = denied, 2 = permanentlyDenied
public class WifiSsidPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private var pendingPermissionResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "wifi_ssid",
            binaryMessenger: registrar.messenger()
        )
        let instance = WifiSsidPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    override init() {
        super.init()
        locationManager.delegate = self
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getSsid":
            getSsid(result: result)
        case "checkPermission":
            checkPermission(result: result)
        case "requestPermission":
            requestPermission(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Permission

    private func checkPermission(result: @escaping FlutterResult) {
        result(mapAuthStatus(locationManager.authorizationStatus).rawValue)
    }

    private func requestPermission(result: @escaping FlutterResult) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            result(0)  // granted
        case .denied, .restricted:
            // iOS never re-prompts; the user must change it in Settings.
            result(2)  // permanentlyDenied
        default:
            pendingPermissionResult = result
            locationManager.requestWhenInUseAuthorization()
        }
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Also fires on init with .notDetermined — only resolve a real request.
        guard let result = pendingPermissionResult,
              manager.authorizationStatus != .notDetermined
        else { return }
        pendingPermissionResult = nil
        result(mapAuthStatus(manager.authorizationStatus).rawValue)
    }

    private func mapAuthStatus(_ status: CLAuthorizationStatus) -> WifiSsidPermission {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return .granted
        case .denied, .restricted:
            return .permanentlyDenied
        default:
            return .denied
        }
    }

    private enum WifiSsidPermission: Int {
        case granted = 0
        case denied = 1
        case permanentlyDenied = 2
    }

    // MARK: - SSID

    /// Requires the "Access Wi-Fi Information" entitlement plus either
    /// location permission or an active packet tunnel from this app.
    private func getSsid(result: @escaping FlutterResult) {
        NEHotspotNetwork.fetchCurrent { network in
            DispatchQueue.main.async {
                result(network?.ssid)
            }
        }
    }
}
