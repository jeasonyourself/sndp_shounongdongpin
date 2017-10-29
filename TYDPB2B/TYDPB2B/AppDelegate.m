//
//  AppDelegate.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/13.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "NSBundle+Language.h"
#import "MWApi.h"
#import "TYDP_VendorController.h"
#import "TYDP_OfferDetailViewController.h"
#import "UMessage.h"
#ifdef  NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import <AlipaySDK/AlipaySDK.h>
#endif

//#import "UserNotifications.h"
//商品详情：交易历史。店铺详情：二级排序。
//你从东到西，我从南到北，我们总会有一个交叉口，或是始不得遇，又或是终将分离

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Override point for customization after application launch.
    /**
     *  友盟微信分享
     */
    
    [PSDefaults setObject:@"0" forKey:@"needCenterBtn"];
    [PSDefaults setObject:@"0" forKey:@"userType"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"] isEqualToString:@""]) {
        [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"]];
    }
    
     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxbcce9bddfe71700f" appSecret:@"d613b222d75ea05042498cad770dd5f1" redirectURL:nil];
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"wxbcce9bddfe71700f"];
    /**
     *  友盟统计
     */
    UMConfigInstance.appKey = @"57aa879467e58e4370003259";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数
    [MobClick setCrashReportEnabled:YES];
    [NSThread sleepForTimeInterval:0.618];//设置启动页面时间
    
    
    //初始化SDK，必写
    [MWApi registerApp:@"Q0AZ6ILYN40Y098WQVGU8X351SNJC2SJ"];
    
 [UMessage startWithAppkey:@"59ec5ab9f43e483a7a000bb4" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(IS_OS_10_OR_LATER)
    {
        UNUserNotificationCenter * center=[UNUserNotificationCenter currentNotificationCenter];
        center.delegate=self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted)
            {
                debugLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    debugLog(@"setttttt:%@",settings);
                }];
            }
            else
            {
                debugLog(@"注册失败");
            }
        }];
         [UMessage registerForRemoteNotifications];
        
    } else{
        //register remoteNotification types (iOS 8.0-10.0)
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        [UMessage registerForRemoteNotifications];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotifications];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
    
    
    //直接设置颜色
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBarTintColor:mainColor];
//    UINavigationBar *navBar = [UINavigationBar appearance];
//     navBar.translucent  =NO;
    [[UINavigationBar appearance] setBackgroundImage:[UIImage
                                                                 imageNamed:@"maincolorImagee"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
    [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [MWApi registerMLinkHandlerWithKey:@"taiyanggo_shop" handler:^(NSURL *url, NSDictionary *params) {
        //自行处理跳转逻辑
        debugLog(@"taiyanggo_shopurl--params:%@%@",url,params);
        TYDPTabBarController *rootVC = (TYDPTabBarController *)self.window.rootViewController;
        TYDP_VendorController *vendorCon = [[TYDP_VendorController alloc] init];
        vendorCon.shopId = params[@"shop_id"];
        
        [rootVC.selectedViewController pushViewController:vendorCon animated:YES];
    }];
    
    [MWApi registerMLinkHandlerWithKey:@"taiyanggo_goods" handler:^(NSURL *url, NSDictionary *params) {
        //自行处理跳转逻辑
        debugLog(@"taiyanggo_goodsurl--params:%@%@",url,params);
        TYDP_OfferDetailViewController *offerDetailViewCon = [[TYDP_OfferDetailViewController alloc] init];
        offerDetailViewCon.goods_id = params[@"goods_id"];
        TYDPTabBarController *rootVC = (TYDPTabBarController *)self.window.rootViewController;
        [rootVC.selectedViewController pushViewController:offerDetailViewCon animated:YES];
    }];
    
    

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    NSString* token1 = [NSString stringWithFormat:@"%@",deviceToken];
    debugLog(@"apns -> 生成的devToken:%@", token1);
    debugLog(@"apns -> devToken:%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""]);
    [PSDefaults setObject:[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""] forKey:@"device_token"];
    [PSDefaults setObject:@"1" forKey:@"device_type"];
}

//远程通知注册失败委托
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    debugLog(@"apns -> 注册推送功能时发生错误， 错误信息:\n %@", error);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
            [MWApi routeMLink:url];
        return YES;
        
    }
    return result;
}
//iOS9+
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    //必写
    [MWApi routeMLink:url];
    return YES;
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    //如果使用了Universal link ，此方法必写
    return [MWApi continueUserActivity:userActivity];
}
/**
 *  键盘处理
 */
- (void)createIQKeybord{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
