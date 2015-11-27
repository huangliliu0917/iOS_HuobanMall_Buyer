//
//  SISGoodsCell.m
//  HuoBanMallBuy
//
//  Created by HuoTu-Mac on 15/10/31.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "SISGoodsCell.h"
#import <UIImageView+WebCache.h>

@implementation SISGoodsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.name.text = self.model.goodsName;
    [self.GoodImage sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl] placeholderImage:nil options:SDWebImageRetryFailed];
    
    self.detail.text = [NSString stringWithFormat:@"销售量:%@ 利润:¥%@/件", self.model.stock, self.model.profit];
    
    self.money.text = [NSString stringWithFormat:@"¥%@", self.model.profit];
    
    
}

@end
