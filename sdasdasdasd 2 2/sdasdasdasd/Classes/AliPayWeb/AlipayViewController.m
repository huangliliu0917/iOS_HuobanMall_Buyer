//
//  AlipayViewController.m
//  sdasdasdasd
//
//  Created by lhb on 16/11/9.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "AlipayViewController.h"

@interface AlipayViewController ()<UIWebViewDelegate>


@property(nonatomic,strong) UIWebView * web;

@end

@implementation AlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付宝支付";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIWebView * web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    web.delegate = self;
    self.view = web;
    NSURLRequest * rel = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.aliPayNewUrl]];
    [web loadRequest:rel];
//    [self.view addSubview:web];
  
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
