//
//  TYDP_SetController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/15.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_SetController.h"
#import "TYDP_changePasswordController.h"
#import "TYDP_AboutUsController.h"

@interface TYDP_SetController ()

@end

@implementation TYDP_SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"设置";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"修改登录密码",@"帮助中心",@"关于我们",@"清除缓存"];
    for (int i = 0; i<4; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 55*i*Height+NavHeight, ScreenWidth-40, 55*Height)];
        [self.view addSubview:lab];
        lab.text = arr[i];
        lab.userInteractionEnabled = YES;
        
        //灰色的线
        UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, 55*Height-1, ScreenWidth-40, 1)];
        [lab addSubview:grayLine];
        grayLine.backgroundColor = RGBACOLOR(217, 217, 217, 1);
        
        //右边图片
        if (i == 3) {
            UILabel *cacheLab = [UILabel new];
            [lab addSubview:cacheLab];
            cacheLab.text = [NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize] / 1000.0 / 1000.0];
            [cacheLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(lab);
                make.right.mas_equalTo(-10*Width);
            }];
            cacheLab.tag = 300;
        }else{
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_return_choose_nor"]];
            [lab addSubview:img];
            img.frame = CGRectMake(ScreenWidth - 40-10*Width, 17.5*Height, 10*Width, 20*Height);
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [lab addSubview:btn];
        btn.frame = CGRectMake(0, 0, ScreenWidth-40, 55*Height);
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //退出按钮
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:logoutBtn];
    logoutBtn.frame = CGRectMake(ScreenWidth/2-100*Width, 315*Height+NavHeight, 200*Width, 50*Height);
    logoutBtn.layer.cornerRadius = 5;
    logoutBtn.layer.borderWidth = 1;
    logoutBtn.layer.borderColor = [RGBACOLOR(234, 100, 62, 1) CGColor];
    [logoutBtn setTitleColor:RGBACOLOR(234, 100, 62, 1) forState:UIControlStateNormal];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag == 100) {
        TYDP_changePasswordController *cpwVC = [[TYDP_changePasswordController alloc]init];
        [self.navigationController pushViewController:cpwVC animated:YES];
    }else if (sender.tag == 101){
    
    }else if (sender.tag == 102){
        TYDP_AboutUsController *usVC = [[TYDP_AboutUsController alloc]init];
        [self.navigationController pushViewController:usVC animated:YES];
    }else {
        [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];
        UILabel *cacheLab = [self.view viewWithTag:300];
        cacheLab.text = [NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0];
        NSLog(@"清除缓存");
    }
}

- (void)logoutBtnClick{
    NSLog(@"退出登录");
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    [userdefaul removeObjectForKey:@"token"];
    [userdefaul removeObjectForKey:@"user_name"];
    [userdefaul removeObjectForKey:@"user_id"];
    [userdefaul removeObjectForKey:@"user_face"];
    [userdefaul removeObjectForKey:@"alias"];
    [userdefaul removeObjectForKey:@"mobile_phone"];
    [userdefaul removeObjectForKey:@"user_rank"];

    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"设置界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"设置界面"];
}
@end
