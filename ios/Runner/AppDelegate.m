#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:@"AIzaSyAipdrKwqPfmyfmzhZG1PZJJ8J61SM14i8"];
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end