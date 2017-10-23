//
//  TYDP_ShopListViewController.h
//  TYDPB2B
//
//  Created by Wangye on 16/7/20.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_ShopListViewController : UIViewController
@property(nonatomic, assign)NSInteger HomePageFlag;
@property(nonatomic, strong)NSMutableDictionary *filterDic;//筛选数据
@property(nonatomic, assign)BOOL sign_MSandTJ;
@property(nonatomic, strong)NSMutableString *more_type;

@end
