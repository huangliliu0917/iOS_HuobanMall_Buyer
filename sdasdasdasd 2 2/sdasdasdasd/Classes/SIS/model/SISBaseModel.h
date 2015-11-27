//
//  SISBaseModel.h
//  HuoBanMallBuy
//
//  Created by 刘琛 on 15/11/18.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SISBaseModel : NSObject

@property (nonatomic, assign) BOOL enableSis;

@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) NSString *sisId;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *indexUrl;

@property (nonatomic, strong) NSString *sisDescription;

@property (nonatomic, strong) NSString *shareDescription;

@property (nonatomic, strong) NSString *shareTitle;

@end
