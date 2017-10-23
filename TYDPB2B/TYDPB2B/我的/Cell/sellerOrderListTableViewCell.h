//
//  sellerOrderListTableViewCell.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/9.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sellerOrderListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *goodsNumLab;//货物数量
@property (strong, nonatomic) IBOutlet UILabel *typeLab;
@property (strong, nonatomic) IBOutlet UIButton *typeBtn;
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *numberLab;//订单编号
@property (weak, nonatomic) IBOutlet UILabel *changNumLable;
@property (weak, nonatomic) IBOutlet UILabel *howMuchLable;
@property (weak, nonatomic) IBOutlet UILabel *regionNameLable;


@end
