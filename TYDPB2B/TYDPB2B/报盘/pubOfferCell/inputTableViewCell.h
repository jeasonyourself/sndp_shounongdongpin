//
//  inputTableViewCell.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/22.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface inputTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UILabel *unitLable;

@end
