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
#import <SDWebImage/SDWebImageManager.h>
#import <SVProgressHUD.h>
#import "IponeVerifyViewController.h"
#import "KeFuViewController.h"



@interface RootViewController ()<UITabBarControllerDelegate>


@property (nonatomic, strong) NSMutableArray *controllerArray;

@property (nonatomic, assign) int index;

@end

@implementation RootViewController

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    
    if ([viewController isKindOfClass:[KeFuViewController class]]) {
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
        {
            
            
            NSString * webqq = [[NSUserDefaults standardUserDefaults] objectForKey:@"webqq"];
            
            if (webqq.length) {
                //用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
                NSString *QQ = webqq;
                //调用QQ客户端,发起QQ临时会话
                NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
            
        }
        
        return NO;
    }
    
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //设置左侧控制器
    MallTabbarViewController *tabbar = [[MallTabbarViewController alloc] init];
    tabbar.delegate = self;
    tabbar.tabbarArray = self.tabbarArray;
    
    self.controllerArray = [NSMutableArray array];
    NSString *imageHostUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"mallResourceURL"];
    
    for (int i = 0; i < self.tabbarArray.count;  i++) {
        
        TabBarModel *model = self.tabbarArray[i];
        
        
        model.linkUrl = [model.linkUrl stringByReplacingOccurrencesOfString:@"{CustomerID}" withString:HuoBanMallBuyApp_Merchant_Id];
        LWLog(@"%@",model.linkUrl);
        
        
        
        NSString * webchannel = [[NSUserDefaults standardUserDefaults] objectForKey:@"KeFuWebchannel"];
        
        
        
        //是qq 且 webchannel 没值
        if ([model.linkUrl isEqualToString:@"{QQ}"] && !webchannel.length) {
            
            
            NSString * webqq = [[NSUserDefaults standardUserDefaults] objectForKey:@"webqq"];
            
            if (webqq.length) {
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
                    KeFuViewController * vc = [[KeFuViewController alloc] init];
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageHostUrl,model.imageUrl]] options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        if (error) {
                        }
                        if (image) {
                            
                            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:model.name image:[self imageCompressForSize:image targetSize:CGSizeMake(24, 24) ] tag:0];
                            vc.tabBarItem = item;
                        }
                    }];
                    
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageHostUrl,model.heightImageUrl]] options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        if (error) {
                        }
                        if (image) {
                            
                            vc.tabBarItem.selectedImage = [[self imageCompressForSize:image targetSize:CGSizeMake(24, 24) ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                        }
                    }];
                    [tabbar addChildViewController:vc];
                }

            }
            
            
        }else{
            
            HomeViewController * home = [[HomeViewController alloc] init];
            tabbar.delegate = self;
            home.openUrl = model.linkUrl;
            if ([model.linkUrl isEqualToString:@"{QQ}"]) {
                home.openUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"KeFuWebchannel"];
            }
            if ([model.linkUrl rangeOfString:@"/index.aspx?back"].location != NSNotFound) {
                tabbar.HomePage = i;
            }
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageHostUrl,model.imageUrl]] options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (error) {
                }
                if (image) {
                    
                    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:model.name image:[self imageCompressForSize:image targetSize:CGSizeMake(24, 24) ] tag:0];
                    home.tabBarItem = item;
                }
            }];
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageHostUrl,model.heightImageUrl]] options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (error) {
                }
                if (image) {
                    
                    home.tabBarItem.selectedImage = [[self imageCompressForSize:image targetSize:CGSizeMake(24, 24) ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                }
            }];
            LWNavigationController * nav = [[LWNavigationController alloc] initWithRootViewController:home];
            [tabbar addChildViewController:nav];
            
        }
        
    }
    [tabbar.tabBar setTintColor:BottomTaBarButtonTitleColor];
    [tabbar.tabBar setBarTintColor:[UIColor whiteColor]];
    tabbar.selectedIndex = tabbar.HomePage;
    
    tabbar.delegate = self;
    
    HTLeftTableViewController * left = [[HTLeftTableViewController alloc] init];
    self.leftDrawerViewController = left;
    
    //设置中间视图控制器
    
    //    HomeViewController * home = [[HomeViewController alloc] init];
    //    home.view.backgroundColor = [UIColor whiteColor];
    //    LWNavigationController * navs = [[LWNavigationController alloc] initWithRootViewController:tabbar];
    self.centerViewController = tabbar;
    
    
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




-(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = size.width;
    
    CGFloat targetHeight = size.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGFloat scaledWidth = targetWidth;
    
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            
            scaleFactor = widthFactor;
            
        }
        
        else{
            
            scaleFactor = heightFactor;
            
        }
        
        scaledWidth = width * scaleFactor;
        
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            
        }
        
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    
    thumbnailRect.size.width = scaledWidth;
    
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
        
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}



@end
