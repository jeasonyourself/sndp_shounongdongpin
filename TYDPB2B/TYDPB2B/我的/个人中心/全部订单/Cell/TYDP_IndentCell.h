//
//  TYDP_IndentCell.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/20.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_IndentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *goodsNumLab;//货物数量
@property (strong, nonatomic) IBOutlet UILabel *typeLab;
@property (strong, nonatomic) IBOutlet UIButton *typeBtn;
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *numberLab;//订单编号

@end
