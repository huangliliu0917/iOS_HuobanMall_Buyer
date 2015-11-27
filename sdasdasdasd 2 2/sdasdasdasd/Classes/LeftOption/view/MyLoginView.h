//
//  MyLoginView.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/10/10.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyLoginView;

@protocol MyLoginViewDelegate <NSObject>

@optional

- (void)MyLoginViewToSwitchAccount:(MyLoginView *)view;

@end


@interface MyLoginView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *firstLable;
@property (weak, nonatomic) IBOutlet UILabel *secondLable;
/**按钮view*/
@property (weak, nonatomic) IBOutlet UIView *myButton;

@property(weak,nonatomic) id <MyLoginViewDelegate> delegate;


@end
