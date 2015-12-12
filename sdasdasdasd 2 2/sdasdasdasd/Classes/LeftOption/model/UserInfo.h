//
//  UserInfo.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/9/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//  用户信息

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/**
 {
 city = Shaoxing;
 country = CN;
 headimgurl = "http://wx.qlogo.cn/mmopen/F8RjDus4R6AiausgyKibkrJp0q5nwwCFeichj0613Xtib01YRemLttgWw1MHmvItoHRCVf1SNZftzfGmiaIQJBiciaI1NyRmcr4SU6e/0";
 language = "zh_CN";
 nickname = Luohaibo;
 openid = ow92RuL4PiGnKAikOV7iDFgvp92A;
 privilege =     (
 );
 province = Zhejiang;
 sex = 1;
 unionid = "o76SuuMeJjOp0Tnsr2AQnPD_0RKs";
 }

 */

@property(nonatomic,strong) NSString * city;
@property(nonatomic,strong) NSString * country;
@property(nonatomic,strong) NSString * headimgurl;
@property(nonatomic,strong) NSString * language;
@property(nonatomic,strong) NSString * nickname;
@property(nonatomic,strong) NSString * openid;
@property(nonatomic,strong) NSArray * privilege;
@property(nonatomic,strong) NSString * province;
@property(nonatomic,strong) NSNumber * sex;
@property(nonatomic,strong) NSString * unionid;
@property(nonatomic,strong) NSString *relatedType;
@end
