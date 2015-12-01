//
//  SISShopViewController.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/11/5.
//  Copyright © 2015年 HT. All rights reserved.
// sdas 

#import "SISShopViewController.h"
#import "ItemsView.h"
#import "RootViewController.h"
#import "ItemCollectionView.h"
#import "SISAddGoodCell.h"
#import "UserLoginTool.h"
#import "SISBaseModel.h"
#import "SISGoodModel.h"
#import "UITableView+CJ.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <UIBarButtonItem+BlocksKit.h>
#import "SISWebViewController.h"
#import "menuView.h"

@interface SISShopViewController ()<UITableViewDataSource,UITableViewDelegate,ItemsViewDelegate,ItemCollectionViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UITableView * showGoods;

@property(nonatomic,strong) UIView * itemView;

@property(nonatomic,strong) menuView * headtitleView;

@property(nonatomic,strong) NSMutableArray * topTitles;

@property(nonatomic,strong) UITableView * tableView;

@property (nonatomic, strong) SISBaseModel *user;

//保存选中的搜索id
@property (nonatomic, strong) NSString *categoryid;

//保存页码
@property (nonatomic, strong) NSString *rpageno;

//商品列表数据
@property (nonatomic, strong) NSMutableArray *goodsArray;

//选中的一级菜单
@property (nonatomic, assign) NSInteger selectButton;

/**
 *  搜索保存数据
 */
@property (nonatomic, strong) NSString *searchStr;

/**搜索栏*/
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIView *searchBgView;

@end

@implementation SISShopViewController

static NSString *addCellIdentify = @"addCell";

- (NSArray *)topTitles{
    
    if (_topTitles == nil) {
        
        _topTitles = [NSMutableArray array];
        [_topTitles addObject:@"全部"];
        for (SISCategory *cate in self.categroyArray) {
            [_topTitles addObject:cate.sisName];
        }
    }
    
    return _topTitles;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    self.title = @"市场选购";
    
    self.view.backgroundColor = [UIColor whiteColor];

    menuView * view = [[menuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    view.delegate = self;
    view.sliderColor = HuoBanMallBuyNavColor;
    view.iteamArray = self.topTitles;
    _headtitleView = view;
    [self.view addSubview:view];
 
    UITableView * tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44 - 64) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    _tableView = tableView;
    [self.tableView registerNib:[UINib nibWithNibName:@"SISAddGoodCell" bundle:nil] forCellReuseIdentifier:addCellIdentify];
    [self setupRefresh];
    [self.tableView removeSpaces];
    [self.view addSubview:tableView];
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:SISUserInfo];
    self.user = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    
    self.rpageno = [NSString string];
    self.categoryid = @"0";
    self.goodsArray = [NSMutableArray array];
    self.selectButton = 0;
    
    [self _initNavSearchBar];
}

- (void)_initNavSearchBar {
    
    self.searchStr = [NSString string];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(8, 0, ScreenWidth - 10, 44)];
    [[[[self.searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    //    [self.searchBar setBarTintColor:[UIColor whiteColor]];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.tintColor = [UIColor blackColor];
    self.searchBar.delegate = self;
    self.searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    self.searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    self.searchBgView.backgroundColor = HuoBanMallBuyNavColor;
    self.searchBgView.userInteractionEnabled = YES;
    [self.searchBgView addSubview:self.searchBar];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"搜索" style:UIBarButtonItemStylePlain handler:^(id sender) {
        
        //        self.navigationItem.leftBarButtonItem = nil;
        
        [self.navigationController.navigationBar addSubview:self.searchBgView
         ];
        
        
        [self.searchBar becomeFirstResponder];
        
//        [self.tableView removeHeader];
        
    }];
}



- (void)setupRefresh
{
    
    MJRefreshNormalHeader * headRe = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewGoods)];
    self.tableView.mj_header = headRe;
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(getNewData)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    //    [self.tableView headerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    //    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    //    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    //    self.tableView.headerRefreshingText = @"正在刷新最新数据,请稍等";
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    
    MJRefreshAutoNormalFooter * Footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreGoodList)];
    self.tableView.mj_footer = Footer;
    
    
