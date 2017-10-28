//
//  TYDP_CaptchaController.m
//  
//
//  Created by 范井泉 on 16/7/20.
//
//

#import "TYDP_CaptchaController.h"
#import "TYDPManager.h"

#define startTime 60
@interface TYDP_CaptchaController ()
{
    NSTimer *_timer;
    int _secondTime;
}
@property (weak, nonatomic) IBOutlet UILabel *numLab;//手机尾号
@property (weak, nonatomic) IBOutlet UITextField *numTF;//验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;//取消按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;//确定按钮
- (IBAction)cancelClick;
- (IBAction)sureClick;

@end

@implementation TYDP_CaptchaController

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
    [self postData];
    
    self.numLab.text = [self.mobileNum substringFromIndex:7];
        
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    self.numTF.layer.borderWidth = 1;
    self.numTF.layer.borderColor = [RGBACOLOR(232, 232, 232, 1) CGColor];
    self.numTF.keyboardType = UIKeyboardTypeNumberPad;
    self.numTF.tag = 100;
    
    self.sendBtn.layer.borderWidth = 1;
    self.sendBtn.layer.borderColor = [RGBACOLOR(232, 232, 232, 1) CGColor];
    
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.borderColor = [RGBACOLOR(232, 232, 232, 1) CGColor];
    
    self.sureBtn.layer.borderWidth = 1;
    self.sureBtn.layer.borderColor = [RGBACOLOR(232, 232, 232, 1) CGColor];
    
    //设置定时器按钮
    [self.sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn.userInteractionEnabled = NO;
    
    _secondTime = startTime;
    
    //设置定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
}

- (void)timerRun{
    if (_secondTime == 0) {
        _timer.fireDate = [NSDate distantFuture];
        [self.sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.sendBtn setTitle:@"点击重发"forState:UIControlStateNormal];
        self.sendBtn.userInteractionEnabled = YES;
    }else{
        [self.sendBtn setTitle:[NSString stringWithFormat:@"%d秒后重发",_secondTime] forState:UIControlStateNormal];
        _secondTime = _secondTime-_timer.timeInterval;
    }
}

- (void)sendBtnClick{
    _secondTime = startTime;
    _timer.fireDate = [NSDate distantPast];
    self.sendBtn.userInteractionEnabled = NO;
    [self.sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self postData];
}

- (void)postData{
    NSDictionary *params = @{@"model":@"user",@"action":@"send_mobile_code",@"mobile":self.mobileNum,@"mobile_sign":[TYDPManager md5:[NSString stringWithFormat:@"%@%@",self.mobileNum,ConfigNetAppKey]],@"sign":[TYDPManager md5:[NSString stringWithFormat:@"usersend_mobile_code%@",ConfigNetAppKey]]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            _timer.fireDate = [NSDate distantPast];
        }else{
            NSLog(@"%@",data[@"message"]);
        }
    } failure:^(TYDPError *error) {
    }];
}

//取消按钮
- (IBAction)cancelClick {
    [self.view removeFromSuperview];
}

//确定按钮
- (IBAction)sureClick {
    
}

//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField *tf = (UITextField *)[self.view viewWithTag:100];
    // 放弃响应（収键盘）
    [tf resignFirstResponder];
}

@end
