//
//  ItemsView.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/11/10.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ItemsViewDelegate <NSObject>

@optional
- (void) itemSelectClick:(UIButton *)btn;

@end

@interface ItemsView : UIView

/**条目数*/
@property(nonatomic,strong) NSArray * items;
@property(nonatomic,weak) id <ItemsViewDelegate> delegate;


/**让建头恢复正常*/
- (void)SetTheArrowToRight;

@end
