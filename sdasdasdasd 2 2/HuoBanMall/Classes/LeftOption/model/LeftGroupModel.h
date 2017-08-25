//
//  LeftGroupModel.h
//  HuoBanMallBuy
//
//  Created by lhb on 15/9/9.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeftGroupModel : NSObject



/**每组条目*/
@property(nonatomic,assign)int groupID;

@property(nonatomic,strong) NSMutableArray * models;

@end
