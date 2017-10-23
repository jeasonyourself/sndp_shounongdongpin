//
//  OrderDetailPaymentBigModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/9/1.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderPaymentListModel.h"
#import "GetAddressModel.h"

@interface OrderDetailPaymentBigModel : JSONModel
@property(nonatomic, copy)NSString *payment_name;
//@property(nonatomic, strong)NSArray<OrderPaymentListModel> *payment_list;
@property(nonatomic, strong)GetAddressModel *seller;
@end
