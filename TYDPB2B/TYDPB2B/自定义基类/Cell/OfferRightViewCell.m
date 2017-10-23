//
//  OfferRightViewCell.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/18.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "OfferRightViewCell.h"

@implementation OfferRightViewCell

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
        _mainImageView.backgroundColor=mainColor;
        [self.contentView addSubview:_mainImageView];
        [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(15);
            make.left.equalTo(self.contentView).with.offset(Gap);
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(20);
        }];
    }
    UIImage *arrowsImage = [UIImage imageNamed:@"offer_icon_down_n"];
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
            make.left.equalTo(self.mainImageView.mas_right).with.offset(7);
            make.width.mas_equalTo(self.contentView.frame.size.width/2);
            make.height.mas_equalTo(self.contentView.frame.size.height/3);
        }];
    }
    if (!_containerView) {
        _containerView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(50);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    _containerView.hidden = YES;
    [_indicateImageView setImage:arrowsImage];
    self.accessoryType = UITableViewCellAccessoryNone;
}
+(OfferRightViewCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *ident = @"cell";
    OfferRightViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[OfferRightViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
