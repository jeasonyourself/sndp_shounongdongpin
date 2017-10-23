//
//  TYDP_CommitEvidenceViewController.h
//  TYDPB2B
//
//  Created by Wangye on 16/7/28.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_CommitEvidenceViewController : UIViewController
@property(nonatomic, copy)NSString *orderSourceString;//订单列表过来还是购买完跳转过来
@property(nonatomic, copy)NSString *orderId;
@property(nonatomic, copy)NSString *order_status;

@end
