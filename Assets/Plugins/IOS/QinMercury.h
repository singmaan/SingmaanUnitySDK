#import <Foundation/Foundation.h>
#import <Security/Security.h>
@interface QinMercury : UIViewController

+(QinMercury *) getAdInstance;
+(void) GameInit;
+(void) ActiveRewardVideo_IOS;
+(void) ActiveInterstitial_IOS;
+(void) ActiveBanner_IOS;
+(void) ActiveNative_IOS;
+(void) UploadGameData_IOS;
+(void) DownloadGameData_IOS;
+(void) MercuryLogin_IOS;
+(NSString *)getDeviceIDInKeychain;
@end

