//
//  LWNavigationController.m
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-3.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import "LWNavigationController.h"
#import "UIBarButtonItem+LHB.h"
#define KEY_WINDOW          [[UIApplication sharedApplication] keyWindow]
#define TOP_VIEW            KEY_WINDOW.rootViewController.view
#define kMaxDistanceY       80 //右滑手势的纵坐标最大移动距离
#define kAnimateDuration    .3f

@interface LWNavigationController ()<UIGestureRecognizerDelegate>
{
@private
    CGPoint startPoint;
    BOOL isCanceled;//是否取消滑动返回操作
}

@property (nonatomic, strong)UIView *animationView;
@property (nonatomic, strong)UIImageView *foreImageView;
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIPanGestureRecognizer *swipeBackGesture;
@property (nonatomic, assign)BOOL shouldSwipeBack;//设置是否允许右滑返回操作，默认为NO


@end

@implementation LWNavigationController

/**
 *  一个类初始化时会调用一次
 */
+ (void)initialize
{
    //1、设置导航栏的主题
    [self setupNavBarTheme];
    
    //2、设置导航栏的按钮主题
    [self setupNavBarButtonItemTheme];
}

+ (void)setupNavBarButtonItemTheme
{
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(ScreenWidth, ScreenHeight)
                                                         forBarMetrics:UIBarMetricsDefault];
//    UIBarButtonItem * item = [UIBarButtonItem appearance];
//    if (!iOS7) {
//        
//        [item setBackButtonBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackButtonBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_push"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//        
//        [item setBackButtonBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_disable"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
//    }
    
    
////    //设置文字
//    NSMutableDictionary * textAttr = [NSMutableDictionary dictionary];
//    textAttr[UITextAttributeTextColor] = iOS7?[UIColor orangeColor]:[UIColor grayColor];
//    //取消阴影
//    textAttr[UITextAttributeTextShadowOffset]=[NSValue valueWithUIOffset:UIOffsetZero];
//    textAttr[UITextAttributeFont] = [UIFont systemFontOfSize:15];
//
//    [item setTitleTextAttributes:textAttr forState:UIControlStateNormal];
//    [item setTitleTextAttributes:textAttr forState:UIControlStateHighlighted];
//    
//    NSMutableDictionary * disabletextAttr = [NSMutableDictionary dictionary];
//    disabletextAttr[UITextAttributeTextColor] = [UIColor grayColor];
//    [item setTitleTextAttributes:disabletextAttr forState:UIControlStateDisabled];
}
/**
 *  设置导航栏的主题
 */
+ (void)setupNavBarTheme
{
    //取出appeace对象,就能改导航栏的样式了
    UINavigationBar * NavBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
//    NavBar. = [UIColor redColor];
    [NavBar setTintColor:BottomTaBarButtonTitleColor];
    
    if (IsIos8) {
        [NavBar setTranslucent:NO];
    }
    

    [NavBar setBarTintColor:HuoBanMallBuyNavColor];
//    //设置标题样式
    NSMutableDictionary * textAttr = [NSMutableDictionary dictionary];
    textAttr[NSForegroundColorAttributeName] = TopNavTitleViewTitleColor;
    [NavBar setTitleTextAttributes:textAttr];
//    //取消阴影
//    textAttr[NSBaselineOffsetAttributeName]=[NSValue valueWithUIOffset:UIOffsetZero];
//    textAttr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:19];
    
    NavBar.barTintColor = TopNavTitleViewTitleColor;
    NavBar.tintColor = TopNavTitleViewTitleColor;
    [NavBar setTitleTextAttributes:@{NSForegroundColorAttributeName : TopNavTitleViewTitleColor}];
//    if (IsIos9) {
//        
//    }else{
//        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
//    [UIApplication sharedApplication] setStatusBar
}

- (void)viewDidLoad{
    [super viewDidLoad];
//    
    id target = self.interactivePopGestureRecognizer.delegate;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target  action:@selector(handleNavigationTransition:)];
