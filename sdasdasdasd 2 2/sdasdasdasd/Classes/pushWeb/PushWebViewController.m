//
//  PushWebViewController.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/9.
//  Copyright (c) 2015年 HT. All rights reserved.
//  跳转的网页页面

#import "PushWebViewController.h"
#import "RootViewController.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "LoginViewController.h"
#import "PayModel.h"
#import "AFNetworking.h"
#import "NSDictionary+HuoBanMallSign.h"
#import "UIViewController+MonitorNetWork.h"
#import "MallMessage.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import <MJRefresh.h>
#import "UserLoginTool.h"
#import <SVProgressHUD.h>
#import "UserInfo.h"
#import "AQuthModel.h"
#import "AccountModel.h"
#import "AccountTool.h"
#import "LeftMenuModel.h"
#import "LeftGroupModel.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "IponeVerifyViewController.h"
#import "NSDictionary+ConfirmSign.h"
#import "WKCookieSyncManager.h"
#import "AlipayViewController.h"
@interface PushWebViewController ()<WXApiDelegate,UIWebViewDelegate,UIActionSheetDelegate,WKUIDelegate,WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
/***/
@property(nonatomic,strong) NSMutableString * debugInfo;

/**刷新按钮标*/
@property (nonatomic,strong) UIButton * refreshBtn;
/**分享按钮*/
@property (nonatomic,strong) UIButton * shareBtn;
@property(nonatomic,strong) NSString * orderNo;       //订单号
@property(nonatomic,strong) NSString * priceNumber;  //订单价格
@property(nonatomic,strong) NSString * proDes;       //订单描述


@property(nonatomic,strong) PayModel * paymodel;

/**支付的url*/
@property(nonatomic,strong) NSString * ServerPayUrl;

@property (strong, nonatomic) UIProgressView *progressView;

//@property (nonatomic, strong) NJKWebViewProgressView *webViewProgressView;
//@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;
@property (nonatomic, assign) BOOL bingWeixin;

@end


@implementation PushWebViewController



- (UIButton *)shareBtn{
    if (_shareBtn == nil) {
        _shareBtn = [[UIButton alloc] init];
        _shareBtn.frame = CGRectMake(0, 0, 25, 25);
        _shareBtn.userInteractionEnabled = NO;
        [_shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"home_title_right_share"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}


-(UIButton *)refreshBtn{
    if (_refreshBtn == nil) {
        _refreshBtn = [[UIButton alloc] init];
        _refreshBtn.frame = CGRectMake(0, 0, 25, 25);
        [_refreshBtn addTarget:self action:@selector(refreshToWebView) forControlEvents:UIControlEventTouchUpInside];
        [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"main_title_left_refresh"] forState:UIControlStateNormal];
        [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
    }
    return _refreshBtn;
}


- (NSMutableString *)debugInfo{
    
    if (_debugInfo == nil) {
        
        _debugInfo = [NSMutableString string];
    }
    return _debugInfo;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    
    LWLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.alpha = 0;
//    self.navigationController.navigationBar.barTintColor = HuoBanMallBuyNavColor;
    self.tabBarController.tabBar.hidden = YES;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin,NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    WKWebViewConfiguration * internalConfig = [[WKWebViewConfiguration alloc] init];
    WKCookieSyncManager * ma = [WKCookieSyncManager shareInstance];
    internalConfig.processPool = ma.processPool;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) configuration:internalConfig];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.customUserAgent = app.userAgent;
//    [self.view addSubview:self.webView];
    self.view = _webView;
    
 
    
    //加载刷新控件
    [self AddMjRefresh];
    
    [self initWebViewProgress];
    
    self.shareBtn.hidden = YES;
 
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.shareBtn]];
    [UIViewController MonitorNetWork];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCuccess:) name:@"payback" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restPushWebAgent) name:ResetAllWebAgent object:nil];

    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.webView.frame = self.view.frame;
    NSURL * urlStr = [NSURL URLWithString:_funUrl];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:urlStr];
    self.webView.tag = 20;
    [self.webView loadRequest:req];
    
    
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
    [self.navigationController.navigationBar addSubview:_progressView];
    
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        NSString *str = title;
        self.title = str;
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.webView.frame = self.view.frame;
//    NSURL * urlStr = [NSURL URLWithString:_funUrl];
//    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:urlStr];
//    self.webView.tag = 20;
//    [self.webView loadRequest:req];
    
