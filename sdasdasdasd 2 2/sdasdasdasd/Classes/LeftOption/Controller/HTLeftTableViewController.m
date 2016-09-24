
//
//  HTLeftTableViewController.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/9/8.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HTLeftTableViewController.h"
#import "WXApi.h"
#import "LeftGroupModel.h"
#import "UserLoginTool.h"
#import "AQuthModel.h"
#import "AccountTool.h"
#import "UserInfo.h"
#import "LeftMenuModel.h"
#import "UIViewController+MMDrawerController.h"
#import "UIImage+LHB.h"
#import "NSDictionary+HuoBanMallSign.h"
//#import "UIImage+LHB.h"
#import <UIImageView+WebCache.h>
#import "MyLoginView.h"
#import "UserInfo.h"
#import <SVProgressHUD.h>
#import "AccountModel.h"
#import <BlocksKit/UIView+BlocksKit.h>
#import "IponeVerifyViewController.h"

@interface HTLeftTableViewController ()<NSXMLParserDelegate,MyLoginViewDelegate,UIAlertViewDelegate,WXApiDelegate>

/**zml左侧数据*/
@property(nonatomic,strong) NSMutableArray * dataList;
@property(nonatomic,strong) LeftMenuModel * currentVideo;
@property(nonatomic,strong) NSMutableString * elementString;


/**头像*/
//@property(nonatomic,strong) UIImageView * iconView;
/**顶部登录按钮*/
@property(nonatomic,strong) UIButton * logingBtn;
@property(nonatomic,strong) NSMutableArray * groupArray;

//添加菜单
@property (nonatomic, strong)LeftMenuModel *wx;
@property (nonatomic, strong)LeftMenuModel *phone;


@property(nonatomic,strong) MyLoginView * topHeadView;
@end

@implementation HTLeftTableViewController





- (NSMutableArray *)groupArray{
    
    if (_groupArray==nil) {
        
        _groupArray = [NSMutableArray array];
    }
    
    return _groupArray;
}

- (NSMutableArray *)dataList{
    
    if (_dataList == nil) {
        
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

- (NSMutableString *)elementString{
    
    if (_elementString == nil) {
        _elementString = [[NSMutableString alloc] init];
    }
    
    return _elementString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    //页面初始化
    [self setup];
    
    
    //设置导航栏样式
    [self setNavItem];
    
    //读取app左侧条目
    [self toDivLefrMenue];
    
    [self LoginTest];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}


/**
 *  更新左侧菜单
 *
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    __weak HTLeftTableViewController * wself = self;
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
    //    AQuthModel * AQuth = [AccountTool account];
    if ([login isEqualToString:Success]) {
        parame[@"clientusertype"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:MallUserType]];
        parame[@"userid"] = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallUserId]];
    }else {
        parame[@"clientusertype"] = @"0";
        parame[@"userid"] = @"0";
    }
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString * url = [NSMutableString stringWithString:AppOriginUrl];
    [url appendString:@"/weixin/UpdateLeftInfo"];
    [UserLoginTool loginRequestGet:url parame:parame success:^(NSDictionary* json) {
        
//        NSLog(@"%@",json);
        if ([json[@"code"] integerValue] == 200) {
           [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"levelName"] forKey:HuoBanMallMemberLevel];
//            _topHeadView.secondLable1.text = json[@"data"][@"levelName"];
            if ([json[@"data"][@"menusCode"] integerValue] == 1) {
                
                NSArray * lefts = [LeftMenuModel objectArrayWithKeyValuesArray:json[@"data"][@"home_menus"]];
                [wself.groupArray removeAllObjects];
                [wself toGroupsByTime:lefts];
                [wself.tableView reloadData];
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
            }else{
                [wself.groupArray removeAllObjects];
                [wself toDivLefrMenue];
                [wself.tableView reloadData];
                
            }
        }
    } failure:^(NSError *error) {
//        NSLog(@"%@",error.description);
    }];
    
    [self setHeadViewLabelsAndImage];
}

- (void) toDivLefrMenue{
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:LeftMenuModels];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    // 2.创建反归档对象
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 3.解码并存到数组中
    NSArray *namesArray = [unArchiver decodeObjectForKey:LeftMenuModels];
    
    [self toGroupsByTime:namesArray];
}

/**
 *  把首页数据进行分组
 */
/**
 *  把首页数据进行分组
 */
- (void)toGroupsByTime:(NSArray *)tasks{
    
    LeftMenuModel * aaas = nil;
    LeftGroupModel * groupModel = [[LeftGroupModel alloc] init];
    groupModel.groupID = -1;
    for (LeftMenuModel * model in tasks) {
        if (model.menu_group != groupModel.groupID) {
            aaas = model;
            LeftGroupModel * group = [[LeftGroupModel alloc] init];
            group.groupID =model.menu_group;
            [group.models addObject:model];//
            groupModel = group;
            [self.groupArray addObject:group];
        }else{
            aaas = model;
            [groupModel.models addObject:model];
        }
    }
//    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:MallUserRelatedType];

//    if ([str intValue] == 0) {
//        if ([WXApi isWXAppInstalled]) {
//            _wx = [[LeftMenuModel alloc] init];
//            _wx.menu_icon = @"home_menu_wx";
//            _wx.menu_name = @"绑定微信";
//            _wx.menu_group = self.groupArray.count ;
//            [groupModel.models addObject:_wx];
//        }
//    }else if ([str intValue] == 1 || [str intValue] == 3){
//        _phone = [[LeftMenuModel alloc] init];
//        _phone.menu_icon = @"home_menu_sjbd";
//        _phone.menu_name = @"绑定手机";
//        _phone.menu_group = self.groupArray.count ;
//        [groupModel.models addObject:_phone];
//    }
}



/**
 *  登录帐号che shi
 */
- (void)LoginTest{
    NSString * flag = [[NSUserDefaults standardUserDefaults] objectForKey:UserQaquthAccountFlag];
    if ([flag isEqualToString:@"scuess"]) {
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
        UserInfo *userinfoss =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        [_topHeadView.iconView sd_setImageWithURL:[NSURL URLWithString:userinfoss.headimgurl] placeholderImage:[UIImage imageNamed:@"sideslip_login_lefttop_logo"] options:SDWebImageRetryFailed];
       
    }
    
}


- (void)setNavItem{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    UIBarButtonItem *leftBarButon = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationController.navigationItem.leftBarButtonItem = leftBarButon;
//    self.navigationController.navigationItem.leftBarButtonItem =
    self.navigationController.navigationBar.translucent = NO;
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]]; 
    
}

