//
//  UIBarButtonItem+LHB.m
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-3.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import "UIBarButtonItem+LHB.h"

@implementation UIBarButtonItem (LHB)


+(UIBarButtonItem *)itemWithIcon:(NSString*)icon hightIcon:(NSString *)hightIcon target:(id) target action:(SEL)action;
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageWithName:hightIcon] forState:UIControlStateHighlighted];
    button.frame= (CGRect){CGPointZero,button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
