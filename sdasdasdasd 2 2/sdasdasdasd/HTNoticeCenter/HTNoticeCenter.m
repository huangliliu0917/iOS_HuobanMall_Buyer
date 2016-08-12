//
//  HTNoticeCenter.m
//  HTNoticeCenter
//
//  Created by lhb on 16/4/22.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "HTNoticeCenter.h"
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define LWLog(...) NSLog(__VA_ARGS__)
#else
#define LWLog(...)
#endif




@implementation HTNoticeCenter

+ (void)HTNoticeCenterRegisterRemoteNotice{
    
    UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge |
                                                             UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


/**
 *  向服务端提交
 *
 *  @param deviceToken deviceToken
 *  @param Result      成功失败
 */
+ (void)HTNoticeCenterRegisterToServerWithDeviceToken:(NSString *)deviceToken DealResult:(void(^)(HTNoticeCenterDealResult resultType))Result{
    Result(HTNoticeCenterFailure);
}




+ (void)HTNoticeCenterRegisterToServerWithDeviceToken:(NSString *)deviceToken AndUserId:(NSString *)UserId  DealResult:(void(^)(HTNoticeCenterDealResult resultType))Result{

    NSString * rowUrl = [NSString stringWithFormat:@"%@/userBinding/bindingTokenOrAlias/%@?token=%@",NoticeCenterMainUrl,UserId,deviceToken];
    //2.构造Request
    NSData * uslDate = [rowUrl dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[[NSString alloc] initWithData:uslDate encoding:NSUTF8StringEncoding]]];
    //(1)设置为POST请求
    [request setHTTPMethod:@"PUT"];   
    //(2)超时
    [request setTimeoutInterval:60];
    [request setValue:NoticeCenterAppKey forHTTPHeaderField:@"_user_key"];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    [request setValue:timeString forHTTPHeaderField:@"_user_random"];
    NSString * head = [self HotTechAsignWith:NoticeCenterAppKey];
    //(3)设置请求头
    [request setAllHTTPHeaderFields:nil];
    [request setValue:head forHTTPHeaderField:@"_user_secure"];
    //3.构造Session
    NSURLSession *session = [NSURLSession sharedSession];
    //4.task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        LWLog(@"%@",response);
        if (!error) {
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                LWLog(@"%@",dict);
            }
           dispatch_async(dispatch_get_main_queue(), ^{
               Result(HTNoticeCenterSuccess);
           });
        }else{
            LWLog(@"%s---registerDevicetoken: %@",__func__, [error description]);
            dispatch_async(dispatch_get_main_queue(), ^{
                Result(HTNoticeCenterFailure);
            });
        }
    }];
    //5.发起请求
    [task resume];
    
}

///deviceBinding/bindingTokenOrAlias/123
+ (void)HTNoticeCenterRegisterToServerWithDeviceTokenWithNoUserInfo:(NSString *)deviceToken AndCustomerId:(NSString *)CustomerId  DealResult:(void(^)(HTNoticeCenterDealResult resultType))Result{
    
    NSString * rowUrl = [NSString stringWithFormat:@"%@/deviceBinding/bindingTokenOrAlias/%@?token=%@",NoticeCenterMainUrl,CustomerId,deviceToken];
    //2.构造Request
    NSData * uslDate = [rowUrl dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[[NSString alloc] initWithData:uslDate encoding:NSUTF8StringEncoding]]];
    //(1)设置为POST请求
    [request setHTTPMethod:@"PUT"];
    //(2)超时
    [request setTimeoutInterval:60];
    [request setValue:NoticeCenterAppKey forHTTPHeaderField:@"_user_key"];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    [request setValue:timeString forHTTPHeaderField:@"_user_random"];
    NSString * head = [self HotTechAsignWith:NoticeCenterAppKey];
    //(3)设置请求头
    [request setAllHTTPHeaderFields:nil];
    [request setValue:head forHTTPHeaderField:@"_user_secure"];
    //3.构造Session
    NSURLSession *session = [NSURLSession sharedSession];
    //4.task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        LWLog(@"%@",response);
        if (!error) {
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                LWLog(@"%@",dict);
            }
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                Result(HTNoticeCenterSuccess);
            //            });
        }else{
            //            LWLog(@"%s---registerDevicetoken: %@",__func__, [error description]);
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                Result(HTNoticeCenterFailure);
            //            });
        }
    }];
    //5.发起请求
    [task resume];
    
}


