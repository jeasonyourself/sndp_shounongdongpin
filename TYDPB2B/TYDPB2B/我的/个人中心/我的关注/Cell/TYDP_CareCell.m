//
//  TYDP_CareCell.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/19.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_CareCell.h"

@implementation TYDP_CareCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self creatUI];
}

- (void)creatUI{
    self.typeBtn.layer.cornerRadius = 5;
    self.typeBtn.layer.borderWidth = 1;
    self.typeBtn.layer.borderColor = [RGBACOLOR(212, 212, 212, 1) CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
