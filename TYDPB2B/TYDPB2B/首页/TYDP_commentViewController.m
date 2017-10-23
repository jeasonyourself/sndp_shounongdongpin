//
//  TYDP_commentViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/14.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "TYDP_commentViewController.h"

@interface TYDP_commentViewController ()
{
    UITextView * pubTextView;
}
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)MBProgressHUD *MBHUD;

@end

@implementation TYDP_commentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self createWholeUI];
    // Do any additional setup after loading the view.
}

- (void)createWholeUI{
    
    _MBHUD = [[MBProgressHUD alloc] init];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    
    self.view.backgroundColor=[UIColor whiteColor];
    pubTextView =[UITextView new];
    pubTextView.text=@"";
    pubTextView.font=[UIFont systemFontOfSize:15.0];
    pubTextView.textColor=[UIColor lightGrayColor];
    [self.view addSubview:pubTextView];
    [pubTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo((ScreenWidth-100)*3/5);
    }];
    [pubTextView becomeFirstResponder];

    UILabel *bottomDecorateLabel = [UILabel new];
    [bottomDecorateLabel setFont:ThemeFont(13)];
    [bottomDecorateLabel setBackgroundColor:mainColor];
    [self.view addSubview:bottomDecorateLabel];
    [bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pubTextView);
        make.right.equalTo(pubTextView);
        make.bottom.equalTo(pubTextView);
        make.height.mas_equalTo(HomePageBordWidth);
    }];
    
    UIButton * bottomBtn =[UIButton new];
    bottomBtn.backgroundColor=mainColor;
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font=[UIFont systemFontOfSize:13.0];
    [bottomBtn setTitle:@"发布" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(pubCommentText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomDecorateLabel.mas_bottom).with.offset(50);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo(50.0);
    }];

}

- (void)pubCommentText{
    if (pubTextView.text&&![pubTextView.text isEqualToString:@""]) {
        //pages are bigger than 1
    } else {
        [self.view Message:@"留言不能为空" HiddenAfterDelay:1.0];
        return;
    }
    [_MBHUD setLabelText:@"稍等片刻。。。"];
    [self.view addSubview:_MBHUD];
    [_MBHUD show:YES];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"purchase",@"addComment",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"addComment",@"sign":[TYDPManager md5:Sign],@"model":@"purchase",@"p_id":self.qiugou_id,@"user_id":[PSDefaults objectForKey:@"user_id"],@"content":pubTextView.text}];
    NSLog(@"commentparams:%@",params);
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        NSLog(@"commentdata:%@",data);
        if (![data[@"error"] intValue]) {
            [_MBHUD show:YES];
            [self leftItemClicked:nil];
            [self.delegate pubcomment:0];
           
        } else {
           
        }
    } failure:^(TYDPError *error) {
        [self.view Message:[NSString stringWithFormat:@"%@",error] HiddenAfterDelay:1.0];
    }];
}


#pragma mark 设置导航栏
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.backgroundColor=mainColor;
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    [self.view addSubview:_navigationBarView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationBarView addSubview:backButton];
    UIImage *backButtonImage = [UIImage imageNamed:@"product_icon_return"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30*(backButtonImage.size.height/backButtonImage.size.width));
    }];
    
    UILabel *titleLable = [UILabel new];
    [_navigationBarView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [titleLable setText:@"求购留言"];
    
    titleLable.textColor=[UIColor whiteColor];
    [titleLable setFont:ThemeFont(16)];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    
    
    
}
- (void)leftItemClicked:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [MobClick beginLogPageView:@"求购留言界面"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"求购留言界面"];
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
