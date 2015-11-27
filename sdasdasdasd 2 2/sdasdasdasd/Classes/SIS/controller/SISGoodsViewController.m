//
//  SISGoodsViewController.m
//  HuoBanMallBuy
//
//  Created by HuoTu-Mac on 15/10/31.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "SISGoodsViewController.h"
#import "UITableView+CJ.h"
#import "SISShopViewController.h"
#import "KxMenu.h"


@interface SISGoodsViewController ()

@end

@implementation SISGoodsViewController

static NSString *GoodCellIdent = @"SISGoodsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initTableView];
}

- (void)_initTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"SISGoodsCell" bundle:nil] forCellReuseIdentifier:GoodCellIdent];
    [self.tableView removeSpaces];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -tableView 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SISGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodCellIdent forIndexPath:indexPath];
    
    cell.more.tag = indexPath.row;
    
    [cell.more addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)moreButtonAction:(UIButton *) sender{
    
    SISGoodsCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    
    CGRect rc = [cell convertRect:cell.more.frame toView:self.view];
    
    if (self.segment.selectedSegmentIndex) {
        NSArray *menuItems =
        @[
          
          [KxMenuItem menuItem:@"推广"
                         image:nil
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"上架"
                         image:nil
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"删除"
                         image:nil
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"移到顶部"
                         image:nil
                        target:self
                        action:@selector(pushMenuItem:)],
          
          ];
        
        [KxMenu setTintColor:[UIColor colorWithWhite:0.945 alpha:1.000]];
        
        
        [KxMenu showMenuInView:self.view
                      fromRect:rc
                     menuItems:menuItems];
    }else {
        NSArray *menuItems =
        @[
          
          [KxMenuItem menuItem:@"推广"
                         image:nil
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"下架"
                         image:nil
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"删除"
                         image:nil
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"移到顶部"
                         image:nil
                        target:self
                        action:@selector(pushMenuItem:)],
          
          ];
        
        [KxMenu setTintColor:[UIColor colorWithWhite:0.945 alpha:1.000]];
        
        
        [KxMenu showMenuInView:self.view
                      fromRect:rc
                     menuItems:menuItems];
    }
  

}


- (void)pushMenuItem:(KxMenuItem *)sender {
    
    NSLog(@"%@", sender.title);
    if ([sender.title isEqualToString:@"下架"]) {
        NSLog(@"1");
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)groundingGoods:(id)sender {
    
    SISShopViewController * cc = [[SISShopViewController alloc] init];
    
    [self.navigationController pushViewController:cc animated:YES];
}
@end
