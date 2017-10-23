//
//  tobeSeller_subBtnTableViewCell.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/20.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "tobeSeller_subBtnTableViewCell.h"

@implementation tobeSeller_subBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)subBtnClick:(UIButton *)sender {
    [self.delegate tobeSeller_subBtnClick:sender.tag];
}
@end
