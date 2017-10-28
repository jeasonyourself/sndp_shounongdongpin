//
//  TYDP_BangDingViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/19.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "TYDP_BangDingViewController.h"
#import "TYDPManager.h"
#define startTime 60


@interface TYDP_BangDingViewController ()
{
    NSTimer *_timer;
    int _secondTime;
}

@property(nonatomic, strong)MBProgressHUD *MBHUD;
@end

@implementation TYDP_BangDingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Bind account", nil);
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
    //logo
    UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_ch"]];
    logoImg.frame = CGRectMake(ScreenWidth/2-38*Width, 64+36*Height, 95*Width, 95*Height);
    //    [self.view addSubview:logoImg];
    
    //四行输入框
    NSArray *placeholderArr = @[NSLocalizedString(@"Your phone Country Code(default:0086)", nil),NSLocalizedString(@"Your phone NO.", nil),NSLocalizedString(@"Verification code", nil),NSLocalizedString(@"password", nil)];
    //    NSArray *leftviewArr = @[@"login_phone",@"login_message",@"login_password",@"login_verification"];
    for (int i = 0; i<4; i++) {
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(15, 64+(55*i)*Height, ScreenWidth-30, 55*Height)];
        tf.tag = 100+i;
        [self.view addSubview:tf];
        tf.background = [UIImage imageNamed:@"login_input"];
        tf.placeholder = placeholderArr[i];
        
        if (i<2) {
            tf.keyboardType=UIKeyboardTypePhonePad;
        }
        //        UIImageView *tfImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:leftviewArr[i]]];
        //        tf.leftView = tfImg;
        //        tf.leftViewMode = UITextFieldViewModeAlways;
        //        tf.clearButtonMode = UITextFieldViewModeAlways;
        
        if (i == 1) {//获取验证码Btn
            tf.clearButtonMode = UITextFieldViewModeNever;
            UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Btn.frame = CGRectMake(tf.frame.size.width-80*Width-20, 15*Height, 80*Width, 25*Height);
            [tf addSubview:Btn];
            Btn.tag = 500;
            Btn.layer.borderWidth = 0.5;
            Btn.layer.borderColor = [mainColor CGColor];
            [Btn setTitleColor:mainColor forState:UIControlStateNormal];
            Btn.titleLabel.font = [UIFont systemFontOfSize:13];
            Btn.layer.cornerRadius = 12.5*Height;
            [Btn setTitle:NSLocalizedString(@"Get code", nil)forState:UIControlStateNormal];
            [Btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 2){//输入密码
            tf.secureTextEntry = YES;
        }else if (i == 3){//验证码图片
            
        }
    }
    
    
    //注册按钮背景
    UIView *registBgView = [UIView new];
    registBgView.frame = CGRectMake(-1, ScreenHeight- 60*Height, ScreenWidth+2, 61*Height);
    [registBgView setBackgroundColor:[UIColor whiteColor]];
    registBgView.layer.borderWidth = 1;
    registBgView.layer.borderColor = [RGBACOLOR(45, 125, 220, 1)CGColor];
    [self.view addSubview:registBgView];
    
    //注册按钮
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registBtn.frame = CGRectMake(40, 10, ScreenWidth-80, 40*Height);
    registBtn.backgroundColor = mainColor;
    [registBtn setTitle:NSLocalizedString(@"binding", nil) forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    registBtn.layer.cornerRadius = 22.5*Height;
    registBtn.layer.masksToBounds = YES;
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [registBgView addSubview:registBtn];
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(40, 64+476*Height, ScreenWidth-80, 45*Height);
    [loginBtn setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    loginBtn.layer.cornerRadius = 22.5*Height;
    loginBtn.layer.borderColor = [mainColor CGColor];
    loginBtn.layer.borderWidth = 1;
    [loginBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:loginBtn];
    
    _secondTime = startTime;
    //设置定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
}

- (void)timerRun{
    UIButton *btn = [(UIButton *)self.view viewWithTag:500];
    if (_secondTime == 0) {
        _timer.fireDate = [NSDate distantFuture];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString(@"Click retransmission", nil)forState:UIControlStateNormal];
        [btn setTitleColor:mainColor forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
    }else{
        btn.userInteractionEnabled = NO;
        [btn setTitle:[NSString stringWithFormat:@"%d%@",_secondTime,NSLocalizedString(@"seconds", nil)] forState:UIControlStateNormal];
        _secondTime = _secondTime-_timer.timeInterval;
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

//注册按钮
- (void)registBtnClick{
    [self creatHUD];
    UITextField *tf1 = (UITextField *)[self.view viewWithTag:101];
    UITextField *tf2 = (UITextField *)[self.view viewWithTag:102];
    UITextField *tf3 = (UITextField *)[self.view viewWithTag:103];
//    UITextField *tf4 = (UITextField *)[self.view viewWithTag:103];
//    if (![tf3.text isEqualToString:tf4.text]) {
//        [_MBHUD setLabelText:@"两次输入的密码不一致。"];
//        [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
//        [_MBHUD setMode:MBProgressHUDModeText];
//        [_MBHUD show:YES];
//        [_MBHUD hide:YES afterDelay:1.5f];
//        return;
//    }
    NSString *sign = [NSString stringWithFormat:@"loginbinding%@",ConfigNetAppKey];
    NSDictionary *params = @{@"model":@"login",@"action":@"binding",@"mobile_phone":tf1.text,@"password":tf3.text,@"mobile_code":tf2.text,@"openid":_userDic[@"openid"],@"unionid":_userDic[@"unionid"],@"user_name":_userDic[@"headimgurl"],@"user_face":_userDic[@"nickname"],@"sign":[TYDPManager md5:sign]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        debugLog(@"bangdingUser:%@",data);
        debugLog(@"%@",data[@"message"]);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD setLabelText:NSLocalizedString(@"Success", nil)];
            [_MBHUD hide:YES afterDelay:1.5f];
            debugLog(@"绑定成功");
            NSUserDefaults *userdefauls = [NSUserDefaults standardUserDefaults];
            [userdefauls setObject:data[@"content"][@"token"] forKey:@"token"];
            [userdefauls setObject:data[@"content"][@"user_id"] forKey:@"user_id"];
            [userdefauls setObject:data[@"content"][@"user_name"] forKey:@"user_name"];
            [userdefauls setObject:data[@"content"][@"mobile_phone"] forKey:@"mobile_phone"];
            [userdefauls setObject:data[@"content"][@"alias"] forKey:@"alias"];
            [userdefauls setObject:data[@"content"][@"user_face"] forKey:@"user_face"];
            [userdefauls synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",data[@"message"]]];
            [_MBHUD hide:YES afterDelay:1.5f];
            NSLog(@"%@",data[@"message"]);
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        NSLog(@"---error:%@---",error);
    }];
}

//获取验证码
- (void)btnClick{
    NSLog(@"获取验证码");
    [self creatHUD];
    UITextField *tf1 = (UITextField *)[self.view viewWithTag:100];
    UITextField *tf = (UITextField *)[self.view viewWithTag:101];
    NSString *sign = [NSString stringWithFormat:@"usersend_mobile_code%@",ConfigNetAppKey];
    NSDictionary *params = @{@"model":@"user",@"action":@"send_mobile_code",@"mobile":tf.text,@"mobile_sign":[TYDPManager md5:[NSString stringWithFormat:@"%@%@",tf.text,ConfigNetAppKey]],@"sign":[TYDPManager md5:sign],@"nation_code":tf1.text};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        NSLog(@"%@",data);
        NSLog(@"%@",data[@"message"]);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            _secondTime = startTime;
            _timer.fireDate = [NSDate distantPast];
        }else{
            NSLog(@"%@",data[@"message"]);
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",data[@"message"]]];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    //    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"注册界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"注册界面"];
    //    self.navigationController.navigationBar.hidden = NO;
}

//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (int i = 100; i<105; i++) {
        UITextField *tf = (UITextField *)[self.view viewWithTag:i];
        [tf resignFirstResponder];
    }
}

@end
