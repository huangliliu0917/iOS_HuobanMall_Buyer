//
//  UITableView+CJ.h
//  minipartner
//
//  Created by Cai Jiang on 2/9/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CJ)


/**
 *  移除多余的空栏
 */
-(void)removeSpaces;

/**
 *  清空选择
 */
-(void)cleanSelection;

/**
 *  设置空表图片
 */
//- (void)setTabelViewListIsZero;

/**
 *  设置正常背景
 */
- (void)setTableViewNormal;

@end
