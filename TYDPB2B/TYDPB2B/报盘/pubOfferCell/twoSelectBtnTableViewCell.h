//
//  twoSelectBtnTableViewCell.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/22.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol fsBtnClickDelegate <NSObject>
- (void) fsClick:(NSInteger)sender andcellTag:(NSInteger)celltag;
@end
@interface twoSelectBtnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *firstLable;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UILabel *secondLable;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
- (IBAction)fsBtnClick:(UIButton *)sender;
@property(nonatomic, strong)id<fsBtnClickDelegate>delegate;

@end
