//
//  menuView.m
//  test
//
//  Created by 刘琛 on 15/11/26.
//  Copyright © 2015年 刘琛. All rights reserved.
//

#import "menuView.h"

@interface menuView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *slider;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIButton *allButton;

@property (nonatomic, strong) UIScrollView *meauView;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) UIButton *secondMeau;

@end

@implementation menuView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _buttonArray = [NSMutableArray array];
        
        _meauView = [[UIScrollView alloc] init];
        _meauView.backgroundColor = [UIColor whiteColor];
        _meauView.showsHorizontalScrollIndicator = NO;
        _meauView.frame = CGRectMake(0, 0, frame.size.width - 50, frame.size.height);
        _meauView.delegate = self;
        [self addSubview:_meauView];
        
        _slider = [[UIView alloc] init];
        _slider.backgroundColor = self.sliderColor;
        [self.meauView addSubview:_slider];
        
        _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, frame.size.height - 2)];
        _allButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_allButton setTitle:@"全部" forState:UIControlStateNormal];
        [_allButton addTarget:self action:@selector(scrollViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _allButton.tag = 10000;
        _allButton.backgroundColor = [UIColor whiteColor];
        [_allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _allButton.hidden = YES;
        [_allButton setBackgroundImage:[UIImage imageNamed:@"xian"] forState:UIControlStateNormal];
        [self addSubview:_allButton];
        
        _secondMeau = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 50, 0, 50, frame.size.height)];
        [_secondMeau setBackgroundImage:[UIImage imageNamed:@"xian2"] forState:UIControlStateNormal];
        [_secondMeau setImage:[UIImage imageNamed:@"50x30"] forState:UIControlStateNormal];
        [self addSubview:_secondMeau];
        _secondMeau.tag = 1000;
        [_secondMeau addTarget:self action:@selector(scrollViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return self;
}

- (void)setSliderColor:(UIColor *)sliderColor {
    _slider.backgroundColor = sliderColor;
    _sliderColor = sliderColor;
    if (_buttonArray.count != 0) {
        UIButton *button = _buttonArray[0];
        [button setTitleColor:sliderColor forState:UIControlStateNormal];
        self.selectButton = button;
    }
    self.slider.backgroundColor = sliderColor;
}

- (void)setIteamArray:(NSArray *)iteamArray {
    
    _iteamArray = iteamArray;
    
    CGFloat with = _iteamArray.count * 70;
    
    _meauView.contentSize = CGSizeMake(with, 0);
    
    _slider.frame = CGRectMake(5, self.frame.size.height - 2, 60, 2);
    
    for (int i = 0; i < _iteamArray.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * 70, 0, 70, self.frame.size.height)];
        button.tag = i;
        [button setTitle:_iteamArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(scrollViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_meauView addSubview:button];
        [_buttonArray addObject:button];
    }
    if (_sliderColor) {
        if (_buttonArray.count != 0) {
            UIButton *button = _buttonArray[0];
            [button setTitleColor:_sliderColor forState:UIControlStateNormal];
            self.selectButton = button;
        }
    }
    
}

- (void)scrollViewButtonAction:(UIButton *) sender{
 
    
    if (sender.tag == 1000 || sender.tag == 2000) {
        
        if (sender.tag == 1000) {
            sender.tag = 2000;
            [sender setImage:[UIImage imageNamed:@"50x30-2"] forState:UIControlStateNormal];
        }else{
            [sender setImage:[UIImage imageNamed:@"50x30"] forState:UIControlStateNormal];
            sender.tag = 1000;
        }
        if ([self.delegate respondsToSelector:@selector(itemSelectClick:)]) {
            
            [self.delegate  itemSelectClick:sender];
        }
        
    }else if (sender.tag == 10000) {
        [self setButtonClickWithAction:0];
    }else{
        
        //按钮的位置判断 以及scrollView的滑动效果
        if (self.selectButton != sender) {
            [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.selectButton = sender;
            [sender setTitleColor:_sliderColor forState:UIControlStateNormal];
        }
        
        
        [UIView animateWithDuration:.2 animations:^{
            self.slider.frame = CGRectMake(sender.frame.origin.x + 5, self.frame.size.height - 2, 60, 2);
        } completion:^(BOOL finished) {
            
            CGFloat float1 = 5 + 70 * sender.tag;
            CGFloat float2 = self.meauView.contentSize.width - float1;
            NSLog(@"tag:%f",float1);
            
            CGPoint point = [sender convertPoint:sender.frame.origin toView:self];
            NSLog(@"%f",point.x);
            if (ScreenWidth / 2  - 17.5 < float1 && ScreenWidth / 2 - 17.5 <float2) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    CGFloat float1 = 5 + 70 * sender.tag;
                    self.meauView.contentOffset = CGPointMake(float1 - ScreenWidth / 2 + 35 , 0);
                }];
            }else if (ScreenWidth / 2 - 17.5  > float2) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.meauView.contentOffset = CGPointMake(self.meauView.contentSize.width - self.meauView.frame.size.width, 0);
                }];
                
            }else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.meauView.contentOffset = CGPointMake(0, 0);
                }];
            }
        }];
        
        if ([self.delegate respondsToSelector:@selector(itemSelectClick:)]) {
            
            [self.delegate  itemSelectClick:sender];
        }
    }
    
    
    
    
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration:0.1 animations:^{
        _allButton.hidden =  !(scrollView.contentOffset.x > 60);
    }];
}

- (void)setButtonClickWithAction:(NSInteger) tag {
    UIButton *button = _buttonArray[tag];
    [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectButton = button;
    [button setTitleColor:_sliderColor forState:UIControlStateNormal];
    
    [UIView animateWithDuration:.2 animations:^{
        self.slider.frame = CGRectMake(button.frame.origin.x + 5, self.frame.size.height - 2, 60, 2);
    } completion:^(BOOL finished) {
        
        CGFloat float1 = 5 + 70 * button.tag;
        if (tag == 0) {
            float1 -= 5;
        }
        CGFloat float2 = self.meauView.contentSize.width - float1;
        NSLog(@"tag:%f",float1);
        
        CGPoint point = [button convertPoint:button.frame.origin toView:self];
        NSLog(@"%f",point.x);
        if (ScreenWidth / 2  - 17.5 < float1 && ScreenWidth / 2 - 17.5 <float2) {
            
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat float1 = 5 + 70 * button.tag;
                self.meauView.contentOffset = CGPointMake(float1 - ScreenWidth / 2 + 35 , 0);
            }];
        }else if (ScreenWidth / 2 - 17.5  > float2) {
            [UIView animateWithDuration:0.2 animations:^{
                self.meauView.contentOffset = CGPointMake(self.meauView.contentSize.width - self.meauView.frame.size.width, 0);
            }];
            
        }else {
            [UIView animateWithDuration:0.2 animations:^{
                self.meauView.contentOffset = CGPointMake(0, 0);
            }];
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(itemSelectClick:)]) {
        
        [self.delegate  itemSelectClick:button];
    }
}

/**让建头恢复正常*/
- (void)SetTheArrowToRight{
    [self.secondMeau setImage:[UIImage imageNamed:@"50x30-2"] forState:UIControlStateNormal];
    self.secondMeau.tag = 1000;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
