//
//  TYDP_MineCellA.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/14.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_MineCellA.h"
#import "TYDP_IndentController.h"

@implementation TYDP_MineCellA

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self creatUI];
}

- (void)creatUI{
    //顶部线
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(5, 0, ScreenWidth-10, 1)];
    [self.btnView addSubview:topLine];
    topLine.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    
    //底部线
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.btnView.frame.size.height-1, ScreenWidth, 1)];
    [self.btnView addSubview:bottomLine];
    bottomLine.backgroundColor = RGBACOLOR(213, 213, 213, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
