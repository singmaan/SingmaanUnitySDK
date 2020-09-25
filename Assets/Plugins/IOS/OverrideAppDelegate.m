#import "UnityAppController.h"
#import "TalkingDataGA.h"
@interface OverrideAppDelegate : UnityAppController
@end


IMPL_APP_CONTROLLER_SUBCLASS(OverrideAppDelegate)


@implementation OverrideAppDelegate


-(BOOL)application:(UIApplication*) application didFinishLaunchingWithOptions:(NSDictionary*) options
{
    NSLog(@"[OverrideAppDelegate application:%@ didFinishLaunchingWithOptions:%@]", application, options);
    [TalkingDataGA onStart:@"33F41AA4DFA54F12BAD05C90570D22FB" withChannelId:@"IOS"];
    [TDGAAccount setAccount:@"IOS_users"];
    return [super application:application didFinishLaunchingWithOptions:options];
    
}


@end
