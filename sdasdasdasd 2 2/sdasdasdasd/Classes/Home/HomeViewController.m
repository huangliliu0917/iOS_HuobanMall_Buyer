//
//  HomeViewController.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/9/5.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HomeViewController.h"
#import <BlocksKit+UIKit.h>
#include <RESideMenu.h>
#import <MJRefresh.h>
#import "UIViewController+NAV.h"
#import "LeftMenuModel.h"
#import "MJExtension.h"
#import "UIViewController+MMDrawerController.h"
#import "RootViewController.h"
#import "PushWebViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "NSDictionary+HuoBanMallSign.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MidTabelViewCell.h"
#import "AccountModel.h"
#import "UIViewController+MonitorNetWork.h"
#import "MallMessage.h"
#import "PayModel.h"
#import "IponeVerifyViewController.h"
#import <SDWebImageManager.h>
//#import "Order.h"  //支付宝
//#import "DataSigner.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "payRequsestHandler.h"
#import "UserLoginTool.h"
#import <SSZipArchive.h>
#import <SVProgressHUD.h>
#import "SISBaseModel.h"
#import "SISHomeViewController.h"
#import "UserInfo.h"

@interface HomeViewController()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *homeWebView;


@property (weak, nonatomic) IBOutlet UIWebView *homeBottonWebView;

/***/
@property(nonatomic,strong) NSMutableString * debugInfo;
/**
 *  是否显示返回按钮
 *  1、表示显示
 *  2、表示不显示
 */
@property(nonatomic,assign) BOOL showBackArrows;

/**底部网页约束高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeBottonWebViewHeight;
/**图标*/
@property (nonatomic,strong) UIButton * backArrow;
/**返回按钮*/
@property (nonatomic,strong) UIButton * leftOption;

/**刷新按钮标*/
@property (nonatomic,strong) UIButton * refreshBtn;
/**分享按钮*/
@property (nonatomic,strong) UIButton * shareBtn;


/**账号提升选秀*/
@property (nonatomic,strong) UITableView * midtableView;

/**登陆后的背景遮罩*/
@property (nonatomic,strong) UIView * backView;

/**本地账号*/
@property (nonatomic,strong) NSArray * LocalAccounts;

@property(nonatomic,strong) NSString * orderNo;       //订单号
@property(nonatomic,strong) NSString * priceNumber;  //订单价格
@property(nonatomic,strong) NSString * proDes;       //订单描述
/**支付的url*/
@property(nonatomic,strong) NSString * ServerPayUrl;

@property(nonatomic,strong) PayModel * paymodel;

@end


@implementation HomeViewController


- (NSMutableString *)debugInfo{
    
    if (_debugInfo == nil) {
        
        _debugInfo = [NSMutableString string];
    }
    return _debugInfo;
}



- (NSArray *)LocalAccounts{
    if (_LocalAccounts == nil) {
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:AccountList];
        NSData *data = [NSData dataWithContentsOfFile:filename];
        // 2.创建反归档对象
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        // 3.解码并存到数组中
        NSArray *namesArray = [unArchiver decodeObjectForKey:AccountList];
        _LocalAccounts = namesArray;
    }
    return _LocalAccounts;
}


