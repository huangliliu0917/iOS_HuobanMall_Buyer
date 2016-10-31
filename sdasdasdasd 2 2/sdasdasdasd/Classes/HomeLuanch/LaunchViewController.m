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
#import <SVProgressHUD.h>
#import "LeftMenuModel.h"
#import "UserInfo.h"
#import "UIViewController+MonitorNetWork.h"
#import "TabBarModel.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setImage];
    
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
    NSLog(@"%@",launchImage);
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    launchView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:launchView];

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
        
        NSLog(@"%@",json);
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
    NSString *url = [NSString stringWithFormat:@"%@/merchantWidgetSettings/search/findByMerchantIdAndScopeDependsScopeOrDefault/nativeCode/%@/global",NoticeCenterMainUrl,HuoBanMallBuyApp_Merchant_Id];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
    parame = [NSDictionary asignWithMutableDictionary:parame];
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {

        
        NSLog(@"json");
        NSArray *array = json[@"widgets"];
        NSDictionary *dic = array[0];
        NSArray *temp = [TabBarModel  objectArrayWithKeyValuesArray:dic[@"properties"][@"Rows"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:json[@"mallResourceURL"] forKey:@"mallResourceURL"];
        
        
        NSString * localVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppVerSion"];
        if ((localVersion.length == 0 || [localVersion isEqualToString:AppVersion] == NO) && LWNewFeatureImageCount != 0) {
            LWNewFeatureController * new = [[LWNewFeatureController alloc] init];
            new.tabbarArray = temp;
            
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
    
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


@end
