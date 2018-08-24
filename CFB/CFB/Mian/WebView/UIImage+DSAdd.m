//
//  UIImage+DSAdd.m
//  TunjinNews
//
//  Created by FS on 2017/7/5.
//  Copyright © 2017年 徐冬苏. All rights reserved.
//

#import "UIImage+DSAdd.h"

@implementation UIImage (DSAdd)

+ (UIImage *)DS_renderOriginalImageWithImageName:(NSString *)imageName {
    UIImage * image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

+ (UIImage *)DS_resizableImageWithLocalImageName:(NSString *)localImageName {
    // 创建图片对象
    UIImage * image = [UIImage imageNamed:localImageName];
    
    // 获取图片的尺寸
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    
    return [image stretchableImageWithLeftCapWidth:imageW * 0.5 topCapHeight:imageH * 0.5];
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}


@end
