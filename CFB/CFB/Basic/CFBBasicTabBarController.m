//
//  BasicTabBarController.m
//  CFB
//
//  Created by 周鑫 on 2018/8/20.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "CFBBasicTabBarController.h"
#import "CFBSettingViewController.h"
#import "CFBSurveyViewController.h"
#import "CFBHistoryViewController.h"
#import "CFBBasicNavigationController.h"



@interface CFBBasicTabBarController ()

@end

@implementation CFBBasicTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAllChildViewcontroller];
    self.selectedIndex = 1;
}


- (void)addAllChildViewcontroller {
    
    // 历史  // 测量 // 设置
    CFBHistoryViewController *historyVC = [[CFBHistoryViewController alloc]init];
    [self addChildViewController:historyVC Image:@"icon_ls" selectedImage:@"icon_li_unselected" title:@"歴史"];
    
    CFBSurveyViewController *surverVC = [[CFBSurveyViewController alloc]init];
    [self addChildViewController:surverVC Image:@"icon_cl" selectedImage:@"icon_ce_unselected" title:@"測定"];
    
    CFBSettingViewController *settingVC = [[CFBSettingViewController alloc]init];
    [self addChildViewController:settingVC Image:@"icon_sz" selectedImage:@"icon_sz_unselected" title:@"設定"];
    
}


#pragma mark - 初始化设置ChildViewControllers
/**
 *
 *  设置单个tabBarButton
 *
 *  @param VC            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)addChildViewController:(UIViewController *)VC Image:(NSString *)image selectedImage:(NSString *)selectImage title:(NSString *)title
{
    CFBBasicNavigationController *NA_VC = [[CFBBasicNavigationController alloc] initWithRootViewController:VC];
    UIImage *defaultImage = [UIImage imageNamed:image];
    defaultImage = [defaultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.image = defaultImage;
    UIImage *selectedImage = [UIImage imageNamed:selectImage];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.selectedImage = selectedImage;
    VC.title = title;
    [self addChildViewController:NA_VC];
    
}

@end
