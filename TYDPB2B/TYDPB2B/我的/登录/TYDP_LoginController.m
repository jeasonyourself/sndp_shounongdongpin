//
//  TYDP_LoginController.m
//  B2Bmine
//
//  Created by 范井泉 on 16/7/13.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_LoginController.h"
#import "TYDP_RegistController.h"
#import "TYDPManager.h"
#import "TYDP_UserInfoModel.h"
#import "TYDP_ForgetPasswordController.h"
#import "ZYTabBar.h"
#import "TYDP_BangDingViewController.h"
#import <UMSocialCore/UMSocialCore.h>
@interface TYDP_LoginController ()
@property(nonatomic, strong)MBProgressHUD *MBHUD;
@property (weak, nonatomic) IBOutlet UITextField *numTf;//请输入手机号tf
@property (weak, nonatomic) IBOutlet UITextField *passTf;//请输入密码tf
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;

- (IBAction)forgetPasswordBtnClick;
- (IBAction)wechatLoginClick;//微信登录按钮
- (IBAction)qqLoginClick;//qq登录按钮

@end

@implementation TYDP_LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=NSLocalizedString(@"Login", nil);
    self.tabBarController.tabBar.hidden = YES;
    [self creatUI];
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
    [self creatHUD];
    NSString *sign = [NSString stringWithFormat:@"userlogin%@",ConfigNetAppKey];
    NSDictionary *params = @{@"model":@"user",@"action":@"login",@"user_name":self.numTf.text,@"password":self.passTf.text,@"sign":[TYDPManager md5:sign],@"device_type":@"1",@"device_token":[PSDefaults objectForKey:@"device_token"]?[PSDefaults objectForKey:@"device_token"]:@""};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        debugLog(@"loginnnnData:%@",data);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            NSUserDefaults *userdefauls = [NSUserDefaults standardUserDefaults];
            [userdefauls setObject:data[@"content"][@"token"] forKey:@"token"];
            [userdefauls setObject:data[@"content"][@"user_id"] forKey:@"user_id"];
            [userdefauls setObject:data[@"content"][@"user_name"] forKey:@"user_name"];
            [userdefauls setObject:data[@"content"][@"mobile_phone"] forKey:@"mobile_phone"];
            [userdefauls setObject:data[@"content"][@"alias"] forKey:@"alias"];
            [userdefauls setObject:data[@"content"][@"user_face"] forKey:@"user_face"];
             [userdefauls setObject:data[@"content"][@"user_rank"] forKey:@"user_rank"];
            
            [userdefauls synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",data[@"message"]]];
            [_MBHUD hide:YES afterDelay:1.5f];
            NSLog(@"%@",data[@"message"]);
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        NSLog(@"%@",error);
    }];
}

- (void)creatUI{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    
    //加载xib文件
    [[NSBundle mainBundle] loadNibNamed:@"TYDP_LoginController" owner:self options:nil];
    
    //手机号输入框左视图
    UIImageView *numImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
    self.numTf.leftView = numImg;
    self.numTf.leftViewMode = UITextFieldViewModeAlways;
    
    //密码输入框左视图
    UIImageView *passImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password"]];
    self.passTf.leftView = passImg;
    self.passTf.leftViewMode = UITextFieldViewModeAlways;
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.frame = CGRectMake(40, _forgetPasswordBtn.mj_h+_forgetPasswordBtn.mj_y+10, ScreenWidth-80, 40);
    loginBtn.backgroundColor = mainColor;
    [loginBtn setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 20*Height;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //注册按钮
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registBtn.frame = CGRectMake(-1, ScreenHeight- 40*Height, ScreenWidth+2, 41*Height);
    [registBtn setTitle:NSLocalizedString(@"No account? Register now!", nil) forState:UIControlStateNormal];
    [registBtn setTitleColor:mainColor forState:UIControlStateNormal];
    registBtn.layer.borderWidth = 1;
    registBtn.layer.borderColor = [mainColor CGColor];
//    registBtn.layer.cornerRadius = 20*Height;
    [registBtn addTarget:self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
}

- (void)retBtnClick{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginBtnClick{
//    if ((self.numTf.text.length>.6)&&(self.passTf.text.length>6)) {
//        [self requestData];
//    }else{
//        NSLog(@"请填写账号和密码");
//    }
    [self requestData];
    NSLog(@"登录");
}

- (void)registBtnClick{
    TYDP_RegistController *registVC = [TYDP_RegistController new];
    [self.navigationController pushViewController:registVC animated:YES];
    NSLog(@"注册");
}

- (IBAction)forgetPasswordBtnClick {
    NSLog(@"忘记密码");
    TYDP_ForgetPasswordController *forgrtPasswordVC = [TYDP_ForgetPasswordController new];
    [self.navigationController pushViewController:forgrtPasswordVC animated:YES];
}

- (IBAction)wechatLoginClick {
    debugLog(@"微信登录");
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            debugLog(@"kfhsdjfhsj");
        }
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        NSDictionary * userDic =(NSDictionary *)resp.originalResponse;
        NSString *sign = [NSString stringWithFormat:@"%@%@%@",@"login",@"wxLogin",ConfigNetAppKey];
         NSUserDefaults *userdefauls = [NSUserDefaults standardUserDefaults];
        NSDictionary *params = @{@"model":@"login",@"action":@"wxLogin",@"openid":userDic[@"openid"],@"unionid":userDic[@"unionid"],@"sign":[TYDPManager md5:sign]};
        [self creatHUD];
        [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
            
            debugLog(@"wxLogindata:%@",data);
            if ([data[@"error"]isEqualToString:@"0"]) {
                [_MBHUD hide:YES];
                NSUserDefaults *userdefauls = [NSUserDefaults standardUserDefaults];
                [userdefauls setObject:data[@"content"][@"token"] forKey:@"token"];
                [userdefauls setObject:data[@"content"][@"user_id"] forKey:@"user_id"];
                [userdefauls setObject:data[@"content"][@"user_name"] forKey:@"user_name"];
                [userdefauls setObject:data[@"content"][@"mobile_phone"] forKey:@"mobile_phone"];
                [userdefauls setObject:data[@"content"][@"alias"] forKey:@"alias"];
                [userdefauls setObject:data[@"content"][@"user_face"] forKey:@"user_face"];
                [userdefauls synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([data[@"error"]isEqualToString:@"301"])
            {
                [_MBHUD hide:YES];
                
                TYDP_BangDingViewController *bangDingVC = [TYDP_BangDingViewController new];
                bangDingVC.userDic=userDic;
                [self.navigationController pushViewController:bangDingVC animated:YES];
                NSLog(@"绑定");
            }
            else{
                [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",data[@"message"]]];
                [_MBHUD hide:YES afterDelay:1.5f];
                NSLog(@"%@",data[@"message"]);
            }
        } failure:^(TYDPError *error) {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
            NSLog(@"%@",error);
        }];

    }];
}

- (IBAction)qqLoginClick {
    NSLog(@"QQ登录");
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    
//    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    [MobClick endLogPageView:@"登录界面"];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=YES;
//    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bggradient_person_"] forBarMetrics:UIBarMetricsDefault];
    [MobClick beginLogPageView:@"登录界面"];
}

//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.passTf resignFirstResponder];
    [self.numTf resignFirstResponder];
}

@end
