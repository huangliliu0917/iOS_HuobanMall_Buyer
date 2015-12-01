//
//  SISGoodModel.h
//  HuoBanMallBuy
//
//  Created by 刘琛 on 15/11/23.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SISGoodModel : NSObject

@property (nonatomic, strong) NSString *goodsId;

@property (nonatomic, strong) NSString *goodsName;

@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSString *profit;

@property (nonatomic, strong) NSString *stock;

@property (nonatomic, strong) NSString *detailsUrl;

@property (nonatomic, strong) NSString *rebate;

@property (nonatomic, assign) BOOL goodSelected;

@end
