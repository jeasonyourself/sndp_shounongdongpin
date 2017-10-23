//
//  HomePageSliderViewCell.h
//  TYDPB2B
//
//  Created by Wangye on 16/7/15.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageSliderViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UIImageView *mainImageView;
@property(nonatomic, strong)UIImageView *indicateImageView;
@property(nonatomic, strong)UILabel *bottomDecorateLabel;
@property(nonatomic, strong)UIButton *containerView;
@property(nonatomic, assign)BOOL flag;
+(HomePageSliderViewCell *)cellWithTableView:(UITableView *)tableView;
@end
