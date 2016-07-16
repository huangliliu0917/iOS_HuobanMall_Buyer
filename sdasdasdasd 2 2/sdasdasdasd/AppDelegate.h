//
//  AppDelegate.h
//  sdasdasdasd
//
//  Created by lhb on 15/11/24.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CALayer *maskLayer;

/**切换账号标志*/
@property (strong,nonatomic) NSString * SwitchAccount;

@property (nonatomic, strong) NSString *Agent;
@end

