//
//  AppDelegate.m
//  sdasdasdasd
//
//  Created by lhb on 15/11/24.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
//#import "WeiboSDK.h"
#import "HuoBanTabBarController.h"
#import "HTLeftTableViewController.h"
#import "LWNavigationController.h"
#import "RootViewController.h"
#import "AFNetworking.h"
#import "AQuthModel.h"
#import "MJExtension.h"
#import "MD5Encryption.h"
#import "AccountTool.h"
#import "UserInfo.h"
#import "LoginViewController.h"
#import "NSDictionary+HuoBanMallSign.h"
#import "PayModel.h"
#import <CoreGraphics/CoreGraphics.h>
#import "LWNewFeatureController.h"
#import "UserLoginTool.h"
#import "NSDictionary+HuoBanMallSign.h"
#import "PayModel.h"


#import "NoticeMessage.h"



#import "MallMessage.h"
#import "LeftMenuModel.h"
#import "UIViewController+MonitorNetWork.h"
#import <SVProgressHUD.h>
#import "HTNoticeCenter.h"
#import "NSData+NSDataDeal.h"

#import "PushWebViewController.h"

#import "LaunchViewController.h"


@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSString *pushToken;



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化
    
    
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 0;
//    app.statusBarStyle = UIStatusBarStyleLightContent;
    
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    LaunchViewController * launchViewController = [[LaunchViewController alloc] init];
    self.window.rootViewController = launchViewController;
    [self.window makeKeyAndVisible];
    [self setupInit];
    [self myAppToInit];
//
//    [self setImage];
//
//    
//    [self myAppGetConfig];
//    //微信支付
//    
//    
//
//    
//    
//    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//
//    _maskLayer = [CALayer layer];
//    [_maskLayer setFrame:CGRectMake(SecrenWith, 0, 0, SecrenHeight)];
//    [_maskLayer setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.400].CGColor];
//    [_window.layer addSublayer:_maskLayer];
//    self.maskLayer.hidden = YES;
//    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _Agent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    [self resetUserAgent:nil];
    
    
    [self registRemoteNotification:application];
    
    if (launchOptions) {
        NSDictionary *dicRemote = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dicRemote) {
            NSLog(@"%@", _openNotifacation);
            self.openNotifacation = [NSDictionary dictionary];
            self.openNotifacation = dicRemote;
        }
    }
    
    [self registRemoteNotification:application];
    
    
    
    
    return YES;
}
//
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@", userInfo);

    [self getRemoteNotifocation:userInfo];
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//    NSLog(@"%@", userInfo);
//    
//    [self getRemoteNotifocation:userInfo];
//}


/**
 *  程序启动初话信息
 */
- (void)setupInit{
    AQuthModel * aquthModel =  [AccountTool account];
    if (aquthModel != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"success" forKey:UserQaquthAccountFlag];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"failure" forKey:UserQaquthAccountFlag];
    }
    [ShareSDK registerApp:HuoBanMallShareSdkAppId
     
          activePlatforms:@[
                            
                            @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:HuoBanMallBuyWeiXinAppId
                                       appSecret:HuoBanMallShareSdkWeiXinSecret];
                 break;
             default:
                 break;
         }
     }];
    
}


/**
 *  app初始化接口
 */
- (void)myAppToInit{
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
    [url appendString:@"/mall/Init"];
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        
        NSLog(@"%@",json);
        if ([json[@"code"] integerValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"testMode"] forKey:TestMode];
             [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"msiteUrl"] forKey:AppMainUrl];
            NSArray * payType = [PayModel objectArrayWithKeyValuesArray:json[@"data"][@"payConfig"]];
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
        }
    } failure:^(NSError *error) {
        
    }];
    
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
        
        if (json) {
            MallMessage * mallmodel = [MallMessage objectWithKeyValues:json];
            NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:HuoBanMaLLMess];
            [NSKeyedArchiver archiveRootObject:mallmodel toFile:filename];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"accountmodel"] forKey:AppLoginType];
            
            [WXApi registerApp:HuoBanMallBuyWeiXinAppId withDescription:mallmodel.mall_name];
            
            
            NSString * localVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppVerSion"];
            if (localVersion.length == 0 || [localVersion isEqualToString:AppVersion] == NO) {
                LWNewFeatureController * new = [[LWNewFeatureController alloc] init];
                self.window.rootViewController = new;
                [self.window makeKeyAndVisible];
                [[NSUserDefaults standardUserDefaults] setObject:AppVersion forKey:@"AppVerSion"];
            }else {
                NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
                //    AQuthModel * AQuth = [AccountTool account];
                if ([login isEqualToString:Success]) {
                    [self myAppGetUserInfo];
                }
                RootViewController * root = [[RootViewController alloc] init];
                self.window.rootViewController = root;
                [self.window makeKeyAndVisible];
                
                
                
            }
            
            
            
        }
        
        
    } failure:^(NSError *error) {

        [SVProgressHUD showErrorWithStatus:@"网络异常请检查网络"];
        
        
    }];
}