- (UIButton *)backArrow{
    if (_backArrow == nil) {
        _backArrow = [[UIButton alloc] init];
        _backArrow.frame = CGRectMake(0, 0, 25, 25);
        [_backArrow addTarget:self action:@selector(BackToWebView) forControlEvents:UIControlEventTouchUpInside];
        [_backArrow setBackgroundImage:[UIImage imageNamed:@"main_title_left_back"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backArrow];
    }
    return _backArrow;
}

- (UIButton *)leftOption{
    
    if (_leftOption == nil) {
        _leftOption = [[UIButton alloc] init];
        _leftOption.frame = CGRectMake(0, 0, 25, 25);
        [_leftOption addTarget:self action:@selector(GoToLeft) forControlEvents:UIControlEventTouchUpInside];
        [_leftOption setBackgroundImage:[UIImage imageNamed:@"main_title_left_sideslip"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftOption];
    }
    return _leftOption;
}


- (UIButton *)shareBtn{
    if (_shareBtn == nil) {
        _shareBtn = [[UIButton alloc] init];
        _shareBtn.frame = CGRectMake(0, 0, 25, 25);
        _shareBtn.userInteractionEnabled = NO;
        [_shareBtn addTarget:self action:@selector(shareBtnClicks) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"home_title_right_share"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}


-(UIButton *)refreshBtn{
    if (_refreshBtn == nil) {
        _refreshBtn = [[UIButton alloc] init];
        _refreshBtn.frame = CGRectMake(0, 0, 25, 25);
        [_refreshBtn addTarget:self action:@selector(refreshToWebViews) forControlEvents:UIControlEventTouchUpInside];
        [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"main_title_left_refresh"] forState:UIControlStateNormal];
        [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
    }
    return _refreshBtn;
}

/**
 *  刷新
 */
- (void)refreshToWebViews{
     [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
    self.refreshBtn.userInteractionEnabled = NO;

    [self.homeWebView reload];
}

/**
 *  分享
 */
- (void)shareBtnClicks{
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
    
    
    
    if(self.homeWebView.loading){
        return;
    }
    NSString * urs =  self.homeWebView.request.URL.absoluteString;
    
    MallMessage * mallmess = [MallMessage getMallMessage];
    
    NSString * uraaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
    NSMutableString * url = [NSMutableString stringWithString:uraaa];
    [url appendString:mallmess.mall_logo];
    
    
    //1、创建分享参数
    NSArray* imageArray = @[url];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:imageArray
                                            url:[NSURL URLWithString:urs]
                                          title:@"行装"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];

    }
}

-(void)xxxxx {
        //    //构造分享内容
        //    id<ISSContent> publishContent = [ShareSDK content:mallmess.mall_description
        //                                       defaultContent:mallmess.mall_description
        //                                                image:[ShareSDK imageWithUrl:url]
        //                                                title:mallmess.mall_name
        //                                                  url:[self toCutew:urs]      //mallmess.mall_site
        //                                          description:mallmess.mall_description
        //                                            mediaType:SSPublishContentMediaTypeNews];
        //    [publishContent addSinaWeiboUnitWithContent:mallmess.mall_description image:[ShareSDK imageWithUrl:mallmess.mall_logo] locationCoordinate:nil];
        //    //创建弹出菜单容器
        //    id<ISSContainer> container = [ShareSDK container];
        //
        //    //弹出分享菜单
        //    [ShareSDK showShareActionSheet:container
        //                         shareList:nil
        //                           content:publishContent
        //                     statusBarTips:YES
        //                       authOptions:nil
        //                      shareOptions:nil
        //                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        //
        //                                if (state == SSResponseStateSuccess)
        //                                {
        //                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //                                    [alert show];
        //
        //                                }
        //                                else if (state == SSResponseStateFail)
        //                                {
        //                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
        //                                }
        //                            }];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString * uraaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
    NSString * ddd = [NSString stringWithFormat:@"%@/%@/index.aspx?back=1",uraaa,HuoBanMallBuyApp_Merchant_Id];
    NSURL * urlStr = [NSURL URLWithString:[NSDictionary ToSignUrlWithString:ddd]];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:urlStr];
    self.homeWebView.scalesPageToFit = YES;
    self.homeWebView.tag = 100;
    self.homeWebView.delegate = self;
//    self.homeWebView.scrollView.bounces = NO;
    [self.homeWebView loadRequest:req];
    
    
    
    NSString * uraaaaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
    NSString * cc = [NSString stringWithFormat:@"%@%@%@",uraaaaa,HomeBottomUrl,HuoBanMallBuyApp_Merchant_Id];
    NSURLRequest * Bottomreq = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:cc]];
    self.homeBottonWebView.scalesPageToFit = YES;
    self.homeBottonWebView.delegate = self;
    self.homeBottonWebView.tag = 20;
//    self.homeBottonWebView.hidden = YES;
    self.homeBottonWebView.scrollView.bounces = NO;
    self.homeBottonWebView.scrollView.scrollEnabled = NO;
    [self.homeBottonWebView loadRequest:Bottomreq];


    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.barTintColor = HuoBanMallBuyNavColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftOption];
    
    //集成刷新控件
    [self AddMjRefresh];
    
