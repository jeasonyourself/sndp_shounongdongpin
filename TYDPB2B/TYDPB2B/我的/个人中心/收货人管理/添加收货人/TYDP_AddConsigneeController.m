//
//  TYDP_AddConsigneeController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/27.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_AddConsigneeController.h"

@interface TYDP_AddConsigneeController ()
{
    MBProgressHUD *_MBHUD;
}
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)saveBtnClickToPostData;
- (IBAction)seleteBtnClickToPostData;
@end

@implementation TYDP_AddConsigneeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatUI];
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    if (self.pushType == 1) {//添加联系人
        self.deleteBtn.hidden = YES;
    }
    self.IDnumberTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.phoneNumberTf.keyboardType = UIKeyboardTypeNumberPad;
    
    _codeBtn.layer.cornerRadius = _codeBtn.frame.size.height/2;//设置那个圆角的有多圆
    _codeBtn.layer.borderWidth =0;//设置边框的宽度，当然可以不要
    _codeBtn.layer.borderColor = nil;//设置边框的颜色
    _codeBtn.layer.masksToBounds = YES;//设为NO去试试

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    if (self.pushType == 0) {
        [self configUIWithModel];
    }
    [MobClick beginLogPageView:@"添加收货人界面"];
}

- (void)configUIWithModel{
    self.nameTf.text = self.model.name;
    self.phoneNumberTf.text = self.model.mobile;
    self.IDnumberTf.text = self.model.id_number;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"添加收货人界面"];
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

//增修收货地址接口
- (IBAction)saveBtnClickToPostData {
   
    if ([self.nameTf.text isEqualToString:@""]||[self.IDnumberTf.text isEqualToString:@""]) {
        [self.view Message:NSLocalizedString(@"Please improve necessary information", nil) HiddenAfterDelay:1.0];
        return;
    }
     [self creatHUD];
    if (self.phoneNumberTf.text.length!=11) {
        [_MBHUD setLabelText:NSLocalizedString(@"Enter Real Phone number", nil)];
        [_MBHUD hide:YES afterDelay:1.5f];
        NSLog(@"请输入正确手机号");
    }else{
        NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *params =[[NSMutableDictionary alloc]initWithDictionary: @{@"model":@"user",@"action":@"save_address",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"usersave_address%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"name":self.nameTf.text,@"id_number":self.IDnumberTf.text,@"mobile":self.phoneNumberTf.text,@"mobile_code":self.codeTf.text,@"type":[NSString stringWithFormat:@"%d",_type]}];
        if (self.pushType == 0) {
            [params setObject:self.model.Id forKey:@"id"];
        }
        [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
            //        NSLog(@"%@",data);
            if ([data[@"error"] isEqualToString:@"0"]) {
                NSLog(@"添加成功");
                [_MBHUD setLabelText:NSLocalizedString(@"Success", nil)];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [_MBHUD setLabelText:data[@"message"]];
                [_MBHUD hide:YES afterDelay:1.5f];
            }
        } failure:^(TYDPError *error) {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
            [_MBHUD hide:YES afterDelay:1];
            NSLog(@"---error:%@---",error);
        }];

    }
}

//删除收货地址接口
- (IBAction)seleteBtnClickToPostData {
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"model":@"user",@"action":@"del_address",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userdel_address%@",ConfigNetAppKey]],@"id":self.model.Id,@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"]};
    [TYDPManager tydp_baseGetReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            NSLog(@"删除成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(TYDPError *error) {
        
    }];
}

- (IBAction)codeBtnClick:(JKCountDownButton *)sender {
    if (self.phoneNumberTf.text.length!=11) {
        [_MBHUD setLabelText:NSLocalizedString(@"Enter Real Phone number", nil)];
        [_MBHUD hide:YES afterDelay:1.5f];
        debugLog(@"请输入正确手机号");
        return;
    }
    _codeBtn.enabled = NO;
    [_codeBtn startWithSecond:60];
    
    [_codeBtn didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"%d%@",second,NSLocalizedString(@"seconds", nil)];
        [_codeBtn setBackgroundColor:[UIColor lightGrayColor]];
        
        return title;
    }];
    [_codeBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        [_codeBtn setBackgroundColor:mainColor];
        
        return @"点击重新获取";
        
    }];
    
    [self creatHUD];
    UITextField *tf = (UITextField *)[self.view viewWithTag:100];
    NSString *sign = [NSString stringWithFormat:@"usersend_mobile_code%@",ConfigNetAppKey];
    NSDictionary *params = @{@"model":@"user",@"action":@"send_mobile_code",@"mobile":tf.text,@"mobile_sign":[TYDPManager md5:[NSString stringWithFormat:@"%@%@",tf.text,ConfigNetAppKey]],@"sign":[TYDPManager md5:sign]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        debugLog(@"addresssss%@",data);
        debugLog(@"%@",data[@"message"]);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            
        }else{
            NSLog(@"%@",data[@"message"]);
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",data[@"message"]]];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];    }];

    
}


@end
