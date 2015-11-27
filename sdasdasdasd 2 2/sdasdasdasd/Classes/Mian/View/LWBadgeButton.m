//
//  LWBadgeButton.m
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-3.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import "LWBadgeButton.h"

@implementation LWBadgeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.hidden = YES;
//        [self setBackgroundImage:[UIImage resizedWithName:@"main_badge"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}


- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = [badgeValue copy];
    
    if (badgeValue&& [badgeValue intValue]!=0) {
        
        self.hidden = NO;
        [self setTitle:badgeValue forState:UIControlStateNormal];
        
        
        //设置提示文字的frame
        
        CGRect fram = self.frame;
        CGFloat badgeH = self.currentBackgroundImage.size.height;
        CGFloat badgeW = self.currentBackgroundImage.size.width;
        
        if (badgeValue.length>1) {
            CGSize badgeSize = [badgeValue sizeWithFont:self.titleLabel.font];
            badgeW = badgeSize.width+10;
        }
        
        fram.size.width  = badgeW;
        fram.size.height = badgeH;
        self.frame = fram;
    }
    else{
        self.hidden = YES;
    }
}

@end
