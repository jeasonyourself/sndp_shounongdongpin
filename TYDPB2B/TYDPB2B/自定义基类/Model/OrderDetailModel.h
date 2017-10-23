//
//  OrderDetailModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/9/1.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderDetailPaymentBigModel.h"

@interface OrderDetailModel : JSONModel
@property(nonatomic, copy)NSString *order_id;
@property(nonatomic, copy)NSString *order_sn;
@property(nonatomic, copy)NSString *formated_order_amount;
@property(nonatomic, copy)NSString *order_status;
@property(nonatomic, copy)NSString *payment;
@property(nonatomic, strong)OrderDetailPaymentBigModel *payment_desc;
@end
