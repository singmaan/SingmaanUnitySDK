#import <Foundation/Foundation.h>
#import <Security/Security.h>
@interface QinMercury : UIViewController

+(QinMercury *) getAdInstance;
+(void) GameInit;
+(void) ActiveRewardVideo_IOS;
+(void) ActiveInterstitial_IOS;
+(void) ActiveBanner_IOS;
+(void) ActiveNative_IOS;
+(void) Get_UUID_By_KeyChain;
+(NSString *)getDeviceIDInKeychain;
@end

