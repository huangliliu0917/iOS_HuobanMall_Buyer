//
//  LWNavigationController.m
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-3.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import "LWNavigationController.h"
#import "UIBarButtonItem+LHB.h"
@interface LWNavigationController ()

@end

@implementation LWNavigationController

/**
 *  一个类初始化时会调用一次
 */
+ (void)initialize
{
    //1、设置导航栏的主题
    [self setupNavBarTheme];
    
    //2、设置导航栏的按钮主题
//    [self setupNavBarButtonItemTheme];
}

+ (void)setupNavBarButtonItemTheme
{
//    UIBarButtonItem * item = [UIBarButtonItem appearance];
//    if (!iOS7) {
//        
//        [item setBackButtonBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackButtonBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_push"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//        
//        [item setBackButtonBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_disable"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
//    }
    
    
////    //设置文字
//    NSMutableDictionary * textAttr = [NSMutableDictionary dictionary];
//    textAttr[UITextAttributeTextColor] = iOS7?[UIColor orangeColor]:[UIColor grayColor];
//    //取消阴影
//    textAttr[UITextAttributeTextShadowOffset]=[NSValue valueWithUIOffset:UIOffsetZero];
//    textAttr[UITextAttributeFont] = [UIFont systemFontOfSize:15];
//
//    [item setTitleTextAttributes:textAttr forState:UIControlStateNormal];
//    [item setTitleTextAttributes:textAttr forState:UIControlStateHighlighted];
//    
//    NSMutableDictionary * disabletextAttr = [NSMutableDictionary dictionary];
//    disabletextAttr[UITextAttributeTextColor] = [UIColor grayColor];
//    [item setTitleTextAttributes:disabletextAttr forState:UIControlStateDisabled];
}
/**
 *  设置导航栏的主题
 */
+ (void)setupNavBarTheme
{
    //取出appeace对象,就能改导航栏的样式了
    UINavigationBar * NavBar = [UINavigationBar appearance];
//    NavBar. = [UIColor redColor];
    [NavBar setTintColor:BottomTaBarButtonTitleColor];
    
    if (IsIos8) {
        [NavBar setTranslucent:NO];
    }
    

//    [NavBar setBarTintColor:HuoBanMallBuyNavColor];
//    //设置标题样式
    NSMutableDictionary * textAttr = [NSMutableDictionary dictionary];
    textAttr[NSForegroundColorAttributeName] = TopNavTitleViewTitleColor;
    [NavBar setTitleTextAttributes:textAttr];
//    //取消阴影
//    textAttr[NSBaselineOffsetAttributeName]=[NSValue valueWithUIOffset:UIOffsetZero];
//    textAttr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:19];
    
    NavBar.barTintColor = TopNavTitleViewTitleColor;
    NavBar.tintColor = TopNavTitleViewTitleColor;
    [NavBar setTitleTextAttributes:@{NSForegroundColorAttributeName : TopNavTitleViewTitleColor}];
//    if (IsIos9) {
//        
//    }else{
//        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
//    [UIApplication sharedApplication] setStatusBar
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if (self.viewControllers.count>0) {
//       viewController.hidesBottomBarWhenPushed = YES;
//        
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_back" hightIcon:@"navigationbar_back_highlighted" target:self action:@selector(back)];
//        
//        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_more" hightIcon:@"navigationbar_more_highlighted" target:self action:@selector(more)];
//     }
    
    [super pushViewController:viewController animated:YES];
}


- (void)back
{
    [self popViewControllerAnimated:YES];
}
- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}
@end
