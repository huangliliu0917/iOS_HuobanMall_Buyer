//
//  menuView.h
//  test
//
//  Created by 刘琛 on 15/11/26.
//  Copyright © 2015年 刘琛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemsViewDelegate <NSObject>

@optional
- (void) itemSelectClick:(UIButton *)btn;

@end

@interface menuView : UIView

@property (nonatomic, strong) NSArray *iteamArray;
@property(nonatomic,weak) id <ItemsViewDelegate> delegate;
@property (nonatomic, strong) UIColor *sliderColor;

//选中第几按钮
- (void)setButtonClickWithAction:(NSInteger) tag;

/**让建头恢复正常*/
- (void)SetTheArrowToRight;


@end
