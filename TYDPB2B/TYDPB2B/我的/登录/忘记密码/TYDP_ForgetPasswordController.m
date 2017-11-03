//
//  TYDP_ForgetPasswordController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/31.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_ForgetPasswordController.h"

#define startTime 60
@interface TYDP_ForgetPasswordController ()<UITextFieldDelegate>
{
    NSTimer *_timer;
    int _sendTime;
    MBProgressHUD *_MBHUD;
}
@property (weak, nonatomic) IBOutlet UITextField *quhaoField;
@property (strong, nonatomic) IBOutlet UITextField *mobileTf;//手机号
@property (strong, nonatomic) IBOutlet UITextField *passwordTf;//密码
@property (strong, nonatomic) IBOutlet UITextField *codeTf;//验证码
@property (strong, nonatomic) IBOutlet UIButton *getCodeBtn;//获取验证码
- (IBAction)sureBtnClick;

@end

@implementation TYDP_ForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _quhaoField.placeholder=NSLocalizedString(@"Your phone Country Code(default:0086)", nil);

    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatUI{
    self.mobileTf.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
    self.mobileTf.leftViewMode = UITextFieldViewModeAlways;
    self.mobileTf.delegate=self;
    self.codeTf.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_message"]];
    self.codeTf.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTf.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password"]];
    self.passwordTf.leftViewMode = UITextFieldViewModeAlways;
    
    self.getCodeBtn.layer.cornerRadius = self.getCodeBtn.frame.size.height/2;//设置那个圆角的有多圆
    self.getCodeBtn.layer.borderWidth =1;//设置边框的宽度，当然可以不要
    self.getCodeBtn.layer.borderColor = [mainColor CGColor];//设置边框的颜色
    self.getCodeBtn.layer.masksToBounds = YES;//设为NO去试试
    [self.getCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
    _sendTime = startTime;
}

- (void)timerRun{
    if (_sendTime == 0) {
        _timer.fireDate = [NSDate distantFuture];
        [self.getCodeBtn setTitle:NSLocalizedString(@"Resend",nil) forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled = YES;
        _sendTime = startTime;
    }else{
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%d",_sendTime] forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled = NO;
        _sendTime = _sendTime - _timer.timeInterval;
    }
}

- (void)getCodeBtnClick{
    
    [self getCodeRequest];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 15 && range.length == 0 &&textField==_mobileTf)
    {
        return NO; // return NO to not change text
    }
    else
    {
        return YES;
    }
}
- (void)getCodeRequest{
    if (_mobileTf.text.length == 0) {
        [_MBHUD setLabelText:NSLocalizedString(@"Enter Real Phone No.", nil)];
        [_MBHUD hide:YES afterDelay:1];
        return;
    }
    
    NSDictionary *params = @{@"model":@"user",@"action":@"send_mobile_code",@"mobile":self.mobileTf.text,@"mobile_sign":[TYDPManager md5:[NSString stringWithFormat:@"%@%@",self.mobileTf.text,ConfigNetAppKey]],@"sign":[TYDPManager md5:[NSString stringWithFormat:@"usersend_mobile_code%@",ConfigNetAppKey]],@"nation_code":_quhaoField.text};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            _timer.fireDate = [NSDate distantPast];
        }else{
            NSLog(@"---error:%@---",data[@"message"]);
        }
    } failure:^(TYDPError *error) {
        NSLog(@"---error:%@---",error);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"忘记密码界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"忘记密码界面"];
}

- (IBAction)sureBtnClick {
    [self creatHUD];
    if (self.passwordTf.text.length<6) {
        NSLog(@"密码长度不小于6位");
        [_MBHUD setMode:MBProgressHUDModeText];
        [_MBHUD setLabelText:@"密码长度不小于6位"];
        [_MBHUD hide:YES afterDelay:1.5];
    }else{
        [self postDataSureBtnClick];
    }
}

- (void)postDataSureBtnClick{
    NSDictionary *params = @{@"model":@"user",@"action":@"forget_password",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userforget_password%@",ConfigNetAppKey]],@"mobile":self.mobileTf.text,@"password":self.passwordTf.text,@"code":self.codeTf.text};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [_MBHUD setMode:MBProgressHUDModeText];
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1.5];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setMode:MBProgressHUDModeText];
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [_MBHUD hide:YES afterDelay:1.5];
    }];
}

- (void)creatHUD{
    if (!_MBHUD) {
        _MBHUD = [MBProgressHUD new];
        [self.view addSubview:_MBHUD];
    }
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeIndeterminate];
    [_MBHUD setLabelText:nil];
    [_MBHUD show:YES];
}

@end
