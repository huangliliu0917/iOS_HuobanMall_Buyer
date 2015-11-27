//
//  ItemCollectionView.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/11/12.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemCollectionViewDelegate <NSObject>

@optional

/**
 *  二级分类选择
 */
- (void)SecondLevelclassify:(NSIndexPath *) indexPath;

@end

@interface ItemCollectionView : UIView

@property(nonatomic,strong) NSArray * items;


@property(nonatomic,weak) id<ItemCollectionViewDelegate>delegate;

@end
