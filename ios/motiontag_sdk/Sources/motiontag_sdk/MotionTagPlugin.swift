import Flutter
import UIKit
import CoreLocation
import MotionTagSDK

public class MotionTagPlugin: NSObject, FlutterPlugin {

    private var channel: FlutterMethodChannel

    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "de.motiontag.tracker", binaryMessenger: registrar.messenger())
        let instance = MotionTagPlugin(channel: channel)
        MainActor.assumeIsolated {
            MotionTagDelegateWrapper.sharedInstance.channel = channel
        }
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        MainActor.assumeIsolated {
            var motionTag = MotionTagCore.sharedInstance
            switch call.method {
            case "getUserToken":
                result(motionTag.userToken)
            case "setUserToken":
                let args = call.arguments as! Dictionary<String, Any>
                motionTag.userToken = args["userToken"] as! String
                result(nil)
            case "getWifiOnlyDataTransfer":
                result(motionTag.wifiOnlyDataTransfer)
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
                motionTag.clearData()
                result(nil)
            case "isTrackingActive":
                result(motionTag.isTrackingActive)
            default:
                result(FlutterError(code: "UNKNOWN_METHOD", message: "Unknown method \(call.method)", details: nil))
            }
        }
    }
}

@MainActor
public class MotionTagDelegateWrapper: NSObject, MotionTagDelegate {

    public static let sharedInstance = MotionTagDelegateWrapper()
    public weak var channel: FlutterMethodChannel? = nil

    private override init() {}

    public func trackingDidChange(isTracking: Bool) {
        let arguments = isTracking ? ["type": "STARTED"] : ["type": "STOPPED"]
        didEventOccur(arguments)
    }

    public func locationAuthorizationDidChange(status: CLAuthorizationStatus, isPrecise: Bool) {
        // Ignored
    }

    public func motionActivityAuthorizationDidChange(isAuthorized: Bool) {
        // Ignored
    }

    public func didUpdateLocation(_ location: CLLocation) {
        var arguments: [String: Any] = [
            "type": "LOCATION",
            "timestamp": location.timestamp.timestampMs,
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "horizontalAccuracy": location.horizontalAccuracy
        ]
        if location.speed >= 0 { arguments["speed"] = location.speed }
        if location.verticalAccuracy > 0 { arguments["altitude"] = location.altitude }
        if location.course >= 0 { arguments["bearing"] = location.course }
        didEventOccur(arguments)
    }

    public func dataUploadDidComplete(from startDate: Date, to endDate: Date, error: Error?) {
        var arguments: [String: Any]
        if let error = error {
            arguments = ["type": "TRANSMISSION_ERROR", "error": error.localizedDescription]
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