//    LWLog(@"%@",NSStringFromCGRect(self.view.frame));
}

- (void)AddMjRefresh{
    // 添加下拉刷新控件
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    header.arrowView.image= nil;
    self.webView.scrollView.mj_header = header;
}


/*
 *网页下拉刷新
 */
- (void)loadNewData{
    
    [self.webView reload];
}



/**
 *  返回
 */
- (void)back{
    
    [self.webView goBack];
}

/**
 *  刷新
 */
- (void)refreshToWebView{
   
    
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
    self.refreshBtn.userInteractionEnabled = NO;
    [self.webView reload];
}


/**
 *  分享
 */
- (void)shareBtnClick{

    
    [self shareSdkSha];
}

/**
 *  分享url处理
 */
- (NSString *) toCutew:(NSString *)urs{
    
    NSString * gduid = [[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId];
    
    NSRange rang = [urs rangeOfString:@"?"];
    
    NSString * back = [urs substringFromIndex:rang.location + 1];
    
    NSArray * aa =  [back componentsSeparatedByString:@"&"];
    
    __block NSMutableArray * todelete = [NSMutableArray arrayWithArray:aa];
    
    NSArray * key = @[@"unionid",@"appid",@"sign"];
    [aa enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [key enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:key]) {
                [todelete removeObject:obj];
            }
        }];
    }];
    
    NSMutableString * cc = [[NSMutableString alloc] init];
    [todelete enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *  stop) {
        
        [cc appendFormat:@"%@&",obj];
    }];
    [cc appendFormat:@"gduid=%@",gduid];
    
    NSString * ee = [urs substringToIndex:rang.location+1];
    
    NSString * dd = [NSString stringWithFormat:@"%@%@",ee,cc];
    return dd;
}


- (void)shareSdkSha{
    
    //1、创建分享参数
#pragma mark 分享修改
    
    [self.webView evaluateJavaScript:@"__getShareStr()" completionHandler:^(id _Nullable str, NSError * _Nullable error) {
        
        NSArray *array = [str componentsSeparatedByString:@"^"];
        if (array.count != 4) {
            return;
        }
        //1、创建分享参数
        NSArray* imageArray = @[[NSURL URLWithString:array[3]]];
        if (imageArray) {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:array[1]
                                             images:imageArray
                                                url:[NSURL URLWithString:array[2]]
                                              title:array[0]
                                               type:SSDKContentTypeAuto];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                   [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                                   [self presentViewController:alert animated:YES completion:nil];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                                   [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                                   [self presentViewController:alert animated:YES completion:nil];
                                   break;
                               }
                               default:
                                   break;
                           }

                           
                       }];

            
        }
    }];
}

- (void)payCuccess:(NSNotification *)note{
    
    LWLog(@"%@",note);
    PushWebViewController * funWeb =  [[PushWebViewController alloc] init];
    funWeb.funUrl = [NSString stringWithFormat:@"%@%@",note.object[@"url"],self.orderNo];
    [self.navigationController pushViewController:funWeb animated:YES];
    
    
}

/**
 *  商城支付宝支付
 */
- (void)MallAliPay:(PayModel *)pay{
    [self doAlipayPay:pay];
}

//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPay:(PayModel *)pay
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = pay.appId;
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"";
    NSString *rsaPrivateKey = pay.appKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        
        UIAlertController *aa =[UIAlertController alertControllerWithTitle:@"提示" message:@"缺少appId或者私钥。" preferredStyle:UIAlertControllerStyleAlert];
        [aa addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }]];
        [self presentViewController:aa animated:YES completion:nil];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    NSString * uraaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
    NSMutableString * urls = [NSMutableString stringWithString:uraaa];
    [urls appendString:pay.notify];
    order.notify_url = urls;
    
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = [self proDes];
    order.biz_content.subject = [self orderNo];
    order.biz_content.out_trade_no = [self orderNo]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [self priceNumber]; //商品价格

    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = BudleId;
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}


