//
//  TYDP_wantBuyViewController.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/10.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_wantBuyViewController : UIViewController
@property(nonatomic, assign)NSInteger HomePageFlag;
@property(nonatomic, strong)NSMutableDictionary *filterDic;
@property(nonatomic, assign)BOOL sign_MSandTJ;
@property(nonatomic, strong)NSMutableString *more_type;

@end
