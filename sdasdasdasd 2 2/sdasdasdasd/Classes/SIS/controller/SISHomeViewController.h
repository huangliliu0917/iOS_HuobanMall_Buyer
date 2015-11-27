//
//  SISHomeViewController.h
//  HuoBanMallBuy
//
//  Created by HuoTu-Mac on 15/10/31.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SISHomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headView;
/***logo 图片**/
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
/** 店名 **/
@property (weak, nonatomic) IBOutlet UILabel *SISName;
/** 店铺二维码 **/
@property (weak, nonatomic) IBOutlet UIImageView *QRCode;
/**
 *  店铺管理
 */
@property (weak, nonatomic) IBOutlet UIButton *storeManagement;

/**
 *  销售中
 */
@property (weak, nonatomic) IBOutlet UIView *sale;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;


/**
 *  已下架
 */
@property (weak, nonatomic) IBOutlet UIView *shelves;

@property (weak, nonatomic) IBOutlet UILabel *shelvesLabel;
/**
 *  滑动视图背景
 */
@property (weak, nonatomic) IBOutlet UIView *bgView;

/**
 *  店铺管理事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)storeManagementAction:(id)sender;

@end
