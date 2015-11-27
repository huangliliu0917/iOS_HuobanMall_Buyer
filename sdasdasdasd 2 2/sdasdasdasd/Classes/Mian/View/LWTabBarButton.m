//
//  LWTabBarButton.m
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-2.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import "LWTabBarButton.h"
#import "LWBadgeButton.h"
//图标的比例
#define LWTabBarButtonImageRatio 0.6
//按钮默认当颜色
#define LWTabBarButtonTitleColor (iOS7?[UIColor grayColor]: [UIColor whiteColor])
//按钮选中的颜色
#define LWTabBarButtonSelectedTitleColor (iOS7? LWColor(234,103,7): LWColor(248,139,0))


@interface LWTabBarButton()

@property(nonatomic,weak)LWBadgeButton * badgeButton;

@end
@implementation LWTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //设置图片为居中不要填充
        self.imageView.contentMode = UIViewContentModeCenter;
        //设置文字为居中不要填充
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.tintColor = [UIColor blackColor];
//        [self setTitleColor: LWTabBarButtonTitleColor forState:UIControlStateNormal];
        [self setTitleColor:BottomTaBarButtonTitleColor forState:UIControlStateSelected];

        
        LWBadgeButton* badgeButton = [[LWBadgeButton alloc] init];
        
        //解决初始化后size为0问题
        badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:badgeButton];
        self.badgeButton = badgeButton;
        
        
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted
{}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    //kvo  监听item属性值改变
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
}


- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
    
}
/**
 *  监听到某个对象属性值改变就会调用
 *
 *  @param keyPath 属性名
 *  @param object  哪个对象的属性被改了
 *  @param change  属性发生的改变
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    //设置title
    [self setTitle:self.item.title forState:UIControlStateNormal];
    //设置选中title
    [self setTitle:self.item.title forState:UIControlStateSelected];
    //设置图片
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];

    //设置消息提醒按钮
    self.badgeButton.badgeValue = self.item.badgeValue;
    
    //设置提醒数字的位置
    CGFloat badgeY = 0;
    CGFloat badgeX = self.frame.size.width - self.badgeButton.frame.size.width -10;
    CGRect badgeF = self.badgeButton.frame;
    badgeF.origin.x = badgeX;
    badgeF.origin.y = badgeY;
    self.badgeButton.frame = badgeF;
}




/**
 *  重写按钮的两个方法
 *
 *  @param contentRect <#contentRect description#>
 *
 *  @return <#return value description#>
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * LWTabBarButtonImageRatio;
    
    return  CGRectMake(0, 0, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = contentRect.size.width;
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * LWTabBarButtonImageRatio;
    CGFloat titleH = contentRect.size.height - titleY;
    return  CGRectMake(titleX, titleY, titleW, titleH);
}

@end