- (void)WeixinQauth:(NSNotification *)note{
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
    UserInfo * userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    [_topHeadView.iconView sd_setImageWithURL:[NSURL URLWithString:userInfo.headimgurl] placeholderImage:[UIImage imageNamed:@"sideslip_login_lefttop_logo"] options:SDWebImageRetryFailed];
    _topHeadView.firstLable.text = userInfo.nickname;
    _topHeadView.firstLable.font = [UIFont systemFontOfSize:20];
    
}
/**
 *  页面初始化
 */
- (void)setup{
    NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
    //    AQuthModel * AQuth = [AccountTool account];
    
    self.tableView.scrollEnabled = NO;
    MyLoginView * headView =  [[[NSBundle mainBundle] loadNibNamed:@"MyLoginView" owner:self options:nil] lastObject];
    headView.delegate = self;
    _topHeadView = headView;
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
    UserInfo * userInfor =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    

    NSString * headUrl =  [[NSUserDefaults standardUserDefaults] objectForKey:IconHeadImage];
    
    if ([login isEqualToString:Success]) {
        
        [headView.iconView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:nil completed:nil];
        headView.firstLable.text = userInfor.nickname;
        headView.userInteractionEnabled = NO;
        
    }else {
        headView.iconView.image = [UIImage imageNamed:@"moren"];
        headView.firstLable.text = @"未登陆";
        headView.userInteractionEnabled = YES;
        __weak HTLeftTableViewController *wself = self;
        [headView bk_whenTapped:^{
            [wself backToTabbarAndGoLogin];
        }];
    }
    headView.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    headView.iconView.layer.cornerRadius = headView.iconView.frame.size.width*0.5;
    headView.secondLable1.layer.cornerRadius = 3;
    headView.secondLable1.layer.masksToBounds = YES;
    headView.secondLable1.backgroundColor = [UIColor whiteColor];
    
    headView.secondLable2.layer.cornerRadius = 3;
    headView.secondLable2.layer.masksToBounds = YES;
    headView.secondLable2.backgroundColor = [UIColor whiteColor];
    
    headView.secondLable3.layer.cornerRadius = 3;
    headView.secondLable3.layer.masksToBounds = YES;
    headView.secondLable3.backgroundColor = [UIColor whiteColor];
    
//    headView.iconView.layer.masksToBounds = YES;
    headView.iconView.layer.borderWidth = 2;
    
    
    headView.secondLable1.textColor = HuoBanMallBuyNavColor;
    headView.secondLable2.textColor = HuoBanMallBuyNavColor;
    headView.secondLable3.textColor = HuoBanMallBuyNavColor;
    CGFloat HeadViewW =  SecrenWith * SplitScreenRate;
    CGFloat HeadViewH = 114;
    headView.frame = CGRectMake(0,0, HeadViewW,HeadViewH);
    headView.backgroundColor = HuoBanMallBuyNavColor;
    self.tableView.tableHeaderView.frame = CGRectMake(0,0, HeadViewW,HeadViewH);
    self.tableView.tableHeaderView = headView; 
    
    
//    NSString * level = [[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallMemberLevel];
//    NSArray *levelArray = [level componentsSeparatedByString:@"&"];
//    for (int i = 0; i < levelArray.count; i++) {
//        UILabel *label = (UILabel *)[self.view viewWithTag:100+i];
//        label.text = [NSString stringWithFormat:@" %@ ",levelArray[i]];
//    }

    self.tableView.tableFooterView = [[UIView alloc] init];
//    [self.view layoutIfNeeded];
}

