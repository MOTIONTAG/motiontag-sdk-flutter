# Flutter MotionTag wrapper plugin

It wraps the [iOS](https://api.motion-tag.de/developer/ios) and the [Android
SDK](https://api.motion-tag.de/developer/android) on the two platforms
respectively.

The general principle was to expose the _intersection_ of the features of the
two implementation, meaning that some Android-only and iOS-only features are
intentionally left out.

## SDK Version
Android: `v6.1.1`\
iOS: `v4.2.1`


## Installation
### iOS
Make sure your Podfile has every line from the relevant section of the [example
Podfile](example/ios/Podfile#L37-L62).

Add the following lines to the `AppDelegate.swift`
([docs](https://api.motion-tag.de/developer/ios#6-setup)):
```swift
func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
   motionTag.handleEvents(forBackgroundURLSession: identifier, completionHandler: completionHandler)
}
```

Additionally, add these lines to the beginning of the
`application(_:didFinishLaunchingWithOptions:)` function
([docs](https://api.motion-tag.de/developer/ios#6-setup)):

```swift
// Access this variable early to register for incoming location changes, see https://api.motion-tag.de/developer/ios#6-setup
_ = MotionTagCore.sharedInstance
```

Then enable every permission listed below (add them to the `Info.plist`).

For more details check out the [official
docs](https://api.motion-tag.de/developer/ios#6-setup).

### Android
Add the requested permissions to the manifest
([example](example/android/app/src/main/AndroidManifest.xml#L4-L7)).

Then create an
[`Application`](https://developer.android.com/reference/android/app/Application),
which you register in the `AndroidManifest.xml`.

You have to call `MotionTagWrapper.initialize()` from the `Application`'s
`onCreate` callback, check out
[`MainApplication.kt`](example/android/app/src/main/kotlin/de/motiontag/motiontag_example/MainApplication.kt)
as an example.

## Permission management
Since the permission management is not part of the iOS MotionTag SDK as of now,
it is the parent package's responsibility to acquire the permissions from the
user and then to start the SDK.

The [example project](example) demonstrates an implementation using the
[`permission_handler`](https://pub.dev/packages/permission_handler) package.

### Required permissions
#### iOS
Add them to the `Info.plist` file. If you use
[`permission_handler`](https://pub.dev/packages/permission_handler) make sure to
add the requested snippets to the Podfile for each of them.
- `NSMotionUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`
- `NSLocationWhenInUseUsageDescription`

And a capability:
- `Location Updates`

#### Android
- `android.permission.ACTIVITY_RECOGNITION`
- `android.permission.ACCESS_FINE_LOCATION`
- `android.permission.ACCESS_COARSE_LOCATION`
- `android.permission.ACCESS_BACKGROUND_LOCATION`