+ (void)HTNoticeCenterToDealRemoteNoticeWithNotice:(NoticeMessage *)notice ResultNoticeCeterType:(void(^)(HTNoticeCenterNoticeType type))NoticeSuccess{
    
    NSString *type =  notice.type;
    if ([type isEqualToString:@"DownRegisterSuccess"]) {//下线会员注册成功
        NoticeSuccess(HTNoticeTypeDownRegisterSuccess);
    }else if ([type isEqualToString:@"UpgradePartner"]) {//会员升级成小伙伴
        NoticeSuccess(HTNoticeTypeUpgradePartner);
    }else if ([type isEqualToString:@"PaySuccess"]) {//订单支付成功
        NoticeSuccess(HTNoticeTypePaySuccess);
    }else if ([type isEqualToString:@"SendRedPackets"]) {//小伙伴发送红包
        NoticeSuccess(HTNoticeTypeSendRedPackets);
    }else if ([type isEqualToString:@"DownPaySuccess"]) {//下线订单支付成功
        NoticeSuccess(HTNoticeTypeDownPaySuccess);
    }else if ([type isEqualToString:@"GetStock"]) {//获得股数
        NoticeSuccess(HTNoticeTypeGetStock);
    }else if ([type isEqualToString:@"WithdrawApply"]) {//余额提现申请
        NoticeSuccess(HTNoticeTypeWithdrawApply);
    }else if ([type isEqualToString:@"OrderShip"]) {//订单发货
        NoticeSuccess(HTNoticeTypeOrderShip);
    }else if ([type isEqualToString:@"GetRedPackets"]) {//会员获得红包通知
        NoticeSuccess(HTNoticeTypeGetRedPackets);
    }else if ([type isEqualToString:@"UpgradeDreamPartner"]) {//升级成为梦想合伙人
        NoticeSuccess(HTNoticeTypeUpgradeDreamPartner);
    }else{
        NoticeSuccess(HTNoticeTypeUnKnow);
    }
}


+ (NSString *)HotTechAsignWith:(NSString *)key{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    NSString * firstSecure =  [NSString stringWithFormat:@"%@%@",NoticeCenterAppKey,timeString];
    NSData * test = [firstSecure dataUsingEncoding:NSUTF8StringEncoding];
    Byte MD5result[16];
    CC_MD5([test bytes],(UInt8)[test length],MD5result);
    NSData *adata = [[NSData alloc] initWithBytes:MD5result length:16];
    NSData * ta1 = [self test:NoticeCenterAppSecure];
    NSMutableData * cc = [NSMutableData dataWithData:adata];
    [cc appendData:ta1];
    CC_MD5([cc bytes],(UInt8)[cc length],MD5result);
    NSString * signS = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        MD5result[0], MD5result[1], MD5result[2], MD5result[3],
                        MD5result[4], MD5result[5], MD5result[6], MD5result[7],
                        MD5result[8], MD5result[9], MD5result[10], MD5result[11],
                        MD5result[12], MD5result[13], MD5result[14], MD5result[15]
                        ];
    return signS;
}


+ (NSData * )test:(NSString *)hexString{
    int j=0;
    Byte bytes[128];  ///3ds key的Byte 数组， 128位
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
        
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:j];
    return newData;
}



+ (void)HotTechShowMessageWithMessage:(NoticeMessage *)note block:(void(^)(id message))dealMessage{
    dealMessage(note);
}
@end
