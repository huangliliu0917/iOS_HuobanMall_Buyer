//
//  SISWebViewController.h
//  HuoBanMallBuy
//
//  Created by 刘琛 on 15/11/9.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SISWebViewController : UIViewController

/**
 *  页面类型 1商品详细 2订单列表 3商品首页
 */
@property (nonatomic, assign) NSInteger type;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *updown;

@property (nonatomic, strong) NSString *goodUrl;

@property (nonatomic, assign) BOOL goodSelected;

@property (nonatomic, strong) NSString *goodId;

- (IBAction)updownAction:(id)sender;

@end
