//
//  MallTabbarViewController.m
//  sdasdasdasd
//
//  Created by 刘琛 on 16/9/13.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "MallTabbarViewController.h"
#import "PushWebViewController.h"
#import "LWNavigationController.h"

@interface MallTabbarViewController ()

@end

@implementation MallTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.barTintColor = HuoBanMallBuyNavColor;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CannelLoginBackToHome) name:@"CannelLoginBackHome" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeftbackToHome:) name:@"backToHomeView" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)CannelLoginBackToHome {
    
    [self setSelectedIndex:0];
}


- (void)LeftbackToHome:(NSNotification *) note{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backToHomeView" object:nil];
    
    NSString * backUrl = [note.userInfo objectForKey:@"url"];
    if (backUrl) {
        
        
        LWNavigationController *nav = self.childViewControllers[self.selectedIndex];
        
        PushWebViewController *push = [[PushWebViewController alloc] init];
        push.funUrl=backUrl;
        [nav pushViewController:push animated:YES];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeftbackToHome:) name:@"backToHomeView" object:nil];
    }else {
        [self CannelLoginBackToHome];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeftbackToHome:) name:@"backToHomeView" object:nil];
    }
}


@end
