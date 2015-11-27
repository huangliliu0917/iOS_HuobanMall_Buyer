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

+ (UIImage *)ToCreateQRcodeWithInformation:(NSString *)QRStr{
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [QRStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    UIImage *image = [UIImage  imageWithCIImage:outputImage];
    return image;
}


@end
