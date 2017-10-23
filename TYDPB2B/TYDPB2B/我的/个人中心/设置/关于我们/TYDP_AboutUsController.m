//
//  TYDP_AboutUsController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/19.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_AboutUsController.h"

@interface TYDP_AboutUsController ()

@end

@implementation TYDP_AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-55, 160*Height+NavHeight, 135, 135)];
    [self.view addSubview:img];
    img.image = [UIImage imageNamed:@"logo_ch"];
    
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(50, ScreenHeight-100, ScreenWidth-100, 100)];
    [self.view addSubview:textLab];
    textLab.text = @"—— Version 1.0.1 ——";
    textLab.textColor = RGBACOLOR(98, 148, 228, 1);
    textLab.textAlignment = NSTextAlignmentCenter;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

@end
