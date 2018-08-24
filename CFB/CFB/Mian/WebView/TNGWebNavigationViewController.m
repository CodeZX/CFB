//
//  TNGWebNavigationViewController.m
//  CPDiary
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//

#import "TNGWebNavigationViewController.h"
#import "TNGWebViewController.h"
#import "UIImage+DSAdd.h"
//RGB 颜色
#define KRGBA(r,g,b,a)  [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

#define RGB(r,g,b) KRGBA(r,g,b,1.0f)
#define KBlueColor RGB(32,179,229)

@interface TNGWebNavigationViewController ()

@end

@implementation TNGWebNavigationViewController

+ (void)initialize {
    
    if (self == [TNGWebNavigationViewController class]) {
        // 1. 获取导航条标识
        UINavigationBar * navbar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[TNGWebNavigationViewController class]]];
        
        //获取导航条颜色
        UIColor * navColor = KBlueColor;
        //把颜色生成图片
        UIImage * alphaImg = [UIImage imageWithColor:navColor];
        [navbar setBackgroundImage:alphaImg forBarMetrics:UIBarMetricsDefault];
        // 设置字体颜色大小
        NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
        // 字体大小
        dictM[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
        // 字体颜色
        dictM[NSForegroundColorAttributeName] = [UIColor whiteColor];
        
        navbar.titleTextAttributes = dictM;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    TNGWebViewController *webVC = [[TNGWebViewController alloc] init];
        [webVC loadWebURLSring:self.url];
    [self pushViewController:webVC animated:YES];

}

@end
