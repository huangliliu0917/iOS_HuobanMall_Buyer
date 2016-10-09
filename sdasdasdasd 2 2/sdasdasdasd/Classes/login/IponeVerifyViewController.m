 //
//  IponeVerifyViewController.m
//  sdasdasdasd
//
//  Created by lhb on 15/12/8.
//  Copyright © 2015年 HT. All rights reserved.
//  手机验证码验证

#import "IponeVerifyViewController.h"
#import <UIView+BlocksKit.h>
#import <UIBarButtonItem+BlocksKit.h>
#import "NSString+EXTERN.h"
#import "UserLoginTool.h"
#import <SVProgressHUD.h>
#import "NSDictionary+HuoBanMallSign.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "LeftMenuModel.h"
#import "AccountModel.h"
#import "AccountTool.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "AQuthModel.h"
#import "PayModel.h"
#import "MallMessage.h"
#import "MBProgressHUD+MJ.h"
#import "MD5Encryption.h"
#import <ShareSDK/ShareSDK.h>

@interface IponeVerifyViewController ()<WXApiDelegate>

/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;
/**验证码*/
@property (weak, nonatomic) IBOutlet UITextField *VerifyCode;
/**验证码*/
@property (weak, nonatomic) IBOutlet UILabel *VerifyLable;
/****手机提示****/
@property (strong, nonatomic) IBOutlet UILabel *loginWarning;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) IBOutlet UIView *weixinLoginBgView;
@property (strong, nonatomic) IBOutlet UILabel *phoneVerify;

@property (strong, nonatomic) IBOutlet UIView *warnView;

@end

@implementation IponeVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    
    
    self.navigationController.navigationBar.barTintColor = HuoBanMallBuyNavColor;
