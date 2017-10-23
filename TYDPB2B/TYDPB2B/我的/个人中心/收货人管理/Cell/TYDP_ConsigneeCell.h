//
//  TYDP_ConsigneeCell.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/27.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_ConsigneeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *changeBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *numberLab;
@property (strong, nonatomic) IBOutlet UILabel *IDnumberLab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstrsint;

@end
