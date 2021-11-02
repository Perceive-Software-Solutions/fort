#import "FortPlugin.h"
#if __has_include(<fort/fort-Swift.h>)
#import <fort/fort-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fort-Swift.h"
#endif

@implementation FortPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFortPlugin registerWithRegistrar:registrar];
}
@end
