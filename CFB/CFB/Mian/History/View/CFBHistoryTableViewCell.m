//
//  CFBHistoryTableViewCell.m
//  CFB
//
//  Created by 周鑫 on 2018/8/23.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "CFBHistoryTableViewCell.h"

@interface CFBHistoryTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *minlabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end

@implementation CFBHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHistory:(NSDictionary *)history {
    
    _history = history;
    
    self.dateLabel.text = [history objectForKey:@"date"];
    self.minlabel.text = [history objectForKey:@"Min"];
    self.maxLabel.text = [history objectForKey:@"Max"];
    self.locationLabel.text = [history objectForKey:@"Location"];
}

@end
