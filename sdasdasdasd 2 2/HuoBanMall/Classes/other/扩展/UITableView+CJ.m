//
//  UITableView+CJ.m
//  minipartner
//
//  Created by Cai Jiang on 2/9/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "UITableView+CJ.h"

@implementation UITableView (CJ)

-(void)removeSpaces{
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)cleanSelection{
    [self selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

//- (void)setTabelViewListIsZero {
//    if (ScreenWidth < 375) {
//        if (ScreenHeight <= 480) {
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tpzw1"]];
//        }else {
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tpzw2"]];
//        }
//    }else if (ScreenWidth < 414) {
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tpzw3"]];
//    }else {
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tpzw4"]];
//    }
//}

- (void)setTableViewNormal {
    
    self.backgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.957 alpha:1.000];
}

@end
