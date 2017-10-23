//
//  threeSelectBtnTableViewCell.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/22.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "threeSelectBtnTableViewCell.h"

@implementation threeSelectBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)fstBtnClick:(UIButton *)sender {
    [self.delegate fstClick:sender.tag andcellTag:self.tag];
}
@end
