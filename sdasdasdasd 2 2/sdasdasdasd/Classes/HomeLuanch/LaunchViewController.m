//
//  LaunchViewController.m
//  sdasdasdasd
//
//  Created by lhb on 16/9/9.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "LaunchViewController.h"
#import "UserLoginTool.h"
#import "PayModel.h"
#import "MallMessage.h"
#import "WXApi.h"
#import "LWNewFeatureController.h"
#import "RootViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "LeftMenuModel.h"
#import "UserInfo.h"
#import "UIViewController+MonitorNetWork.h"
#import "TabBarModel.h"

@interface LaunchViewController ()


@property(nonatomic,strong) UIButton * btn;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setImage];
    
    
    //[self AddButtonToRefresh];
    
    
    
    
    

    
    AFNetworkReachabilityManager * Reachability = [AFNetworkReachabilityManager sharedManager];
    
    [Reachability startMonitoring];
    
    NSLog(@"AFNetworkReachabilityManager－－%ld",(long)Reachability.networkReachabilityStatus);
    if (Reachability.networkReachabilityStatus > 0) {
        
        [self NewMyAppToInit];
        //[self myAppToInit];
           
    }
    
    [Reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (!(status == 0) || (status == -1)) {
            [self NewMyAppToInit];
             //[self myAppToInit];

        }else{
           
            //UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"当前设备网络异常，请检查当前设备网络" preferredStyle:UIAlertControllerStyleAlert];
            //UIAlertAction * ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            //[vc addAction:ac];
            //[self presentViewController:vc animated:YES completion:nil];
        }
    }];
    
    

    
    
}


- (void)AddButtonToRefresh{
    
    UIButton * startButton = [[UIButton alloc] init];
    _btn = startButton;
    startButton.hidden = YES;
    [startButton setTitle:@"重新进入" forState:UIControlStateNormal];
    [startButton setTitleColor:ButtonTitleColor forState:UIControlStateNormal];
    //设置尺寸
    CGFloat centerX = ScreenWidth * 0.5;
    CGFloat centerY = ScreenHeight * 0.9;
    startButton.center = CGPointMake(centerX,centerY);
    //    startButton.layer.borderWidth = 1;
    startButton.layer.cornerRadius = 5;
    startButton.layer.masksToBounds =YES;
    startButton.backgroundColor = HuoBanMallBuyNavColor;
    startButton.layer.borderColor = [UIColor blackColor].CGColor;
    [startButton becomeFirstResponder];
    startButton.bounds = (CGRect){CGPointZero,{SecrenWith*2/4,44}};
    [startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
}

- (void)startButtonClick{
    
    [self myAppGetConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//处理白屏问题
- (void)setImage {
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
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    launchView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:launchView];

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
    
    __block AppDelegate * appde =(AppDelegate *)[UIApplication sharedApplication].delegate;
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        
        LWLog(@"myAppGetConfig%@",json);
        if (json) {

            NSArray * adArray = [AdModel mj_objectArrayWithKeyValuesArray:json[@"appad"]];
            appde.Ad = [adArray firstObject];
            
            MallMessage * mallmodel = [MallMessage mj_objectWithKeyValues:json];
            NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:HuoBanMaLLMess];
            [NSKeyedArchiver archiveRootObject:mallmodel toFile:filename];
            /*
            微信加手机 = 0,
            手机登录 = 1,
            微信登录 = 2,
            手机为主授权为辅 = 3
            */
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

- (void)myAppGetUserInfo {
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"userid"] = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId]];
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString *url = [NSMutableString stringWithFormat:AppOriginUrl];
    [url appendString:@"/Account/getAppUserInfo"];
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        
        LWLog(@"%@",json);
        if ([json[@"code"] integerValue] == 200) {
            UserInfo * userInfo = [[UserInfo alloc] init];
            userInfo.unionid = json[@"data"][@"unionId"];
            userInfo.nickname = json[@"data"][@"nickName"];
            userInfo.headimgurl = json[@"data"][@"headImgUrl"];
            userInfo.openid = json[@"data"][@"openId"];
            
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
            [NSKeyedArchiver archiveRootObject:userInfo toFile:fileName];
            
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"IsMobileBind"] forKey:@"bangShouji"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"levelName"] forKey:HuoBanMallMemberLevel];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"userid"] forKey:HuoBanMallUserId];
            if (![json[@"data"][@"headImgUrl"] isKindOfClass:[NSNull class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"headImgUrl"] forKey:IconHeadImage];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:@"21321321" forKey:IconHeadImage];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"userType"] forKey:MallUserType];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"relatedType"] forKey:MallUserRelatedType];
            NSArray * lefts = [LeftMenuModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"home_menus"]];
            NSMutableData *data = [[NSMutableData alloc] init];
            //创建归档辅助类
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            //编码
            [archiver encodeObject:lefts forKey:LeftMenuModels];
            //结束编码
            [archiver finishEncoding];
            
            NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:LeftMenuModels];
            //写入
            [data writeToFile:filename atomically:YES];
            
            [self resetUserAgent:nil];
        }else {
            [UIViewController ToRemoveSandBoxDate];
            [[NSUserDefaults standardUserDefaults] setObject:Failure forKey:LoginStatus];
        }
    } failure:^(NSError *error) {
        LWLog(@"%@", error);
    }];
}

