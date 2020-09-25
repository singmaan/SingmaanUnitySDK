#import "QinMercury.h"
#import "IAPManager.h"
#import "TalkingDataGA.h"
static QinMercury *instance;
NSString* const gamename =@"TerraGenesis";
NSString* const back_url =@"http://192.168.10.7:10010/uploadgamedata";
extern NSString *unique_id=@"";

@implementation QinMercury

+(QinMercury *) getAdInstance{
    return instance;
}
+(void) GameInit
{
    NSLog(@"[GameInit]");
    NSString* uuid = [QinMercury getDeviceIDInKeychain];
    unique_id = uuid;
    UnitySendMessage("PluginMercury", "onFunctionCallBack", "GameInit");

}

+(void) ActiveRewardVideo_IOS
{
    NSLog(@"[ActiveRewardVideo_IOS]");
    UnitySendMessage("PluginMercury", "AdShowSuccessCallBack", "ActiveRewardVideo_IOS");
    UnitySendMessage("PluginMercury", "AdLoadSuccessCallBack", "ActiveRewardVideo_IOS");
}
+(void) ActiveInterstitial_IOS
{
    NSLog(@"[ActiveInterstitial_IOS]");
    UnitySendMessage("PluginMercury", "AdShowSuccessCallBack", "ActiveInterstitial_IOS");
    UnitySendMessage("PluginMercury", "AdLoadSuccessCallBack", "ActiveInterstitial_IOS");
}
+(void) ActiveBanner_IOS
{
    NSLog(@"[ActiveBanner_IOS]");
    UnitySendMessage("PluginMercury", "AdShowSuccessCallBack", "ActiveBanner_IOS");
    UnitySendMessage("PluginMercury", "AdLoadSuccessCallBack", "ActiveBanner_IOS");
}
+(void) ActiveNative_IOS
{
    NSLog(@"[ActiveNative_IOS]");
    UnitySendMessage("PluginMercury", "AdShowSuccessCallBack", "ActiveNative_IOS");
    UnitySendMessage("PluginMercury", "AdLoadSuccessCallBack", "ActiveNative_IOS");
}

+(void) MercuryLogin_IOS
{
    NSLog(@"[MercuryLogin_IOS]");

    UnitySendMessage("PluginMercury", "LoginSuccessCallBack", unique_id.UTF8String);
}

+(void) UploadGameData_IOS:(NSString *)data
{
    NSLog(@"[UploadGameData_IOS]data=%@",data);
    NSMutableDictionary *dict  = [[NSMutableDictionary alloc] init];
    NSError *error;
    NSString *game_data = data;
    NSString *postParams = [[NSString alloc] initWithFormat:@"gamename=%@&unique_id=%@&data=%@", gamename, unique_id,game_data ];
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:back_url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSString *UploadGameData = [back_url stringByAppendingString:postParams];;
        NSString *result = @"";
        NSLog(@"[UploadGameData_IOS]UploadGameData=%@",UploadGameData);
        UnitySendMessage("PluginMercury", "LoginSuccessCallBack", requestReply.UTF8String);
    }] resume];
}

