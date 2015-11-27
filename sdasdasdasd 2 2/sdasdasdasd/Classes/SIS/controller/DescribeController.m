//
//  DescribeController.m
//  HuoBanMall
//
//  Created by HuoTu-Mac on 15/8/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "DescribeController.h"
#import "SISBaseModel.h"
#import <SVProgressHUD.h>
#import <UIBarButtonItem+BlocksKit.h>
#import "UserLoginTool.h"


@interface DescribeController ()

@end

@implementation DescribeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.textAlignment = NSTextAlignmentLeft;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存" style:UIBarButtonItemStylePlain handler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textView.text = self.string;
    
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (self.textView.text.length != 0 && ![self.textView.text isEqualToString:self.string]) {
        dic[@"profiledata"] = self.textView.text;
        
        if ([self.title isEqualToString:@"店铺简介"]) {
            dic[@"profiletype"] = @"4";
        }else {
            dic[@"profiletype"] = @"3";
        }
        
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:SISUserInfo];
        
        SISBaseModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
        
        dic[@"sisid"] = model.sisId;
        
        dic = [NSDictionary asignWithMutableDictionary:dic];
        
        NSMutableString * url = [NSMutableString stringWithString:SISMainUrl];
        [url appendString:@"updateSisProfile"];
        [SVProgressHUD showWithStatus:@"数据上传中"];
        
        
        [UserLoginTool loginRequestGet:url parame:dic success:^(id json) {
            
            NSLog(@"%@",json);
            
            [SVProgressHUD dismiss];
            
            if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
                
                SISBaseModel *model = [SISBaseModel objectWithKeyValues:(json[@"resultData"][@"data"])];
                NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *fileName = [path stringByAppendingPathComponent:SISUserInfo];
                [NSKeyedArchiver archiveRootObject:model toFile:fileName];
                
            }
            
            
            
        } failure:^(NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络"];
            
        }];
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

@end
