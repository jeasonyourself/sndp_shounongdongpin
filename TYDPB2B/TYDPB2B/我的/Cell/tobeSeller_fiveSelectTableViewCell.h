//
//  tobeSeller_fiveSelectTableViewCell.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/20.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol fstffBtnClickDelegate <NSObject>
- (void) fstffClick:(NSInteger)sender;
@end
@interface tobeSeller_fiveSelectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *firstLable;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UILabel *secondLable;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UILabel *thirdLable;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property (weak, nonatomic) IBOutlet UILabel *forthLable;
@property (weak, nonatomic) IBOutlet UIImageView *forthImage;
@property (weak, nonatomic) IBOutlet UIButton *forthBtn;

@property (weak, nonatomic) IBOutlet UILabel *fifthLable;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImage;
@property (weak, nonatomic) IBOutlet UIButton *fifthBtn;


- (IBAction)fstBtnClick:(UIButton *)sender;
@property(nonatomic, strong)id<fstffBtnClickDelegate>delegate;
@end
