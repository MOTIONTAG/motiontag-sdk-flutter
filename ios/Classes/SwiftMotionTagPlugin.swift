import Flutter
import UIKit
import MotionTagSDK

public class SwiftMotionTagPlugin: NSObject, FlutterPlugin, MotionTagDelegate {
    private var motionTag: MotionTag!
    private var channel: FlutterMethodChannel;
    
    init(channel: FlutterMethodChannel) {
        motionTag = MotionTagCore.sharedInstance
        self.channel = channel
        
        super.init()
        
        motionTag.delegate = self
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "motiontag", binaryMessenger: registrar.messenger())
        let instance = SwiftMotionTagPlugin(channel: channel);
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "initialize":
            // initialize is a no-op on iOS
            result(nil)
        case "getUserToken":
            result(getUserToken())
        case "setUserToken":
            let args = call.arguments as! Dictionary<String, Any>
            setUserToken(userToken: args["userToken"] as! String)
            result(nil)
        case "start":
            start()
            result(nil)
        case "stop":
            stop()
            result(nil)
        case "clearData":
            clearData()
            result(nil)
        case "isTrackingActive":
            result(isTrackingActive())
        default:
            result(FlutterError(code: "UNKNOWN_METHOD", message: "Unknown method \(call.method)", details: nil))
        }
    }
    
    private func getUserToken() -> String? {
        return motionTag.userToken
    }
    
    private func setUserToken(userToken: String) {
        motionTag.userToken = userToken
    }
    
    private func start() {
        motionTag.start()
    }
    
    private func stop() {
        motionTag.stop()
    }
    
    private func clearData() {
        let semaphore = DispatchSemaphore(value: 0)
        motionTag.clearData(completionHandler: {
            semaphore.signal()
        })
        semaphore.wait()
    }
    
    private func isTrackingActive() -> Bool {
        return motionTag.isTrackingActive
    }
    
    public func trackingStatusChanged(_ isTracking: Bool) {
        didEventOccur(isTracking ? "STARTED" : "STOPPED")
    }
    
    public func didTrackLocation(_ location: CLLocation) {
        didEventOccur("LOCATION")
    }
    
    public func dataUploadWithTracked(from startDate: Date, to endDate: Date, didCompleteWithError error: Error?) {
        didEventOccur(error == nil ? "TRANSMISSION_SUCCESS" : "TRANSMISSION_ERROR")
    }
    
    private func didEventOccur(_ type: String) {
        channel.invokeMethod("onEvent", arguments: ["type": type])
    }
}
