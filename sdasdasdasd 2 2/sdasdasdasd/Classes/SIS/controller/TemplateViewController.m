//
//  TemplateViewController.m
//  HuoBanMallBuy
//
//  Created by 刘琛 on 15/11/24.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "TemplateViewController.h"
#import <SVProgressHUD.h>
#import "UserLoginTool.h"
#import "SISBaseModel.h"
#import "TemplateModel.h"
#import "TemplateCell.h"


@interface TemplateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) SISBaseModel *model;

@property (nonatomic, strong) NSMutableArray *showArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSNumber *templateid;

@property (nonatomic, strong) NSNumber *selectTemplate;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation TemplateViewController

static NSString *templateIdentify = @"templateCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"模版选择";
    
    self.showArray = [NSMutableArray array];
    
    
    HMLineLayout *layout = [[HMLineLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) collectionViewLayout: layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TemplateCell" bundle:nil] forCellWithReuseIdentifier:templateIdentify];
    [self.view addSubview:self.collectionView];
    
}

- (SISBaseModel *)model {
    if (_model==nil) {
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:SISUserInfo];
        _model = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    }
    return _model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getTemplateList];
    
}

- (void)getTemplateList {
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"sisid"] = self.model.sisId;
    
    
    parame = [NSDictionary asignWithMutableDictionary:parame];
    NSMutableString * url = [NSMutableString stringWithString:SISMainUrl];
    [url appendString:@"getTemplateList"];
    
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            NSArray *array = [TemplateModel objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
            
            [self.showArray addObjectsFromArray:array];
            
            [self.collectionView reloadData];
            
            self.templateid = json[@"resultData"][@"templateid"];
            self.selectTemplate = self.templateid;
        }
        

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络"];
        NSLog(@"%@",error);
        
    }];
}


#pragma mark collectdelegete

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TemplateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:templateIdentify forIndexPath:indexPath];
    
    cell.model = self.showArray[indexPath.row];
    
    if (cell.model.tid == self.selectTemplate) {
        self.selectIndexPath = indexPath;
        cell.select.hidden = NO;
    }else {
        cell.select.hidden = YES;
    }
    
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.showArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndexPath != indexPath) {
        TemplateCell *cell = (TemplateCell *)[collectionView cellForItemAtIndexPath:indexPath];
        self.selectTemplate = cell.model.tid;
        cell.select.hidden = NO;
        
        TemplateCell *cell1 = (TemplateCell *)[collectionView cellForItemAtIndexPath:self.selectIndexPath];
        cell1.select.hidden = YES;
        self.selectIndexPath = indexPath;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.selectTemplate !=  self.templateid) {
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"sisid"] = self.model.sisId;
        parame[@"templateid"] = [NSString stringWithFormat:@"%@", self.selectTemplate];
        
        parame = [NSDictionary asignWithMutableDictionary:parame];
        NSMutableString * url = [NSMutableString stringWithString:SISMainUrl];
        [url appendString:@"updateTemplate"];
        
        
        [SVProgressHUD showWithStatus:@"数据上传中"];
        [UserLoginTool loginRequestGet:url parame:parame success:^(id json) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",json);
            if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
                
                [SVProgressHUD showSuccessWithStatus:@"修改模版成功"];
            }
            
            
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络"];
            NSLog(@"%@",error);
            
        }];
    }

}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
