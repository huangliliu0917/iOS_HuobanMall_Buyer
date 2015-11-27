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
    
    self.secondLable.adjustsFontSizeToFitWidth = YES;
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    
}

- (IBAction)SwitchAccount:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(MyLoginViewToSwitchAccount:)]) {
        
        [self.delegate MyLoginViewToSwitchAccount:self];
    }
}


@end
