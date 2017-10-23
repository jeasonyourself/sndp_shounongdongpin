//
//  TYDP_CareCell.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/19.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_CareCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImg;//厂家图片
@property (weak, nonatomic) IBOutlet UILabel *numLab;//厂号
@property (weak, nonatomic) IBOutlet UILabel *detailLab;//厂家描述
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;//关注状态按钮（已关注，为关注）
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImg;

@end
