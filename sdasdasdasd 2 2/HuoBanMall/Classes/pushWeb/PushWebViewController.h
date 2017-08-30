//
//  PushWebViewController.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/9.
//  Copyright (c) 2015年 HT. All rights reserved.
//  跳转的网页页面

#import <UIKit/UIKit.h>

@interface PushWebViewController : UIViewController

/***/
@property(nonatomic,strong) NSString * funUrl;


// 1 表示来自云品星球
@property(nonatomic,assign) int fromType;
@end