+(void) DownloadGameData_IOS
{
    NSLog(@"[DownloadGameData_IOS]");
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


+(NSString *)getDeviceIDInKeychain {
    NSString *bundleId =[[NSBundle mainBundle]bundleIdentifier];
    NSString *getUDIDInKeychain = (NSString *)[QinMercury load:bundleId];
    if (!getUDIDInKeychain ||[getUDIDInKeychain isEqualToString:@""]||[getUDIDInKeychain isKindOfClass:[NSNull class]]) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        [QinMercury save:bundleId data:result];
        getUDIDInKeychain = (NSString *)[QinMercury load:bundleId];
    }
    NSLog(@"[getDeviceIDInKeychain]getUDIDInKeychain=%@",getUDIDInKeychain);
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
    NSString *timeString = @"";
    void BuyProduct(char *p)
    {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
        NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
        timeString = [NSString stringWithFormat:@"%.0f", time];
        NSString *pid = [NSString stringWithUTF8String:p];
        NSLog(@"[C][BuyProduct]:%@",timeString);
        NSLog(@"[C][BuyProduct]:%@",pid);
        NSString *my_iapId = @"";
        int my_currencyAmount = 0;
        NSArray *myWords = [pid componentsSeparatedByString:@"."];
        int size = [myWords count];
        NSLog(@"[C][BuyProduct]:size=%d",size);
        if(size==0)
        {
            my_iapId = myWords[size];
        }
        else
        {
            my_iapId = myWords[size-1];
        }
        NSLog(@"[C][BuyProduct]:size=%@",my_iapId);
        if([pid isEqualToString:@"uk.fiveaces.nsfcchina.superstriker"])
        {
            my_currencyAmount = 20;
        }
        else if([pid isEqualToString:@"uk.fiveaces.nsfcchina.superstriker"])
        {
            my_currencyAmount = 20;
        }
        else if([pid isEqualToString:@"uk.fiveaces.nsfcchina.superstriker"])
        {
            my_currencyAmount = 20;
        }
        else if([pid isEqualToString:@"uk.fiveaces.nsfcchina.superstriker"])
        {
            my_currencyAmount = 20;
        }
        else if([pid isEqualToString:@"uk.fiveaces.nsfcchina.superstriker"])
        {
            my_currencyAmount = 20;
        }
        else if([pid isEqualToString:@"uk.fiveaces.nsfcchina.superstriker"])
        {
            my_currencyAmount = 20;
        }
        else if([pid isEqualToString:@"uk.fiveaces.nsfcchina.superstriker"])
        {
            my_currencyAmount = 20;
        }
        else
        {
            my_iapId =@"testpid";
            my_currencyAmount = 1;
        }
        
        
        [TDGAVirtualCurrency onChargeRequst:timeString
                                      iapId:my_iapId
                             currencyAmount:my_currencyAmount
                               currencyType:@"RMB"
                      virtualCurrencyAmount:1
                                paymentType:@"AppStore"];

        if(nil == iapManager){//初始化
            iapManager = [[IAPManager alloc] init];
        }
        [iapManager attachObserver];
        
        
        //pid = [NSString stringWithFormat:@"com.singmaan.sdk.6"];
        //商品信息
        [iapManager requestProductData:pid];
        //购买商品
        [iapManager buyRequest:pid];
        [iapManager giveParam:timeString];
        

    }
    
    void GameInit()
    {
        NSLog(@"[C][GameInit]");
        [QinMercury GameInit];
    }
    
    void ActiveRewardVideo_IOS()
    {
        NSLog(@"[C][ActiveRewardVideo_IOS]");
        [QinMercury ActiveRewardVideo_IOS];
    }
    
    void ActiveInterstitial_IOS()
    {
        NSLog(@"[C][ActiveInterstitial_IOS]");
        [QinMercury ActiveInterstitial_IOS];
    }

    void ActiveBanner_IOS()
    {
        NSLog(@"[C][ActiveBanner_IOS]");
        [QinMercury ActiveBanner_IOS];
    }

    void ActiveNative_IOS()
    {
        NSLog(@"[C][ActiveNative_IOS]");
        [QinMercury ActiveNative_IOS];
    }

    void MercuryLogin_IOS()
    {
        NSLog(@"[C][MercuryLogin_IOS]");
        [QinMercury MercuryLogin_IOS];
    }
    
    void UploadGameData_IOS(char *p)
    {
        NSString *pid = [NSString stringWithUTF8String:p];
        NSLog(@"[C][UploadGameData_IOS]");
        [QinMercury UploadGameData_IOS:pid];
    }
    
    void DownloadGameData_IOS()
    {
        NSLog(@"[C][DownloadGameData_IOS]");
        [QinMercury DownloadGameData_IOS];
    }
    
#if defined (__cplusplus)
}
#endif
@end


