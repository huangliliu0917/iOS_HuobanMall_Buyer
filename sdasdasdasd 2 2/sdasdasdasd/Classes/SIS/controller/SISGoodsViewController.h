//
//  SISGoodsViewController.h
//  HuoBanMallBuy
//
//  Created by HuoTu-Mac on 15/10/31.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SISGoodsCell.h"

@interface SISGoodsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

- (IBAction)groundingGoods:(id)sender;

@end