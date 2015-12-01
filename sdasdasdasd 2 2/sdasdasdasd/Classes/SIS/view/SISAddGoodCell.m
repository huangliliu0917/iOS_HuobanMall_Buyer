//
//  SISAddGoodCell.m
//  HuoBanMallBuy
//
//  Created by 刘琛 on 15/11/16.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "SISAddGoodCell.h"
#import <UIImageView+WebCache.h>

@implementation SISAddGoodCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.button.layer.borderWidth = 1;
    self.button.layer.borderColor = [UIColor colorWithRed:1.000 green:0.239 blue:0.000 alpha:1.000].CGColor;
    self.button.layer.cornerRadius = 5;
    
    self.title.text = self.model.goodsName;
    [self.image sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl] placeholderImage:nil options:SDWebImageRetryFailed];
    
    self.details.text = [NSString stringWithFormat:@"库存:%@ 返利:%@", self.model.stock, self.model.rebate];
    
    self.profits.text = [NSString stringWithFormat:@"¥%@", self.model.profit];
}


@end
