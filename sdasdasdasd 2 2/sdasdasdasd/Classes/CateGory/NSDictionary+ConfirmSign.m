//
//  NSDictionary+ConfirmSign.m
//  sdasdasdasd
//
//  Created by lhb on 16/9/23.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "NSDictionary+ConfirmSign.h"
#import "MD5Encryption.h"



@implementation NSDictionary (ConfirmSign)

- (BOOL) HuoTuPayInfoConfConfirmWithOrderId:(NSString *)OrderId{
    if ( OrderId == nil) {
        return false;
    }
    if (![[self objectForKey:@"orderid"] isEqualToString:OrderId]) {
        return false;
    }
    //1、获取动态字典，剔除sign字段
    NSMutableDictionary * newDict = [[NSMutableDictionary alloc] initWithDictionary:self];
    [newDict removeObjectForKey:@"sign"];
    //2、剔除字段为空的数据
    NSArray * arrKey = [newDict allKeys];
    [arrKey enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * cc =[NSString stringWithFormat:@"%@", [newDict objectForKey:obj]];
        if (cc.length==0) {
            [newDict removeObjectForKey:obj];
        }
    }];
    //3、数据进行排序
    arrKey = [newDict allKeys];
    arrKey = [arrKey sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        return [[obj1 lowercaseString] compare:[obj2 lowercaseString]] == NSOrderedDescending;
    }];
    //4、对数据进行拼接
    NSMutableString * signCap = [[NSMutableString alloc] init];
    for (NSString * dicKey in arrKey) {
        [signCap appendString:[NSString stringWithFormat:@"%@=%@&", [dicKey lowercaseString], [newDict objectForKey:dicKey]]];
    }
    NSString * aa = [signCap substringToIndex:signCap.length-1];
    NSString * cc  = [NSString stringWithFormat:@"%@%@",aa,HuoBanMallBuyAppSecrect];
    return [[MD5Encryption md5by32:cc] isEqualToString:[self objectForKey:@"sign"]];
}






@end
