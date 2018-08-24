//
//  TNGURLFailture.m
//  CPDiary
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//

#import "TNGURLFailture.h"

//RGB 颜色
#define KRGBA(r,g,b,a)  [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

#define RGB(r,g,b) KRGBA(r,g,b,1.0f)
//宏
#define KSelfWitdh self.frame.size.width
#define KSelfHeight self.frame.size.height

#define KtitleColor RGB(102,102,102) //文字颜色
#define KRecommendColor RGB(153,153,153) //其他文字颜色
#define KButtonColor RGB(200, 10, 10) //按钮颜色

@implementation TNGURLFailture
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
        
    }
    return self;
}

- (void)setupViews{
    
    UIImageView * imgView = [[UIImageView alloc] init];
    [imgView setImage:[UIImage imageNamed:@"Noorder_img.png"]];
    imgView.frame = CGRectMake((KSelfWitdh - 103) * 0.5, KSelfHeight * 0.17, 103, 91);
    [self addSubview:imgView];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame) + 14, KSelfWitdh, 26)];
    lab.text = @"请求超时了哦";
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = KtitleColor;

    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    
    UILabel * recommendLab = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(lab.frame) + 8 , KSelfWitdh - 40, 44)];
    recommendLab.text = @"您可以点击刷新按钮重新加载";
    recommendLab.numberOfLines = 0;
    recommendLab.font = [UIFont systemFontOfSize:15];
    recommendLab.textColor = KRecommendColor;
    [self addSubview:recommendLab];
    
//    [UILabel DS_labelStylewithlabel:recommendLab Withsize:FONTSIZE_CELL_SUBTITLE withLineSpace:5 WordSpace:0 withColor:KRecommendColor withisBold:NO withTextStyle:FONTNAME];
    recommendLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(35, CGRectGetMaxY(recommendLab.frame) + 40, self.frame.size.width - 70, 44);
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = KButtonColor;
    [btn setTitle:@"点击刷新" forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didClickSpeedPingFangBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    self.backgroundColor = [UIColor whiteColor];
}

-(void)didClickSpeedPingFangBtn:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCleanBtn:)]) {
        [self.delegate didClickCleanBtn:sender];
    }
    
}

@end
