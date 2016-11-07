//
//  WKCookieSyncManager.h
//  sdasdasdasd
//
//  Created by lhb on 16/11/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKCookieSyncManager : NSObject


+(instancetype) shareInstance;

@property(nonatomic,strong) WKProcessPool * processPool;

@end
