#import "MotionTagPlugin.h"
#if __has_include(<motiontag_sdk/motiontag_sdk-Swift.h>)
#import <motiontag_sdk/motiontag_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "motiontag_sdk-Swift.h"
#endif

@implementation MotionTagPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMotionTagPlugin registerWithRegistrar:registrar];
}
@end