//    [UIBarButtonItem alloc] initWithCustomView:self.refreshBtn],
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.shareBtn]];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self ReturnNavPictureWithName:@"home_title_right_search"]];
    
    //左侧返回到首页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeftbackToHome:) name:@"backToHomeView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeixinQauth) name:WeiXinQAuthSuccessNotigication object:nil];
    
    //切换账号
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ToSwitchAccount) name:@"SwitchAccount" object:nil];
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoSIShomeVC) name:@"pushtoSIS" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToIphone) name:@"goToIponeVerifyViewController" object:nil];
    
    [UIViewController MonitorNetWork];
    
    [self ToCheckDate];
}

/**
 *  查看数据资源
 */
- (void)ToCheckDate{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DatePackageVersion];
    __weak HomeViewController * wself = self;
    NSString * cc = [NSString stringWithFormat:@"%@%@",AppOriginUrl,@"/mall/CheckDataPacket"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"datapacketversion"] = AppVersion;
    NSMutableDictionary * aa =  [NSDictionary asignWithMutableDictionary:dict];
    [UserLoginTool loginRequestGet:cc parame:aa success:^(id json) {
//        NSLog(@"%@",json);
        if ([json[@"code"] integerValue] == 200 && [json[@"data"][@"updateData"] integerValue] == 1 ) {
            //数据包版本号
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"version"] forKey:DatePackageVersion];
            
            [wself ToGetDownDateWithDateSource:json[@"data"][@"downloadUrl"] andverson:json[@"version"]];
        }
    } failure:^(NSError *error) {
         NSLog(@"%@",error.description);
    }];
    
}


- (void)AddMjRefresh{
    // 添加下拉刷新控件
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    header.arrowView.image= nil;
    self.homeWebView.scrollView.mj_header = header;

}


- (void)ToGetDownDateWithDateSource:(NSString *) url andverson:(NSString *)ver{
    [UserLoginTool loginRequestDateGet:url parame:nil downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/update.zip"];
        NSString *unsavedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/update"];
        NSString * cc = [NSString stringWithFormat:@"%@/icon",unsavedPath];
        
        [SSZipArchive unzipFileAtPath:savedPath toDestination: unsavedPath];
        NSFileManager * manage = [NSFileManager defaultManager];
        NSArray * fileName = [manage contentsOfDirectoryAtPath:cc error:nil];
        [fileName enumerateObjectsUsingBlock:^(NSString * fileName, NSUInteger idx, BOOL *stop) {
            
//            NSLog(@"dasdasdasdasdasd====%@",fileName);
        }];
        
        
    } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error.description);
    } progress:^(float progress) {
         NSLog(@"xxxxxx%f",progress);
    }];
    
}

/*
 *网页下拉刷新
 */
- (void)loadNewData{
    [self.homeWebView reload];
}

- (void)switchUserInfoSuccess {
    NSString * uraaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
    NSString * ddd = [NSString stringWithFormat:@"%@/%@/index.aspx?back=1",uraaa,HuoBanMallBuyApp_Merchant_Id];
    NSURL * urlStr = [NSURL URLWithString:[NSDictionary ToSignUrlWithString:ddd]];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:urlStr];
    [self.homeWebView loadRequest:req];
}

/**
 *  切换账号
 */
- (void)ToSwitchAccount{
    
    if (self.LocalAccounts.count>1) {
        [self MildAlertView];
    }
}


- (void)blackView{
    AppDelegate * de = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([de.SwitchAccount isEqualToString:@"first"]) {
        if (self.LocalAccounts.count>1) {
            [self MildAlertView];
        }
        de.SwitchAccount = @"xxx";
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    
    
    [self blackView];
}





- (void)MildAlertView{
    
    UIView * backgroundView = [[UIView alloc] init];
    _backView = backgroundView;
    backgroundView.userInteractionEnabled = YES;
    backgroundView.frame = CGRectMake(0, 0,SecrenWith,SecrenHeight);
    backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.800];
    [self.view.window insertSubview:backgroundView aboveSubview:self.view];
    
    
    
    
    CGFloat midTableH = 55 + 65 + (self.LocalAccounts.count>5?5:self.LocalAccounts.count) * 40;//
    _midtableView = [[UITableView alloc] initWithFrame:CGRectMake((SecrenWith - 200)/ 2, (SecrenHeight - midTableH) / 2, 200, midTableH) style:UITableViewStylePlain];
    _midtableView.dataSource = self;
    _midtableView.delegate = self;
    _midtableView.backgroundColor = [UIColor whiteColor];
    _midtableView.layer.cornerRadius = 10;
    _midtableView.scrollEnabled = NO;
    [backgroundView addSubview:_midtableView];
}

