import Flutter
import UIKit
import os.log

class SceneDelegate: FlutterSceneDelegate {

    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)
        // The Flutter engine is alive by this point; the root view controller
        // provides the binary messenger we need for custom channels.
        DispatchQueue.main.async { [weak self] in
            guard let self,
                  let vc = self.window?.rootViewController as? FlutterViewController,
                  let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { return }
            let messenger = vc.binaryMessenger
            appDelegate.serviceChannel = ServiceChannel(messenger: messenger)
            appDelegate.appChannel = AppChannel(messenger: messenger)
            os_log("SceneDelegate: channels registered via FlutterViewController")
        }
    }
}
