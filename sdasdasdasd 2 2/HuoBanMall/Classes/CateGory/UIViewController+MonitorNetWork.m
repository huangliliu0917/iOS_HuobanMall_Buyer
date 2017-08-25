//
//  UIViewController+MonitorNetWork.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "UIViewController+MonitorNetWork.h"
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>

@implementation UIViewController (MonitorNetWork)

+ (void)MonitorNetWork{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                UIAlertView * aa =  [[UIAlertView alloc] initWithTitle:nil message:@"当前网络不可用,请检查网络状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [aa show];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
               break;
                
            }
            default:
                break;
        }
    }];
}

+ (void)ToRemoveSandBoxDate{
    
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    
//     NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
////    LWLog(@"xxxxxxxxxx===%@",path);
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    NSArray * fileName = [fileManager contentsOfDirectoryAtPath:path error:nil];
//    
//    for (int i = 0; i<fileName.count; i++) {
//        NSString * cc = [fileName[i] copy];
////        LWLog(@"xxxxxxxxxx===%@",cc);
//        NSError * error = nil;
//        
//        
//        [fileManager removeItemAtPath:[path stringByAppendingPathComponent:cc] error:&error];
//        if (error) {
//            
//            LWLog(@"%@",error.description);
//        }
//    }
    
    [[NSUserDefaults standardUserDefaults] setObject:Failure forKey:LoginStatus];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:HuoBanMallUserId];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IconHeadImage];
    
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    
    AppDelegate * de = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [de resetUserAgent:nil];
    
 
}
@end
