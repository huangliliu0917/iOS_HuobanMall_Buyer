//
//  WeiXinLoginModel.m
//  HuoBanMall
//
//  Created by lhb on 15/11/30.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "WeiXinLoginModel.h"
#import "MJExtension.h"
@implementation WeiXinLoginModel

MJCodingImplementation


+ (instancetype)WeiXinLoginModelWithLevelName:(NSString *)levelName WithNickName:(NSString *)nickName WithUserType:(int)userType Withuserid:(int)userid{
    WeiXinLoginModel * model =  [[WeiXinLoginModel alloc] init];
    model.levelName = levelName;
    model.nickName = nickName;
    model.userType = [NSString stringWithFormat:@"%d",userType];
    model.userid = [NSString stringWithFormat:@"%d",userid];
    return model;
}
@end
