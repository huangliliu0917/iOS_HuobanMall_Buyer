//
//  OaLoginController.m
//  HuoBanMall
//
//  Created by lhb on 2017/8/25.
//  Copyright © 2017年 HT. All rights reserved.
//

#import "OaLoginController.h"
#import <SVProgressHUD.h>
#import "UserLoginTool.h"
#import "UserInfo.h"
#import "MallMessage.h"
#import "AccountTool.h"

@interface OaLoginController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic,strong) UIButton * leftBtn;

@end

@implementation OaLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    
    self.backBtn.layer.cornerRadius = 5;
    self.backBtn.layer.masksToBounds = YES;
    self.backBtn.layer.borderWidth = 1;
    self.backBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    self.passWord.delegate = self;
    self.firstName.delegate = self;
    self.navigationItem.title = MallName;
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = kAdaptedFontSize(16);
    [_leftBtn sizeToFit];
    [_leftBtn addTarget:self action:@selector(BackToWebView) forControlEvents:UIControlEventTouchUpInside];
//    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"main_title_left_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    
}

/**
 * 取消登录
 */
- (void)BackToWebView{
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"CannelLoginBackHome" object:nil];  
 
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 注册
 **/
- (IBAction)gesterBtn:(id)sender {
    
    
    PushWebViewController * funWeb =  [[PushWebViewController alloc] init];
    funWeb.fromType = 1;
    funWeb.funUrl = @"http://m.championstar.cn/UserCenter/OAzc.aspx?customerid=7031";
    [self.navigationController pushViewController:funWeb animated:YES];
}

/**
 * 找回密码
 **/
- (IBAction)backPass:(id)sender {
    PushWebViewController * funWeb =  [[PushWebViewController alloc] init];
    funWeb.fromType = 1;
    funWeb.funUrl = @"http://m.championstar.cn/UserCenter/OAlogin-w.aspx?customerid=7031";
    [self.navigationController pushViewController:funWeb animated:YES];
}

/**
 * 登录
 **/
- (IBAction)login:(id)sender {
    
    if (!self.firstName.text.length) {
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        return;
    }
    if (!self.passWord.text.length) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginname"] = self.firstName.text;
    parame[@"password"] = [MD5Encryption md5by32:self.passWord.text];
    //parame[@"CustomerID"] = HuoBanMallBuyApp_Merchant_Id;
    NSDate * timestamp = [[NSDate alloc] init];
    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[timestamp timeIntervalSince1970] * 1000];  //转化为UNIX时间戳
    parame[@"secure"] = timeSp;
    parame = [NSDictionary asignWithMutableDictionary:parame];
    LWLog(@"%@",parame);
    LWLog(@"%@",[NSString stringWithFormat:@"%@/Account/OAlogin",AppOriginUrl]);
    [SVProgressHUD showWithStatus:@"登录中"];
    [UserLoginTool loginRequestPost:[NSString stringWithFormat:@"%@/Account/OAlogin",AppOriginUrl] parame:parame success:^(NSDictionary * json) {
        LWLog(@"%@",json);
        [SVProgressHUD dismiss];
        if ([json[@"code"] intValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:Success forKey:LoginStatus];
            UserInfo * userInfo = [[UserInfo alloc] init];
            
            LWLog(@"%@",json[@"data"][@"nickName"]);
            userInfo.unionid = json[@"data"][@"authorizeCode"];
            userInfo.nickname = json[@"data"][@"username"];
            userInfo.headimgurl = json[@"data"][@"headImgUrl"];
            userInfo.openid = json[@"data"][@"openId"];
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
            [NSKeyedArchiver archiveRootObject:userInfo toFile:fileName];
            
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"levelName"] forKey:HuoBanMallMemberLevel];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"userid"] forKey:HuoBanMallUserId];
            if (![json[@"data"][@"headImgUrl"] isKindOfClass:[NSNull class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"headImgUrl"] forKey:IconHeadImage];
            }
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"userType"] forKey:MallUserType];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"relatedType"] forKey:MallUserRelatedType];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"IsMobileBind"] forKey:@"bangShouji"];
            [self toGetMainUrl];
            [self ToGetShareMessage];
            
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if ([[[self goUrl] lowercaseString] rangeOfString:@"usercenter/usersetting"].location == NSNotFound) {
                [app resetUserAgent:_goUrl];
            }else{
                [app resetUserAgent:nil];

            }
            
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"OATest" object:self.goUrl];
            [self dismissViewControllerAnimated:NO completion:^{
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            }];
            
            
            
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:json[@"msg"]];
            });
            
        }
    } failure:^(NSError *error) {
         LWLog(@"%@",error);
         [SVProgressHUD dismiss];
    }];
  
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
        MallMessage * mallmodel = [MallMessage mj_objectWithKeyValues:json];
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:HuoBanMaLLMess];
        [NSKeyedArchiver archiveRootObject:mallmodel toFile:filename];
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
 * 登录
 **/
- (IBAction)haveOA:(id)sender {
    PushWebViewController * funWeb =  [[PushWebViewController alloc] init];
    funWeb.fromType = 1;
    funWeb.funUrl = @"http://m.championstar.cn/UserCenter/OAlogin-s.aspx?customerid=7031";
    [self.navigationController pushViewController:funWeb animated:YES];
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 101) {
      [textField resignFirstResponder];
    }else{
        [self.passWord becomeFirstResponder];
    }
    
    return YES;
}

@end
