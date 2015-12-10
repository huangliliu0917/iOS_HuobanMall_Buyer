//
//  IponeVerifyViewController.m
//  sdasdasdasd
//
//  Created by lhb on 15/12/8.
//  Copyright © 2015年 HT. All rights reserved.
//  手机验证码验证

#import "IponeVerifyViewController.h"
#import <UIView+BlocksKit.h>
@interface IponeVerifyViewController ()

/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;
/**验证码*/
@property (weak, nonatomic) IBOutlet UITextField *VerifyCode;
/**验证码*/
@property (weak, nonatomic) IBOutlet UILabel *VerifyLable;

@end

@implementation IponeVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    UIGestureRecognizer * ges = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(MinuteBack)];
//    [self.VerifyCode addGestureRecognizer:ges];
    
    [self.VerifyLable bk_whenTapped:^{
        NSLog(@"xxxxx"); 
    }];
}

/**
 *  手机验证码
 */
- (void)MinuteBack{
    
    
    NSLog(@"xxxxx");
}

/**
 *  点击登录按钮
 *
 *  @param sender <#sender description#>
 */
- (IBAction)loginActionClick:(id)sender {
    
    NSLog(@"xxxx");
}

@end
