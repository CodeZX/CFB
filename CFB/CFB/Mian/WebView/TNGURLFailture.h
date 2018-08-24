//
//  TNGURLFailture.h
//  CPDiary
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TNGURLFailtureDelegate <NSObject>

-(void)didClickCleanBtn:(UIButton *)sender;

@end

@interface TNGURLFailture : UIView
@property (nonatomic, weak) id<TNGURLFailtureDelegate> delegate;

@end
