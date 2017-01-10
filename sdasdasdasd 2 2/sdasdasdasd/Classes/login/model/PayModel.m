//
//  PayModel.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/15.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "PayModel.h"
#import "MJExtension.h"
#import <CommonCrypto/CommonCryptor.h>


@implementation PayModel


MJCodingImplementation



- (void)setAppKey:(NSString *)appKey{
    if (appKey.length > 0) {
        _appKey = [NSString encryptWithContent:appKey type:kCCDecrypt cckey:@"69a23e06"];
        
        LWLog(@"%@",_appKey);
    }else{
        _appKey = appKey;
    }
}



@end
