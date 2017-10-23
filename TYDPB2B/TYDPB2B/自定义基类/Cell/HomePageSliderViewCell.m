//
//  HomePageSliderViewCell.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/15.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "HomePageSliderViewCell.h"

@implementation HomePageSliderViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCellUI];
    }
    return self;
}
- (void)createCellUI{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    if (!_mainImageView) {
        _mainImageView = [UIImageView new];
//        [_mainImageView setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:_mainImageView];
//        [self.contentView setBackgroundColor:[UIColor greenColor]];
        CGFloat imageHeight = self.contentView.frame.size.height/1.2;
        CGFloat imageWidth = self.contentView.frame.size.height/1.2;
        [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(30-imageHeight/2);
            make.left.equalTo(self.contentView).with.offset(MiddleGap);
            make.width.mas_equalTo(imageWidth);
            make.height.mas_equalTo(imageHeight);
        }];
    }
    UIImage *arrowsImage = [UIImage imageNamed:@"leftclassify_icon_down"];
    if (!_indicateImageView) {
        _indicateImageView = [UIImageView new];
        [self.contentView addSubview:_indicateImageView];
        [_indicateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-MiddleGap);
            make.centerY.mas_equalTo(_mainImageView);
            make.width.mas_equalTo(arrowsImage.size.width);
            make.height.mas_equalTo(arrowsImage.size.height);
        }];
    }
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_mainImageView);
            make.left.equalTo(self.mainImageView.mas_right).with.offset(MiddleGap);
            make.width.mas_equalTo(self.contentView.frame.size.width/2);
            make.height.mas_equalTo(self.contentView.frame.size.height/3);
        }];
    }
    if (!_bottomDecorateLabel) {
        _bottomDecorateLabel = [UILabel new];
        [self.contentView addSubview:_bottomDecorateLabel];
        [_bottomDecorateLabel setBackgroundColor:[UIColor lightGrayColor]];
        [_bottomDecorateLabel setAlpha:0.3];
        [_bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-1);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(HomePageBordWidth);
        }];
    }
    if (!_containerView) {
        _containerView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_containerView setBackgroundColor:RGBACOLOR(232, 232, 232, 1)];
        [self.contentView addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(60);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    _containerView.hidden = YES;
    [_indicateImageView setImage:arrowsImage];
    self.accessoryType = UITableViewCellAccessoryNone;
}
+(HomePageSliderViewCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *ident = @"cell";
    HomePageSliderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[HomePageSliderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
