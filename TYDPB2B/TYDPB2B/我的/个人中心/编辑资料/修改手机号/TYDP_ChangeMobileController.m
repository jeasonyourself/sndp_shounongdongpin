//
//  TYDP_ChangeMobileController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/25.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_ChangeMobileController.h"

#define startTime 60
@interface TYDP_ChangeMobileController ()<UITextFieldDelegate>
{
    MBProgressHUD *_MBHUD;
    UIButton *_reinputBtn;
    UIImageView *_reintputImg;
    NSTimer *_timer;
    int _startTime;
}
@property (strong, nonatomic) IBOutlet UIButton *getNumBtn;//获取验证码按钮
@property (strong, nonatomic) IBOutlet UITextField *mobileTf;//手机号输入框
@property (strong, nonatomic) IBOutlet UITextField *numTf;//验证码输入框
@property (strong, nonatomic) IBOutlet UILabel *oldMobileLab;//当前手机号
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;//提交按钮
- (IBAction)postDataWithSureBtnClick;

@end

@implementation TYDP_ChangeMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatUI{
    self.oldMobileLab.text = self.oldMobile;
    
    self.sureBtn.userInteractionEnabled = NO;
    self.getNumBtn.userInteractionEnabled = YES;
    self.getNumBtn.layer.cornerRadius = 5;
    self.getNumBtn.layer.borderWidth = 0.5;
    self.getNumBtn.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.getNumBtn addTarget:self action:@selector(sendNumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.mobileTf.delegate = self;
    self.numTf.delegate = self;
    [self.mobileTf addTarget:self action:@selector(btnChangeColor) forControlEvents:UIControlEventEditingChanged];
    [self.numTf addTarget:self action:@selector(btnChangeColor) forControlEvents:UIControlEventEditingChanged];
    
    _reinputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _reinputBtn.frame = CGRectMake(ScreenWidth-200, 7.5, 50, 50);
    [_reinputBtn addTarget:self action:@selector(reinputClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _reintputImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_icon_cancel"]];
    _reintputImg.frame = CGRectMake(ScreenWidth-185, 22.5, 20, 20);

    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
    _startTime = startTime;
}

- (void)timerRun{
    if (_startTime == 0) {
        _timer.fireDate = [NSDate distantFuture];
        [self.getNumBtn setTitle:@"点击重发" forState:UIControlStateNormal];
        self.getNumBtn.userInteractionEnabled = YES;
        _startTime = startTime;
    }else{
        self.getNumBtn.userInteractionEnabled = NO;
        [self.getNumBtn setTitle:[NSString stringWithFormat:@"%d秒后重发",_startTime] forState:UIControlStateNormal];
        _startTime = _startTime-_timer.timeInterval;
    }
}

//发送验证码
- (void)sendNumBtnClick{
    [self creatHUD];
    if (self.mobileTf.text.length == 11) {
        [self getMobileCode];
        _timer.fireDate = [NSDate distantPast];
    }else{
        [_MBHUD setLabelText:@"请输入正确的手机号"];
        [_MBHUD hide:YES afterDelay:1];
    }
}

- (void)reinputClick:(UIButton *)sender{
    UITextField *tf = (UITextField *)sender.superview;
    tf.text = NULL;
    [self btnChangeColor];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField addSubview:_reinputBtn];
    [textField addSubview:_reintputImg];
}

//监听输入框字数改变按钮状态
- (void)btnChangeColor{
    if (self.mobileTf.text.length == 11) {
        if (self.numTf.text.length == 6) {
            [self.sureBtn setBackgroundColor:RGBACOLOR(226, 114, 27, 1)];
            self.sureBtn.userInteractionEnabled = YES;
            self.getNumBtn.backgroundColor = RGBACOLOR(226, 114, 27, 1);
            self.getNumBtn.layer.borderColor = [RGBACOLOR(226, 114, 27, 1) CGColor];
            [self.getNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.getNumBtn.userInteractionEnabled = YES;
        }else{
            [self.sureBtn setBackgroundColor:RGBACOLOR(134, 134, 134, 1)];
            self.sureBtn.userInteractionEnabled = NO;
            self.getNumBtn.backgroundColor = RGBACOLOR(226, 114, 27, 1);
            self.getNumBtn.layer.borderColor = [RGBACOLOR(226, 114, 27, 1) CGColor];
            [self.getNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.getNumBtn.userInteractionEnabled = YES;
        }
    }else{
        [self.sureBtn setBackgroundColor:RGBACOLOR(134, 134, 134, 1)];
        self.sureBtn.userInteractionEnabled = NO;
        self.getNumBtn.backgroundColor = [UIColor whiteColor];
        self.getNumBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        [self.getNumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.getNumBtn.userInteractionEnabled = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_reinputBtn removeFromSuperview];
    [_reintputImg removeFromSuperview];
}

- (void)creatHUD{
    if (!_MBHUD) {
        _MBHUD = [[MBProgressHUD alloc] init];
        [self.view addSubview:_MBHUD];
    }
    [_MBHUD setLabelText:@"稍等片刻。。。"];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [_MBHUD show:YES];
}

- (void)getMobileCode{
    NSDictionary *params = @{@"model":@"user",@"action":@"send_mobile_code",@"mobile":self.mobileTf.text,@"mobile_sign":[TYDPManager md5:[NSString stringWithFormat:@"%@%@",self.mobileTf.text,ConfigNetAppKey]],@"sign":[TYDPManager md5:[NSString stringWithFormat:@"usersend_mobile_code%@",ConfigNetAppKey]]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            //            _timer.fireDate = [NSDate distantPast];
        }else{
            [_MBHUD setMode:MBProgressHUDModeText];
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1];
            NSLog(@"%@",data[@"message"]);
        }
    } failure:^(TYDPError *error) {
    }];
}

//体交按钮，判断手机号与短信验证码是否一致
- (IBAction)postDataWithSureBtnClick {
    [self creatHUD];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"model":@"user",@"action":@"change_mobile",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userchange_mobile%@",ConfigNetAppKey]],@"mobile":self.mobileTf.text,@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"code":self.numTf.text};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            NSLog(@"提交");
            [_MBHUD hide:YES];
            self.Block(self.mobileTf.text);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [_MBHUD setMode:MBProgressHUDModeText];
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",data[@"message"]]];
            [_MBHUD hide:YES afterDelay:1.5];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setMode:MBProgressHUDModeText];
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [_MBHUD hide:YES afterDelay:1.5];

    }];
}

- (void)retMobileAndCodeBlock:(retBlock)block{
    self.Block = block;
}
- (void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"修改手机号界面"];
}
- (void)viewWillAppear:(BOOL)animated {
    [MobClick beginLogPageView:@"修改手机号界面"];
}

@end
