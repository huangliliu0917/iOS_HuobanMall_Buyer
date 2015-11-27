//
//  CollectionViewCell.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/11/5.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *item;

@end


@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.item.layer.borderWidth = 0.5;
    _item.adjustsFontSizeToFitWidth = YES;
}


- (void)setItemTitle:(NSString *)itemTitle{
    _itemTitle = itemTitle;
    [_item setText:itemTitle];
}
@end
