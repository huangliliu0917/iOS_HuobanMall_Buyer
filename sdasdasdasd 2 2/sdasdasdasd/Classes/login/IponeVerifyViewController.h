//
//  IponeVerifyViewController.h
//  sdasdasdasd
//
//  Created by lhb on 15/12/8.
//  Copyright © 2015年 HT. All rights reserved.
//  手机验证码


#import <UIKit/UIKit.h>

@interface IponeVerifyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *login;

@property (weak, nonatomic) IBOutlet UIButton *weixinLogin;

@property (weak, nonatomic) IBOutlet UIButton *visiLogin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *visiCenter;

@property (nonatomic, assign) BOOL isPhoneLogin;

@property (nonatomic, assign) BOOL isBundlPhone;

@end