/**
 *  微信支付
 */
- (void)WeiChatPay:(PayModel *)model{
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [self PayByWeiXinParame:model];
    if(dict != nil){
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }else{
        LWLog(@"提示信息----微信预支付失败");
    }
}


/**
 *  微信支付预zhifu
 */
- (NSMutableDictionary *)PayByWeiXinParame:(PayModel *)paymodel{

    payRequsestHandler * payManager = [[payRequsestHandler alloc] init];
    [payManager setKey:paymodel.appKey];
    
//    LWLog(@"%@-----%@ -----",paymodel.appId,paymodel.partnerId);
    BOOL isOk = [payManager init:paymodel.appId mch_id:paymodel.partnerId];
    if (isOk) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
        params[@"appid"] = paymodel.appId;
        params[@"mch_id"] =paymodel.partnerId;     //微信支付分配的商户号
        params[@"nonce_str"] = noncestr; //随机字符串，不长于32位。推荐随机数生成算法
        params[@"trade_type"] = @"APP";   //取值如下：JSAPI，NATIVE，APP，WAP,详细说明见参数规定
        params[@"body"] = ((self.proDes.length)?self.proDes:MallName); //商品或支付单简要描述
//        LWLog(@"self.proDes%@",self.proDes);
        NSString * uraaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
        NSMutableString * urls = [NSMutableString stringWithString:uraaa];
        [urls appendString:paymodel.notify];
        params[@"notify_url"] = urls;  //接收微信支付异步通知回调地址
        params[@"out_trade_no"] = self.orderNo; //订单号
        params[@"spbill_create_ip"] = @"192.168.1.1"; //APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
        params[@"total_fee"] = [NSString stringWithFormat:@"%.f",[self.priceNumber floatValue] * 100];  //订单总金额，只能为整数，详见支付金额
        params[@"device_info"] = ([[UIDevice currentDevice].identifierForVendor UUIDString]);
        params[@"attach"] = [NSString stringWithFormat:@"%@_0",HuoBanMallBuyApp_Merchant_Id];
        //获取prepayId（预支付交易会话标识）
        NSString * prePayid = nil;
        prePayid  = [payManager sendPrepay:params];
//        [payManager getDebugifo];
//        LWLog(@"%@",[payManager getDebugifo]);
        if ( prePayid != nil) {
            //获取到prepayid后进行第二次签名
            NSString    *package, *time_stamp, *nonce_str;
            //设置支付参数
            time_t now;
            time(&now);
            time_stamp  = [NSString stringWithFormat:@"%ld", now];
            nonce_str	= [WXUtil md5:time_stamp];
            //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
            //package       = [NSString stringWithFormat:@"Sign=%@",package];
            package         = @"Sign=WXPay";
            //第二次签名参数列表
            NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
            [signParams setObject: paymodel.appId  forKey:@"appid"];
            [signParams setObject: nonce_str    forKey:@"noncestr"];
            [signParams setObject: package      forKey:@"package"];
            [signParams setObject: paymodel.partnerId   forKey:@"partnerid"];
            [signParams setObject: time_stamp   forKey:@"timestamp"];
            [signParams setObject: prePayid     forKey:@"prepayid"];
            //生成签名
            NSString *sign  = [payManager createMd5Sign:signParams];
            //添加签名
            [signParams setObject: sign forKey:@"sign"];
            [_debugInfo appendFormat:@"第二步签名成功，sign＝%@\n",sign];
            //返回参数列表
            return signParams;
        }else{
            [_debugInfo appendFormat:@"获取prepayid失败！\n"];
        }
        
    }
    return nil;
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 切换账号

