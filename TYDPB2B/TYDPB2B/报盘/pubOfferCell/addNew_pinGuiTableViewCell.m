//
//  addNew_pinGuiTableViewCell.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/23.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "addNew_pinGuiTableViewCell.h"

@implementation addNew_pinGuiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addBtnClick:(UIButton *)sender {
    [self.delegate addNew_pinGuiClick:sender.tag];
}
@end
