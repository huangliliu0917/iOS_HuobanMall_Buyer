//
//  TemplateCell.h
//  HuoBanMallBuy
//
//  Created by 刘琛 on 15/11/24.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateModel.h"

@interface TemplateCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *select;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (nonatomic, strong) TemplateModel *model;

@end
