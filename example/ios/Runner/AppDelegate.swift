import UIKit
import Flutter

// Add the required imports
import MotionTagSDK
import motiontag_sdk

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Add this line before the plugin registration so the SDK can get initialized
        MotionTagCore.sharedInstance.initialize(using: MotionTagDelegateWrapper.sharedInstance, launchOption: launchOptions)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Override the handleEventsForBackgroundURLSession delegate
    override func application(
            _ application: UIApplication,
            handleEventsForBackgroundURLSession identifier: String,
            completionHandler: @escaping () -> Void) {

         // Add this line here to forward the events to the SDK
         MotionTagCore.sharedInstance.processBackgroundSessionEvents(with: identifier, completionHandler: completionHandler)
    }
}