#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_LocalAccounts.count<=5) {
        return _LocalAccounts.count + 2;
    }else{
      return 7;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wz"]];
        cell.userInteractionEnabled = NO;
        return cell;
    }else if (_LocalAccounts.count <= 5) {
        if (indexPath.row == (_LocalAccounts.count + 1) ){//
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wzd"]];
            cell.userInteractionEnabled = NO;
            return cell;
        }else {
            MidTabelViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MidTabelViewCell" owner:nil options:nil] lastObject];
            AccountModel * account =  _LocalAccounts[indexPath.row-1];
            cell.Identification.text = account.username;
            return cell;
        }
    }else {
        if (indexPath.row == 6 ){//
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wzd"]];
            cell.userInteractionEnabled = NO;
            return cell;
        }else {
            MidTabelViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MidTabelViewCell" owner:nil options:nil] lastObject];
            AccountModel * account =  _LocalAccounts[indexPath.row-1];
            cell.Identification.text = account.username;
            return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 55;
    }else if (_LocalAccounts.count <= 5){
        if (indexPath.row == (self.LocalAccounts.count + 1)) {
            return 65;
        }else {
            return 40;
        }
    }else {
        if (indexPath.row == 6) {
            return 65;
        }else {
            return 40;
        }
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_backView removeFromSuperview];
    AccountModel * account =  _LocalAccounts[indexPath.row-1];
    [[NSUserDefaults standardUserDefaults] setObject:account.userid forKey:HuoBanMallUserId];
    
    //取出用户数据列表
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:UserInfoList];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    // 2.创建反归档对象
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 3.解码并存到数组中
    NSArray *userList = [unArchiver decodeObjectForKey:UserInfoList];
    
    //读取相应的用户数据以及替换本地书记
    UserInfo *user = userList[indexPath.row - 1];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *userfileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
    [NSKeyedArchiver archiveRootObject:user toFile:userfileName];
    
    [self switchUserInfoSuccess];
    
}




- (void)WeixinQauth{
    
    NSURL * urlStr = [NSURL URLWithString:[NSDictionary ToSignUrlWithString:HomeUrl]];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:urlStr];
    [self.homeWebView loadRequest:req];
}



/**
 *  网页
 */
- (void)BackToWebView{
    if ([self.homeWebView canGoBack]) {
        [self.homeWebView goBack];
    }
}

/**
 *  去左侧
 */
- (void)GoToLeft{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
       
    }];
}

- (void)LeftbackToHome:(NSNotification *) note{
    
    NSString * backUrl = [note.userInfo objectForKey:@"url"];
    NSURL * newUrl = [NSURL URLWithString:backUrl];
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:newUrl];
    [self.homeWebView loadRequest:req];
}

- (UIView *)ReturnNavPictureWithName:(NSString *)name andTwo:(NSString *)share{
 
    return nil;
}

