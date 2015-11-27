//
//  SISGoodsCell.h
//  HuoBanMallBuy
//
//  Created by HuoTu-Mac on 15/10/31.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SISGoodModel.h"

@interface SISGoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *money;


@property (weak, nonatomic) IBOutlet UIButton *more;

@property (weak, nonatomic) IBOutlet UIView *moreView;

@property (weak, nonatomic) IBOutlet UIImageView *GoodImage;

@property (nonatomic, strong) SISGoodModel *model;

@end
