//
//  AccountTool.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/9/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "AccountTool.h"
#import "AQuthModel.h"
#import "AFNetworking.h"

@implementation AccountTool
+(void)saveAccount:(AQuthModel*)account
{
    NSDate * nowDate = [NSDate date];
    account.expiresTime = [nowDate dateByAddingTimeInterval:account.expires_in];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * file = [path stringByAppendingPathComponent:@"accessToken.data"];
    [NSKeyedArchiver archiveRootObject:account toFile:file];
}


+ (AQuthModel *)account
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * file = [path stringByAppendingPathComponent:@"accessToken.data"];
    AQuthModel * account = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    return account;
}


+ (BOOL)verifyAccess_Token_Effect{
    
    AQuthModel * mode = [self account];
//    NSLog(@"%@xxxxxxx-----",mode.openid);
    //判断时间时候过期
    NSDate * nowDate = [NSDate date];
    if ([nowDate compare:mode.expiresTime]==NSOrderedAscending) {//没过期
        return true;
    }
    return false;
}


@end
