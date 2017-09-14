//
//  NSMutableDictionary+UrlParame.h
//  HuoBanMall
//
//  Created by lhb on 2017/9/11.
//  Copyright © 2017年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (UrlParame)
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;
@end
