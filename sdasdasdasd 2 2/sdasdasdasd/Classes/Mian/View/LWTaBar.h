//
//  LWTaBar.h
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-2.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LWTaBar;

@protocol LWTaBarDelegate <NSObject>

@optional

- (void)taBar:(LWTaBar *)taBar didSelecteButtonFrom:(long) from to:(long)to;

- (void)taBarDidPlusButtonClick:(LWTaBar *)taBar;

@end
@interface LWTaBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property(nonatomic,weak)id<LWTaBarDelegate>delegate;
@end
