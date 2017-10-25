//
//  seller_orderDetailViewController.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/13.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface seller_orderDetailViewController : UIViewController
@property(nonatomic, copy)NSString *orderId;
@property(nonatomic, copy)NSString *order_status;
@property(nonatomic, assign)BOOL popMore;

@end
