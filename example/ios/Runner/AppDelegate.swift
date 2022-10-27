import UIKit
import Flutter
import MotionTagSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Access this variable early to register for incoming location changes, see https://api.motion-tag.de/developer/ios#6-setup
        _ = MotionTagCore.sharedInstance
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // https://api.motion-tag.de/developer/ios#6-setup
        MotionTagCore.sharedInstance.handleEvents(forBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
}