- (void)changeWithUserInfo:(NSArray *) array {
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"userid"] = array[1];
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
    [url appendString:@"/Account/getAppUserInfo"];
    
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        LWLog(@"%@", json);
        
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
            
            AppDelegate * de = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [de resetUserAgent:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CannelLoginBackHome" object:nil];
        }else {
            [SVProgressHUD showErrorWithStatus:@"切换失败"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"切换失败"];
    }];
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_progressView removeFromSuperview];
}

#pragma mark wk

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    
    NSString *temp = webView.URL.absoluteString;
    LWLog(@"decidePolicyForNavigationResponse%@",temp);
    NSString *url = [temp lowercaseString];
    if ([url isEqualToString:@"about:blank"]) {
         decisionHandler(WKNavigationResponsePolicyCancel);
    }
    if ([url rangeOfString:@"/usercenter/login.aspx"].location !=  NSNotFound || [url rangeOfString:@"/invite/mobilelogin.aspx?"].location != NSNotFound) {
        NSString *goUrl = [[NSString alloc] init];
        if ([url rangeOfString:@"redirecturl="].location != NSNotFound) {
            NSArray *array = [url componentsSeparatedByString:@"redirecturl="];
            NSString *str = array[1];
            if (str.length != 0) {
                goUrl = [str stringByRemovingPercentEncoding];
                if ([goUrl rangeOfString:@"http:"].location == NSNotFound) {
                    goUrl = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl], goUrl];
                }
            }
        }else {
            NSString * uraaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
            NSString * ddd = [NSString stringWithFormat:@"%@/%@/index.aspx?back=1",uraaa,HuoBanMallBuyApp_Merchant_Id];
            goUrl = ddd;
        }
        
        [UIViewController ToRemoveSandBoxDate];
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:AppLoginType];
        
        if ([str intValue] == 0) {
            IponeVerifyViewController *login = [main instantiateViewControllerWithIdentifier:@"IponeVerifyViewController"];
            UINavigationController * root = [[UINavigationController alloc] initWithRootViewController:login];
            login.title = @"登录";
            login.goUrl = goUrl;
            [self presentViewController:root animated:YES completion:^{
                [[NSUserDefaults standardUserDefaults] setObject:Failure forKey:LoginStatus];
            }];
        }else if ([str intValue] == 1) {
            IponeVerifyViewController *login = [main instantiateViewControllerWithIdentifier:@"IponeVerifyViewController"];
            UINavigationController * root = [[UINavigationController alloc] initWithRootViewController:login];
            login.isPhoneLogin = YES;
            login.title = @"登录";
            login.goUrl = goUrl;
            [self presentViewController:root animated:YES completion:^{
                [[NSUserDefaults standardUserDefaults] setObject:Failure forKey:LoginStatus];
            }];
        }else if ([str intValue] == 2) {
            LoginViewController * login =  [main instantiateViewControllerWithIdentifier:@"LoginViewController"];
            login.title = @"登录";
            login.goUrl = goUrl;
            UINavigationController * root = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:root animated:YES completion:^{
                [[NSUserDefaults standardUserDefaults] setObject:Failure forKey:LoginStatus];
            }];
        }
        
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else if ([url rangeOfString:@"/usercenter/bindingweixin.aspx"].location != NSNotFound) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OquthByWeiXinSuccess1:) name:@"ToGetUserInfoBuild" object:nil];
        
        if ([WXApi isWXAppInstalled]) {
            self.bingWeixin = YES;
            [self WeiXinLog];
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"绑定失败"];
        }
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else if ([url rangeOfString:@"/usercenter/appaccountswitcher.aspx"].location != NSNotFound) {
        NSArray *array = [url componentsSeparatedByString:@"?u="]; //从字符A中分隔成2个元素的数组
        LWLog(@"array:%@",array);
        [self changeWithUserInfo:array];
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else if ([url rangeOfString:@"/usercenter/index.aspx"].location != NSNotFound){
//        [self.navigationController popViewControllerAnimated:YES];
        decisionHandler(WKNavigationResponsePolicyAllow);
    }else if([url rangeOfString:@"mredirectv2.aspx"].location != NSNotFound ){
         decisionHandler(WKNavigationResponsePolicyCancel);
        AlipayViewController * vc = [[AlipayViewController alloc] init];
        vc.aliPayNewUrl = url;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([url rangeOfString:@"appalipay.aspx"].location != NSNotFound){
        
            decisionHandler(WKNavigationResponsePolicyCancel);
            __weak PushWebViewController *wself = self;
            
            self.ServerPayUrl = [temp copy];
            NSRange trade_no = [temp rangeOfString:@"trade_no="];
            NSRange customerID = [temp rangeOfString:@"customerID="];
            //            NSRange paymentType = [url rangeOfString:@"paymentType="];
            NSRange trade_noRange = {trade_no.location + 9,customerID.location-trade_no.location-10};
            NSString * trade_noss = [temp substringWithRange:trade_noRange];//订单号
            self.orderNo = trade_noss;
            //            NSString * payType = [url substringFromIndex:paymentType.location+paymentType.length];
            // 1.得到data
//            NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
//            NSData *data = [NSData dataWithContentsOfFile:filename];
//            // 2.创建反归档对象
//            NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//            // 3.解码并存到数组中
//            NSArray *namesArray = [unArchiver decodeObjectForKey:PayTypeflat];
        
        AppDelegate * de = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSArray *namesArray = de.payConfig;
        LWLog(@"%lu",(unsigned long)namesArray.count);
        NSMutableString *url = [NSMutableString stringWithString:AppOriginUrl];
        [url appendFormat:@"%@?orderid=%@",@"/order/getpayinfo",trade_noss];
        
        
        
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        NSString * to = [NSDictionary ToSignUrlWithString:url];
        [SVProgressHUD show];
        [manager GET:to parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
            [SVProgressHUD dismiss];
            if(([json[@"code"] integerValue] == 200) && ([json[@"data"] HuoTuPayInfoConfConfirmWithOrderId:trade_noss])){
                
                LWLog(@"%@",json);
                self.priceNumber = json[@"data"][@"finalamount"];
                NSString * des =  json[@"data"][@"name"]; //商品描述
                self.proDes = [des copy];
                if(namesArray.count == 1){ // 1种支付方式
                    PayModel * pay =  namesArray.firstObject;  //300微信  400支付宝
                    self.paymodel = pay;
                    if ([pay.payType integerValue] == 300) {//300微信
                        UIAlertController *aa =[UIAlertController alertControllerWithTitle:@"支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                        [aa addAction:[UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [wself weixinPay];
                        }]];
                        [aa addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        [self presentViewController:aa animated:YES completion:nil];
                    }
                    if ([pay.payType integerValue] == 1 || [pay.payType integerValue] == 11) {//11 支付宝 和 1
                        UIAlertController *aa =[UIAlertController alertControllerWithTitle:@"支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                        [aa addAction:[UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [wself zhifubaoPay];
                        }]];
                        [aa addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        [self presentViewController:aa animated:YES completion:nil];
                    }
                }else if(namesArray.count == 2){ //2 种支付方式
                    
                    UIAlertController *aa =[UIAlertController alertControllerWithTitle:@"支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                    [aa addAction:[UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [wself weixinPay];
                    }]];
                    [aa addAction:[UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [wself zhifubaoPay];
                    }]];
                    [aa addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        PushWebViewController * funWeb =  [[PushWebViewController alloc] init];
                        
                        
                        MallMessage * mess =  [MallMessage getMallMessage];
                        LWLog(@"%@",[NSString stringWithFormat:@"%@/UserCenter/OrderV2/ListV2.aspx?customerid=%@&tab=1",mess.mall_site,HuoBanMallBuyApp_Merchant_Id]);
                        funWeb.funUrl = [NSString stringWithFormat:@"%@/UserCenter/OrderV2/ListV2.aspx?customerid=%@&tab=1",mess.mall_site,HuoBanMallBuyApp_Merchant_Id];
                        [self.navigationController pushViewController:funWeb animated:YES];
                        
                        
                        
                    }]];
                    [self presentViewController:aa animated:YES completion:nil];
                }
                
                
                
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"获取订单信息异常，请重新提交订单" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

        
        decisionHandler(WKNavigationResponsePolicyCancel);
    } else {
        if (![temp isEqualToString:self.funUrl]) {
            //                UIStoryboard * mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            if([temp rangeOfString:@"https"].location != NSNotFound){
                
                temp = [temp stringByReplacingOccurrencesOfString:@"https"withString:@"http"];
                if ([temp isEqualToString:self.funUrl]) {
                     decisionHandler(WKNavigationResponsePolicyAllow);
                }
                
            }else if ([temp.lowercaseString isEqualToString:self.funUrl.lowercaseString] || [temp.lowercaseString rangeOfString:@"im.html"].location!=NSNotFound) {
                decisionHandler(WKNavigationResponsePolicyAllow);
            }else {
                decisionHandler(WKNavigationResponsePolicyCancel);
                PushWebViewController * funWeb =  [[PushWebViewController alloc] init];
                funWeb.funUrl = temp;
                [self.navigationController pushViewController:funWeb animated:YES];
                self.tabBarController.tabBar.hidden = YES;
                self.navigationItem.title = nil;
                
                
            }
        }else{
            decisionHandler(WKNavigationResponsePolicyAllow);

        }

    }
    
    //decisionHandler(WKNavigationResponsePolicyAllow);

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    [webView evaluateJavaScript:@"__getShareStr()" completionHandler:^(id _Nullable shareStr, NSError * _Nullable error) {
        NSString *str = shareStr;
        if (str.length != 0) {
            self.shareBtn.hidden = NO;
        }else {
            self.shareBtn.hidden = YES;
        }
    }];
    

    
    
    
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"main_title_left_refresh"] forState:UIControlStateNormal];
    
    self.refreshBtn.userInteractionEnabled = YES;
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        NSString *str = title;
        self.navigationItem.title = str;
    }];

    _shareBtn.userInteractionEnabled = YES;
    [self.webView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    _shareBtn.userInteractionEnabled = NO;
}
- (void)restPushWebAgent {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.webView.customUserAgent = app.userAgent;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  初始化进度条
 */
- (void)initWebViewProgress {
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    self.progressView.tintColor = [UIColor greenColor];
    self.progressView.trackTintColor = HuoBanMallBuyNavColor;
    [self.navigationController.navigationBar addSubview:_progressView];
    
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}


#pragma mark 微信授权登录

/**
 *  微信授权登录
 */
- (void)WeiXinLog{
    
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendAuthReq:req viewController:self delegate:self];
}

