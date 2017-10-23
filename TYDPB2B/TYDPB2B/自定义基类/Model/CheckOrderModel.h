//
//  CheckOrderModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/9/2.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderDetailPaymentBigModel.h"
#import "CheckOrderGoodsModel.h"
#import "GetAddressModel.h"

@interface CheckOrderModel : JSONModel
@property(nonatomic, strong)OrderDetailPaymentBigModel *payment_desc;
@property(nonatomic, strong)CheckOrderGoodsModel *goods_info;
@property(nonatomic, strong)NSDictionary *bank;
@property(nonatomic, copy)NSString *apply_pay;
@property(nonatomic, copy)NSString *amount_last;
@property(nonatomic, copy)NSString *buyer_seller_edit;
@property(nonatomic, copy)NSString *can_pay;
@property(nonatomic, copy)NSString *formated_add_time;
@property(nonatomic, strong)GetAddressModel *get_address;
@property(nonatomic, copy)NSString *goods_amount;
@property(nonatomic, copy)NSString *money_paid;
@property(nonatomic, copy)NSString *user_id;
@property(nonatomic, copy)NSString *order_amount;
@property(nonatomic, copy)NSString *order_id;
@property(nonatomic, copy)NSString *order_sn;
@property(nonatomic, copy)NSString *order_status;
@property(nonatomic, copy)NSString *order_status_name;
@property(nonatomic, copy)NSString *pay_check;
@property(nonatomic, copy)NSString *pay_id;
@property(nonatomic, copy)NSString *pay_name;
@property(nonatomic, copy)NSString *pay_status_name;
@property(nonatomic, copy)NSString *pay_type_id;
@property(nonatomic, strong)NSDictionary *payment_list;
@property(nonatomic, copy)NSString *postscript;
@property(nonatomic, strong)NSDictionary *send_address;
@property(nonatomic, copy)NSString *stock_remark;
@property(nonatomic, copy)NSString *stock_status;
@property(nonatomic, copy)NSString *stock_status_tag;
@property(nonatomic, strong)NSDictionary *user_info;
@end
