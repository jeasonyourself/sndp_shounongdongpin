//
//  TYDPTabBarController.m
//  myShopping
//
//  Created by tycdong on 16/7/8.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDPTabBarController.h"
#import "ZYTabBar.h"
#import "TYDP_pubOfferViewController.h"
#import "TYDP_IssueWantController.h"
#import "TYDP_NewsController.h"
#import "TYDP_LoginController.h"
//防止在block中引用本类的属性引起循环引用
#define WS(weakSelf) __weak TYDPTabBarController *weakSelf = self

@interface TYDPTabBarController ()<ZYTabBarDelegate,UITabBarControllerDelegate>
{
    ZYTabBar *tabBar;
}
@end

@implementation TYDPTabBarController
- (void)viewWillAppear:(BOOL)animated {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(changeTabBarIndex:) name:@"changeTabBarIndex" object:nil];
//    tabBar.plusBtn.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    for (UITabBarItem *item in self.tabBar.items) {
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:mainColor} forState:UIControlStateSelected];
    }
    self.delegate=self;
//    [self setUpAllChildVc];
    [self configureZYPathButton];
    
//    WS(weakSelf);
//    _selectTabBarBlock = ^(NSInteger index) {
//        [weakSelf tmpMethod:index];
//    };
    // Do any additional setup after loading the view.
}

- (void)configureZYPathButton {
    tabBar = [ZYTabBar new];
    tabBar.delegate = self;
    ZYPathItemButton *itemButton_1 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"pop_buy"]highlightedImage:[UIImage imageNamed:@"pop_buy"]backgroundImage:[UIImage imageNamed:@"pop_buy"]backgroundHighlightedImage:[UIImage imageNamed:@"pop_buy"] title:NSLocalizedString(@"Buy",nil)];
    
    ZYPathItemButton *itemButton_2 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"pop_news"]highlightedImage:[UIImage imageNamed:@"pop_news"]backgroundImage:[UIImage imageNamed:@"pop_news"]backgroundHighlightedImage:[UIImage imageNamed:@"pop_news"] title:NSLocalizedString(@"News",nil)];
    
    ZYPathItemButton *itemButton_3 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"pop_sell"]highlightedImage:[UIImage imageNamed:@"pop_sell"]backgroundImage:[UIImage imageNamed:@"pop_sell"]backgroundHighlightedImage:[UIImage imageNamed:@"pop_sell"] title:NSLocalizedString(@"Sell",nil)];
   
    
//    ZYPathItemButton *itemButton_4 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
//    
//    ZYPathItemButton *itemButton_5 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    tabBar.pathButtonArray = @[itemButton_3 , itemButton_2 , itemButton_1/*, itemButton_4 , itemButton_5*/];
    tabBar.basicDuration = 0.5;
    tabBar.allowSubItemRotation = YES;
    tabBar.bloomRadius = 150;
    tabBar.allowCenterButtonRotation = NO;
    tabBar.bloomAngel = 100;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
        tabBar.plusBtn.hidden=NO;
}

- (void)pathButton:(ZYPathButton *)ZYPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@" 点中了第%ld个按钮" , itemButtonIndex);
    if (itemButtonIndex==2) {
        NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];

       NSString* _user_id = [userdefaul objectForKey:@"user_id"];
       NSString* _user_name = [userdefaul objectForKey:@"alias"];
       NSString* _user_phone = [userdefaul objectForKey:@"mobile_phone"];
       NSString* _token = [userdefaul objectForKey:@"token"];
        if (!_token||!_user_id||!_user_name||!_user_phone) {
            TYDP_LoginController *loginVC = [TYDP_LoginController new];
            UINavigationController * navVC1 =(UINavigationController*)self.selectedViewController;
             [navVC1 pushViewController:loginVC animated:YES];
            return;
        }
        
        
        TYDP_IssueWantController *IssueWantVC = [TYDP_IssueWantController new];
//        IssueWantVC.dismissOrPop=YES;
//        UINavigationController * navVC =[[UINavigationController alloc] initWithRootViewController:IssueWantVC];
//        [self.selectedViewController presentViewController:navVC animated:YES completion:nil  ];
        UINavigationController * navVC =(UINavigationController*)self.selectedViewController;
        [navVC pushViewController:IssueWantVC animated:YES];
    }

    if (itemButtonIndex==1) {
        TYDP_NewsController*  TYDP_NewsVC = [TYDP_NewsController new];
//        TYDP_NewsVC.dismissOrPop=YES;
//         UINavigationController * navVC =[[UINavigationController alloc] initWithRootViewController:TYDP_NewsVC];
//        [self.selectedViewController presentViewController:navVC animated:YES completion:nil  ];
        UINavigationController * navVC =(UINavigationController*)self.selectedViewController;
        [navVC pushViewController:TYDP_NewsVC animated:YES];
    }

    
    if (itemButtonIndex==0) {
        NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
        if (![[userdefaul objectForKey:@"user_rank"] isEqualToString:@"2"]) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window Message:@"发布报盘仅供商家用户使用，请先入驻！" HiddenAfterDelay:1.5];
            return;
        }
        
        
        NSString* _user_id = [userdefaul objectForKey:@"user_id"];
        NSString* _user_name = [userdefaul objectForKey:@"alias"];
        NSString* _user_phone = [userdefaul objectForKey:@"mobile_phone"];
        NSString* _token = [userdefaul objectForKey:@"token"];
        if (!_token||!_user_id||!_user_name||!_user_phone) {
            TYDP_LoginController *loginVC = [TYDP_LoginController new];
            UINavigationController * navVC1 =(UINavigationController*)self.selectedViewController;
            [navVC1 pushViewController:loginVC animated:YES];
            return;
        }
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"seller_Storyboard" bundle:nil];
       TYDP_pubOfferViewController*  pubOfferVC = [story instantiateViewControllerWithIdentifier:@"pubOfferVC"];
        pubOfferVC.if_addOrEditOrCopy=@"1";
//         pubOfferVC.dismissOrPop=YES;
        UINavigationController * navVC =(UINavigationController*)self.selectedViewController;
//         UINavigationController * navVC =[[UINavigationController alloc] initWithRootViewController:pubOfferVC];
        
        [navVC pushViewController:pubOfferVC animated:YES];
        return;
    }
   
    
}



//- (void)tmpMethod:(NSInteger) index {
//    self.selectedIndex = index;
//}
- (void)changeTabBarIndex:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    self.selectedIndex = [dic[@"index"] intValue];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeTabBarIndex" object:nil];
}
#pragma mark - tabBarController Delegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
