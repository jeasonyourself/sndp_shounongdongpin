//
//  TYDP_BargainCell.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/19.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_BargainCell : UITableViewCell

//@property (strong, nonatomic) UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//物品名称
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;//产地（美国）
@property (weak, nonatomic) IBOutlet UIImageView *typeImg;//还价状态（还价成功，还价失败，等待回复）
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;//主图片
@property (weak, nonatomic) IBOutlet UIImageView *subImg1;//还
@property (weak, nonatomic) IBOutlet UIImageView *subImg2;//期/现
@property (weak, nonatomic) IBOutlet UIImageView *subImg3;//零/整
@property (weak, nonatomic) IBOutlet UIImageView *subImg4;//整
@property (weak, nonatomic) IBOutlet UILabel *numLab;//厂号
@property (weak, nonatomic) IBOutlet UILabel *priceNow;//现在的价格
@property (weak, nonatomic) IBOutlet UILabel *priceAgo;//原价
@property (weak, nonatomic) IBOutlet UILabel *priceMine;//我的价格
@property (weak, nonatomic) IBOutlet UILabel *suitLab;//30件/吨
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UIButton *bargainBtn;//继续还价按钮
@property (weak, nonatomic) IBOutlet UILabel *spec_textLable;
@property (strong, nonatomic) IBOutlet UIButton *buyBtn;//购买按钮

@end
