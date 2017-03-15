//
//  PayModel.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/15.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayModel : NSObject
/**
 appId = wxaeda2d5603b12302;
 appKey = 0db0d4908a6ae6a09b0a7727878f0ca6;
 partnerId = 1251040401;
 payType = 300;
 payTypeName = "\U5fae\U4fe1APP\U652f\U4ed8";
 */


@property(nonatomic,strong) NSString * appId;

@property(nonatomic,strong) NSString * appKey;

@property(nonatomic,strong) NSString * partnerId;

@property(nonatomic,strong) NSString * payType;

@property(nonatomic,strong) NSString * payTypeName;

@property(nonatomic,strong) NSString * notify;

@property(nonatomic,assign) BOOL webPagePay;





@end