- (void)setHeadViewLabelsAndImage {
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:WeiXinUserInfo];
    UserInfo * userInfor =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    NSString * headUrl =  [[NSUserDefaults standardUserDefaults] objectForKey:IconHeadImage];
    NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
    if ([login isEqualToString:Success]) {
        
        [_topHeadView.iconView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:nil options:SDWebImageRetryFailed];
        _topHeadView.firstLable.text = userInfor.nickname;
        _topHeadView.userInteractionEnabled = NO;
    }else {
        _topHeadView.iconView.image = [UIImage imageNamed:@"moren"];
        _topHeadView.firstLable.text = @"未登陆";
        _topHeadView.userInteractionEnabled = YES;
    }
//    [_topHeadView.iconView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:nil completed:nil];
//    
//    _topHeadView.firstLable.text = userInfor.nickname;
    
    NSString * level = [[NSUserDefaults standardUserDefaults] objectForKey:HuoBanMallMemberLevel];
    NSArray *levelArray = [level componentsSeparatedByString:@"&"];
    for (int i = 0; i < levelArray.count; i++) {
        NSString *temp = levelArray[i];
        UILabel *label = (UILabel *)[self.view viewWithTag:100+i];
        label.text = [NSString stringWithFormat:@" %@ ",temp];
    }
    
}

- (void)accountLogin:(UIButton *) btn{
    
//    NSLog(@"点击登陆");
   
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    LeftGroupModel * model = self.groupArray[section];
    return  model.models.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString * cellId = @"xxxxxxx";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    }
    LeftGroupModel * model = self.groupArray[indexPath.section];
    LeftMenuModel * models =  model.models[indexPath.row];
    cell.textLabel.text = models.menu_name;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    NSString *unsavedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/update/icon"];
//    NSString * imageUrl = [NSString stringWithFormat:@"%@/%@",unsavedPath,models.menu_icon];
//    NSLog(@"%@",imageUrl);
//    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:imageUrl];
    
//    UIImage *savedImages = [savedImage imageCompressForWidth:savedImage targetWidth:44];
    cell.imageView.image = [UIImage LeftMenuImageWithIconName:models.menu_icon];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LeftGroupModel * model = self.groupArray[indexPath.section];
    LeftMenuModel * models =  model.models[indexPath.row];
    NSString * uraaa = [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl];
    NSMutableString * url = [NSMutableString stringWithString:uraaa];
    if (models.menu_url) {
        [url appendString:models.menu_url];
    }
    
    //绑定微信
    if ([models.menu_name isEqualToString:@"绑定微信"]) {
        
    }else if ([models.menu_name isEqualToString:@"绑定手机"]){
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToIponeVerifyViewController" object:nil];
//        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }else {
        //业务逻辑(胖子写的)
        if ([models.menu_url isEqualToString:@"http://www.dzd.com"]) {
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }else{
            NSRange rangs = [url rangeOfString:@"?"];
            rangs.location != NSNotFound?[url appendFormat:@"&back=1"]:[url appendFormat:@"?back=1"];
            NSString * urls = url;
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                
                NSDictionary * objc = [NSDictionary dictionaryWithObject:urls forKey:@"url"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHomeView" object:nil userInfo:objc];
            }];
        }
    }
    
}





- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


#pragma mark - 加载XML

- (void)loadXML
{
    // 0. 获取网络数据
    // 从web服务器直接加载数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"main_menu" ofType:@"xml"];
    NSData * data = [NSData dataWithContentsOfFile:filePath];
//        MyXMLParser *myParser = [[MyXMLParser alloc]init];
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // 1. 实例化解析器，传入要解析的数据
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    // 2. 设置代理
    [parser setDelegate:self];
    // 3. 解析器解析
    [parser parse];
}


/*
 XML解析的思路
 
 目前的资源：dataList记录表格中显示的数组，保存video对象。
 
 0. 数据初始化的工作，实例化dataList和第3步需要使用的全局字符串
 
 1. 如果在第2个方法中，elementName == video，会在attributeDict中包含videoId
 2. 如果在第2个方法中，elementName == video，需要实例化一个全局的video属性，
 记录2、3、4步骤中解析的当前视频信息对象
 3. 其他得属性会依次执行2、3、4方法，同时第3个方法有可能会被多次调用
 4. 在第3个方法中，需要拼接字符串——需要定义一个全局的属性记录中间的过程
 5. 在第4个方法中，可以通过第3个方法拼接的字符串获得elementName对应的内容
 可以设置全局video对象的elementName对应的数值
 6. 在第4个方法中，如果elementName == video，则将该对象插入self.dataList
 
 需要的准备工作
 1) 全局的字符串，记录每一个元素的完整内容
 2) 全局的video对象，记录当前正在解析的元素
 */

// 1. 解析文档
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
   
}

// 在整个XML文件解析完成之前，2、3、4方法会不断被循环调用
// 2. 开始解析一个元素，新的节点开始了
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"home_menu"]) {
        // 1. 实例化currentVideo
        self.currentVideo = [[LeftMenuModel alloc]init];
        
        // 2. 设置videoId
//        self.currentVideo.videoId = [attributeDict[@"videoId"]integerValue];
    }
    // 需要清空中转的字符串
    [self.elementString setString:@""];
}

// 3. 接收元素的数据（发现字符，因为元素内容过大，此方法可能会被重复调用，需要拼接数据）
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // 拼接字符串
    [self.elementString appendString:string];
}

// 4. 结束解析一个元素
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // 获得第3步拼接出来的字符串
    NSString *result = [NSString stringWithString:self.elementString];
    if ([elementName isEqualToString:@"menu_group"]) {
        self.currentVideo.menu_group = [result intValue];
    }else if ([elementName isEqualToString:@"menu_name"]) {
        self.currentVideo.menu_name = result;
    } else if ([elementName isEqualToString:@"menu_tag"]) {
        self.currentVideo.menu_tag = result;
    } else if ([elementName isEqualToString:@"menu_icon"]) {
        self.currentVideo.menu_icon = result;
    }  else if ([elementName isEqualToString:@"menu_url"]) {
        self.currentVideo.menu_url = result;
    } else if ([elementName isEqualToString:@"home_menu"]) {
        [self.dataList addObject:self.currentVideo];
    }
}

// 5. 解析文档结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // 清空临时数据
    self.currentVideo = nil;
    [self.elementString setString:@""];
    NSMutableArray * aaArray = [NSMutableArray array];
    for (int i = 0; i < self.dataList.count; i++) {
        if ([aaArray containsObject:self.dataList[i]] == NO) {
            [aaArray addObject:self.dataList[i]];
        }
    }
    self.dataList = aaArray;
    
    [self toGroupsByTime:aaArray];
    [self.tableView reloadData];
 }

// 6. 解析出错
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
   [self.elementString setString:@""];
}







#pragma mark topView

- (void)MyLoginViewToSwitchAccount:(MyLoginView *)view{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchAccount" object:nil];
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 未登陆返回并点击登录


- (void)backToTabbarAndGoLogin {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backAndGoLogin" object:nil];
        
    }];
}



@end
