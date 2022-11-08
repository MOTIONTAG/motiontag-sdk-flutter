import Flutter
import UIKit
import MotionTagSDK

public class SwiftMotionTagPlugin: NSObject, FlutterPlugin {

    private lazy var motionTag = MotionTagCore.sharedInstance
    private var channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "de.motiontag.tracker", binaryMessenger: registrar.messenger())
        let instance = SwiftMotionTagPlugin(channel: channel);
        MotionTagDelegateWrapper.sharedInstance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "initialize":
            // initialize is a no-op on iOS
            result(nil)
        case "getUserToken":
            let userToken = motionTag.userToken
            result(userToken)
        case "setUserToken":
            let args = call.arguments as! Dictionary<String, Any>
            motionTag.userToken = args["userToken"] as! String
            result(nil)
        case "start":
            motionTag.start()
            result(nil)
        case "stop":
            motionTag.stop()
            result(nil)
        case "clearData":
            let semaphore = DispatchSemaphore(value: 0)
            motionTag.clearData(completionHandler: {
                semaphore.signal()
            })
            semaphore.wait()
            result(nil)
        case "isTrackingActive":
            let isTrackingActive = motionTag.isTrackingActive
            result(isTrackingActive)
        default:
            let error = FlutterError(code: "UNKNOWN_METHOD", message: "Unknown method \(call.method)", details: nil)
            result(error)
        }
    }
}

public class MotionTagDelegateWrapper: NSObject, MotionTagDelegate {

    public static let sharedInstance = MotionTagDelegateWrapper()
    public var channel: FlutterMethodChannel? = nil

    private override init() {
    }

    public func trackingStatusChanged(_ isTracking: Bool) {
        didEventOccur(isTracking ? "STARTED" : "STOPPED")
    }

    public func locationAuthorizationStatusDidChange(_ status: CLAuthorizationStatus, precise: Bool) {
        // TODO: Ignoring it for now
    }

    public func motionActivityAuthorized(_ authorized: Bool) {
        // TODO: Ignoring it for now
    }

    public func didTrackLocation(_ location: CLLocation) {
        didEventOccur("LOCATION")
    }

    public func dataUploadWithTracked(from startDate: Date, to endDate: Date, didCompleteWithError error: Error?) {
        didEventOccur(error == nil ? "TRANSMISSION_SUCCESS" : "TRANSMISSION_ERROR")
    }

    private func didEventOccur(_ type: String) {
        channel?.invokeMethod("onEvent", arguments: ["type": type])
    }
}
