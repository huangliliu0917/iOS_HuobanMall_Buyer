//
//  MyLoginView.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "MyLoginView.h"

#import <UIView+BlocksKit.h>
@interface MyLoginView()

/**切换账号*/
- (IBAction)SwitchAccount:(id)sender;

@end



@implementation MyLoginView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.secondLable1.adjustsFontSizeToFitWidth = YES;
    self.secondLable2.adjustsFontSizeToFitWidth = YES;
    self.secondLable3.adjustsFontSizeToFitWidth = YES;
//    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.secondLable1 setTextColor:HuoBanMallBuyNavColor];
    [self.secondLable2 setTextColor:HuoBanMallBuyNavColor];
    [self.secondLable3 setTextColor:HuoBanMallBuyNavColor];
    
//    NSString * color = [NSString stringWithFormat:@"%@",HuoBanMallBuyNavColor];
    
    
    if(CGColorEqualToColor(HuoBanMallBuyNavColor.CGColor,[UIColor whiteColor].CGColor)){
        self.secondLable1.backgroundColor = [UIColor blackColor];
        self.secondLable2.backgroundColor = [UIColor blackColor];
        self.secondLable3.backgroundColor = [UIColor blackColor];
        
        self.firstLable.textColor = [UIColor blackColor];
    }
    
    
    if(NaVColor){
        self.backImage.alpha = 1;
    }else{
        self.backImage.alpha = 0;
    }
    
    
}

- (IBAction)SwitchAccount:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(MyLoginViewToSwitchAccount:)]) {
        
        [self.delegate MyLoginViewToSwitchAccount:self];
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height * 0.5;
    self.iconView.layer.masksToBounds = YES;
}

@end
