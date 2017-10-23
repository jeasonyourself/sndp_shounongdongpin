//
//  tobeSeller_fiveSelectTableViewCell.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/20.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "tobeSeller_fiveSelectTableViewCell.h"

@implementation tobeSeller_fiveSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)fstBtnClick:(UIButton *)sender
{
    [self.delegate fstffClick:sender.tag];
}
@end
