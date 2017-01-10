//
//  AppDelegate.h
//  sdasdasdasd
//
//  Created by lhb on 15/11/24.
//  Copyright © 2015年 HT. All rights reserved.
//
#import "HomeViewController.h"
#import "PushWebViewController.h"
#import <UIKit/UIKit.h>
#import "PayModel.h"





@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CALayer *maskLayer;

/**切换账号标志*/
@property (strong,nonatomic) NSString * SwitchAccount;

@property (nonatomic, strong) NSString *Agent;

@property (nonatomic, strong) NSString *userAgent;

@property (nonatomic, strong) NSDictionary *openNotifacation;

- (void)resetUserAgent:(NSString *) goUrl;

- (void)sendTokenAndUserIdToSevern;


@property (nonatomic, strong) NSArray <PayModel *> * payConfig;





@end

