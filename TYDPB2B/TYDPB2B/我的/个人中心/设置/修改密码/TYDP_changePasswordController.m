//
//  TYDP_changePasswordController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/19.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_changePasswordController.h"

@interface TYDP_changePasswordController ()
{
    NSString *_oldPassword;
    NSString *_newPassword;
    MBProgressHUD *_MBHUD;
}
@end

@implementation TYDP_changePasswordController

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
    
    //logo
    UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_ch"]];
    logoImg.frame = CGRectMake(ScreenWidth/2-38*Width, 36*Height+NavHeight, 95*Width, 95*Height);
    [self.view addSubview:logoImg];
    
    NSArray *titleArr = @[@"输入旧密码",@"输入新密码",@"再次输入新密码"];
    //三行输入框
    for (int i = 0; i<3; i++) {
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(55*Width, (150+55*i)*Height+NavHeight, ScreenWidth-110*Width, 55*Height)];
        [self.view addSubview:tf];
        tf.tag = 100+i;
        tf.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password"]];
        tf.background = [UIImage imageNamed:@"login_input"];
        tf.leftViewMode = UITextFieldViewModeAlways;
        tf.placeholder = [NSString stringWithFormat:@"  %@",titleArr[i]];
        tf.secureTextEntry = YES;
        tf.clearButtonMode = UITextFieldViewModeAlways;
    }
    
    //保存按钮
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(55*Width, 416*Height+NavHeight, ScreenWidth-100*Width, 45*Height);
    btn.backgroundColor = mainColor;
    btn.layer.cornerRadius = 22.5*Height;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

//保存按钮点击事件
- (void)saveBtnClick{
    NSLog(@"保存");
    [self creatHUD];
    UITextField *oldTf = (UITextField *)[self.view viewWithTag:100];
    _oldPassword = oldTf.text;
    UITextField *newTf1 = (UITextField *)[self.view viewWithTag:101];
    UITextField *newTf2 = (UITextField *)[self.view viewWithTag:102];
    if ([newTf1.text isEqualToString:newTf2.text]) {
        _newPassword = newTf2.text;
        [self requestData];
    }else{
        [_MBHUD setMode:MBProgressHUDModeText];
        [_MBHUD setLabelText:@"两次输入密码不一样"];
        [_MBHUD hide:YES afterDelay:1];
        NSLog(@"两次输入密码不一样");
    }
}

- (void)creatHUD{
    if (!_MBHUD) {
        _MBHUD = [[MBProgressHUD alloc] init];
        [self.view addSubview:_MBHUD];
    }
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [_MBHUD show:YES];
}

- (void)requestData{
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"model":@"user",@"action":@"edit_password",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"useredit_password%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"],@"password":_oldPassword,@"new_password":_newPassword,@"token":[userdefaul objectForKey:@"token"]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [_MBHUD setMode:MBProgressHUDModeText];
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setMode:MBProgressHUDModeText];
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [_MBHUD hide:YES afterDelay:1];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"修改密码界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"修改密码界面"];
}
@end