- (UIView *)ReturnNavPictureWithName:(NSString *)name{
    
    UIButton *leftbutton = [[UIButton alloc] init];
    if ([name isEqualToString:@"home_title_left_menu"]) {
        leftbutton.tag = 0;
    }else{
        leftbutton.tag = 1;
    }
    leftbutton.frame = CGRectMake(0, 0, 25, 25);
    [leftbutton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    return leftbutton;
}

- (void)presentLeftMenuViewController:(UIButton *)item{
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
}


- (void)ocappCallJspoc{
    [self.homeWebView stringByEvaluatingJavaScriptFromString:@"alert(1);"];
}



/**
 *  jsp调app
 
 windown.location.href  = 'ios://openAlum'
 */
- (void)jspCallApp{
    
    
}

- (void)openAlbum{
    
}




- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    _shareBtn.userInteractionEnabled = NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"main_title_left_refresh"] forState:UIControlStateNormal];
    
    self.refreshBtn.userInteractionEnabled = YES;
   
    
    if (webView.tag == 100) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (_showBackArrows) {//返回按钮
            
            [UIView animateWithDuration:0.05 animations:^{
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftOption];
            }];
        }else{
            [UIView animateWithDuration:0.05 animations:^{
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backArrow];
            }];
        }
    }
    
    _shareBtn.userInteractionEnabled = YES;
    [self.homeWebView.scrollView.mj_header endRefreshing];
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    
    if (webView.tag == 100) {
        
        if ([url rangeOfString:@"/UserCenter/Login.aspx"].location !=  NSNotFound) {
             [UIViewController ToRemoveSandBoxDate];
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController * login =  [main instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController * root = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:root animated:YES completion:^{
               [[NSUserDefaults standardUserDefaults] setObject:Failure forKey:LoginStatus];
            }];
            
        }else if([url rangeOfString:@"AppAlipay.aspx"].location != NSNotFound){
         
                
                self.ServerPayUrl = [url copy];
                NSRange trade_no = [url rangeOfString:@"trade_no="];
                NSRange customerID = [url rangeOfString:@"customerID="];
                //            NSRange paymentType = [url rangeOfString:@"paymentType="];
                NSRange trade_noRange = {trade_no.location + 9,customerID.location-trade_no.location-10};
                NSString * trade_noss = [url substringWithRange:trade_noRange];//订单号
                self.orderNo = trade_noss;
                //            NSString * payType = [url substringFromIndex:paymentType.location+paymentType.length];
                // 1.得到data
                NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
                NSData *data = [NSData dataWithContentsOfFile:filename];
                // 2.创建反归档对象
                NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                // 3.解码并存到数组中
                NSArray *namesArray = [unArchiver decodeObjectForKey:PayTypeflat];
                
                
                NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
                [url appendFormat:@"%@?orderid=%@",@"/order/GetOrderInfo",trade_noss];
                
                AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
                NSString * to = [NSDictionary ToSignUrlWithString:url];
                [manager GET:to parameters:nil success:^void(AFHTTPRequestOperation * requset, id json) {
                    if ([json[@"code"] integerValue] == 200) {
                        self.priceNumber = json[@"data"][@"Final_Amount"];
                        NSString * des =  json[@"data"][@"ToStr"]; //商品描述
                        self.proDes = des;
                        
                        if(namesArray.count == 1){
                            PayModel * pay =  namesArray.firstObject;  //300微信  400支付宝
                            self.paymodel = pay;
                            if ([pay.payType integerValue] == 300) {//300微信
                                UIActionSheet * aa =  [[UIActionSheet alloc] initWithTitle:@"支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信", nil];
                                aa.tag = 500;//单个微信支付
                                [aa showInView:self.view];
                            }
                            if ([pay.payType integerValue] == 400) {//400支付宝
                                UIActionSheet * aa =  [[UIActionSheet alloc] initWithTitle:@"支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", nil];
                                aa.tag = 700;//单个支付宝支付
                                [aa showInView:self.view];
                            }
                        }else if(namesArray.count == 2){
                            UIActionSheet * aa =  [[UIActionSheet alloc] initWithTitle:@"支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
                            aa.tag = 900;//两个都有的支付
                            [aa showInView:self.view];
                        }
                        
                    }
                    
                    
                } failure:^void(AFHTTPRequestOperation * reponse, NSError * error) {
                    NSLog(@"%@",error.description);
                }];
                
                return NO;
         

            
        }else{
            NSRange range = [url rangeOfString:@"__newframe"];
            if (range.location != NSNotFound) {
                UIStoryboard * mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                PushWebViewController * funWeb =  [mainStory instantiateViewControllerWithIdentifier:@"PushWebViewController"];
                funWeb.funUrl = url;
                [self.navigationController pushViewController:funWeb animated:YES];
                return NO;
            }else{
                
                NSRange range = [url rangeOfString:@"back"];
                if (range.location != NSNotFound) {
                    self.showBackArrows = YES;
                }else{
                    self.showBackArrows = NO;
                }
                return YES;
            }
            
        }
        
        
    }else if(webView.tag == 20){
        
        NSString * uraaaaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
        NSString * cc = [NSString stringWithFormat:@"%@%@%@",uraaaaa,HomeBottomUrl,HuoBanMallBuyApp_Merchant_Id];
        if ([url isEqualToString:cc]) {
            return YES;
        }else if([url rangeOfString:@"http://wpa.qq.com/msgrd?v=3&uin"].location != NSNotFound){
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]; //拨号
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/cn/app/qq/id451108668?mt=12"]]; //拨号
            }
            return NO;
        }else {
            
            
//            NSString * uraaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
//            NSRange  range = [url rangeOfString:@"com"];
//            NSString * openUrl = [url substringFromIndex:range.location + range.length];

            NSRange range = [url rangeOfString:@"back"];
            NSString * newUrls = nil;
            if (range.location != NSNotFound) {
                
                newUrls = [url stringByReplacingCharactersInRange:range withString:@"back=1"];
            }else{
                newUrls = [NSString stringWithFormat:@"%@&back=1",url];
            }
           
            NSRange ran = [newUrls rangeOfString:@"aspx"];
            NSString * newUrl = nil;
            if (ran.location != NSNotFound) {
                NSRange cc = NSMakeRange(ran.location+ran.length, 1);
                newUrl = [newUrls stringByReplacingCharactersInRange:cc withString:@"?"];
            }
            NSString * dddd = [NSDictionary ToSignUrlWithString:newUrl];
            NSURL * urlStr = [NSURL URLWithString:dddd];
            NSURLRequest * req = [[NSURLRequest alloc] initWithURL:urlStr];
            [self.homeWebView loadRequest:req];
            return NO;
        }
    }
    return YES;
}