- (void)myAppGetUserInfo {
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"userid"] = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId]];
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString *url = [NSMutableString stringWithFormat:AppOriginUrl];
    [url appendString:@"/Account/getAppUserInfo"];
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {

        if ([json[@"code"] integerValue] == 200) {
            UserInfo * userInfo = [[UserInfo alloc] init];
            userInfo.unionid = json[@"data"][@"unionId"];
            userInfo.nickname = json[@"data"][@"nickName"];
            userInfo.headimgurl = json[@"data"][@"headImgUrl"];
            userInfo.openid = json[@"data"][@"openId"];
            
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
            [NSKeyedArchiver archiveRootObject:userInfo toFile:fileName];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"levelName"] forKey:HuoBanMallMemberLevel];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"userid"] forKey:HuoBanMallUserId];
            if (![json[@"data"][@"headImgUrl"] isKindOfClass:[NSNull class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"headImgUrl"] forKey:IconHeadImage];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:@"21321321" forKey:IconHeadImage];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"userType"] forKey:MallUserType];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"relatedType"] forKey:MallUserRelatedType];
            NSArray * lefts = [LeftMenuModel objectArrayWithKeyValuesArray:json[@"data"][@"home_menus"]];
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
        NSLog(@"%@", error);
    }];
}

-(void) onResp:(BaseResp*)resp
{
    
    /*ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效                         state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
//            NSLog(@"----%@",code);
            //授权成功的code
            NSDictionary * dict = @{@"code":code};
            NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
            if ([login isEqualToString:Success]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ToGetUserInfoBuild" object:nil userInfo:dict];
                
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ToGetUserInfo" object:nil userInfo:dict];
            }
            return;
        }else if (aresp.errCode== -4 || aresp.errCode== -2 ){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ToGetUserInfoError" object:nil userInfo:nil];
        }
    }
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle = nil;
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        return;
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败"];
                //                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

/*************************************************************************************/
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString *string =[url absoluteString];
    NSLog(@"%@",string);
   
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
    NSString *string =[url absoluteString];
    NSLog(@"%@",string);
   
    return [WXApi handleOpenURL:url delegate:self];
    
}
/*************************************************************************************/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"payback" object:nil];
    
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
    
    
    newAgent = [_Agent stringByAppendingString:[NSString stringWithFormat: @";mobile;hottec:%@:%@:%@:%@;",str,userID, usaa.unionid, usaa.openid]];
    
    
    self.userAgent = newAgent;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ResetAllWebAgent object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (goUrl) {
            NSDictionary * objc = [NSDictionary dictionaryWithObject:goUrl forKey:@"url"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
        }
    });
    
}


- (void)setImage {
    CGSize viewSize = self.window.bounds.size;
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
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchView.frame = self.window.bounds;
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    [self.window addSubview:launchView];
    [UIView animateWithDuration:2.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         launchView.alpha = 0.0f;
                         launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [launchView removeFromSuperview];
                         
                     }];
}

/**
 *  注册远程通知
 */
- (void)registRemoteNotification:(UIApplication *)application{
        UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [application registerUserNotificationSettings:settings];
}

/**
 *  ios8
 *
 *  @param application
 *  @param notificationSettings
 */
-(void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //    LWLog(@"注册推送服务时，发生以下错误： %@",error.description);
}

/**
 *  获取deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    
    NSString * aa = [deviceToken hexadecimalString] ;
    
    self.pushToken = aa;
    NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
    //    AQuthModel * AQuth = [AccountTool account];
    if ([login isEqualToString:Success]) {
        [self sendTokenAndUserIdToSevern];
        
    }else {
        [HTNoticeCenter HTNoticeCenterRegisterToServerWithDeviceTokenWithNoUserInfo:aa AndCustomerId:HuoBanMallBuyApp_Merchant_Id DealResult:^(HTNoticeCenterDealResult resultType) {
            if (resultType == HTNoticeCenterSuccess) {
                NSLog(@"Push  success");
            }
        }];
    }
}

- (void)getRemoteNotifocation:(NSDictionary *) userInfo {
    NSLog(@"%@", userInfo);
    if (userInfo) {
        NoticeMessage *message = [NoticeMessage objectWithKeyValues:userInfo];
        if (![message.alertUrl isKindOfClass:[NSNull class]]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:message.alertUrl forKey:@"url"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:dic];
        }else if (![message.url isKindOfClass:[NSNull class]]) {
            UIAlertController *aa = [UIAlertController alertControllerWithTitle:message.title message:message.body preferredStyle:UIAlertControllerStyleAlert];
            [aa addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [aa addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *dic = [NSDictionary dictionaryWithObject:message.url forKey:@"url"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:dic];
            }]];
            
            [self.window.rootViewController presentViewController:aa animated:YES completion:nil];
        }
    }
    
}




- (void)sendTokenAndUserIdToSevern {
    [HTNoticeCenter HTNoticeCenterRegisterToServerWithDeviceToken:self.pushToken AndUserId:[[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId] DealResult:^(HTNoticeCenterDealResult resultType) {
        if (resultType == HTNoticeCenterSuccess) {
            NSLog(@"Push  success");
        }
    }];

}

@end
