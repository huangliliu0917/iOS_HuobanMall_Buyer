//
//  NSString+Des.m
//  sdsfdsfsdf
//
//  Created by 罗海波 on 2017/1/9.
//  Copyright © 2017年 罗海波. All rights reserved.
//

#import "NSString+Des.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>
#define key @"69a23e06"
// 向量

//密钥
#define gkey            @"69a23e06"
//偏移量
#define gIv             @"01234567"
@implementation NSString (Des)



/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *urlKey = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (urlKey == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:urlKey];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:urlKey];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:urlKey];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:urlKey];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *urlKey = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (urlKey == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:urlKey];
    }
    
    return params;
}



+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *cckey)
{
    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
    //      NSLog(@"[[item.url description] UTF8String=%@",textString);
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[textString dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
        
        
    }
    else  //encrypt
    {
        NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 00, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    //NSString *initIv = @"12345678";
    const void *vkey = cckey;
    const void *iv = (const void *) cckey; //[initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    return [result UTF8String];
    
}


+(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type cckey:(NSString*)aKey
{
    const char * contentChar =[content UTF8String];
    char * keyChar =(char*)[aKey UTF8String];
    const char *miChar;
    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
    return  [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
}




@end
