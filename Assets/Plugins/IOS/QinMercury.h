#import <Foundation/Foundation.h>
#import <Security/Security.h>
@interface QinMercury : UIViewController

+(QinMercury *) getAdInstance;
+(void) GameInit;
+(void) ActiveRewardVideo_IOS;
+(void) ActiveInterstitial_IOS;
+(void) ActiveBanner_IOS;
+(void) ActiveNative_IOS;
+(void) UploadGameData_IOS:(NSString *)data;
+(void) DownloadGameData_IOS;
+(void) MercuryLogin_IOS;
+(void) Redeem_IOS:(NSString *)code;
+(void) Data_UseItem_IOS:(NSString *)quantity item:(NSString *)item;
+(void) Data_LevelBegin_IOS:(NSString *)eventID;
+(void) Data_LevelCompleted_IOS:(NSString *)eventID;
+(void) Data_Event_IOS:(NSString *)eventID;

+(NSString *)getDeviceIDInKeychain;
extern NSString* const gamename;
extern NSString* const back_url;
extern NSString *unique_id;
@end

