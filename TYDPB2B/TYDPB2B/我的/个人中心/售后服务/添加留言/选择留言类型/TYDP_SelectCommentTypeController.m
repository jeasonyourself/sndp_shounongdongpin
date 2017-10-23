


//
//  TYDP_SelectCommentTypeController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/22.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_SelectCommentTypeController.h"

@interface TYDP_SelectCommentTypeController ()
- (IBAction)cancelSelect;
- (IBAction)selectBtnDown:(UIButton *)sender;
- (IBAction)selestBtnUp:(UIButton *)sender;

@end

@implementation TYDP_SelectCommentTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatUI];
}

- (void)creatUI{
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelSelect {
    [self.view removeFromSuperview];
}

- (IBAction)selectBtnDown:(UIButton *)sender {
    sender.superview.backgroundColor = RGBACOLOR(203, 203, 203, 1);
}

- (IBAction)selestBtnUp:(UIButton *)sender {
    sender.superview.backgroundColor = [UIColor clearColor];
    NSLog(@"%@",sender.titleLabel.text);
    self.returnBlock(sender.titleLabel.text,[NSString stringWithFormat:@"%d",(int)sender.tag-100]);
    [self.view removeFromSuperview];
}

- (void)returnTypr:(returnBlock)block{
    self.returnBlock = block;
}

@end