- (void)resetUserAgent:(NSString *) goUrl {
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //add my info to the new agent
    NSString *newAgent = nil;
    UserInfo * usaa = nil;
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
    usaa =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId];
    //    NSString *tempUserId = [(NSNumber*)userID  stringValue]
    if ([NSString stringWithFormat:@"%@", userID].length == 0) {
        userID = @"";
    }
    if (usaa) {
        if (usaa.unionid) {
        }else {
            usaa.unionid = @"";
        }
        if (usaa.openid) {
        }else {
            usaa.openid= @"";
        }
    }else {
        usaa = [[UserInfo alloc] init];
        usaa.openid = @"";
        usaa.unionid = @"";
    }
    
    NSString *str = [MD5Encryption md5by32:[NSString stringWithFormat: @"%@%@%@%@",userID, usaa.unionid, usaa.openid, SISSecret]];
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    newAgent = [appDelegate.Agent stringByAppendingString:[NSString stringWithFormat: @";mobile;hottec:%@:%@:%@:%@;",str,userID, usaa.unionid, usaa.openid]];
    
    
    appDelegate.userAgent = newAgent;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ResetAllWebAgent object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (goUrl) {
            NSDictionary * objc = [NSDictionary dictionaryWithObject:goUrl forKey:@"url"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
        }
    });
    
}

#pragma mark 获取底部导航数据

- (void)getButtomTabbarData {
    
    
    __weak typeof(self) wself = self;
    NSString *url = [NSString stringWithFormat:@"%@/merchantWidgetSettings/search/findByMerchantIdAndScopeDependsScopeOrDefault/nativeCode/%@/global",NoticeCenterMainUrl,([HuoBanMallBuyApp_Merchant_Id intValue] == 5020 ? @"7944" :HuoBanMallBuyApp_Merchant_Id)];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
    parame = [NSDictionary asignWithMutableDictionary:parame];
    //__weak LaunchViewController * wself = self;
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        LWLog(@"%@",json);
        NSArray *array = json[@"widgets"];
        NSDictionary *dic = array[0];
        NSArray *temp = [TabBarModel  mj_objectArrayWithKeyValuesArray:dic[@"properties"][@"Rows"]];
        
        
        //底部栏目图片的域名地址
        [[NSUserDefaults standardUserDefaults] setObject:json[@"mallResourceURL"] forKey:@"mallResourceURL"];
        
        
        NSString * localVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppVerSion"];
        if (localVersion.length == 0 || [localVersion isEqualToString:AppVersion] == NO) {
            LWNewFeatureController * new = [[LWNewFeatureController alloc] init];
            new.tabbarArray = temp;
            //            [wself myAppToInit];
            [UIApplication sharedApplication].keyWindow.rootViewController = new;
            
            [[NSUserDefaults standardUserDefaults] setObject:AppVersion forKey:@"AppVerSion"];
        }else {
            NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
            //    AQuthModel * AQuth = [AccountTool account];
            if ([login isEqualToString:Success]) {
                [self myAppGetUserInfo];
            }
            RootViewController * root = [[RootViewController alloc] init];
            root.tabbarArray = temp;
            [UIApplication sharedApplication].keyWindow.rootViewController = root;
            
            
            [self getMallBaseInfo];
            
            
        }
        
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
        [wself getButtomTabbarData];
    }];
}

