//
//  MallMessage.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/27.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MallMessage : NSObject

@property(nonatomic,strong) NSString * mall_description;
@property(nonatomic,strong) NSString * mall_logo;
@property(nonatomic,strong) NSString * mall_name;
@property(nonatomic,strong) NSString * mall_site;


+ (instancetype)getMallMessage;
@end
