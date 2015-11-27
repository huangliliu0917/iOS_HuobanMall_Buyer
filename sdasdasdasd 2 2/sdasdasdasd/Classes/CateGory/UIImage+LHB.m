//
//  UIImage+LHB.m
//  HuoBanMallBuy
//
//  Created by lhb on 15/11/3.
//  Copyright © 2015年 HT. All rights reserved.
//

#import "UIImage+LHB.h"

@implementation UIImage (LHB)


+ (UIImage *) LeftMenuImageWithIconName:(NSString *) imageName{
    
    NSString *unsavedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/update/icon"];
    NSString * imageUrl = [NSString stringWithFormat:@"%@/%@",unsavedPath,imageName];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:imageUrl];
    if (savedImage == nil) {
        
        return [UIImage imageNamed:imageName];
    }
    return savedImage;
}
@end
