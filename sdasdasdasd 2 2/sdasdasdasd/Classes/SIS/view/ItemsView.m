//
//  ItemsView.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/11/10.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "ItemsView.h"

@interface ItemsView ()<UIScrollViewDelegate>

/**选项*/
@property(nonatomic,strong) UIScrollView * itemsScroll;
/**全部按你*/
@property(nonatomic,strong) UIButton * allitem;

@property(nonatomic,strong) UIButton * arrowbtn;
/**选中滑动条*/
@property(nonatomic,strong) UIView * selectView;


@end


@implementation ItemsView

- (instancetype)initWithFrame:(CGRect)frame AndColor:(UIColor *) color{
    
    if (self = [super initWithFrame:frame]) {
        
        UIScrollView * items = [[UIScrollView alloc] init];
        _itemsScroll = items;
        items.backgroundColor = [UIColor whiteColor];
        items.showsHorizontalScrollIndicator = false;
        items.frame = CGRectMake(0, 0, SecrenWith * (1 - 0.00625), 44);
        items.delegate = self;
        [self addSubview:items];
        
        //全部按钮
        UIButton * allitem = [[UIButton alloc] init];
        _allitem = allitem;
        allitem.backgroundColor = [UIColor whiteColor];
        [allitem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [allitem setTitle:@"全部" forState:UIControlStateNormal];
        [allitem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        allitem.tag = 0;
        allitem.titleLabel.adjustsFontSizeToFitWidth = YES;
        allitem.frame = CGRectMake(0, 0, SecrenWith * 0.156, 42);
        [self addSubview:allitem];
        
        //全部按钮
        UIButton * arrowbtn = [[UIButton alloc] init];
        [arrowbtn setImage:[UIImage imageNamed:@"jt"] forState:UIControlStateNormal];
        [self addSubview:arrowbtn];
        arrowbtn.tag = 1000;
        [arrowbtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        arrowbtn.frame = CGRectMake(SecrenWith - 39, 0, 39, 42);
        arrowbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        arrowbtn.backgroundColor = [UIColor whiteColor];
        _arrowbtn = arrowbtn;
        
        //滑动块
        UIView * selectView = [[UIView alloc] init];
        selectView.frame = CGRectMake(0, 42, SecrenWith * 0.156, 2);
        selectView.backgroundColor = [UIColor redColor];
        [items addSubview:selectView];
        _selectView = selectView;
    }
    
    return self;
}


- (void)setItems:(NSArray *)items{
    
    _items = items;
    
    
    CGFloat itemY = 0;
    CGFloat itemW = SecrenWith * 0.156;
    CGFloat itemH = 42;
    _itemsScroll.contentSize = CGSizeMake(items.count * itemW+39 , 0);
    NSLog(@"%lu",(unsigned long)items.count);
    for (int i = 0; i<items.count; i++) {
        NSString * itemtitle =  items[i];
        CGFloat itemX = itemW * i;
        UIButton * btn = [[UIButton alloc] init];
        if (i!=0) {
            btn.tag = i;
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
//        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:itemtitle forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(itemX, itemY, itemW, itemH)];
        [self.itemsScroll addSubview:btn];
    }
}

- (void)SetTheArrowToRight{
    [self.arrowbtn setImage:[UIImage imageNamed:@"jt"] forState:UIControlStateNormal];
    self.arrowbtn.tag = 1000;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    
    [UIView animateWithDuration:0.1 animations:^{
        self.allitem.hidden =  !(scrollView.contentOffset.x > SecrenWith * 0.156);
    }];
}



- (void)itemClick:(UIButton *)btn{
    
    if (btn.tag == 1000 || btn.tag == 2000) {
        
        if (btn.tag == 1000) {
            btn.tag = 2000;
            [btn setImage:[UIImage imageNamed:@"xjt"] forState:UIControlStateNormal];
        }else{
           [btn setImage:[UIImage imageNamed:@"jt"] forState:UIControlStateNormal];
           btn.tag = 1000;
        }
        if ([self.delegate respondsToSelector:@selector(itemSelectClick:)]) {
            
            [self.delegate  itemSelectClick:btn];
        }
               
    }else{
        
        self.selectView.frame = CGRectMake(btn.frame.origin.x, 42, btn.frame.size.width, 2);
        if ([self.delegate respondsToSelector:@selector(itemSelectClick:)]) {
            
            [self.delegate  itemSelectClick:btn];
        }
    }
    
    
    
}


@end
