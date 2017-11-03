//
//  TYDP_SetController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/15.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_SetController.h"
#import "TYDP_changePasswordController.h"
#import "TYDP_AboutUsController.h"
#import "AppDelegate.h"
#import "TYDPTabBarController.h"
#import "NSBundle+Language.h"
@interface TYDP_SetController ()

@end

@implementation TYDP_SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *currentLanguage = languages.firstObject;
    debugLog(@"当前语言：%@",currentLanguage);
    
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = NSLocalizedString(@"Settings", nil);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[NSLocalizedString(@"Change login password", nil),NSLocalizedString(@"Help Center", nil),NSLocalizedString(@"About Us", nil),NSLocalizedString(@"Clear Cache", nil),NSLocalizedString(@"Switch language", nil)];
    for (int i = 0; i<5; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 55*i*Height+NavHeight, ScreenWidth-40, 55*Height)];
        [self.view addSubview:lab];
        lab.text = arr[i];
        lab.userInteractionEnabled = YES;
        
        //灰色的线
        UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, 55*Height-1, ScreenWidth-40, 1)];
        [lab addSubview:grayLine];
        grayLine.backgroundColor = RGBACOLOR(217, 217, 217, 1);
        
        //右边图片
        if (i == 3) {
            UILabel *cacheLab = [UILabel new];
            [lab addSubview:cacheLab];
            cacheLab.text = [NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize] / 1000.0 / 1000.0];
            [cacheLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(lab);
                make.right.mas_equalTo(-10*Width);
            }];
            cacheLab.tag = 300;
        }else{
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_return_choose_nor"]];
            [lab addSubview:img];
            img.frame = CGRectMake(ScreenWidth - 40-10*Width, 17.5*Height, 10*Width, 20*Height);
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [lab addSubview:btn];
        btn.frame = CGRectMake(0, 0, ScreenWidth-40, 55*Height);
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //退出按钮
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:logoutBtn];
    logoutBtn.frame = CGRectMake(ScreenWidth/2-100*Width, 315*Height+NavHeight, 200*Width, 50*Height);
    logoutBtn.layer.cornerRadius = 5;
    logoutBtn.layer.borderWidth = 1;
    logoutBtn.layer.borderColor = [RGBACOLOR(234, 100, 62, 1) CGColor];
    [logoutBtn setTitleColor:RGBACOLOR(234, 100, 62, 1) forState:UIControlStateNormal];
    [logoutBtn setTitle:NSLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag == 100) {
        TYDP_changePasswordController *cpwVC = [[TYDP_changePasswordController alloc]init];
        [self.navigationController pushViewController:cpwVC animated:YES];
    }else if (sender.tag == 101){
    
    }else if (sender.tag == 102){
        TYDP_AboutUsController *usVC = [[TYDP_AboutUsController alloc]init];
        [self.navigationController pushViewController:usVC animated:YES];
    }else if (sender.tag == 103){
        [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];
        UILabel *cacheLab = [self.view viewWithTag:300];
        cacheLab.text = [NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0];
        NSLog(@"清除缓存");
    }
    else
    {
        // 切换语言前
        NSArray *langArr1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
        NSString *language1 = langArr1.firstObject;
        debugLog(@"模拟器语言切换之前：%@",language1);
        
        NSArray *lans;
        if ([language1 rangeOfString:@"zh-Hans"].location !=NSNotFound) {
            lans = @[@"en"];
        }
        else
        {
        lans = @[@"zh-Hans"];
        }
        // 切换语言
        
        [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
        
        // 切换语言后
        NSArray *langArr2 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
        NSString *language2 = langArr2.firstObject;
        debugLog(@"语言切换之后：%@",language2);
        //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
        
        [NSBundle setLanguage:language2];
        
        // 然后将设置好的语言存储好，下次进来直接加载
        [[NSUserDefaults standardUserDefaults] setObject:language2 forKey:@"myLanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [PSDefaults setObject:@"0" forKey:@"needCenterBtn"];

        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TYDPTabBarController*  rootVC = story.instantiateInitialViewController;
        AppDelegate* appDele=(AppDelegate* )[UIApplication sharedApplication].delegate;
        appDele.window.rootViewController=rootVC;
        
    }
}

- (void)logoutBtnClick{
    debugLog(@"退出登录");
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    [userdefaul removeObjectForKey:@"token"];
    [userdefaul removeObjectForKey:@"user_name"];
    [userdefaul removeObjectForKey:@"user_id"];
    [userdefaul removeObjectForKey:@"user_face"];
    [userdefaul removeObjectForKey:@"alias"];
    [userdefaul removeObjectForKey:@"mobile_phone"];
    [userdefaul removeObjectForKey:@"user_rank"];

    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"设置界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"设置界面"];
}
@end
