//
//  TemplateCell.m
//  HuoBanMallBuy
//
//  Created by 刘琛 on 15/11/24.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "TemplateCell.h"
#import <UIImageView+WebCache.h>

@implementation TemplateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:self.model.pictureUrl] placeholderImage:nil options:SDWebImageRetryFailed];
}


@end
