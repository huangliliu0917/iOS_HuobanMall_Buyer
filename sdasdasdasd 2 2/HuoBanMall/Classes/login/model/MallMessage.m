//
//  MallMessage.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/27.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "MallMessage.h"
#import "MJExtension.h"
#import "MallMessage.h"

@implementation MallMessage
MJCodingImplementation


+ (instancetype)getMallMessage{
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:HuoBanMaLLMess];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
}
@end
