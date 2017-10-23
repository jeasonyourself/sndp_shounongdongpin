//
//  TYDP_MyWantCell.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/18.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_MyWantCell : UITableViewCell

@property (assign,nonatomic)BOOL isSpread;//展开状态
@property (strong, nonatomic) IBOutlet UIButton *compileBtn;//编辑按钮
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UILabel *addressLab;//地点
@property (weak, nonatomic) IBOutlet UILabel *priceLab;//价钱
@property (strong, nonatomic) IBOutlet UILabel *timeLab;//时间
@property (weak, nonatomic) IBOutlet UILabel *remarksLab;//备注
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *spreadButton;//展开按钮，用来改变按钮背景
@property (nonatomic, copy) NSString *Id;
@property (strong, nonatomic) IBOutlet UIImageView *spreadImg;//展开的图片

@end
