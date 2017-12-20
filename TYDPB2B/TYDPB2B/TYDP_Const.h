//
//  TYDP_Const.h
//  TYDPB2B
//
//  Created by Wangye on 16/7/13.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#ifndef TYDP_Const_h
#define TYDP_Const_h
#pragma mark ---常用参数

//获取当前窗体
#define CurrentWindow [[UIApplication sharedApplication].delegate window]
//获取当前屏幕宽度
#define ScreenWidth [[UIScreen mainScreen]bounds].size.width
//获取当前屏幕高度
#define ScreenHeight [[UIScreen mainScreen]bounds].size.height
//获取当前导航栏高度
#define NavHeight 64
//获取当前tabbar的高度
#define TabbarHeight self.tabBarController.tabBar.frame.size.height
#define FunctionViewHeight (([[UIScreen mainScreen]bounds].size.width)/2.5+30)

//判断iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6+
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


//rgba颜色
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//字体设置
#define ThemeFont(s) [UIFont systemFontOfSize:(s)]
#define CommonFontSize 15.0
#define OrderFontSize 16.0
//常用间距
#define Gap 10.0
#define MiddleGap 15.0
//常用搜索栏高度
#define CommonSearchViewHeight 30
#define CommonHeight 20
#define HomePageBordWidth 0.8
#define OfferViewCommonMultiple 4.68
#define OfferLeftViewSmallCircelMultiple 2.36
#endif /* TYDP_Const_h */
//设置网络超时
#define TYDPTimeoutInterval 20
#define ConfigNetAppKey @"76sRx2VW@i4uJleBd4X9MoFfgWdGqbe1"
#define TYDPIphone5sHeight 568.0

//PHP
#define PHPURL @"http://www.taiyanggo.com/app/api.php"

//长，宽缩放比例（按iPhone6尺寸适配）
#define Width [UIScreen mainScreen].bounds.size.width / 375.f
#define Height [UIScreen mainScreen].bounds.size.height / 667.f
