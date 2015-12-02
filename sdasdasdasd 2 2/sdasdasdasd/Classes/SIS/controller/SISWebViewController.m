//
//  SISWebViewController.m
//  HuoBanMallBuy
//
//  Created by 刘琛 on 15/11/9.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "SISWebViewController.h"
#import "SISBaseModel.h"
#import "UserLoginTool.h"
#import <SVProgressHUD.h>

@interface SISWebViewController ()<UIWebViewDelegate>

@end

@implementation SISWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    if (self.type == 1) {
        //商品详细
        self.title  = @"商品详情";
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.goodUrl]];
        
        [self.webView loadRequest:request];
        
        if (self.goodSelected) {
            [self.updown setTitle:@"下架" forState:UIControlStateNormal];
            self.updown.backgroundColor = [UIColor lightGrayColor];
        }
        
    }else if (self.type == 2) {
        // 订单详情
        self.title = @"订单详情";
        self.updown.hidden = YES;
    }else if (self.type == 3) {
        self.title = @"首页";
        self.updown.hidden = YES;
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updownAction:(id)sender {
    
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:SISUserInfo];
    SISBaseModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    
    parame[@"userid"] = user.userId;
    parame[@"goodsid"] = [NSString stringWithFormat:@"%@",self.goodId];
    
    
    if ([self.updown.titleLabel.text isEqualToString:@"上架"]) {
        parame[@"opertype"] = @"1";
    }else if ([self.updown.titleLabel.text isEqualToString:@"下架"]) {
        parame[@"opertype"] = @"0";
    }
    NSMutableString * url = [NSMutableString stringWithString:SISMainUrl];
    [url appendString:@"operGoods"];
    [SVProgressHUD showWithStatus:nil];
    [UserLoginTool loginRequestPost:url parame:parame success:^(id json) {
        if ([json[@"systemResultCode"] intValue] ==1&&[json[@"resultCode"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"上架成功"];
            self.updown.backgroundColor = [UIColor lightGrayColor];
            self.updown.userInteractionEnabled  = NO;
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", error);
    }];
}
@end
