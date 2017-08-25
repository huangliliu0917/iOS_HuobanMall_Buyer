//
//  UIViewController+MonitorNetWork.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface UIViewController (MonitorNetWork)

/**
 *  检查网络
 */
+ (void)MonitorNetWork;




/**
 *  清除沙盒数据
 */
+ (void)ToRemoveSandBoxDate;
@end
