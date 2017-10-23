//
//  addNew_pinGuiTableViewCell.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/23.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol addNew_pinGuiBtnClickDelegate <NSObject>
- (void) addNew_pinGuiClick:(NSInteger)sender;
@end

@interface addNew_pinGuiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnClick:(UIButton *)sender;
@property(nonatomic, strong)id<addNew_pinGuiBtnClickDelegate>delegate;

@end
