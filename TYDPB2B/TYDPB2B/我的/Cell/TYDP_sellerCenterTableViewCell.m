//
//  TYDP_sellerCenterTableViewCell.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/19.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "TYDP_sellerCenterTableViewCell.h"

@implementation TYDP_sellerCenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self creatUI];
}

- (void)creatUI{
    //顶部线
//    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(5, 0, ScreenWidth-10, 1)];
////    [self.btnView addSubview:topLine];
//    topLine.backgroundColor = RGBACOLOR(230, 230, 230, 1);
//    
//    UIView * aLine = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3, 0, 1, ScreenWidth/3)];
//    [self.btnView addSubview:aLine];
//    aLine.backgroundColor = RGBACOLOR(230, 230, 230, 1);
//    
//    UIView *bLine = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth*2/3, 0, 1, ScreenWidth/3)];
//    [self.btnView addSubview:bLine];
//    bLine.backgroundColor = RGBACOLOR(230, 230, 230, 1);
//    
//    //底部线
//    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenWidth/3-1, ScreenWidth, 1)];
//    [self.btnView addSubview:bottomLine];
//    bottomLine.backgroundColor = RGBACOLOR(213, 213, 213, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