-(UIImage *)scaleimage:(UIImage *)img size:(CGSize)c

{
    
    UIGraphicsBeginImageContext(c);
    
    [img drawInRect:CGRectMake(0, 0, SecrenWith, SecrenHeight)];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 500) {//单个微信支付
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
        NSData *data = [NSData dataWithContentsOfFile:filename];
        // 2.创建反归档对象
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        // 3.解码并存到数组中
        NSArray *namesArray = [unArchiver decodeObjectForKey:PayTypeflat];
        [self WeiChatPay:namesArray[0]];
    }else if (actionSheet.tag == 700){// 单个支付宝支付
        //NSLog(@"支付宝%ld",(long)buttonIndex);
        //        [self MallAliPay:self.paymodel];
    }else if(actionSheet.tag == 900){//两个都有的支付
        //0
        //1
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:PayTypeflat];
        NSData *data = [NSData dataWithContentsOfFile:filename];
        // 2.创建反归档对象
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        // 3.解码并存到数组中
        NSArray *namesArray = [unArchiver decodeObjectForKey:PayTypeflat];
        if (buttonIndex==0) {//支付宝
            PayModel * paymodel =  namesArray[0];
            PayModel *cc =  [paymodel.payType integerValue] == 400?namesArray[0]:namesArray[1];
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
                NSString * js = [NSString stringWithFormat:@"utils.Go2Payment(%@, %@, 1, false)",dict[@"customerID"],dict[@"trade_no"]];
                [self.homeWebView stringByEvaluatingJavaScriptFromString:js];
            }else{
                [self MallAliPay:cc];
            }
        }
        if (buttonIndex==1) {//微信
            PayModel * paymodel =  namesArray[0];
            if ([paymodel.payType integerValue] == 300) {
                [self WeiChatPay:namesArray[0]];
            }else{
                [self WeiChatPay:namesArray[1]];//微信
            }
            
        }
        
    }
    
}

/**
 *  商城支付宝支付
 */
