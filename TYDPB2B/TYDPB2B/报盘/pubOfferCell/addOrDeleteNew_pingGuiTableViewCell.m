//
//  addOrDeleteNew_pingGuiTableViewCell.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/23.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "addOrDeleteNew_pingGuiTableViewCell.h"

@implementation addOrDeleteNew_pingGuiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addOrDeleteBtnClick:(UIButton *)sender {
    [self.delegate addOrDeleteNew_pinGuiClick:sender.tag];
}
@end
