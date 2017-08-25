//
//  UIBarButtonItem+LHB.h
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-3.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LHB)

/**
 *  快速产生一个item
 *
 *  @param icon      普通图片
 *  @param hightIcon 高亮图片
 *  @param target    监听对象
 *  @param action    监听方法
 *
 *  @return <#return value description#>
 */
+(UIBarButtonItem *)itemWithIcon:(NSString*)icon hightIcon:(NSString *)hightIcon target:(id) target action:(SEL)action;
@end
