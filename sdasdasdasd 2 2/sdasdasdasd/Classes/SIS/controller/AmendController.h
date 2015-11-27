//
//  AmendController.h
//  HuoBanMall
//
//  Created by HuoTu-Mac on 15/8/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AmendControllerdelegate <NSObject>

@optional
- (void)NameControllerpickName:(NSString *) name;

- (void)NicknameControllerpickName:(NSString *)name;

@end

@interface AmendController : UIViewController



//保存text中的内容
@property (strong, nonatomic) NSString *string;

@property (weak, nonatomic) IBOutlet UITextField *textField;


@property(nonatomic,weak) id<AmendControllerdelegate> delegate;

@end