//
    
    
    pan.delegate =self;
    self.interactivePopGestureRecognizer.enabled = NO;
    [self.view addGestureRecognizer:pan];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self addAnimationView];
    
}
//添加返回动画视图
- (void)addAnimationView{
    if (self.animationView) {
        return;
    }
    CGRect rect = KEY_WINDOW.bounds;
    self.animationView = [[UIView alloc] initWithFrame:rect];
    self.animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CGRect rect1 = rect;
    rect1.origin.x = - rect.size.width;
    self.backImageView = [[UIImageView alloc] initWithFrame:rect1];
    self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.animationView addSubview:self.backImageView];
    
    CGRect rect2 = rect;
    self.foreImageView = [[UIImageView alloc] initWithFrame:rect2];
    self.foreImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.animationView addSubview:self.foreImageView];
    
    CGRect rect3 = rect;
    rect3.origin.x = - 10;
    rect3.size.width = 10;
    UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftside_shadow_bg.png"]];
    shadowView.frame = rect3;
    shadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.animationView addSubview:shadowView];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated swipeBack:(BOOL)swipeBack
{
    self.shouldSwipeBack = swipeBack;
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    self.shouldSwipeBack = NO;
    return [super popViewControllerAnimated:animated];
}

//对当前屏幕进行截图，用于返回动画
- (UIImage *)captureImage
{
    UIGraphicsBeginImageContextWithOptions(KEY_WINDOW.bounds.size, KEY_WINDOW.opaque, 0.0);
    if (self.topViewController.tabBarController) {
        [self.topViewController.tabBarController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    else {
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

//设置是否允许右滑返回操作
- (void)setShouldSwipeBack:(BOOL)shouldSwipeBack
{
    //如果支持iOS7自带的手势，就不必使用自定义的手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        return;
    }
    _shouldSwipeBack = shouldSwipeBack;
    if (shouldSwipeBack) {
        if (self.swipeBackGesture == nil) {
            self.swipeBackGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBack:)];
        }
        [self.view addGestureRecognizer:self.swipeBackGesture];
        
        self.backImageView.image = [self captureImage];
    }
    else {
        [self removeSwipeBackGesture];
    }
}

//移除右滑返回手势
- (void)removeSwipeBackGesture
{
    if (self.swipeBackGesture) {
        [self.view removeGestureRecognizer:self.swipeBackGesture];
    }
}

//取消返回操作，恢复原状
- (void)cancelSwipeBack
{
    isCanceled = YES;
    CGRect rect = self.animationView.frame;
    rect.origin.x = 0;
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.animationView.frame = rect;
    } completion:^(BOOL finished) {
        [self.animationView removeFromSuperview];
        isCanceled = NO;
    }];
}

//监听右滑手势
- (void)swipeBack:(UIPanGestureRecognizer*)gestureRecognizer
{
    //[self popViewControllerAnimated:YES];
    if (isCanceled) {
        return;
    }
    else {
        CGRect rect = self.animationView.frame;
        
        CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
        
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            startPoint = touchPoint;
            isCanceled = NO;
            self.foreImageView.image = [self captureImage];
            [KEY_WINDOW addSubview:self.animationView];
        }
        else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGFloat distanceX = (touchPoint.x - startPoint.x);
            CGFloat distanceY = ABS(touchPoint.y - startPoint.y);
            if (distanceY < kMaxDistanceY && distanceX > 0) {
                rect.origin.x = distanceX;
                self.animationView.frame = rect;
            }
            /*
             else {
             [self cancelSwipeBack];
             }
             */
        }
        else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            CGFloat distanceX = (touchPoint.x - startPoint.x);
            //CGFloat distanceY = ABS(touchPoint.y - startPoint.y);
            CGFloat minDistance = rect.size.width/4;//触发返回操作的向右最小滑动距离
            if (distanceX > minDistance/* && distanceY < kMaxDistanceY*/) {
                [self popViewControllerAnimated:NO];
                rect.origin.x = rect.size.width;
                [UIView animateWithDuration:kAnimateDuration animations:^{
                    self.animationView.frame = rect;
                } completion:^(BOOL finished) {
                    CGRect rect = self.animationView.frame;
                    rect.origin.x = 0;
                    self.animationView.frame = rect;
                    [self.animationView removeFromSuperview];
                    isCanceled = NO;
                }];
            }
            else {
                [self cancelSwipeBack];
            }
        }
        else {
            [self cancelSwipeBack];
        }
    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count>0) {
       viewController.hidesBottomBarWhenPushed = YES;
        
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_back" hightIcon:@"navigationbar_back_highlighted" target:self action:@selector(back)];
//
//        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_more" hightIcon:@"navigationbar_more_highlighted" target:self action:@selector(more)];
     }
    
    [super pushViewController:viewController animated:YES];
}


- (void)back
{
    [self popViewControllerAnimated:YES];
}
- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return self.childViewControllers.count > 1;
}


@end
