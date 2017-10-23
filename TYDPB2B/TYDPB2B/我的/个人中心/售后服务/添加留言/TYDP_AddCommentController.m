//
//  TYDP_AddCommentController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/21.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_AddCommentController.h"
#import "TYDP_SelectCommentTypeController.h"
#import "TYDPManager.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface TYDP_AddCommentController ()
{
    MBProgressHUD *_MBHUD;
}
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *substanceView;
@property (nonatomic, copy) NSString *msg_type;
- (IBAction)sureBtnClick;
- (IBAction)selectCommentType:(UITapGestureRecognizer *)sender;

@end

@implementation TYDP_AddCommentController

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
    if (self.pushType == 0) {
        self.msg_type = @"0";
    }else{
        self.msg_type = @"2";
        self.typeLab.text = @"  售后";
        self.titleField.text = self.titleStr;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
            
    self.typeLab.layer.borderColor = [RGBACOLOR(207, 207, 207, 1) CGColor];
    
    self.titleField.layer.borderColor = [RGBACOLOR(207, 207, 207, 1) CGColor];

    self.substanceView.layer.borderColor = [RGBACOLOR(207, 207, 207, 1) CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bggradient_person_"] forBarMetrics:UIBarMetricsDefault];
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"添加留言界面"];
}

- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"添加留言界面"];
}

- (IBAction)sureBtnClick {
    NSLog(@"提交");
    [self requestData];
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

- (void)requestData{
    [self creatHUD];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSDictionary *param = @{@"model":@"user",@"action":@"message_add",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"usermessage_add%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"msg_type":self.msg_type,@"msg_title":self.titleField.text,@"msg_content":self.substanceView.text};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:param success:^(id data) {
        NSLog(@"%@",data);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [_MBHUD hide:YES afterDelay:1];
        NSLog(@"---error:%@---",error);
    }];
}

- (IBAction)selectCommentType:(UITapGestureRecognizer *)sender {
    NSLog(@"选择留言类型");
    TYDP_SelectCommentTypeController *selectVC = [[TYDP_SelectCommentTypeController alloc]init];
    [self addChildViewController:selectVC];
    selectVC.view.frame = [[UIScreen mainScreen]bounds];
    [selectVC returnTypr:^(NSString *typeSAtr,NSString *msg_type) {
        self.typeLab.text = [NSString stringWithFormat:@"  %@",typeSAtr];
        self.msg_type = msg_type;
    }];
    [self.view addSubview:selectVC.view];
}

@end