//    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.tableView addHeaderWithTarget:self action:@selector(getNewGoods)];
//    //#warning 自动刷新(一进入程序就下拉刷新)
//    //    [self.tableView headerBeginRefreshing];
//    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
//    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
//    self.tableView.headerRefreshingText = @"正在刷新最新数据,请稍等";
//    
//    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tableView addFooterWithTarget:self action:@selector(getMoreGoodList)];
//    
//    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
//    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
//    self.tableView.footerRefreshingText = @"正在加载更多数据,请稍等";
    
}

- (void)getNewGoods {
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    
    parame[@"userid"] = self.user.userId;
    parame[@"rpageno"] = @"0";
    parame[@"categoryid"] = self.categoryid;
    parame[@"key"] = self.searchStr;
    
    
    NSMutableString * url = [NSMutableString stringWithString:SISMainUrl];
    [url appendString:@"searchGoodsList"];
    
    parame = [NSDictionary asignWithMutableDictionary:parame];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        NSLog(@"%@", json);
        
        [SVProgressHUD dismiss];
//        [self.tableView headerEndRefreshing];
        
        if ([json[@"systemResultCode"] intValue] ==1&&[json[@"resultCode"] intValue] == 1) {
            [self.goodsArray removeAllObjects];
            
            NSArray *array = [SISGoodModel objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
            self.rpageno = json[@"resultData"][@"rpageno"];
            [self.goodsArray addObjectsFromArray:array];
            
            [self.tableView reloadData];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.mj_header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络"];
        NSLog(@"%@", error);
    }];
}

