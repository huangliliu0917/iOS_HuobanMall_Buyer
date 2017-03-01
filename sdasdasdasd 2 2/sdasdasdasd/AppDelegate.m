


//
//  AppDelegate.m
//  sdasdasdasd
//
//  Created by lhb on 15/11/24.
//  Copyright © 2015年 HT. All rights reserved.
//
#import "UMMobClick/MobClick.h"
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
#import "PushWebViewController.h"
#import "NSString+Des.h"
#import "MallMessage.h"


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
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    
    if ([HuoBanMallBuyApp_Merchant_Id intValue] == 7020) {
        app.statusBarStyle = UIStatusBarStyleDefault;
        
    }else{
        app.statusBarStyle = UIStatusBarStyleLightContent;
    }
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.window.backgroundColor = [UIColor whiteColor];
    LaunchViewController * launchViewController = [[LaunchViewController alloc] init];
    self.window.rootViewController = launchViewController;
    [self.window makeKeyAndVisible];
    [self setupInit];

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

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
    //    NSLog(@"%@", userInfo);
    
    [self getRemoteNotifocation:userInfo];
}

/**支付宝支付回调*/
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
   
   
    NSString *string =[url absoluteString];
    NSLog(@"--%s---%@",__func__,string);
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            LWLog(@"result = %@",resultDic);
        
            LWLog(@"%d",[resultDic[@"resultStatus"] intValue]);
            if([resultDic[@"resultStatus"] intValue] == 9000){
                [self paySuccess];
            }else if([resultDic[@"resultStatus"] intValue] == 6001){
                [self payCancle];
            }
            
        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}



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
    
    if([HuoBanMallBuyApp_Merchant_Id intValue] == 4886 || [HuoBanMallBuyApp_Merchant_Id intValue] == 8082){
       
        UMConfigInstance.appKey = HuoBanMallYouMeng;
        UMConfigInstance.channelId = @"App Store";
        [MobClick startWithConfigure:UMConfigInstance];
    }
    
    
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
            case WXSuccess:{
                strMsg = @"支付结果：成功！";
                [self paySuccess];
                LWLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            }
            case WXErrCodeUserCancel:{
                
                [self payCancle];
//                self.currentVc.navigationController 
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"payback" object:nil];
            }
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败"];
                //strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                LWLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                break;
        }
//        //支付成功通知
//        NSDictionary * parame = @{@"url":url};
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"paysuccesstoWeb" object:parame];
        
//        [UIAlertController  alertControllerWithTitle:@"支付成功" message:nil preferredStyle:(UIAlertControllerStyle)]
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
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
    LWLog(@"注册推送服务时，发生以下错误： %@",error.description);
}

/**
 *  获取deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    
    LWLog(@"%@",deviceToken);
    
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
    if (!userInfo) {
        return;
    }
    NoticeMessage *message = [NoticeMessage mj_objectWithKeyValues:userInfo];
    LWLog(@"xxxxxx%@---%@",message.alertUrl,message.url);
    UIAlertController *aa = [UIAlertController alertControllerWithTitle:userInfo[@"aps"][@"alert"][@"title"] message:userInfo[@"aps"][@"alert"][@"body"] preferredStyle:UIAlertControllerStyleAlert];
    [aa addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(message.alertUrl.length){
            NSDictionary *dic = [NSDictionary dictionaryWithObject:message.alertUrl forKey:@"url"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:dic];
        }else if (message.url.length){
            NSDictionary *dic = [NSDictionary dictionaryWithObject:message.url forKey:@"url"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:dic];
        }
        
    }]];
    [self.window.rootViewController presentViewController:aa animated:YES completion:nil];
    
}




- (void)sendTokenAndUserIdToSevern {
    [HTNoticeCenter HTNoticeCenterRegisterToServerWithDeviceToken:self.pushToken AndUserId:[[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId] DealResult:^(HTNoticeCenterDealResult resultType) {
        if (resultType == HTNoticeCenterSuccess) {
            NSLog(@"Push  success");
        }
    }];
    
}


/**
 * 支付取消
 */
- (void)payCancle{
    
    if (![self.currentVc.navigationItem.title isEqualToString:@"订单列表"]) {
        PushWebViewController * funWeb =  [[PushWebViewController alloc] init];
        NSString * Msiteurl =  [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
        LWLog(@"%@",[NSString stringWithFormat:@"%@/UserCenter/OrderV2/ListV2.aspx?customerid=%@&tab=1",Msiteurl,HuoBanMallBuyApp_Merchant_Id]);
        funWeb.funUrl = [NSString stringWithFormat:@"%@/UserCenter/OrderV2/ListV2.aspx?customerid=%@&tab=1",Msiteurl,HuoBanMallBuyApp_Merchant_Id];
        [self.currentVc.navigationController pushViewController:funWeb animated:YES];
    }
    
}


- (void)paySuccess{
    
    NSString * aa =  [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
    NSString * url =  [NSString stringWithFormat:@"%@/Weixin/Pay/PayReturn.aspx?customerid=%@&orderid=",aa,HuoBanMallBuyApp_Merchant_Id];
    if (![self.currentVc.navigationItem.title isEqualToString:@"订单列表"]) {
        PushWebViewController * funWeb =  [[PushWebViewController alloc] init];
        funWeb.funUrl = url;
        [self.currentVc.navigationController pushViewController:funWeb animated:YES];
    }
    
}

@end

