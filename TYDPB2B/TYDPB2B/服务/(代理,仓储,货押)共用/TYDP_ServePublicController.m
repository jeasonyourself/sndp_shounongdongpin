//
//  TYDP_ServePublicController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/23.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_ServePublicController.h"
#import "TYDP_LoginController.h"

@interface TYDP_ServePublicController ()
{
    NSString *_token;
    NSString *_user_id;
    MBProgressHUD *_MBHUD;
}

@property (strong, nonatomic) IBOutlet UITextField *productTf;//产品
@property (strong, nonatomic) IBOutlet UITextField *weightTf;//重量
@property (strong, nonatomic) IBOutlet UITextField *typeTf;//规格
@property (strong, nonatomic) IBOutlet UITextField *NumberTf;//厂号
@property (strong, nonatomic) IBOutlet UITextField *addressTf;//产地
@property (strong, nonatomic) IBOutlet UITextView *remarksTv;//备注
@property (strong, nonatomic) IBOutlet UILabel *nameLab;//联系人姓名
@property (strong, nonatomic) IBOutlet UILabel *PhoneNumLab;//联系人电话

@property (strong, nonatomic) IBOutlet UIView *blackView;//黑色半透明的view
@property (strong, nonatomic) IBOutlet UIView *WhiteAlertView;//白色的view

@end

@implementation TYDP_ServePublicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatUI];
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *titleArr = @[@"代理报关",@"仓储服务",@"货押贷款"];
    self.navigationItem.title = titleArr[self.sendType];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bggradient_person_"] forBarMetrics:UIBarMetricsDefault];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    _user_id = [userdefaul objectForKey:@"user_id"];
    self.nameLab.text = [userdefaul objectForKey:@"alias"];
    self.PhoneNumLab.text = [userdefaul objectForKey:@"mobile_phone"];
    _token = [userdefaul objectForKey:@"token"];
    
    if (!_token||!_user_id||!self.nameLab.text||!self.PhoneNumLab.text) {
        TYDP_LoginController *loginVC = [TYDP_LoginController new];
        [self.navigationController pushViewController:loginVC animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"代理、仓储、货押界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"代理、仓储、货押界面"];
}

- (IBAction)IKnownBtnClick {
    self.blackView.hidden = YES;
    self.WhiteAlertView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SureBtnClick {
    [self requestData];
}

- (void)sendSuccessCreatAlert{
//    self.blackView.frame = CurrentWindow.frame;
    self.blackView.hidden = NO;
    [self.view addSubview:self.blackView];
    self.WhiteAlertView.hidden = NO;
    [self.view addSubview:self.WhiteAlertView];
}

- (void)creatHUD{
    if (!_MBHUD) {
        _MBHUD = [[MBProgressHUD alloc] init];
        [self.view addSubview:_MBHUD];
    }
        [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
        [_MBHUD setMode:MBProgressHUDModeText];
        [_MBHUD setLabelText:@"稍等片刻。。。"];
        [_MBHUD show:YES];
}

- (void)requestData{
    [self creatHUD];
    NSArray *actionArr = @[@"save_abroad",@"save_storage",@"save_loan"];
    NSDictionary *pa = @{@"model":@"other",@"action":actionArr[self.sendType],@"sign":[TYDPManager md5:[NSString stringWithFormat:@"other%@%@",actionArr[self.sendType],ConfigNetAppKey]],@"user_id":_user_id,@"token":_token,@"goods_name":self.productTf.text,@"num":self.weightTf.text,@"spec":self.typeTf.text,@"brand_sn":self.NumberTf.text,@"country":self.addressTf.text,@"user_phone":self.PhoneNumLab.text,@"memo":self.remarksTv.text,};
    for (NSString * key in pa.allKeys) {
        if ([[pa objectForKey:key] isEqualToString:@""]) {
            [self.view Message:@"缺少参数" HiddenAfterDelay:1.0];
            return;
        }
    }
    NSMutableDictionary *params =[NSMutableDictionary dictionaryWithDictionary:pa];
    params[@"user_name"]=self.nameLab.text;
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        NSLog(@"%@",data);
        NSLog(@"%@",data[@"message"]);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            [self sendSuccessCreatAlert];
        }else{
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1];
        }
    } failure:^(TYDPError *error) {
        
    }];
}

@end
