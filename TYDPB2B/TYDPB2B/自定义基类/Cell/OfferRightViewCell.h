//
//  OfferRightViewCell.h
//  TYDPB2B
//
//  Created by Wangye on 16/7/18.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferRightViewCell : UITableViewCell
@property(nonatomic, strong)UIImageView *mainImageView;
@property(nonatomic, strong)UIImageView *indicateImageView;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UIButton *containerView;
+(OfferRightViewCell *)cellWithTableView:(UITableView *)tableView;
@end
