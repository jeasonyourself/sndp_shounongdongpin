//
//  addOrDeleteNew_pingGuiTableViewCell.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/23.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol addOrDeleteNew_pinGuiBtnClickDelegate <NSObject>
- (void) addOrDeleteNew_pinGuiClick:(NSInteger)sender;
@end
@interface addOrDeleteNew_pingGuiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)addOrDeleteBtnClick:(UIButton *)sender;
@property(nonatomic, strong)id<addOrDeleteNew_pinGuiBtnClickDelegate>delegate;

@end