/**
 *  微信授权登录后返回的用户信息
 */
-(void)getUserInfo1:(AQuthModel*)aquth
{

    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"access_token"] = aquth.access_token;
    parame[@"openid"] = aquth.openid;
    [UserLoginTool loginRequestGet:@"https://api.weixin.qq.com/sns/userinfo" parame:parame success:^(id json) {
        //        LWLog(@"%@",json);
        UserInfo * userInfo = [UserInfo mj_objectWithKeyValues:json];
        //向服务端提供微信数据
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo]    ;
        UserInfo *userLocal = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        
        [self bindWeixinWithUserInfo:userInfo AndUnionid:userLocal.unionid  AndRefreshToken:aquth.refresh_token];
        
    } failure:^(NSError *error) {
        LWLog(@"%@",error.description);
    }];
    
}
- (void)OquthByWeiXinSuccess1:(NSNotification *) note{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ToGetUserInfoBuild" object:nil];
    LWLog(@"-=------------%@",note);
    
    if (self.bingWeixin) {
        
        [self accessTokenWithCode1:note.userInfo[@"code"]];
        
        self.bingWeixin = NO;
    }else {
        return;
    }
    
    
    
}


- (void)accessTokenWithCode1:(NSString * )code
{
    __weak PushWebViewController * wself = self;
    //进行授权
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",HuoBanMallBuyWeiXinAppId,HuoBanMallShareSdkWeiXinSecret,code];
    [UserLoginTool loginRequestGet:url parame:nil success:^(id json) {
        
        LWLog(@"accessTokenWithCode%@",json);
        AQuthModel * aquth = [AQuthModel mj_objectWithKeyValues:json];
        [AccountTool saveAccount:aquth];
        //获取用户信息
        [wself getUserInfo1:aquth];
    } failure:^(NSError *error) {
        LWLog(@"%@",error.description);
    }];
}
/**
 *  刷新access_token
 */
