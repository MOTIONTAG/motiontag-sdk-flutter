import Flutter
import UIKit
import MotionTagSDK

// TODO: Add unit tests
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
        switch (call.method) {
        case "getUserToken":
            let userToken = motionTag.userToken
            result(userToken)
        case "setUserToken":
            let args = call.arguments as! Dictionary<String, Any>
            motionTag.userToken = args["userToken"] as! String
            result(nil)
        case "getWifiOnlyDataTransfer":
            let wifiOnlyDataTransfer = motionTag.wifiOnlyDataTransfer
            result(wifiOnlyDataTransfer)
        case "setWifiOnlyDataTransfer":
            let args = call.arguments as! Dictionary<String, Any>
            motionTag.wifiOnlyDataTransfer = args["wifiOnlyDataTransfer"] as! Bool
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
    public weak var channel: FlutterMethodChannel? = nil

    private override init() {
    }

    public func trackingStatusChanged(_ isTracking: Bool) {
        let arguments = isTracking ? ["type": "STARTED"] : ["type": "STOPPED"]
        didEventOccur(arguments)
    }

    public func locationAuthorizationStatusDidChange(_ status: CLAuthorizationStatus, precise: Bool) {
        // Ignored
    }

    public func motionActivityAuthorized(_ authorized: Bool) {
        // Ignored
    }

    public func didTrackLocation(_ location: CLLocation) {
        let arguments: [String: Any] = ["type": "LOCATION",
                                        "timestamp": location.timestamp.timestampMs,
                                        "latitude": location.coordinate.latitude,
                                        "longitude": location.coordinate.longitude,
                                        "horizontalAccuracy": location.horizontalAccuracy,
                                        "speed": location.speed < 0 ? nil : location.speed,
                                        "altitude": location.verticalAccuracy <= 0 ? nil : location.altitude,
                                        "bearing": location.course < 0 ? nil : location.course]
        didEventOccur(arguments)
    }

    public func dataUploadWithTracked(from startDate: Date, to endDate: Date, didCompleteWithError error: Error?) {
        var arguments: [String: Any]
        if let error = error {
            arguments = ["type": "TRANSMISSION_ERROR",
                         "error": error.localizedDescription]
        } else {
            arguments = ["type": "TRANSMISSION_SUCCESS",
                         "trackedFrom": startDate.timestampMs,
                         "trackedTo": endDate.timestampMs]
        }
        didEventOccur(arguments)
    }

    private func didEventOccur(_ arguments: [String: Any]) {
        channel?.invokeMethod("onEvent", arguments: arguments)
    }
}

private extension Date {

    var timestampMs: Int {
        Int(self.timeIntervalSince1970 * 1_000)
    }
}
