//
//  TYDP_offerIntroViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/11.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "TYDP_offerIntroViewController.h"

@interface TYDP_offerIntroViewController ()
@property(nonatomic, strong)UIView *navigationBarView;

@end

@implementation TYDP_offerIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    
    // Do any additional setup after loading the view.
}
#pragma mark 设置导航栏
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    [self.view addSubview:_navigationBarView];
    _navigationBarView.backgroundColor=mainColor;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationBarView addSubview:backButton];
    UIImage *backButtonImage = [UIImage imageNamed:@"navi_return_btn_nor"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 0)];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navigationBarView).with.offset(Gap);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100*(backButtonImage.size.height/backButtonImage.size.width));
    }];
    UILabel *navigationLabel = [UILabel new];
    [_navigationBarView addSubview:navigationLabel];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setTextColor:[UIColor whiteColor]];
    [navigationLabel setText:[NSString stringWithFormat:@"报盘标识说明"]];
    [navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(ScreenWidth/3);
        make.height.mas_equalTo(25);
    }];
    [self createBottomUI:_navigationBarView];
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"报盘标识说明"];
}
- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"报盘术语说明"];
}
- (void)viewDidDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)leftItemClicked:(UIBarButtonItem *)item{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createBottomUI:(UIView *)frontView {
    self.view.backgroundColor=[UIColor grayColor];
    UIImage *bottomImage = [UIImage imageNamed:@"img_note"];
    UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:bottomImage];
    [self.view addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(Gap);
        make.top.equalTo(_navigationBarView.mas_bottom).with.offset(20);
        make.right.equalTo(self.view).with.offset(-Gap);
        make.height.mas_equalTo((ScreenWidth-2*Gap)*(bottomImage.size.height/bottomImage.size.width));
    }];
    UIImageView *topDecorateImageView = [UIImageView new];
    UIImage *topDecorateImage = [UIImage imageNamed:@"offer_img_introduce"];
    [topDecorateImageView setImage:topDecorateImage];
    NSInteger topDecorateImageHeight = 90*(topDecorateImage.size.height/topDecorateImage.size.width);
    [bottomImageView addSubview:topDecorateImageView];
    [topDecorateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomImageView).with.offset(-5);
        make.left.equalTo(bottomImageView).with.offset(MiddleGap);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(topDecorateImageHeight);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
