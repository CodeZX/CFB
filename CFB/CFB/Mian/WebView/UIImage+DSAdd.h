//
//  UIImage+DSAdd.h
//  TunjinNews
//
//  Created by FS on 2017/7/5.
//  Copyright © 2017年 徐冬苏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DSAdd)

/**
 获取没有被渲染的图片
 
 @param imageName 图片名称
 @return 没有渲染的图片
 */
+ (UIImage *)DS_renderOriginalImageWithImageName:(NSString *)imageName;

/**
 图片拉伸
 
 @param localImageName 图片名称
 @return 拉伸后的图片
 */
+ (UIImage *)DS_resizableImageWithLocalImageName:(NSString *)localImageName;

// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
