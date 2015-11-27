//
//  UIViewController+MonitorNetWork.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "UIViewController+MonitorNetWork.h"

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
    
     NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"xxxxxxxxxx===%@",path);
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * fileName = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    for (int i = 0; i<fileName.count; i++) {
        NSString * cc = [fileName[i] copy];
//        NSLog(@"xxxxxxxxxx===%@",cc);
        NSError * error = nil;
        
        
        [fileManager removeItemAtPath:[path stringByAppendingPathComponent:cc] error:&error];
        if (error) {
            
            NSLog(@"%@",error.description);
        }
    }
    
//    [fileName enumerateObjectsUsingBlock:^(NSString * fileName, NSUInteger idx, BOOL *stop) {
//       
//        NSLog(@"%@",fileName);
//        [fileManager removeItemAtPath:fileName error:nil];
//    }];
 
}
@end
