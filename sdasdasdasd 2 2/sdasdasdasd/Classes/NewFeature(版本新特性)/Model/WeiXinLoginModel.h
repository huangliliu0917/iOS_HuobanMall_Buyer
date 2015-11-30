//
//  WeiXinLoginModel.h
//  sdasdasdasd
//
//  Created by lhb on 15/11/30.
//  Copyright © 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiXinLoginModel : NSObject


@property(nonatomic,strong) NSString * levelName;
@property(nonatomic,strong) NSString * nickName;
@property(nonatomic,strong) NSString * userType;
@property(nonatomic,strong) NSString * userid;



+ (instancetype)WeiXinLoginModelWithLevelName:(NSString *)levelName WithNickName:(NSString *)nickName WithUserType:(int)userType Withuserid:(int)userid;
@end
