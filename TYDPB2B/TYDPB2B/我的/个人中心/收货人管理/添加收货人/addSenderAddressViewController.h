//
//  addSenderAddressViewController.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/11.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYDP_ConsigneeModel.h"
#import "JKCountDownButton.h"
@interface addSenderAddressViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTf;//电话号码输入框
@property (strong, nonatomic) IBOutlet UITextField *IDnumberTf;//身份证号输入框
@property (strong, nonatomic) IBOutlet UITextField *nameTf;//姓名输入框
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (nonatomic, assign) int pushType;//0:修改,1:添加.
@property (nonatomic, strong) TYDP_ConsigneeModel *model;
@property (nonatomic, assign) int type;//0:买家,1:卖家.
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;
- (IBAction)codeBtnClick:(JKCountDownButton *)sender;

@end
