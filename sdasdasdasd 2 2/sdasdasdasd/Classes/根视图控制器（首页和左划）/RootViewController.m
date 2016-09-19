//
//  RootViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "RootViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "HuoBanTabBarController.h"
#import "HTLeftTableViewController.h"
#import "LWNavigationController.h"
#import "HomeViewController.h"
#import "MallTabbarViewController.h"
#import "TabBarModel.h"
@interface RootViewController ()

@property (nonatomic, strong) NSMutableArray *controllerArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //设置左侧控制器
    
    self.controllerArray = [NSMutableArray array];
    for (int i = 0; i < self.tabbarArray.count;  i++) {
        HomeViewController * home = [[HomeViewController alloc] init];
        
        
    }
    
    
    HTLeftTableViewController * left = [[HTLeftTableViewController alloc] init];
    self.leftDrawerViewController = left;

    //设置中间视图控制器
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController * home = [[HomeViewController alloc] init];
//    home.view.backgroundColor = [UIColor whiteColor];
    LWNavigationController * navs = [[LWNavigationController alloc] initWithRootViewController:home];
    self.centerViewController = navs;
    
    
    //设置右侧视图控制器
    self.rightDrawerViewController = nil;
    
    //设置测拉宽度
    self.maximumLeftDrawerWidth = [UIScreen mainScreen].bounds.size.width * SplitScreenRate;
//    self.maximumRightDrawerWidth = 0;
    
    //设置手势范围
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    // 6.设置动画切换
    // 01.配置动画
    [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block = [[MMExampleDrawerVisualStateManager sharedManager] drawerVisualStateBlockForDrawerSide:drawerSide];
        if (block != nil) {
            block(drawerController,drawerSide,percentVisible);
        }

    }];
    
    [self setShowsShadow:NO];
    [MMExampleDrawerVisualStateManager sharedManager].leftDrawerAnimationType = MMDrawerAnimationTypeParallax;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