/**
 *  app初始化接口
 */
- (void)NewMyAppToInit{
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
    if ([HuoBanMallBuyApp_Merchant_Id intValue] == 5020) {
       parame[@"merchantid"] = @"7944";
    }
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
    [url appendString:@"/mall/InitMall"];
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        LWLog(@"myAppToInit%@",json);
        if ([json[@"code"] integerValue] == 200) {
            //测试模式
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"testMode"] forKey:TestMode];
            //站点地址
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"msiteUrl"] forKey:AppMainUrl];
            //支付信息
            NSArray * payType = [PayModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"payConfig"]];
            LWLog(@"%lu",(unsigned long)payType.count);
            AppDelegate * de = (AppDelegate *)[UIApplication sharedApplication].delegate;
            de.payConfig = payType;
            [self myAppGetConfig];
        }
    } failure:^(NSError *error) {
        LWLog(@"%@",error.description);
        
        [self NewMyAppToInit];
    }];
    
}


/**
 *  app初始化接口
 */
- (void)myAppToInit{
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
    if ([HuoBanMallBuyApp_Merchant_Id intValue] == 5020) {
        parame[@"merchantid"] = @"7944";
    }
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
    [url appendString:@"/mall/Init"];
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        
        LWLog(@"myAppToInit%@",json);
        if ([json[@"code"] integerValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"testMode"] forKey:TestMode];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"msiteUrl"] forKey:AppMainUrl];
            NSArray * payType = [PayModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"payConfig"]];
            
            LWLog(@"%lu",(unsigned long)payType.count);
            
            LWLog(@"%@", [payType objectAtIndex:0]);
            NSMutableData *data = [[NSMutableData alloc] init];
            //创建归档辅助类
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            //编码
            [archiver encodeObject:payType forKey:PayTypeflat];
            //结束编码
            [archiver finishEncoding];
            NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
            //写入
            [data writeToFile:filename atomically:YES];
            
            [self myAppGetConfig];
            
            
            // 1.得到data
            NSArray *arrays =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * filenames = [[arrays objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
            NSData *datas = [NSData dataWithContentsOfFile:filenames];
            // 2.创建反归档对象
            NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:datas];
            // 3.解码并存到数组中
            NSArray *namesArrays = [unArchiver decodeObjectForKey:PayTypeflat];
            LWLog(@"%lu",(unsigned long)namesArrays.count);
        }
    } failure:^(NSError *error) {
        LWLog(@"%@",error.description);
    }];
    
}

/**
 *  app初始化接口
 */
- (void)getMallBaseInfo{
    NSString *url = [NSString stringWithFormat:@"%@/buyerSeller/api/goods/getMallBaseInfo?customerId=%@",NoticeCenterMainUrl,HuoBanMallBuyApp_Merchant_Id];
    LWLog(@"%@",url);
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
    parame = [NSDictionary asignWithMutableDictionary:parame];

    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        LWLog(@"getMallBaseInfo%@",json);
        if ([json[@"resultCode"] integerValue] == 200) {
            NSString * webqq =  [json[@"data"][@"clientQQ"] copy];
            if (webqq.length) {
                [[NSUserDefaults standardUserDefaults] setObject:webqq forKey:@"webqq"];
            }
        }
    } failure:^(NSError *error) {
        LWLog(@"%@",error.description);
    }];
    
}

@end
