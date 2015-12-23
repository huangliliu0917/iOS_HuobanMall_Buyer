//
//  ItemCollectionView.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/11/12.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "ItemCollectionView.h"
#import "CollectionViewCell.h"

#define colCount 4

@interface ItemCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>


@property(nonatomic,strong) UICollectionView * itemsView;
/**当前选中的颜色*/
@property(nonatomic,strong) NSIndexPath* indexPath;

@end


@implementation ItemCollectionView


static NSString *ID = @"btn";


- (instancetype)initWithFrame:(CGRect)frame{
    
    if ( self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout * lay = [[UICollectionViewFlowLayout alloc] init];
        lay.minimumLineSpacing = 0;
        lay.minimumInteritemSpacing = 0;
        UICollectionView * itemsView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:lay];
        [self addSubview:itemsView];
        itemsView.dataSource = self;
        itemsView.delegate = self;
        itemsView.backgroundColor = [UIColor whiteColor];
        _itemsView = itemsView;
        [itemsView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
    }
    return self;
}



- (void)setItems:(NSArray *)items{
    _items = items;
    
    UICollectionViewFlowLayout * lay = (UICollectionViewFlowLayout *)self.itemsView.collectionViewLayout;
    
    long col = items.count / colCount;
    if (items.count % colCount) {
        col++;
    }
    lay.itemSize = CGSizeMake(self.frame.size.width / colCount, 30);
    [self.itemsView reloadData];
}

#pragma SrcView dateSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{

//    NSLog(@"collectionView%lu",(unsigned long)self.items.count);
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    cell.itemTitle = self.items[indexPath.row];
    return cell;
}
#pragma SrcView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell * bolds = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:self.indexPath];
    CollectionViewCell * cc =  (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cc.backgroundColor = [UIColor orangeColor];
    self.indexPath = indexPath;
    if ([self.delegate respondsToSelector:@selector(SecondLevelclassify:)]) {
        
        [self.delegate SecondLevelclassify:indexPath];
    }
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.itemsView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
@end
