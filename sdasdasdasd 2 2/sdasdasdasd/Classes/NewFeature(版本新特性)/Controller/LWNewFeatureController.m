//
//  LWNewFeatureController.m
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-3.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import "LWNewFeatureController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "AccountTool.h"
#import "UserInfo.h"
#import "AQuthModel.h"
#import "MJExtension.h"
#import "NSDictionary+HuoBanMallSign.h"
#import "PayModel.h"
#import <SVProgressHUD.h>
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"
#import "AccountModel.h"
#import "UIViewController+MonitorNetWork.h"
#import "UserLoginTool.h"
#import "WXApi.h"
#import "RootViewController.h"
#import "MallMessage.h"
#import "LeftMenuModel.h"
#import "IponeVerifyViewController.h"
#import "LoginViewController.h"
#import "TabBarModel.h"

@interface LWNewFeatureController ()<UIScrollViewDelegate,WXApiDelegate>


@property(nonatomic,weak)UIPageControl * padgeControl;
@end

@implementation LWNewFeatureController



- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self myAppGetConfig];
    self.view.userInteractionEnabled = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    //1、创建scrollView
    [self setupScrollView];
    //2、添加  pageControll
    
   
    [self setupPageControll];
 
    
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
//    [UIViewController MonitorNetWork];
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 *添加  pageControll
 */
- (void)setupPageControll
{
    //添加
    UIPageControl *pageControll = [[UIPageControl alloc] init];
    pageControll.numberOfPages = LWNewFeatureImageCount;
    CGFloat padgeX = self.view.frame.size.width * 0.5;
    CGFloat padgeY = self.view.frame.size.height - 15;
    pageControll.center = CGPointMake(padgeX, padgeY);
    pageControll.userInteractionEnabled = NO;
    pageControll.bounds = CGRectMake(0, 0, 60, 40);
    [self.view addSubview:pageControll];
    //设置圆点颜色
    pageControll.currentPageIndicatorTintColor =LWColor(253, 98, 42);
    pageControll.pageIndicatorTintColor = LWColor(189, 189, 189);
    //page
    self.padgeControl= pageControll;
    
}
/**
 *  scrollView image
 */
- (void)setupScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, SecrenWith, SecrenHeight);
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    
    
    //2、添加图片
    
    CGFloat scrollW = scrollView.frame.size.width;
    CGFloat scrollH = scrollView.frame.size.height;
    
    for (int index = 0; index < LWNewFeatureImageCount; index++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if(LWNewFeatureImageCount == 1){
            CGSize viewSize = CGSizeMake(ScreenWidth, ScreenHeight);
            NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
            NSString *launchImage = nil;
            NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
            for (NSDictionary* dict in imagesDict)
            {
                CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
                
                if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
                {
                    launchImage = dict[@"UILaunchImageName"];
                }
            }
            LWLog(@"%@",launchImage);
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
        }else{
           imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"newfeature_0%d_414x736",index+1]];
        }
        
        //设置scorllview的frame
        CGFloat imageX = index * scrollW;
        CGFloat imageY = 0;
        CGFloat imageW = scrollW;
        CGFloat imageH = scrollH;
        imageView.frame =CGRectMake(imageX, imageY, imageW, imageH);
        [scrollView addSubview:imageView];
        //在最后一个图片上面添加按钮
        if (index==LWNewFeatureImageCount-1) {
            [self setupLastImageView:imageView];
        }
    }
    //设置滚动内容范围尺寸
    scrollView.contentSize = CGSizeMake(scrollW*LWNewFeatureImageCount, 0);
    
    //隐藏滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces =NO;
}

/**
 *  处理追后一个view的按钮
 */
