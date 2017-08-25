//
//  MallTabbarViewController.m
//  HuoBanMall
//
//  Created by 刘琛 on 16/9/13.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "MallTabbarViewController.h"
#import "PushWebViewController.h"
#import "LWNavigationController.h"
#import "HomeViewController.h"

@interface MallTabbarViewController ()

@end

@implementation MallTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.alpha = 0;
    
//    self.navigationController.navigationBar.barTintColor = HuoBanMallBuyNavColor;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CannelLoginBackToHome) name:@"CannelLoginBackHome" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeftbackToHome:) name:@"backToHomeView" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)CannelLoginBackToHome {
    LWNavigationController *nav = self.childViewControllers[self.selectedIndex];
    [self setSelectedIndex:self.HomePage];
    [nav popToRootViewControllerAnimated:YES];
}



- (void)LeftbackToHome:(NSNotification *) note{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backToHomeView" object:nil];
    
    NSString * backUrl = [note.userInfo objectForKey:@"url"];
    if (backUrl) {
        
        
        LWNavigationController *nav = self.childViewControllers[self.selectedIndex];
        
        TabBarModel *model = self.tabbarArray[self.selectedIndex];

        LWLog(@"%@",model.linkUrl);
        NSString *compareUrl = [NSString stringWithFormat:@"%@%@", [[NSUserDefaults standardUserDefaults] objectForKey:AppMainUrl], model.linkUrl];
        
        if ([backUrl.lowercaseString rangeOfString:compareUrl.lowercaseString].location != NSNotFound) {
            
            HomeViewController *home = nav.viewControllers[0];
            NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:backUrl]];
            [home.homeWebView loadRequest:req];
        }else {
        
            PushWebViewController *push = [[PushWebViewController alloc] init];
            push.funUrl=backUrl;
            [nav pushViewController:push animated:YES];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeftbackToHome:) name:@"backToHomeView" object:nil];
    }else {
        [self CannelLoginBackToHome];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeftbackToHome:) name:@"backToHomeView" object:nil];
    }
}


@end
