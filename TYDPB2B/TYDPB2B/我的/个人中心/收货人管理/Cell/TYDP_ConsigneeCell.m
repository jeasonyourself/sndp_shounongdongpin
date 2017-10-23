//
//  TYDP_ConsigneeCell.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/27.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_ConsigneeCell.h"

@implementation TYDP_ConsigneeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.selectBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonClicked:(UIButton *)button {

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
