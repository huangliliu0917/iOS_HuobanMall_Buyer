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


/**是否只有手机登录*/
@property (nonatomic, assign) BOOL isPhoneLogin;


/**是否是绑定手机*/
@property (nonatomic, assign) BOOL isBundlPhone;

/**登录成功后要去的地址*/
@property (nonatomic, strong) NSString *goUrl;


/**新方式去登录需要的信息*/
@property (nonatomic, strong) UserInfo * userInfo;

@end