- (void)getMoreGoodList {
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    
    parame[@"userid"] = self.user.userId;
    parame[@"rpageno"] = [NSString stringWithFormat:@"%@", self.rpageno ];
    parame[@"categoryid"] = self.categoryid;
    parame[@"key"] = self.searchStr;
    
    NSMutableString * url = [NSMutableString stringWithString:SISMainUrl];
    [url appendString:@"searchGoodsList"];
    
    parame = [NSDictionary asignWithMutableDictionary:parame];
    
    
    
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        NSLog(@"%@", json);
        
//        [self.tableView footerEndRefreshing];
        
        
        if ([json[@"systemResultCode"] intValue] ==1&&[json[@"resultCode"] intValue] == 1) {
            
            NSArray *array = [SISGoodModel objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
            self.rpageno = json[@"resultData"][@"rpageno"];
            
            NSMutableArray *temp = [NSMutableArray arrayWithArray:array];
            
            for (SISGoodModel *good1 in array) {
                for (SISGoodModel *goodTemp in self.goodsArray) {
                    if ([good1.goodsId isEqualToString:goodTemp.goodsId]) {
                        [temp removeObject:good1];
                    }
                }
            }
            
            
            
            [self.goodsArray addObjectsFromArray:temp];
            
            [self.tableView reloadData];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络"];
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getNewGoods];
}



#pragma 滑动条点击
- (void)itemSelectClick:(UIButton *)btn{
    __weak SISShopViewController * wself = self;
    if (btn.tag == 1000) {
        NSLog(@"close");
        [_itemView removeFromSuperview];
    }else if (btn.tag == 2000) {
//        if (self.selectButton != 0) {
            NSLog(@"open");
            
            CGFloat ittemX = 0;
            CGFloat ittemY = 44;
            CGFloat ittemW = self.view.frame.size.width;
            CGFloat ittemH = 200;
            ItemCollectionView * itemView = [[ItemCollectionView alloc] initWithFrame:CGRectMake(ittemX, ittemY, ittemW, ittemH)];
            itemView.delegate = self;
            if (_selectButton == 0) {
                itemView.items = _topTitles;
            }else {
                SISCategory *model = self.categroyArray[_selectButton - 1];
                NSMutableArray *temp = [NSMutableArray array];
                for (SISSecondCategory *str  in model.list) {
                    [temp addObject:str.sisName];
                }
                if (temp.count != 0) {
                    itemView.items = temp;
                }
                
            }
            CGFloat chittemH = (itemView.items.count / 4 + 1) * 30;
            if (itemView.items.count % 4 == 0) {
                chittemH -= 30;
            }
            itemView.frame = CGRectMake(ittemX, ittemY, ittemW, chittemH);
            itemView.backgroundColor = [UIColor grayColor];
            [self.view insertSubview:itemView belowSubview:self.view];
            _itemView = itemView;
            
            [UIView animateWithDuration:0.7 animations:^{
                [wself.view bringSubviewToFront:wself.view];
            }];
//        }
    }
//    else if (btn.tag == 0 || btn.tag == 10000){
//        [self.itemView removeFromSuperview];
//        [self.headtitleView SetTheArrowToRight];
//        self.selectButton = 0;
//        self.categoryid = 0;
//        [self getNewGoods];
//        
//        
//    }
    else{
        
        [self.itemView removeFromSuperview];
        
        [self.headtitleView SetTheArrowToRight];
        
        SISCategory *model = self.categroyArray[btn.tag];
        self.categoryid = model.sisId;
        self.selectButton = btn.tag;
        
        [self getNewGoods];
        
    }

    NSLog(@"%ld",(long)btn.tag);
}
#pragma mark 二级分离选择
- (void)SecondLevelclassify:(NSIndexPath *) indexPath{
    
    NSLog(@"xxx");
    [self.headtitleView SetTheArrowToRight];
    [_itemView removeFromSuperview];
    
    if (self.selectButton == 0) {
        if (indexPath.row == 0) {
            self.categoryid = @"0";
        }else {
            SISCategory *model = self.categroyArray[indexPath.row - 1];
            self.categoryid = model.sisId;
            self.selectButton = indexPath.row - 1;
            [self.headtitleView setButtonClickWithAction:indexPath.row];
        }
    }else {
        SISCategory *model = self.categroyArray[self.selectButton];
        SISSecondCategory *model1 = model.list[indexPath.row];
        self.categoryid = model1.sisId;
        
    }
    NSLog(@"%@",self.categoryid);
    
    [self getNewGoods];
   
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.goodsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SISAddGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:addCellIdentify forIndexPath:indexPath];
    
    cell.model = self.goodsArray[indexPath.row];
    
    cell.button.tag = 10000 + indexPath.row;
    
    if (cell.model.goodSelected) {
        cell.button.hidden = YES;
    }else {
        cell.button.hidden = NO;
        [cell.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchStr = @"";
    
    self.searchBar.text = nil;
    
    [self.searchBar resignFirstResponder];
    
    [self.searchBgView removeFromSuperview];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SISGoodModel *model = self.goodsArray[indexPath.row];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SISWebViewController *web = [story instantiateViewControllerWithIdentifier:@"SISWebViewController"];
    web.type = 1;
    web.goodUrl = model.detailsUrl;
    web.goodId = model.goodsId;
    web.goodSelected = model.goodSelected;
    
    [self.navigationController pushViewController:web animated:YES];
}

- (void)buttonAction:(UIButton *) button {
    
    SISGoodModel *model = self.goodsArray[button.tag -10000];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    
    parame[@"userid"] = self.user.userId;
    parame[@"goodsid"] = model.goodsId;
    parame[@"opertype"] = @"1";
    
    
    NSMutableString * url = [NSMutableString stringWithString:SISMainUrl];
    [url appendString:@"operGoods"];
    [UserLoginTool loginRequestPost:url parame:parame success:^(id json) {
        if ([json[@"systemResultCode"] intValue] ==1&&[json[@"resultCode"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"上架成功"];
            button.hidden = YES;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}
#pragma mark searchbar

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchStr = @"";
    
    self.searchBar.text = nil;
    
    [self.searchBar resignFirstResponder];
    
    [self.searchBgView removeFromSuperview];
    
    
    MJRefreshNormalHeader * headRe = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewGoods)];
    self.tableView.mj_header = headRe;

//    [self.tableView addHeaderWithTarget:self action:@selector(getNewGoods)];
    
    [self getNewGoods];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    if (searchBar.text.length < 6) {
//        [SVProgressHUD showErrorWithStatus:@"请输入至少6位订单号"];
//    }else {
    
        self.searchStr = self.searchBar.text;
        
        [self getNewGoods];
//    }
}


@end
