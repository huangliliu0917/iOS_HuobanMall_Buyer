//
//  NSString+EXTERN.m
//  fanmore---
//
//  Created by lhb on 15/5/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "NSString+EXTERN.h"

@implementation NSString (EXTERN)



/**
 *  验证手机号的正则表达式
 */
+ (BOOL) checkTel:(NSString *) phoneNumber{
    NSString *regex = @"^(1)\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phoneNumber];
}




@end