- (void)toRefreshaccess_token1{
    
    [SVProgressHUD setStatus:nil];
    __weak PushWebViewController * wself = self;
    AQuthModel * mode = [AccountTool account];
    NSString * ss = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",HuoBanMallBuyWeiXinAppId,mode.refresh_token];
    [UserLoginTool loginRequestGet:ss parame:nil success:^(id json) {
        AQuthModel * aquth = [AQuthModel mj_objectWithKeyValues:json];
        [AccountTool saveAccount:aquth];
        //获取用户信息
        [wself getUserInfo1:aquth];
    } failure:^(NSError *error) {
        LWLog(@"%@",error.description);
    }];
}

- (void)bindWeixinWithUserInfo:(UserInfo *)userInfo AndUnionid:(NSString *) unionid AndRefreshToken:(NSString *)refreshToken
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"customerid"] = HuoBanMallBuyApp_Merchant_Id;
    params[@"userid"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId]];
    params[@"sex"] = [NSString stringWithFormat:@"%@",userInfo.sex];
    params[@"nickname"] = userInfo.nickname;
    params[@"openid"] = userInfo.openid;
    params[@"city"] = userInfo.city;
    params[@"country"] = userInfo.country;
    params[@"province"] = userInfo.province;
    params[@"unionid"] = userInfo.unionid;
    params[@"headimgurl"] = userInfo.headimgurl;
    params[@"refreshtoken"] = refreshToken;
    
    
    params = [NSDictionary asignWithMutableDictionary:params];
    
    NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
    [url appendString:@"/Account/bindWeixin"];
    
    [UserLoginTool loginRequestPost:url parame:params success:^(id json) {
        //        LWLog(@"%@",json);
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
            
            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
            
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app resetUserAgent:nil];
            
            [self.webView reload];
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"绑定失败"];
        }
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
    }];
    
}



