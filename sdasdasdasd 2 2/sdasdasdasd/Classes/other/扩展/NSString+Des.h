//
//  NSString+Des.h
//  sdsfdsfsdf
//
//  Created by 罗海波 on 2017/1/9.
//  Copyright © 2017年 罗海波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface NSString (Des)

+(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type cckey:(NSString*)aKey;


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
