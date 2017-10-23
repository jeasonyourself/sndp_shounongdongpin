//
//  userMoneyTableViewCell.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/9.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userMoneyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *changeBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *numberLab;
@property (strong, nonatomic) IBOutlet UILabel *IDnumberLab;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
