//
//  NoticeMessage.h
//  ysg
//
//  Created by lhb on 16/4/29.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeMessage : NSObject


@property(nonatomic,copy) NSString * alertUrl;


//aps =     {
//    alert =         {
//        body = "\U60a8\U7684\U4e00\U7ea7\U4f1a\U5458\U6709\U4e00\U7b14\U8ba2\U5355\U4ea4\U6613\U6210\U529f\Uff0c\U60a8\U5c06\U83b7\U5f97\U76f8\U5e94\U7684\U6536\U76ca\Uff0c\U8bf7\U8010\U5fc3\U7b49\U5f85: )";
//        title = "\U60a8\U7684\U4e00\U7ea7\U4f1a\U5458\U6210\U529f\U652f\U4ed8\U8ba2\U5355";
//    };
//    sound = default;
//};

@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSString * body;

@property(nonatomic,assign) long long createTime;
@property(nonatomic,strong) NSString * imageUrl;
@property(nonatomic,assign) double money;
@property(nonatomic,copy) NSString * nickName;
@property(nonatomic,copy) NSString * orderId;
@property(nonatomic,copy) NSString * orderName;
@property(nonatomic,assign) long long payTime;
@property(nonatomic,assign) double rebateScore;
@property(nonatomic,copy) NSString * relation;
@property(nonatomic,copy) NSString * type;
@property(nonatomic,copy) NSString *  url;
@end

