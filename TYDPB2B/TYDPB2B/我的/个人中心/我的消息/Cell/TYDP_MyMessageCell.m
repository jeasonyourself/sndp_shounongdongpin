//
//  TYDP_MyMessageCell.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/15.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_MyMessageCell.h"

@implementation TYDP_MyMessageCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.whiteView.layer.borderColor = [RGBACOLOR(210, 210, 210, 1) CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
