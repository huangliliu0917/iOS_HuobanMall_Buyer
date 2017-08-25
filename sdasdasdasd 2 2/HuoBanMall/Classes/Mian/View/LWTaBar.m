//
//  LWTaBar.m
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-2.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import "LWTaBar.h"
#import "LWTabBarButton.h"
@interface  LWTaBar()

@property(nonatomic,weak)LWTabBarButton* selectButton;
@property(nonatomic,weak)UIButton* plusButton;
@property(nonatomic,strong)NSMutableArray * taBarButtons;
@end

@implementation LWTaBar


- (NSMutableArray *)taBarButtons
{
    if (_taBarButtons==nil) {
        _taBarButtons = [NSMutableArray array];
    }
    return _taBarButtons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


-(void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    //创建按钮
    LWTabBarButton * button = [[LWTabBarButton alloc] init];
    [self addSubview:button];
    //设置按钮数据
    button.item = item;
    //监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    //默认选中第一个按钮
    if (self.subviews.count==1) {
        [self buttonClick:button];
    }
    [self.taBarButtons addObject:button];
}


/**
 *  监听按钮点击   //三部曲
 *
 *  @param button 点击的按钮
 */
- (void)buttonClick:(LWTabBarButton *)button
{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(taBar:didSelecteButtonFrom:to:)]){
    
        [self.delegate taBar:self didSelecteButtonFrom: self.selectButton.tag to :button.tag];
    }
    //1、单前选中的按钮取消选中
    self.selectButton.selected = NO;
    //2、设置当前点击的按钮为选中
    button.selected = YES;
    //3、给选中按钮属性复制
    self.selectButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat buttonY = 0;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonH = self.frame.size.height;
    
    for (int index = 0; index < self.taBarButtons.count; index++) {
        //1、取出按钮
        LWTabBarButton * button = self.taBarButtons[index];
        //2、设置按钮的frame
        CGFloat buttonX = index * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        //绑定Tag
        button.tag = index;
    }
}
@end
