//
//  NSData+NSDataDeal.m
//  fanmore---
//
//  Created by lhb on 15/6/30.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "NSData+NSDataDeal.h"

@implementation NSData (NSDataDeal)


- (NSString *)hexadecimalString {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    if (!dataBuffer)
        return [NSString string];
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}



@end
