//
//  NSDictionary+HuoBanMallSign.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/13.
//  Copyright (c) 2015年 HT. All rights reserved.
//  网页链接签名

#import <Foundation/Foundation.h>

@interface NSDictionary (HuoBanMallSign)


+ (NSMutableDictionary *)asignWithMutableDictionary:(NSMutableDictionary *)dict;

+ (NSString *)ToSignUrlWithString:(NSString *)urlStr;
@end