//    self.navigationController.navigationBar.translucent = NO;
    
    
    
    self.loginWarning.hidden = YES;
    self.messageLabel.hidden = YES;
    
    
    
    self.phoneVerify.userInteractionEnabled = YES;
    [self.phoneVerify bk_whenTapped:^{
        self.phoneVerify.userInteractionEnabled = NO;
        NSString * phoneNumber= self.iphoneTextField.text;
        if ([phoneNumber isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
            self.phoneVerify.userInteractionEnabled = YES;
            return;
        }
        //判断是否是手机号
        if (![NSString checkTel:phoneNumber]) {
            [SVProgressHUD showErrorWithStatus:@"帐号必须是手机号"];
            self.phoneVerify.userInteractionEnabled = YES;
            self.iphoneTextField.text = @"";
            return ;
        }
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
        params[@"mobile"] = phoneNumber;
        
        params = [NSDictionary asignWithMutableDictionary:params];
        
        NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
        [url appendString:@"/Account/sendVoiceCode"];
        
        [UserLoginTool loginRequestPost:url parame:params success:^(id json) {
            
            if ([json[@"code"] intValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"语音验证码发送成功"];
                
            }else {
                self.phoneVerify.userInteractionEnabled = YES;
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", json[@"msg"]]];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }];
    
    self.VerifyLable.backgroundColor = HuoBanMallBuyNavColor;
    self.VerifyLable.layer.cornerRadius = 5;
    self.VerifyLable.layer.masksToBounds = YES;
    
    self.login.backgroundColor = HuoBanMallBuyNavColor;
    self.login.layer.cornerRadius = 5;
    
    
    self.weixinLogin.layer.cornerRadius = 5;
    self.weixinLogin.layer.borderColor = [UIColor colorWithWhite:0.5803 alpha:1].CGColor;
    self.weixinLogin.layer.borderWidth = 1;
    
    [self.VerifyLable bk_whenTapped:^{
        
        self.VerifyLable.userInteractionEnabled = NO;
        NSString * phoneNumber= self.iphoneTextField.text;
        if ([phoneNumber isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
            self.VerifyLable.userInteractionEnabled = YES;
            return;
        }
        //判断是否是手机号
        if (![NSString checkTel:phoneNumber]) {
            [SVProgressHUD showErrorWithStatus:@"帐号必须是手机号"];
            self.VerifyLable.userInteractionEnabled = YES;
            self.iphoneTextField.text = @"";
            return ;
        }
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
        params[@"mobile"] = phoneNumber;
        
        params = [NSDictionary asignWithMutableDictionary:params];
        
        NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
        [url appendString:@"/Account/sendCode"];
        
        [UserLoginTool loginRequestPost:url parame:params success:^(id json) {
            
            if ([json[@"code"] intValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                [self settime];
            }else {
                self.VerifyLable.userInteractionEnabled = YES;
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", json[@"msg"]]];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];

    }];
    
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.phoneVerify.hidden = YES;
    
    //是否是绑定手机
    if (self.isBundlPhone) {
        self.messageLabel.hidden = YES;
        self.loginWarning.hidden = YES;
        self.warnView.hidden = NO;
        self.weixinLoginBgView.hidden = YES;
        self.weixinLogin.hidden = YES;
        self.title = @"绑定手机";
        [self.login setTitle:@"绑定" forState:UIControlStateNormal];
        self.title = @"绑定手机";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"跳过" style:UIBarButtonItemStylePlain handler:^(id sender) {
            [self.VerifyCode resignFirstResponder];
            [self.iphoneTextField resignFirstResponder];
            [self dismissViewControllerAnimated:YES completion:^{
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app resetUserAgent:_goUrl];
            }];
        }];
    }else {
        self.title = @"登录";
        self.messageLabel.hidden = NO;
        self.loginWarning.hidden = NO;
        self.warnView.hidden = YES;
        [self.login setTitle:@"登录" forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CannelLoginBackHome" object:nil];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        
        //是否是只有手机登陆
        if (_isPhoneLogin) {
            self.title = @"手机登录";
            self.weixinLoginBgView.hidden = YES;
            self.weixinLogin.hidden = YES;
        }else {
            
            self.weixinLoginBgView.hidden = NO;
            
            if ([WXApi isWXAppInstalled]) {
                self.weixinLogin.hidden = NO;
            }else {
                self.weixinLogin.hidden = YES;
            }
            
            [self.weixinLogin bk_whenTapped:^{
                
                if ([WXApi isWXAppInstalled]) {
//                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OquthByWeiXinSuccess:) name:@"ToGetUserInfo" object:nil];
                    [self WeiXinLog];
                }
            }];
            
        }
    }
    
    
}
/**
 *  手机验证码
 */

/**
 *  点击登录按钮$
 *
 *  @param sender
 */
- (IBAction)loginActionClick:(id)sender {
    
    __weak IponeVerifyViewController  * wself = self;
    
    NSString * phoneNumber= self.iphoneTextField.text;
    
    if ([phoneNumber isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    //判断是否是手机号
    if (![NSString checkTel:phoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"帐号必须是手机号"];
        self.iphoneTextField.text = @"";
        return ;
    }
    NSString *verify = self.VerifyCode.text;
    if ([verify isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        return;
    }
    
    
    
    if (self.isBundlPhone) {
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
        params[@"userid"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId]];
        params[@"mobile"] = phoneNumber;
        params[@"code"] = verify;
        params = [NSDictionary asignWithMutableDictionary:params];
        
        
        NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
        [url appendString:@"/Account/bindMobile"];
        
        [UserLoginTool loginRequestPost:url parame:params success:^(id json) {
            if ([json[@"code"] intValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"绑定成功"];

                [SVProgressHUD dismiss];
                [self.VerifyCode resignFirstResponder];
                [self.iphoneTextField resignFirstResponder];
                [self dismissViewControllerAnimated:YES completion:^{
                    if (_goUrl) {
                        NSDictionary * objc = [NSDictionary dictionaryWithObject:_goUrl forKey:@"url"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
                    }
                }];
    
                
            }else {
                [SVProgressHUD showErrorWithStatus:json[@"msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
        
        
    }else {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
        params[@"mobile"] = phoneNumber;
        params[@"code"] = verify;
        params[@"secure"] = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        
        params = [NSDictionary asignWithMutableDictionary:params];
        
        NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
        [url appendString:@"/Account/loginAuthorize"];
        
        [SVProgressHUD showWithStatus:@"登录中"];
        
        [UserLoginTool loginRequestPost:url parame:params success:^(id json) {
            NSLog(@"%@",json);
            if ([json[@"code"] intValue] == 200) {
                
                
                UserInfo * userInfo = [[UserInfo alloc] init];
                userInfo.unionid = json[@"data"][@"authorizeCode"];
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
                
                [wself toGetMainUrl];
                
                [[NSUserDefaults standardUserDefaults] setObject:Success forKey:LoginStatus];
                [self ToGetShareMessage];
                
                [self UserLoginSuccess];
                
                
                
            }else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", json[@"msg"]]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
}





- (void)settime{
    
    /*************倒计时************/
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.VerifyLable setText:@"重新发送"];
                self.VerifyLable.backgroundColor = HuoBanMallBuyNavColor;
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                self.VerifyLable.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                self.VerifyLable.backgroundColor = [UIColor lightGrayColor];
                [self.VerifyLable setText:[NSString stringWithFormat:@"%@秒重新发送",strTime]];
                self.VerifyLable.userInteractionEnabled = NO;
                
                if (timeout <= 50) {
                    self.phoneVerify.hidden = NO;
                }
                
            });
            timeout--;
        }
        
    });
    dispatch_resume(_timer);
}

/**
 *  用户登录成功
 *
 *  @param note
 */
- (void)UserLoginSuccess{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:MallUserRelatedType];
    
    [[NSUserDefaults standardUserDefaults] setObject:Success forKey:LoginStatus];
    if ([str intValue] == 1) {
        [SVProgressHUD dismiss];
        [self.view endEditing:NO];
        IponeVerifyViewController *bundle = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IponeVerifyViewController"];
        bundle.isBundlPhone = YES;
        bundle.goUrl = _goUrl;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app resetUserAgent:nil];
        [self.navigationController pushViewController:bundle animated:YES];
    }else {
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app resetUserAgent:_goUrl];
        [app sendTokenAndUserIdToSevern];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [SVProgressHUD dismiss];
        [self.VerifyCode resignFirstResponder];
        [self.iphoneTextField resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:^{
                
     }];
    }
}




/**
 *  微信授权登录
 */
- (void)WeiXinLog{
    
//    //构造SendAuthReq结构体
//    SendAuthReq* req =[[SendAuthReq alloc ] init];
//    req.scope = @"snsapi_userinfo" ;
//    req.state = @"123" ;
//    //第三方向微信终端发送一个SendAuthReq消息结构
//    [WXApi sendAuthReq:req viewController:self delegate:self];
    __weak IponeVerifyViewController * wself = self;
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            
            UserInfo * userInfo = [UserInfo objectWithKeyValues:user.rawData];
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
            [NSKeyedArchiver archiveRootObject:userInfo toFile:fileName];
            //向服务端提供微信数据
            [wself toPostWeiXinUserMessage:userInfo];
            //获取主地址
            [wself toGetMainUrl];
            //微信授权成功后获取支付参数
            [wself WeiXinLoginSuccessToGetPayParameter];
            //获得用户账户列表
        }
    }];
}


/**
 *  通过code获取accessToken
 *
 *  @param code code
 */

- (void)accessTokenWithCode:(NSString * )code
{
    
//    [MBProgressHUD showMessage:nil];
    __weak IponeVerifyViewController * wself = self;
    //进行授权
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",HuoBanMallBuyWeiXinAppId,HuoBanMallShareSdkWeiXinSecret,code];
    [UserLoginTool loginRequestGet:url parame:nil success:^(id json) {
        
        //        NSLog(@"accessTokenWithCode%@",json);
        AQuthModel * aquth = [AQuthModel objectWithKeyValues:json];
        [AccountTool saveAccount:aquth];
        //获取用户信息
        [wself getUserInfo:aquth];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}



/**
 *  刷新access_token
 */
- (void)toRefreshaccess_token{
    
//    [MBProgressHUD showMessage:nil];
    __weak IponeVerifyViewController * wself = self;
    AQuthModel * mode = [AccountTool account];
    NSString * ss = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",HuoBanMallBuyWeiXinAppId,mode.refresh_token];
    [UserLoginTool loginRequestGet:ss parame:nil success:^(id json) {
        AQuthModel * aquth = [AQuthModel objectWithKeyValues:json];
        [AccountTool saveAccount:aquth];
        //获取用户信息
        [wself getUserInfo:aquth];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}




/**
 *  微信授权登录后返回的用户信息
 */
-(void)getUserInfo:(AQuthModel*)aquth
{
    __weak IponeVerifyViewController * wself = self;
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"access_token"] = aquth.access_token;
    parame[@"openid"] = aquth.openid;
    [UserLoginTool loginRequestGet:@"https://api.weixin.qq.com/sns/userinfo" parame:parame success:^(id json) {
        UserInfo * userInfo = [UserInfo objectWithKeyValues:json];
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
        [NSKeyedArchiver archiveRootObject:userInfo toFile:fileName];
        //向服务端提供微信数据
        [wself toPostWeiXinUserMessage:userInfo];
        //获取主地址
        [wself toGetMainUrl];
        //微信授权成功后获取支付参数
        [wself WeiXinLoginSuccessToGetPayParameter];
        //获得用户账户列表
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}


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
        if ([json[@"code"] integerValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"msiteUrl"] forKey:AppMainUrl];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"getmsiteurlSuccess" object:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}


/**
 *  提交数据给服务端
 *
 *  @param user 
 */
- (void)toPostWeiXinUserMessage:(UserInfo *) user{
    __weak IponeVerifyViewController * wself = self;
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"sex"] = [NSString stringWithFormat:@"%ld",(long)[user.sex integerValue]];
    parame[@"nickname"] = user.nickname;
    parame[@"openid"] = user.openid;
    parame[@"city"] = user.city;
    parame[@"country"] = user.country;
    parame[@"province"] = user.province;
    parame[@"headimgurl"] = user.headimgurl;
    parame[@"unionid"] = user.unionid;
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
    [url appendString:@"/weixin/LoginAuthorize"];
    [UserLoginTool loginRequestPost:url parame:parame success:^(id json) {
        if ([json[@"code"] integerValue] == 200) {
            

            user.nickname = json[@"data"][@"nickName"];
            user.headimgurl = json[@"data"][@"headImgUrl"];
            user.openid = json[@"data"][@"openId"];
            user.relatedType = json[@"data"][@"relatedType"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"relatedType"] forKey:MallUserRelatedType];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"levelName"] forKey:HuoBanMallMemberLevel];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"userid"] forKey:HuoBanMallUserId];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"headImgUrl"] forKey:IconHeadImage];
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
            
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
            [NSKeyedArchiver archiveRootObject:user toFile:fileName];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetUserAgent" object:nil];
            [self UserLoginSuccess];
            
            [[NSUserDefaults standardUserDefaults] setObject:Success forKey:LoginStatus];
        }else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", json[@"msg"]]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@ --- ",error.description);
    }];
    
}


/**
 *  微信授权成功后获取支付参数
 */
- (void) WeiXinLoginSuccessToGetPayParameter{
    //    NSString * url = [NSString stringWithFormat:@"http://mallapi.huobanj.cn/PayConfig?customerId=%@",HuoBanMallBuyApp_Merchant_Id];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSString * cc = [NSString stringWithFormat:@"%@%@",AppOriginUrl,@"/PayConfig"];
    [UserLoginTool loginRequestGet:cc parame:parame success:^(id json) {
        if ([json[@"code"] integerValue] == 200) {
            NSArray * payType = [PayModel objectArrayWithKeyValuesArray:json[@"data"]];
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
        NSLog(@"%@",error.description);
    }];
    
}

- (void)OquthByWeiXinSuccess:(NSNotification *) note{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ToGetUserInfo" object:nil];
    [SVProgressHUD showWithStatus:@"登录中"];
    
    AQuthModel * account = [AccountTool account];
    if (account.refresh_token.length) {
        [self toRefreshaccess_token];
    }else{
        [self accessTokenWithCode:note.userInfo[@"code"]];
    }
    [self ToGetShareMessage];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ToGetUserInfo" object:nil];
}

/**
 * 分享商城信息
 */
- (void)ToGetShareMessage{
    NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
    [url appendString:@"/mall/getConfig"];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        MallMessage * mallmodel = [MallMessage objectWithKeyValues:json];
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:HuoBanMaLLMess];
        [NSKeyedArchiver archiveRootObject:mallmodel toFile:filename];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.iphoneTextField resignFirstResponder];
    
    [self.VerifyCode resignFirstResponder];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
