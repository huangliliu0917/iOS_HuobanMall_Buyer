//
//  DescribeController.h
//  HuoBanMall
//
//  Created by HuoTu-Mac on 15/8/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DescribeControllerdelegate <NSObject>

@optional

- (void)DescribeControllerpickDescribe:(NSString *) describe;

@end

@interface DescribeController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSString *string;

@property (nonatomic, strong) id<DescribeControllerdelegate> delegate;

@end
