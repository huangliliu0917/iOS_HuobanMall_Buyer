//
//  SISAddGoodCell.h
//  HuoBanMallBuy
//
//  Created by 刘琛 on 15/11/16.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SISGoodModel.h"

@interface SISAddGoodCell : UITableViewCell

@property (nonatomic, strong) SISGoodModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *details;
@property (weak, nonatomic) IBOutlet UILabel *profits;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