-(void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    //添加按钮
    UIButton * startButton = [[UIButton alloc] init];
//    [startButton setBackgroundImage:[UIImage imageNamed:@"button-BR"] forState:UIControlStateNormal];

    //设置尺寸
    CGFloat centerX = imageView.frame.size.width*0.5;
    CGFloat centerY = imageView.frame.size.height*0.9;
    startButton.center = CGPointMake(centerX,centerY);
//    startButton.layer.borderWidth = 1;
    startButton.layer.cornerRadius = 5;
    startButton.layer.masksToBounds =YES;
    startButton.backgroundColor = HuoBanMallBuyNavColor;
    startButton.layer.borderColor = [UIColor blackColor].CGColor;
    [startButton becomeFirstResponder];
    startButton.bounds = (CGRect){CGPointZero,{SecrenWith*2/4,44}};
    [startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //设置文字
//    [startButton setImage:[UIImage imageNamed:@"weixing"] forState:UIControlStateNormal];
    [startButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,8)];
    [startButton setTitle:@"开始体验" forState:UIControlStateNormal];
    
    [startButton setTitleColor:ButtonTitleColor forState:UIControlStateNormal];
    [imageView addSubview:startButton];
    
}


/**
 *  开始粉猫之旅
 */
-(void)startButtonClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    RootViewController * root = [[RootViewController alloc] init];
    root.tabbarArray = self.tabbarArray;
    window.rootViewController = root;
    [window makeKeyAndVisible];

}


#pragma scorllView 代理方法

/**
 *  只要滚地就掉用这个方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x =  scrollView.contentOffset.x;
    double padgeDouble = x / scrollView.frame.size.width;
    int padgeInt = (int)(padgeDouble + 0.5);
    
    
    self.padgeControl.currentPage = padgeInt;
 
}

/**
 *  getconfig接口
 */
- (void)myAppGetConfig {
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString *url = [NSMutableString stringWithFormat:AppOriginUrl];
    [url appendString:@"/mall/getConfig"];
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        
        LWLog(@"myAppGetConfig%@",json);
        if (json) {
            MallMessage * mallmodel = [MallMessage objectWithKeyValues:json];
            NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:HuoBanMaLLMess];
            [NSKeyedArchiver archiveRootObject:mallmodel toFile:filename];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"accountmodel"] forKey:AppLoginType];
            NSString *webchannel = json[@"webchannel"];
            if (webchannel.length) {
                [[NSUserDefaults standardUserDefaults] setObject:[webchannel stringByRemovingPercentEncoding] forKey:@"KeFuWebchannel"];
            }
            [WXApi registerApp:HuoBanMallBuyWeiXinAppId withDescription:mallmodel.mall_name];
            [self getButtomTabbarData];
        }
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常请检查网络"];
//        __weak LaunchViewController * wself = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [wself myAppGetConfig];
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                wself.btn.hidden = NO;
//            });
//        });
    }];
}
#pragma mark 获取底部导航数据

- (void)getButtomTabbarData {
    NSString *url = [NSString stringWithFormat:@"%@/merchantWidgetSettings/search/findByMerchantIdAndScopeDependsScopeOrDefault/nativeCode/%@/global",NoticeCenterMainUrl,HuoBanMallBuyApp_Merchant_Id];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
    parame = [NSDictionary asignWithMutableDictionary:parame];
    __weak LWNewFeatureController * wself = self;
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        
        
        LWLog(@"%@",json);
        NSArray *array = json[@"widgets"];
        NSDictionary *dic = array[0];
        NSArray *temp = [TabBarModel  objectArrayWithKeyValuesArray:dic[@"properties"][@"Rows"]];
        [[NSUserDefaults standardUserDefaults] setObject:json[@"mallResourceURL"] forKey:@"mallResourceURL"];
        wself.tabbarArray = temp;
//        NSString * localVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppVerSion"];
//        if (localVersion.length == 0 || [localVersion isEqualToString:AppVersion] == NO) {
//            LWNewFeatureController * new = [[LWNewFeatureController alloc] init];
//            new.tabbarArray = temp;
//            [wself myAppToInit];
//            [UIApplication sharedApplication].keyWindow.rootViewController = new;
//            
//            [[NSUserDefaults standardUserDefaults] setObject:AppVersion forKey:@"AppVerSion"];
//        }
//        else {
//            NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
//            //    AQuthModel * AQuth = [AccountTool account];
//            if ([login isEqualToString:Success]) {
//                [self myAppGetUserInfo];
//            }
//            RootViewController * root = [[RootViewController alloc] init];
//            root.tabbarArray = temp;
//            [UIApplication sharedApplication].keyWindow.rootViewController = root;
//            
//        }
        
        
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
    }];
}

@end
