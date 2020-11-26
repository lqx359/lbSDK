#import "LblelinkpluginPlugin.h"
 #if __has_include(<lb_flutter/lb_flutter-swift.h>)
 #import <lb_flutter/lb_flutter-swift.h>
 #else
// // Support project import fallback if the generated compatibility header
// // is not copied when this plugin is created as a library.
// // https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
 #import "lb_flutter-swift.h"
 #endif
//#import "SwiftLblelinkpluginPlugin.swift"

@implementation LblelinkpluginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftLblelinkpluginPlugin registerWithRegistrar:registrar];
}
@end
