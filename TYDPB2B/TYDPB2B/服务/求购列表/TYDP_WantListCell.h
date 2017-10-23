//
//  TYDP_WantListCell.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/18.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_WantListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *callBtn;//打电话按钮
@property (weak, nonatomic) IBOutlet UILabel *nameLab;//联系人
@property (weak, nonatomic) IBOutlet UILabel *timeLab;//时间
@property (weak, nonatomic) IBOutlet UILabel *remarksLab;//备注
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UILabel *addressLad;//地址
@property (weak, nonatomic) IBOutlet UILabel *priceLab;//价钱
@property (weak, nonatomic) IBOutlet UIButton *spreadBtn;//展开按钮

@end
