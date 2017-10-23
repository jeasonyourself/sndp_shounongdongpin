//
//  TYDP_ViewController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/2.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_CustomerServiceController.h"

@interface TYDP_CustomerServiceController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLab;//客服专员
@property (strong, nonatomic) IBOutlet UILabel *numberLab;//联系电话
- (IBAction)callBtn;//打电话按钮
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headConstraint;//距离约束

@end

@implementation TYDP_CustomerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MODEL:%@",_TYDPmodel);
    // Do any additional setup after loading the view from its nib.
    [self creatUI];
}

- (void)creatUI{
    self.headConstraint.constant = 145*Height+20;
    
    //创建头视图
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 145*Height+20)];
    [self.view addSubview:headImg];
    headImg.image = [UIImage imageNamed:@"bg_account"];
    headImg.userInteractionEnabled = YES;
    
    //头像
    UIImageView *portraitImg = [[UIImageView alloc]initWithFrame:CGRectMake(20*Width, 50*Height+20, 80*Width, 80*Width)];
    [headImg addSubview:portraitImg];
    portraitImg.layer.cornerRadius = 40*Width;
    portraitImg.layer.borderWidth = 2;
    portraitImg.layer.borderColor = [[UIColor whiteColor]CGColor];
    portraitImg.layer.masksToBounds = YES;
    [portraitImg sd_setImageWithURL:[NSURL URLWithString:self.TYDPmodel.user_face] placeholderImage:[UIImage imageNamed:@"person_head_default"]];//实际图片网络获取
    
    //用户昵称
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(110*Width, 57*Height+20, 100*Width, 20*Height)];
    [headImg addSubview:nameLab];
    nameLab.text = self.TYDPmodel.alias;
    [nameLab sizeToFit];
    nameLab.textColor = [UIColor whiteColor];
    
    //会员类型
    UIImageView *VIPimg = [[UIImageView alloc]initWithFrame:CGRectMake(nameLab.frame.origin.x+nameLab.frame.size.width+10, 55*Height+20, 90*Width, 20*Height)];
    [headImg addSubview:VIPimg];
    VIPimg.image = [UIImage imageNamed:@"person_icon_member"];
    
    //余额
    UILabel *YuE = [[UILabel alloc]initWithFrame:CGRectMake(110*Width, 89*Height+20, 45*Width+Gap, 20*Height)];
    [headImg addSubview:YuE];
    YuE.text = @"余额¥";
    YuE.textColor = [UIColor whiteColor];
    UILabel *moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(155*Width+Gap, 89*Height+20, ScreenWidth-165*Width, 20*Height)];
    [headImg addSubview:moneyLab];
    moneyLab.textColor = RGBACOLOR(229, 161, 71, 1);
    moneyLab.font = [UIFont systemFontOfSize:15];
    moneyLab.text = [NSString stringWithFormat:@"%@",self.TYDPmodel.user_money];
    
//    //关注
//    UILabel *GuanZhu = [[UILabel alloc]initWithFrame:CGRectMake(110*Width, 110*Height+20, 40*Width, 20*Height)];
//    [headImg addSubview:GuanZhu];
//    GuanZhu.text = @"关注";
//    GuanZhu.textColor = [UIColor whiteColor];
//    GuanZhu.userInteractionEnabled = YES;
//    
//    UILabel *careLab = [[UILabel alloc]initWithFrame:CGRectMake(155*Width, 110*Height+20, 120*Width, 20*Height)];
//    [headImg addSubview:careLab];
//    careLab.textColor = RGBACOLOR(229, 161, 71, 1);
//    careLab.font = [UIFont systemFontOfSize:15];
//    careLab.text = [NSString stringWithFormat:@"0"];
    
    //返回按钮
    UIButton *retBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [headImg addSubview:retBtn];
    retBtn.frame = CGRectMake(0, 0, 60*Width, 60*Width);
    [retBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *retBtnImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_return"]];
    [headImg addSubview:retBtnImg];
    retBtnImg.frame = CGRectMake(20*Width, 10*Height+20, 10*Width, 20*Width);
    //联系电话
    self.numberLab.text = @" 15834010881";   //客服专员
    self.nameLab.text = @" 张衡小逼";
}

- (void)returnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"专属客服界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"专属客服界面"];
}

- (IBAction)callBtn {
    NSLog(@"调用系统打电话");
    NSString *callString = [NSString stringWithFormat:@"15834010881"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callString]];
}

@end
