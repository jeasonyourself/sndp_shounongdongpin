//
//  TYDP_wantBuyDetailViewController.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/13.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_wantBuyDetailViewController : UIViewController
@property(nonatomic, assign)NSInteger HomePageFlag;
@property(nonatomic, strong)NSMutableDictionary *filterDic;
@property(nonatomic, assign)BOOL sign_MSandTJ;
@property(nonatomic, strong)NSMutableString *more_type;
@property(nonatomic, strong)NSString *qiugou_id;

@end
