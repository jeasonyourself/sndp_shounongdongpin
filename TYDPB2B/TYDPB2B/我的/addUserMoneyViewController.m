//
//  addUserMoneyViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/9.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "addUserMoneyViewController.h"

@interface addUserMoneyViewController ()
{
    MBProgressHUD *_MBHUD;
}
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)saveBtnClickToPostData;
- (IBAction)seleteBtnClickToPostData;
- (IBAction)saveMoRenBtnClick:(UIButton *)sender;
- (IBAction)saveMoRen_qihuoBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveMoRenBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveMoRen_qiHuoBtn;

@end

@implementation addUserMoneyViewController

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
    self.IDnumberTf.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumberTf.keyboardType = UIKeyboardTypeNumberPad;
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
    self.nameTf.text = self.model.username;
    self.phoneNumberTf.text = self.model.mobile;
    self.IDnumberTf.text = self.model.account;
    self.kaiHuHangTf.text = self.model.deposit_bank;
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
    [_MBHUD setLabelText:@"稍等片刻。。。"];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [_MBHUD show:YES];
}

//增修收货地址接口
- (IBAction)saveBtnClickToPostData {
    
    if ([self.nameTf.text isEqualToString:@""]||[self.IDnumberTf.text isEqualToString:@""]||[self.kaiHuHangTf.text isEqualToString:@""]) {
        [self.view Message:@"请完善必要信息" HiddenAfterDelay:1.0];
        return;
    }
    
    [self creatHUD];
    if (self.phoneNumberTf.text.length!=11) {
        [_MBHUD setLabelText:@"请输入正确手机号"];
        [_MBHUD hide:YES afterDelay:1.5f];
        NSLog(@"请输入正确手机号");
    }else{
        NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *params =[[NSMutableDictionary alloc]initWithDictionary: @{@"model":@"seller",@"action":@"saveBank",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"sellersaveBank%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"],@"username":self.nameTf.text,@"account":self.IDnumberTf.text,@"mobile":self.phoneNumberTf.text,@"deposit_bank":self.kaiHuHangTf.text}];
        if (self.pushType == 0) {
            [params setObject:self.model.Id forKey:@"bank_id"];
        }
        [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
            //        NSLog(@"%@",data);
            if ([data[@"error"] isEqualToString:@"0"]) {
                NSLog(@"添加成功");
                [_MBHUD setLabelText:@"操作成功！"];
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
    NSDictionary *params = @{@"model":@"seller",@"action":@"delBank",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"sellerdelBank%@",ConfigNetAppKey]],@"bank_id":self.model.Id,@"user_id":[userdefaul objectForKey:@"user_id"]};
    [TYDPManager tydp_baseGetReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            NSLog(@"删除成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(TYDPError *error) {
        
    }];
}

- (IBAction)saveMoRenBtnClick:(UIButton *)sender {
    
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"model":@"seller",@"action":@"defaultBank",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"sellerdefaultBank%@",ConfigNetAppKey]],@"bank_id":self.model.Id,@"user_id":[userdefaul objectForKey:@"user_id"],@"good_type":@"future"};
    [TYDPManager tydp_baseGetReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            debugLog(@"设置成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(TYDPError *error) {
        
    }];
}

- (IBAction)saveMoRen_qihuoBtnClick:(UIButton *)sender {
    
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"model":@"seller",@"action":@"defaultBank",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"sellerdefaultBank%@",ConfigNetAppKey]],@"bank_id":self.model.Id,@"user_id":[userdefaul objectForKey:@"user_id"],@"good_type":@"spot"};
    [TYDPManager tydp_baseGetReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            debugLog(@"设置成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(TYDPError *error) {
        
    }];

}

@end
