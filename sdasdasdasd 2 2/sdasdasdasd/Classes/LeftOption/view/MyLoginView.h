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
@property (weak, nonatomic) IBOutlet UILabel *secondLable1;
@property (strong, nonatomic) IBOutlet UILabel *secondLable2;
@property (strong, nonatomic) IBOutlet UILabel *secondLable3;
/**按钮view*/
@property (weak, nonatomic) IBOutlet UIView *myButton;
/**头像背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property(weak,nonatomic) id <MyLoginViewDelegate> delegate;


@end
