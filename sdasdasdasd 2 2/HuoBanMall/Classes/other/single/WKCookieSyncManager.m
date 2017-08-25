//
//  WKCookieSyncManager.m
//  HuoBanMall
//
//  Created by lhb on 16/11/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "WKCookieSyncManager.h"

@implementation WKCookieSyncManager


static WKCookieSyncManager * _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [WKCookieSyncManager shareInstance] ;
}


- (WKProcessPool *)processPool{
    
    if (_processPool == nil) {
        _processPool = [[WKProcessPool alloc] init];
    }
    return _processPool;
}

@end


