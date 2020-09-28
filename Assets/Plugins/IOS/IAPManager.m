//
//  IAPManager.m
//  SingmaanSDK
//
//  Created by 星漫 on 2020/6/9.
//  Copyright © 2020 App. All rights reserved.
//

#import "IAPManager.h"
#import "TalkingDataGA.h"

@interface IAPManager ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>
// 所有商品
@property (nonatomic, strong)NSArray *products;
@property (nonatomic, strong)SKProductsRequest *request;
@end
 
static IAPManager *manager = nil;

@implementation IAPManager

extern NSString *pid=@"";
extern NSString *order_id=@"";

-(void) attachObserver{
    NSLog(@"[IAPManager][AttachObserver]");
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

-(BOOL) CanMakePayment{
    NSLog(@"[IAPManager][CanMakePayment]");
    return [SKPaymentQueue canMakePayments];
}

-(void) requestProductData:(NSString *)productIdentifiers{
    pid =productIdentifiers;
    NSLog(@"[IAPManager][requestProductData] pid%@",pid);
    NSArray *idArray = [productIdentifiers componentsSeparatedByString:@"\t"];
    NSSet *idSet = [NSSet setWithArray:idArray];
    [self sendRequest:idSet];
}

-(void) sendRequest:(NSSet *)idSet{
    NSLog(@"[IAPManager][sendRequest]");
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:idSet];
    request.delegate = self;
    [request start];
}

-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"[IAPManager][productsRequest]");
    NSArray *products = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[products count]);
    // populate UI
    for (SKProduct *p in products) {
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [products description]);
        NSLog(@"产品标题 %@" , p.localizedTitle);
        NSLog(@"产品描述信息: %@" , p.localizedDescription);
        NSLog(@"价格: %@" , p.price);
        NSLog(@"Product id: %@" , p.productIdentifier);
        //UnitySendMessage("IOSIAPMgr", "ShowProductList", [[self productInfo:p] UTF8String]);
    }
    for(NSString *invalidProductId in response.invalidProductIdentifiers){
        NSLog(@"Invalid product id:%@",invalidProductId);
    }
//     [request autorelease];
}
-(void)giveParam:(NSString *)timeString{
    order_id =timeString;
}

-(void)buyRequest:(NSString *)productIdentifier{
    NSArray* transactions=[SKPaymentQueue defaultQueue].transactions;
    if(transactions.count>0) {
      for(SKPaymentTransaction *tran in transactions) {
          //检查是否有完成的交易
          SKPaymentTransaction* transaction = [transactions firstObject];
          if(tran.transactionState == SKPaymentTransactionStatePurchasing) {
              NSLog(@"[IAPManager][buyRequest]%@",tran.transactionState);
              [[SKPaymentQueue defaultQueue] finishTransaction:tran];
              return;
          }
      }
    }
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self checkedLossOrders];

    productIndentify = productIdentifier;
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
-(void)checkedLossOrders{
    NSLog(@"[IAPManager][checkedLossOrders]");
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        //检测是否有未完成的交易
        for (SKPaymentTransaction *transaction in transactions) {
            NSLog(@"[IAPManager][checkedLossOrders] for (SKPaymentTransaction *transaction in transactions)");
            if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
                [self verifyPurchaseWithPaymentTransaction];// 发送到苹果服务器验证凭证
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
        }
        SKPaymentTransaction* transaction = [transactions firstObject];
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            NSLog(@"[IAPManager][checkedLossOrders] if (transaction.transactionState == SKPaymentTransactionStatePurchased)");
            lossIndentify = transaction.payment.productIdentifier;
            [self verifyPurchaseWithPaymentTransaction];// 发送到苹果服务器验证凭证
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            return;
        }
    }
}
-(NSString *)productInfo:(SKProduct *)product{
    NSLog(@"[IAPManager][productInfo]");
    NSArray *info = [NSArray arrayWithObjects:product.localizedTitle,product.localizedDescription,product.price,product.productIdentifier, nil];
    
    return [info componentsJoinedByString:@"\t"];
}
//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 */
-(void)verifyPurchaseWithPaymentTransaction{
    NSLog(@"[IAPManager][verifyPurchaseWithPaymentTransaction]");
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    
//    //测试的时候填写沙盒路径，上APPStore的时候填写正式环境路径
//    NSURL *url=[NSURL URLWithString:AppStore];
//    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
//    requestM.HTTPBody=bodyData;
//    requestM.HTTPMethod=@"POST";
//    //创建连接并发送同步请求
//    NSError *error = nil;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
//    if (error) {
//        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
//        return;
//    }
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSDictionary* dic = [self verifyPurchaseInfo:[NSURL URLWithString:AppStore] body:bodyData];
    NSLog(@"[IAPManager][verifyPurchaseWithPaymentTransaction]%@",dic);
    if([dic[@"status"] intValue] == 21007){
        dic = [self verifyPurchaseInfo:[NSURL URLWithString:SANDBOX] body:bodyData];
    }
    if([dic[@"status"] intValue] == 0){
        NSLog(@"[IAPManager][verifyPurchaseWithPaymentTransaction]购买成功");
        NSDictionary *dicReceipt = dic[@"receipt"];
        
        NSLog(@"[IAPManager][verifyPurchaseWithPaymentTransaction]dicReceipt=%@", dicReceipt);
        //NSDictionary *dicInApp = [dicReceipt[@"in_app"] firstObject];
        for(NSDictionary  *tmp in dicReceipt[@"in_app"])
        {
            NSString *productIdentifier = tmp[@"product_id"];//读取产品标识
            NSLog(@"[IAPManager][verifyPurchaseWithPaymentTransaction]productIndentify=%@",productIdentifier);
            //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([productIdentifier isEqualToString:productIndentify] ||
                [productIdentifier isEqualToString:lossIndentify])
            {
                NSInteger purchasedCount = [defaults integerForKey:productIdentifier];//已购买数量
                [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
                [TDGAVirtualCurrency onChargeSuccess:order_id];
                UnitySendMessage("PluginMercury", "PurchaseSuccessCallBack", productIdentifier.UTF8String);
            }else{
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
                UnitySendMessage("PluginMercury", "PurchaseSuccessCallBack", productIdentifier.UTF8String);
            }
        }
    }else{
        NSLog(@"[IAPManager][verifyPurchaseWithPaymentTransaction]购买失败，未通过验证！");
    }
}
- (NSDictionary*)verifyPurchaseInfo:(NSURL *)url body:(NSData* )bodyData{
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody = bodyData;
    requestM.HTTPMethod=@"POST";
    //创建连接并发送同步请求
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"[IAPManager][verifyPurchaseInfo]验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    return dic;
}

//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"[IAPManager][paymentQueue]交易完成Start");
                [self verifyPurchaseWithPaymentTransaction];// 发送到苹果服务器验证凭证
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"[IAPManager][paymentQueue]商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"[IAPManager][paymentQueue]恢复购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"[IAPManager][paymentQueue]交易失败");
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"交易失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            default:
                NSLog(@"[IAPManager][paymentQueue]未知交易");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
        }
    }
}
@end
