//
//  LeftMenuModel.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/9/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeftMenuModel : NSObject

@property(nonatomic,assign) int menu_group;
@property(nonatomic,strong) NSString * menu_icon;
@property(nonatomic,strong) NSString * menu_name;
@property(nonatomic,strong) NSString * menu_tag;
@property(nonatomic,strong) NSString * menu_url;

@end
