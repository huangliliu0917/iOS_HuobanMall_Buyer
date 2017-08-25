//
//  HuoBanTabBarController.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/9/5.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HuoBanTabBarController.h"
#import "HomeViewController.h"
#import "Settingviewcontrller.h"
#import "LWNavigationController.h"
#import "LWTaBar.h"


@interface HuoBanTabBarController()<LWTaBarDelegate>
@property(nonatomic,weak)LWTaBar * customTaBar;
@end
@implementation HuoBanTabBarController



- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //初始化TaBar
    [self setupTaBar];
    
    //初始化所有的子控制器
    [self setupAllChildViewControllers];
    
//    HomeViewController * aa = [[HomeViewController alloc] init];
//    aa.tabBarItem.image = [UIImage imageNamed:@"error"];
//    aa.title = @"首页";
//    UINavigationController * bb = [[UINavigationController alloc] initWithRootViewController:aa];
//    [self addChildViewController:bb];
//    
//    Settingviewcontrller * cc = [[Settingviewcontrller alloc] init];
//    cc.tabBarItem.image = [UIImage imageNamed:@"error"];
//    cc.title = @"设置";
//    UINavigationController * dd = [[UINavigationController alloc] initWithRootViewController:cc];
//    [self addChildViewController:dd];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //删除系统tabar里面的按钮
    for (UIView *child in self.tabBar.subviews) {
        
        if ([child isKindOfClass:[UIControl class]]) {
            
            [child removeFromSuperview];
        }
    }
}

/**
 *  初始化TaBar
 */
- (void)setupTaBar
{
    LWTaBar * customTaBar = [[LWTaBar alloc] init];
    //控制器成为taBar的代理
    customTaBar.delegate = self;
    customTaBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:customTaBar];
    self.customTaBar = customTaBar;
}

/**
 *  监听TaBar按钮点击
 *  @param taBar tabar
 *  @param from  原来选中按钮当位置
 *  @param to    当前点击按钮当位置
 */
- (void)taBar:(LWTaBar *)taBar didSelecteButtonFrom:(long)from to:(long)to
{
    self.selectedIndex = to;
#warning 点击首页可能要刷新
    if (to == 0) {
        
//        [self.home reFresh];
    }
}

/**
 *  初始化所有的子控制器
 */
- (void) setupAllChildViewControllers
{
    //主页
    HomeViewController * home = [[HomeViewController alloc] init];
    home.view.backgroundColor = [UIColor redColor];
    [self setupChildViewController:home title:@"主页" imageName:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
//    self.home = home;
//
    
    //主页
    UIViewController * homes = [[UIViewController alloc] init];
    homes.view.backgroundColor = [UIColor purpleColor];
    [self setupChildViewController:homes title:@"设置" imageName:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    
    //主页
    UIViewController * homess = [[UIViewController alloc] init];
    homess.view.backgroundColor = [UIColor grayColor];
    [self setupChildViewController:homess title:@"发现" imageName:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    
    //主页
    UIViewController * homesss = [[UIViewController alloc] init];
    homesss.view.backgroundColor = [UIColor grayColor];
    [self setupChildViewController:homesss title:@"123" imageName:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    //主页
    UIViewController * homessss = [[UIViewController alloc] init];
    homessss.view.backgroundColor = [UIColor grayColor];
    [self setupChildViewController:homessss title:@"678" imageName:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    
//    //消息
//    LWMessageViewController * message = [[LWMessageViewController alloc] init];
//    [self setupChildViewController:message title:@"消息" imageName:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
//    self.message = message;
//    
//    //发现
//    LWDiscoverViewController * discover = [[LWDiscoverViewController alloc] init];
//    [self setupChildViewController:discover title:@"发现" imageName:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
//    self.discover = discover;
//    //我
//    LWMeViewController * me = [[LWMeViewController alloc] init];
//    [self setupChildViewController:me title:@"我" imageName:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
//    self.me = me;
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc       需要初始化的子控制器
 *  @param title         标题
 *  @param imageName     图标
 *  @param selectedImage 选中图标
 */
- (void) setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *) imageName selectedImage:(NSString *)selectedImage
{
    //1设置控制器属性
    childVc.title = title;
    
    //选中的图片
    UIImage * selectImage = [UIImage imageNamed:selectedImage];
    childVc.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    //默认图片
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 2包装一个自定义的导航控制器
    LWNavigationController *nav = [[LWNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    //3 设置tabbar内部的按钮
    [self.customTaBar addTabBarButtonWithItem:childVc.tabBarItem];
}

@end
