import UIKit
import Flutter
import MotionTagSDK
import motiontag

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    private lazy var motionTag = MotionTagCore.sharedInstance

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // The native iOS MotionTagSDK must be initialized here, see https://api.motion-tag.de/developer/ios
        motionTag.initialize(using: MotionTagDelegateWrapper.sharedInstance, launchOption: launchOptions)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        motionTag.handleEvents(forBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
}
