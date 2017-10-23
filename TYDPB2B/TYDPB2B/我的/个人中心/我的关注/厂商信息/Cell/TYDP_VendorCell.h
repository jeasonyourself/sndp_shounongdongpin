//
//  TYDP_VendorCell.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/2.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_VendorCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLab;//
@property (strong, nonatomic) IBOutlet UIImageView *headImg;//
@property (strong, nonatomic) IBOutlet UILabel *priceLab;//
@property (strong, nonatomic) IBOutlet UILabel *numLab;
@property (strong, nonatomic) IBOutlet UILabel *addressLab;
@property (strong, nonatomic) IBOutlet UIImageView *subImg1;
@property (strong, nonatomic) IBOutlet UIImageView *subImg2;
@property (strong, nonatomic) IBOutlet UIImageView *subImg3;
@property (strong, nonatomic) IBOutlet UIImageView *subImg4;
@property (weak, nonatomic) IBOutlet UILabel *unitNameLable;
@property (strong, nonatomic) IBOutlet UIImageView *regin_icon;
@property (weak, nonatomic) IBOutlet UILabel *regionNameLbale;

@end