- (void)MallAliPay:(PayModel *)pay{
    
//    NSString *privateKey = pay.appKey;
//    // @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAMCul0XS9X/cVMkmrSeaZXnSvrs/bK5EiZf3d3/lTwHx165wAX/UIz4AcZHbKkYKKzmZKrRsu3tLRKFuflooKSVmWxk2hmeMqRETPZ/t8rKf8UONZIpOlOXEmJ/rYwxhnMeVhbJJxsko2so/jc+XAPLyv0tsfoI/TsJuhaGQ569ZAgMBAAECgYAK4lHdOdtwS4vmiO7DC++rgAISJbUH6wsysGHpsZRS8cxTKDSNefg7ql6/9Hdg2XYznLlS08mLX2cTD2DHyvj38KtxLEhLP7MtgjFFeTJ5Ta1UuBRERcmy0xSLh2zayiSwGTM8Bwu7UD6LUSTGwrgRR2Gg4EDpSG08J5OCThKF4QJBAPOO6WKI/sEuoRDtcIJqtv58mc4RSmit/WszkvPlZrjNFDU6TrOEnPU0zi3f8scxpPxVYROBceGj362m+02G2I0CQQDKhlq4pIM2FLNoDP4mzEUyoXIwqn6vIsAv8n49Tr9QnBjCrKt8RiibhjSEvcYqM/1eocW0j2vUkqR17rNuVVz9AkBq+Z02gzdpwEJMPg3Jqnd/pViksuF8wtbo6/kimOKaTrEOg/KnVJrf9HaOnatzpDF0B0ghGhzb329SRWJhddXNAkAkjrgVmGyu+HGiGKZP7pOXHhl0u3H+vzEd9pHfEzXpoSO/EFgsKKXv3Pvh8jexKo1T5bPAchsu1gGl4B63jeUpAkBbgUalUpZWZ4Aii+Mfts+S2E5RooZfVFqVBIsK47hjcoqLw4JJenyjFu+Skl2jOQ8+I5y1Ggeg6fpBMr2rbVkf";
//    
//    Order *order = [[Order alloc] init];
//    order.service = @"mobile.securitypay.pay";
//    order.partner = pay.partnerId;
//    order.inputCharset = @"utf-8";
//    NSMutableString * urls = [NSMutableString stringWithString:MainUrl];
//    [urls appendString:pay.notify];
//    order.notifyURL = urls;
//    order.tradeNO = self.orderNo;
//    order.productName = self.proDes;;
//    order.productDescription = self.proDes;;
//    order.amount = [NSString stringWithFormat:@"%.2f",[self.priceNumber floatValue]];  //订单总金额，只能为整数，详见支付金额;
//    order.paymentType = @"1";
//    order.seller = pay.partnerId;
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
//    NSDictionary *infoPlist =[NSDictionary dictionaryWithContentsOfFile:path];
//    NSString * appScheme = [[[[infoPlist objectForKey:@"CFBundleURLTypes"] firstObject] objectForKey:@"CFBundleURLSchemes"] lastObject];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:nil];
//    }
    
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
        NSLog(@"提示信息----微信预支付失败");
    }
}


/**
 *  微信支付预zhifu
 */
- (NSMutableDictionary *)PayByWeiXinParame:(PayModel *)paymodel{
    
    payRequsestHandler * payManager = [[payRequsestHandler alloc] init];
    [payManager setKey:paymodel.appKey];
    BOOL isOk = [payManager init:self.paymodel.appId mch_id:self.paymodel.partnerId];
    if (isOk) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
        params[@"appid"] = paymodel.appId;
        params[@"mch_id"] = paymodel.partnerId;     //微信支付分配的商户号
        params[@"nonce_str"] = noncestr; //随机字符串，不长于32位。推荐随机数生成算法
        params[@"trade_type"] = @"APP";   //取值如下：JSAPI，NATIVE，APP，WAP,详细说明见参数规定
        params[@"body"] = MallName; //商品或支付单简要描述
        NSMutableString * urls = [NSMutableString stringWithString:MainUrl];
        [urls appendString:paymodel.notify];
        params[@"notify_url"] = urls;  //接收微信支付异步通知回调地址
        
        NSString * order = [NSString stringWithFormat:@"%@_%@_%d",self.orderNo,HuoBanMallBuyApp_Merchant_Id,(arc4random() % 900 + 100)];
        params[@"out_trade_no"] = order; //订单号
        params[@"spbill_create_ip"] = @"192.168.1.1"; //APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
        params[@"total_fee"] = [NSString stringWithFormat:@"%.f",[self.priceNumber floatValue] * 100];  //订单总金额，只能为整数，详见支付金额
        params[@"device_info"] = ([[UIDevice currentDevice].identifierForVendor UUIDString]);
        params[@"attach"] = [NSString stringWithFormat:@"%@_0",HuoBanMallBuyApp_Merchant_Id];
        //获取prepayId（预支付交易会话标识）
        NSString * prePayid = nil;
        prePayid  = [payManager sendPrepay:params];
        NSLog(@"xcaccasc%@",[payManager getDebugifo]);
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
            [signParams setObject: HuoBanMallBuyWeiXinAppId  forKey:@"appid"];
            [signParams setObject: nonce_str    forKey:@"noncestr"];
            [signParams setObject: package      forKey:@"package"];
            [signParams setObject: @"1251040401"   forKey:@"partnerid"];
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


- (void)pushtoSIShomeVC {
    
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SISHomeViewController *home = [story instantiateViewControllerWithIdentifier:@"SISHomeViewController"];
    
    [self.navigationController pushViewController:home animated:YES];
}

- (void)pushToIphone {
    UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IponeVerifyViewController *phone = [stroy instantiateViewControllerWithIdentifier:@"IponeVerifyViewController"];
    [self.navigationController pushViewController:phone animated:YES];
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end


