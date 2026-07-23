import UIKit
import Flutter
import MotionTagSDK
import motiontag_sdk

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        MotionTagCore.sharedInstance.initialize(using: MotionTagDelegateWrapper.sharedInstance, launchOptions: launchOptions)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: any FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }
    
    override func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String) async {
        await MotionTagCore.sharedInstance.processBackgroundSessionEvents(with: identifier)
    }
}
