#import "QinMercury.h"
#import "IAPManager.h"

static QinMercury *instance;
@implementation QinMercury

+(QinMercury *) getAdInstance{
    return instance;
}
+(void) GameInit
{
    NSLog(@"this is GameInit self object-c");
    UnitySendMessage("PluginMercury", "onFunctionCallBack", "GameInit");
}

+(void) ActiveRewardVideo_IOS
{
    NSLog(@"this is ActiveRewardVideo_IOS http object-c");
    UnitySendMessage("PluginMercury", "AdShowSuccessCallBack", "ActiveRewardVideo_IOS");
    UnitySendMessage("PluginMercury", "AdLoadSuccessCallBack", "ActiveRewardVideo_IOS");
}
+(void) ActiveInterstitial_IOS
{
    NSLog(@"this is ActiveInterstitial_IOS object-c");
    UnitySendMessage("PluginMercury", "AdShowSuccessCallBack", "ActiveInterstitial_IOS");
    UnitySendMessage("PluginMercury", "AdLoadSuccessCallBack", "ActiveRewardVideo_IOS");
}
+(void) ActiveBanner_IOS
{
    NSLog(@"this is ActiveBanner_IOS object-c");
    UnitySendMessage("PluginMercury", "AdShowSuccessCallBack", "ActiveBanner_IOS");
    UnitySendMessage("PluginMercury", "AdLoadSuccessCallBack", "ActiveRewardVideo_IOS");
}
+(void) ActiveNative_IOS
{
    NSLog(@"this is ActiveNative_IOS object-c");
    UnitySendMessage("PluginMercury", "AdShowSuccessCallBack", "ActiveNative_IOS");
    UnitySendMessage("PluginMercury", "AdLoadSuccessCallBack", "ActiveRewardVideo_IOS");
}

+(void) UploadGameData_IOS
{
    NSLog(@"this is UploadGameData_IOS object-c");
    NSString *post = [NSString stringWithFormat:@"test=Message&this=isNotReal"];
    NSMutableDictionary *dict  = [[NSMutableDictionary alloc] init];
    NSError *error;
    NSString *postParams = @"gamename=1&unique_id=1&data=bbbbbbb";
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://192.168.10.7:10010/uploadgamedata"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSString *UploadGameData = @"gamename=1&unique_id=1&data=bbbbbbb";
        NSString *result = @"gamename=1&unique_id=1&data=bbbbbbb";
        result = [UploadGameData stringByAppendingString:requestReply];
        NSLog(@"Request reply: %@", requestReply);
        UnitySendMessage("PluginMercury", "LoginSuccessCallBack", result.UTF8String);
    }] resume];
}

+(void) DownloadGameData_IOS
{
    NSLog(@"this is DownloadGameData_IOS object-c");
    NSString *post = [NSString stringWithFormat:@"test=Message&this=isNotReal"];
    NSMutableDictionary *dict  = [[NSMutableDictionary alloc] init];
    NSError *error;
    NSString *postParams = @"gamename=1&unique_id=1&data=bbbbbbb";
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://192.168.10.7:10010/uploadgamedata"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSString *UploadGameData = @"gamename=1&unique_id=1&data=bbbbbbb";
        NSString *result = @"gamename=1&unique_id=1&data=bbbbbbb";
        result = [UploadGameData stringByAppendingString:requestReply];
        NSLog(@"Request reply: %@", requestReply);
        UnitySendMessage("PluginMercury", "LoginSuccessCallBack", result.UTF8String);
    }] resume];
}

+(void) MercuryLogin_IOS
{
    NSString* uuid = [QinMercury getDeviceIDInKeychain];
    UnitySendMessage("PluginMercury", "LoginSuccessCallBack", uuid.UTF8String);
}


+(NSString *)getDeviceIDInKeychain {
    NSString *bundleId =[[NSBundle mainBundle]bundleIdentifier];
    NSString *getUDIDInKeychain = (NSString *)[QinMercury load:bundleId];
    NSLog(@"从keychain中获取到的 UDID_INSTEAD %@",getUDIDInKeychain);
    if (!getUDIDInKeychain ||[getUDIDInKeychain isEqualToString:@""]||[getUDIDInKeychain isKindOfClass:[NSNull class]]) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        NSLog(@"\n \n \n _____重新存储 UUID _____\n \n \n  %@",result);
        [QinMercury save:bundleId data:result];
        getUDIDInKeychain = (NSString *)[QinMercury load:bundleId];
    }
    NSLog(@"最终 ———— UDID_INSTEAD %@",getUDIDInKeychain);
    return getUDIDInKeychain;
}


+(NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+(void)save:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}


+(id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}





#if defined (__cplusplus)
extern "C"
{
#endif
    IAPManager *iapManager = nil;
    void BuyProduct(char *p){
        if(nil == iapManager){//初始化
            iapManager = [[IAPManager alloc] init];
        }
        [iapManager attachObserver];
        NSString *pid = [NSString stringWithUTF8String:p];
        NSLog(@"商品编码:%@",pid);
        //pid = [NSString stringWithFormat:@"com.singmaan.sdk.6"];
        //商品信息
        [iapManager requestProductData:pid];
        //购买商品
        [iapManager buyRequest:pid];
    }
#if defined (__cplusplus)
}
#endif
@end


