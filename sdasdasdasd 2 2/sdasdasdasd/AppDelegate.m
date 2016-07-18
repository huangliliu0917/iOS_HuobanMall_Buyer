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
#import "MallMessage.h"
#import "LeftMenuModel.h"
#import "UIViewController+MonitorNetWork.h"
#import <SVProgressHUD.h>
@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate>



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化
    
    [self setupInit];
    [self myAppToInit];
    
    
    [self myAppGetConfig];
    //微信支付
    
    

    [self setImage];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    _maskLayer = [CALayer layer];
    [_maskLayer setFrame:CGRectMake(SecrenWith, 0, 0, SecrenHeight)];
    [_maskLayer setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.400].CGColor];
    [_window.layer addSublayer:_maskLayer];
    self.maskLayer.hidden = YES;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _Agent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    [self resetUserAgent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUserAgent) name:@"resetUserAgent" object:nil];
    
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
 *  app初始化接口
 */
- (void)myAppToInit{
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
    [url appendString:@"/mall/Init"];
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        
//        NSLog(@"%@",json);
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
        
//        NSLog(@"%@" , json);
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
//        NSLog(@"%@", error);
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
            
        }else {
            [UIViewController ToRemoveSandBoxDate];
            [self resetUserAgent];
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




- (void) resetUserAgent {
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //add my info to the new agent
    NSString *newAgent = nil;
    UserInfo * usaa = nil;

    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
    usaa =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];

    
    NSString *str = [MD5Encryption md5by32:[NSString stringWithFormat: @"%@%@%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId], usaa.unionid, usaa.openid, SISSecret]];
    
    
    newAgent = [_Agent stringByAppendingString:[NSString stringWithFormat: @";mobile;hottec:%@:%@:%@:%@;",str,[[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId], usaa.unionid, usaa.openid]];
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    
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

@end
