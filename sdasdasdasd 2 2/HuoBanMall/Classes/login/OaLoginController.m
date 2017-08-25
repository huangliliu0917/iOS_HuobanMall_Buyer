//
//  OaLoginController.m
//  HuoBanMall
//
//  Created by lhb on 2017/8/25.
//  Copyright © 2017年 HT. All rights reserved.
//

#import "OaLoginController.h"

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
}

/**
 * 找回密码
 **/
- (IBAction)backPass:(id)sender {
}

/**
 * 登录
 **/
- (IBAction)login:(id)sender {
}


/**
 * 登录
 **/
- (IBAction)haveOA:(id)sender {
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
