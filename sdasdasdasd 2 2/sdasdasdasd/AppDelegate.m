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
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "HuoBanTabBarController.h"
#import "HTLeftTableViewController.h"
#import "LWNavigationController.h"
#import "RootViewController.h"
#import "AFNetworking.h"
#import "AQuthModel.h"
#import "MJExtension.h"
#import "AccountTool.h"
#import "UserInfo.h"
#import "LoginViewController.h"
#import "NSDictionary+HuoBanMallSign.h"
#import "PayModel.h"
#import <CoreGraphics/CoreGraphics.h>
#import "LWNewFeatureController.h"
#import "UserLoginTool.h"

@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化
    [self setupInit];
    //微信支付
    [WXApi registerApp:HuoBanMallBuyWeiXinAppId withDescription:@"行装"];
    

    NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
    //    AQuthModel * AQuth = [AccountTool account];
    if ([login isEqualToString:Success]) {
        [self toGetMainUrl];
        RootViewController * root = [[RootViewController alloc] init];
        self.window.rootViewController = root;
        [self.window makeKeyAndVisible];
    }else{
        
//        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginViewController * login =  [main instantiateViewControllerWithIdentifier:@"LoginViewController"];
        LWNewFeatureController * cc = [[LWNewFeatureController alloc] init];
        self.window.rootViewController = cc;
        [self.window makeKeyAndVisible];
    }
    
    
    
    
    _maskLayer = [CALayer layer];
    [_maskLayer setFrame:CGRectMake(SecrenWith, 0, 0, SecrenHeight)];
    [_maskLayer setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.400].CGColor];
    [_window.layer addSublayer:_maskLayer];
    self.maskLayer.hidden = YES;
    
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
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:HuoBanMallShareSdkSinaKey
                                           appSecret:HuoBanMallShareSdkSinaSecret
                                         redirectUri:HuoBanMallShareSdkSinaRedirectUri
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:HuoBanMallBuyWeiXinAppId
                                       appSecret:HuoBanMallShareSdkWeiXinSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:HuoBanMallShareSdkQQKey
                                      appKey:HuoBanMallShareSdkQQSecret
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
}

/**
 *  获取前端app接口地址
 */
/**
 *  获取主地址
 */
- (void)toGetMainUrl{
    
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    UserInfo * usaa = nil;
    if ([AccountTool account]) {
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
        usaa =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    };
    parame[@"unionid"] = usaa.unionid;
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
    [url appendString:@"/mall/getmsiteurl"];
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        //        NSLog(@"toGetMainUrl%@",json);
        if ([json[@"code"] integerValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"msiteUrl"] forKey:AppMainUrl];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
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
            NSLog(@"----%@",code);
            //授权成功的code
            NSDictionary * dict = @{@"code":code};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ToGetUserInfo" object:nil userInfo:dict];
            return;
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

@end