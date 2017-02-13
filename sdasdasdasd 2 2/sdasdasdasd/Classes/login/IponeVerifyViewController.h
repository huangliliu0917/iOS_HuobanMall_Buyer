//
//  IponeVerifyViewController.h
//  sdasdasdasd
//
//  Created by lhb on 15/12/8.
//  Copyright © 2015年 HT. All rights reserved.
//  手机验证码


#import <UIKit/UIKit.h>
@class  UserInfo;

@interface IponeVerifyViewController : UIViewController



@property (nonatomic, assign) BOOL isPhoneLogin;

@property (nonatomic, assign) BOOL isBundlPhone;


@property (nonatomic, strong) NSString *goUrl;


@property (nonatomic, strong) UserInfo * userInfo;
@end
