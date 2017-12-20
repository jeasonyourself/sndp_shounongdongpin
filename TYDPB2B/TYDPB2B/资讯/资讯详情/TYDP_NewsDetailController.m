//
//  TYDP_NewsDetailController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/11.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_NewsDetailController.h"

@interface TYDP_NewsDetailController ()<UIWebViewDelegate>
{
    MBProgressHUD *_MBHUD;
}
@end

@implementation TYDP_NewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)creatHUD{
    if (!_MBHUD) {
        _MBHUD = [[MBProgressHUD alloc] init];
        [self.view addSubview:_MBHUD];
    }
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeIndeterminate];
    [_MBHUD setLabelText:@"正在加载..."];
    [_MBHUD show:YES];
}

- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"资讯详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight)];
    [self.view addSubview:webView];
    webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.taiyanggo.com/mobile/%@&from=app",self.requestURL]]];
    [webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self creatHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_MBHUD hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
    [_MBHUD hide:YES afterDelay:1];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"新闻资讯界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"新闻资讯界面"];
}
@end
