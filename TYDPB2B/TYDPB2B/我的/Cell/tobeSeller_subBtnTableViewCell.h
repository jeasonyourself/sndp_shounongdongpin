//
//  tobeSeller_subBtnTableViewCell.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/20.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tobeSeller_subBtnClickDelegate <NSObject>
- (void) tobeSeller_subBtnClick:(NSInteger)sender;
@end
@interface tobeSeller_subBtnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
- (IBAction)subBtnClick:(UIButton *)sender;
@property(nonatomic, strong)id<tobeSeller_subBtnClickDelegate>delegate;

@end
