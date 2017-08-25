//
//  NSString+EXTERN.m
//  fanmore---
//
//  Created by lhb on 15/5/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "NSString+EXTERN.h"
#import "MD5Encryption.h"

@implementation NSString (EXTERN)



/**
 *  验证手机号的正则表达式
 */
+ (BOOL) checkTel:(NSString *) phoneNumber{
    NSString *regex = @"^(1)\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phoneNumber];
}




+ (NSString *)stringWithMutableDictionary:(NSMutableDictionary *)dict {
    //计算asign参数
    NSArray * arr = [dict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        return [obj1 compare:obj2] == NSOrderedDescending;
    }];
    NSMutableString * signCap = [[NSMutableString alloc] init];
    //进行asign拼接
    for (NSString * dicKey in arr) {
        [signCap appendString:[NSString stringWithFormat:@"%@",[dict valueForKey:dicKey]]];
    }
    
    return [MD5Encryption md5by32:signCap];
}
@end
