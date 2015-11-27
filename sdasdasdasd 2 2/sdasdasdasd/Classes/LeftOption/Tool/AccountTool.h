//
//  AccountTool.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/9/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AQuthModel;
@interface AccountTool : NSObject
/**
 *  存储账号
 */
+(void)saveAccount:(AQuthModel*)account;


/**
 *  读取账号
 *@return <#return value description#>
 */
+ (AQuthModel *)account;


/**
 *  验证access_code的有效行
 */
+ (BOOL)verifyAccess_Token_Effect;
@end
