//
//  UITabBar+XSDExt.h
//  bameng
//
//  Created by 罗海波 on 2016/12/15.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (XSDExt)


//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index;

//移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index;


- (void)showBadgeOnItemIndex:(NSInteger)index andItemMumber:(NSUInteger)count;
@end
