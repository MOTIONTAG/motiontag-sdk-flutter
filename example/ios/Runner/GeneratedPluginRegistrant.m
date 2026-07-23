//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_activity_recognition/FlutterActivityRecognitionPlugin.h>)
#import <flutter_activity_recognition/FlutterActivityRecognitionPlugin.h>
#else
@import flutter_activity_recognition;
#endif

#if __has_include(<integration_test/IntegrationTestPlugin.h>)
#import <integration_test/IntegrationTestPlugin.h>
#else
@import integration_test;
#endif

#if __has_include(<motiontag_sdk/MotionTagPlugin.h>)
#import <motiontag_sdk/MotionTagPlugin.h>
#else
@import motiontag_sdk;
#endif

#if __has_include(<permission_handler_apple/PermissionHandlerPlugin.h>)
#import <permission_handler_apple/PermissionHandlerPlugin.h>
#else
@import permission_handler_apple;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterActivityRecognitionPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterActivityRecognitionPlugin"]];
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
  [MotionTagPlugin registerWithRegistrar:[registry registrarForPlugin:@"MotionTagPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
}

@end