#pragma mark 支付处理

/**
 微信支付
 */
- (void)weixinPay {
    AppDelegate * de = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *namesArray = de.payConfig;
    PayModel * paymodel =  namesArray[0];
    if ([paymodel.payType integerValue] == 300) {
        [self WeiChatPay:namesArray[0]];
    }else{
        [self WeiChatPay:namesArray[1]];//微信
    }
}


/**
 支付宝支付
 */
- (void)zhifubaoPay {
    AppDelegate * de = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *namesArray = de.payConfig;

    PayModel * paymodel =  namesArray[0];
    PayModel *cc =  [paymodel.payType integerValue] == 300?namesArray[1]:namesArray[0];
    if (cc.webPagePay) {//网页支付
        NSRange parameRange = [self.ServerPayUrl rangeOfString:@"?"];
        NSString * par = [self.ServerPayUrl substringFromIndex:(parameRange.location+parameRange.length)];
        NSArray * arr = [par componentsSeparatedByString:@"&"];
        __block NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
            NSArray * aa = [obj componentsSeparatedByString:@"="];
            NSDictionary * dt = [NSDictionary dictionaryWithObject:aa[1] forKey:aa[0]];
            [dict addEntriesFromDictionary:dt];
        }];
        NSString * js = [NSString stringWithFormat:@"utils.Go2Payment(%@, %@, 1, false)",dict[@"customerID"],[NSString stringWithFormat:@"'%@'",dict[@"trade_no"]]];
        //                [self.homeWebView stringByEvaluatingJavaScriptFromString:js];
        [self.webView evaluateJavaScript:js completionHandler:^(NSString * _Nullable js, NSError * _Nullable error) {
            
        }];
    }else{
        [self MallAliPay:cc];
    }
}

@end
