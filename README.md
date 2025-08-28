# motiontag SDK Flutter Plugin

[![pub package](https://img.shields.io/pub/v/motiontag_sdk.svg)](https://pub.dartlang.org/packages/motiontag_sdk)
[![Build Status](https://dev.azure.com/motiontag/public/_apis/build/status/Flutter/Test/%5BFlutter%5D%20%5BTest%5D%20MOTIONTAG%20SDK?branchName=main)](https://dev.azure.com/motiontag/public/_build/latest?definitionId=21&branchName=main)


The motiontag Mobility & Location Analytics SDK enables to collect raw sensor data of the telephone in
a battery efficient way. This data is then transmitted to the motiontag back-end system (ISO 27001 certified).
In the backend, the sensor events are processed and a partial journey is constructed. Journeys consist
either solely of tracks or tracks plus stays. Tracks describe a movement from a origin to a destination with
a certain mode of transport. Stays symbolize a stationary behaviour with a particular purpose for the visit.

The use cases for the SDK are manifold. In the mobility sector it can be used to get detailed mobility data
for planning purposes. The collected data enables to compare how the transport network is being used.
This way the effectiveness of the current infrastructure and the passenger flow management is measured and
the design of new mobility services. By implementing and using the SDK you can make use of these findings
to improve timetables and routes, expand transport supply and attract more passengers.

If you integrate the motiontag SDK inside your own application, you can either download
user journeys via a provided dump interface on the internet or we tailor a customized solution to
your needs.

This plugin wraps the [iOS](https://api.motion-tag.de/developer/ios) and the [Android  SDK](https://api.motion-tag.de/developer/android)
on the two platforms respectively.

The general principle was to expose the _intersection_ of the features of the two implementation,
meaning that some Android-only and iOS-only features are intentionally left out.
Minimum supported OS versions:


| Android | iOS       |
|---------|-----------|
| API 23+ | iOS 12.3+ |


## 1. Installation

First, add `motiontag_sdk` as a [dependency in your pubspec.yaml file](https://docs.flutter.dev/development/packages-and-plugins/using-packages).


### iOS

The SDK must be initialized **before** the plugin registration in the `didFinishLaunchingWithOptions` application's delegate function.
The `handleEventsForBackgroundURLSession` calls must be forwarded by overriding the appropriate delegate.
Check out [AppDelegate.swift](https://github.com/MOTIONTAG/motiontag-sdk-flutter/blob/main/example/ios/Runner/AppDelegate.swift) as an example.


### Android

Create an [`Application`](https://developer.android.com/reference/android/app/Application), which you register in the `AndroidManifest.xml`.

You have to call `MotionTagWrapper.initialize()` from the `Application`'s `onCreate` callback and provide the required arguments.
Check out [`MainApplication.kt`](https://github.com/MOTIONTAG/motiontag-sdk-flutter/blob/main/example/android/app/src/main/kotlin/de/motiontag/motiontag_sdk_example/MainApplication.kt) as an example.

[Auto Backup for Apps](https://developer.android.com/guide/topics/data/autobackup) is a platform feature that automatically backs up a user's data from apps that target and run on Android 6.0 (API level 23) or later.
To limit unexpected behavior from our SDK, you should either disable automated backups entirely or exclude the appropriate SDK files from full backup.
Please check [this section](https://api.motion-tag.de/developer/android#1-4-auto-backup-for-apps) of the native Android motiontag SDK for more information.


## 2. Permission management

Since the permission management is not part of the motiontag SDK, it is the app's responsibility to acquire the permissions/authorizations from the user before starting the SDK.

The [example project](https://github.com/MOTIONTAG/motiontag-sdk-flutter/tree/main/example) demonstrates an implementation using the
[`permission_handler`](https://pub.dev/packages/permission_handler) package.

### iOS

The SDK requires access to location updates in the background, for that please add following capability in Xcode:

+ Capabilities -> Background Modes:
    + Location Updates

Additionally, The SDK requires two authorizations before being started: `Location (Always)` and `Motion`.
Therefore, add the following items to your app's `Info.plist`:

+ "Privacy - Motion Usage Description" string
+ "Privacy - Location Always & When in Use Description" string
+ "Privacy - When in Use Description" string

If you use [`permission_handler`](https://pub.dev/packages/permission_handler) make sure to add the
requested snippets to the Podfile for each of them.

### Android

The following runtime permissions are required before starting the SDK:

- `android.permission.ACTIVITY_RECOGNITION`
- `android.permission.ACCESS_FINE_LOCATION`
- `android.permission.ACCESS_COARSE_LOCATION`
- `android.permission.ACCESS_BACKGROUND_LOCATION`

Some of these permissions may not be required when targeting older Android versions.
Please check the native [Android MOTIONTAG SDK documentation](https://api.motion-tag.de/developer/android#3-2-runtime-permissions) for more info.


## 3. Usage

The [MotionTag class](https://github.com/MOTIONTAG/motiontag-sdk-flutter/blob/main/lib/motiontag.dart) is the main entry point of the SDK. It has the following public functions:

Function | Description
--- | ---
`Future<void> start() async` | Starts tracking. It's not necessary to call this method again after a device reboot.
`Future<void> stop() async` | Stops tracking.
`Future<void> setUserToken(String userToken) async` | Sets the user token (JWT). The SDK expects a valid user token prior to executing the `start()` function. The provided token will be persisted internally.
`Future<String?> getUserToken() async` | Retrieved the persisted user token or `null` if it was not previously set.
`void setObserver(void Function(MotionTagEvent event)? observer)`  |  Set a function to be called by the SDK to inform abour relevant changes (e.g.: data transmission error, tracking started, etc).
`Future<void> clearData() async `  |  Deletes all unstransmitted stored user data from the SDK. This function is useful when signing out the user from your app.
`Future<bool> isTrackingActive() async`  |  Returns `true` if the SDK is currently active, `false` otherwise.

The [MotionTagEvent class](https://github.com/MOTIONTAG/motiontag-sdk-flutter/blob/main/lib/events/motiontag_event.dart) is the base class for all notifiable SDK events.
The SDK currently supports the following concrete implementations of the `MotionTagEvent` class:

Event | Description
--- | ---
`StartedEvent` | Informs the application that tracking has been started.
`StoppedEvent` | Informs the application that tracking has been stopped.
`LocationEvent` | Hands the latest captured device location to the application.
`TransmissionSuccessEvent` | Informs when a package of events has been successfully sent to the server.
`TransmissionErrorEvent` | Informs when a package of events failed to be transmitted to the server.


## 4. User authentication

The SDK must be configured at runtime with a user-specific token using JWT.
For more information, please check the native [Android](https://api.motion-tag.de/developer/android#3-4-sdk-user-authentication)
and/or [iOS](https://api.motion-tag.de/developer/ios#6-sdk-user-authentication) SDK documentations.


## 5. Non-standard background process limitations on Android

Some Android OEMs, like Huawei and OnePlus, decided to implement non-standard background process limitations on 3rd party apps as an attempt to reduce battery consumption.
The motiontag SDK must be running all times in the background, otherwise it won't function properly.

Therefore we recommend developers integrating our SDK to read the [https://dontkillmyapp.com](https://dontkillmyapp.com) website,
it describes this problem in detail and it provides some workaround options for both developers and users.
There's also [this StackOverflow post](https://stackoverflow.com/a/51726040/2983102) which describes how developers can forward users to the correct OEM settings.

When battery optimization is turned on for your app, the motiontag SDK may not be able to track and generate data continuously.
If 24/7 tracking on all supported phone models is crucial to your use case, we strongly recommend you to include a prompt for the user, and facilitate the deactivation of battery optimization settings for your app on the affected phones.


## 6. License

The SDK is licensed under the [MOTIONTAG SDK Test License](https://api.motion-tag.de/developer/sdk_test_license).
