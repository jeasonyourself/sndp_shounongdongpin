//
//  sellerOrderDetailModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/15.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OrderDetailPaymentBigModel.h"
#import "CheckOrderGoodsModel.h"
#import "GetAddressModel.h"

@interface sellerOrderDetailModel : JSONModel
@property(nonatomic, strong)CheckOrderGoodsModel *goods_info;
@property(nonatomic, strong)NSDictionary *action_user;

@property(nonatomic, copy)NSString *add_time;
@property(nonatomic, copy)NSString *address;
@property(nonatomic, copy)NSString *amount_last;
@property(nonatomic, copy)NSString *apply_pay;
@property(nonatomic, strong)GetAddressModel *get_address;
@property(nonatomic, copy)NSString *bonus;
@property(nonatomic, copy)NSString *bonus_id;
@property(nonatomic, copy)NSString *business_reason;
@property(nonatomic, copy)NSString *business_status;
@property(nonatomic, copy)NSString *buyer_card;
@property(nonatomic, copy)NSString *buyer_name;
@property(nonatomic, copy)NSString *buyer_phone;
@property(nonatomic, copy)NSString *buyer_seller_edit;
@property(nonatomic, copy)NSString *city;
@property(nonatomic, copy)NSString *confirm_time;
@property(nonatomic, copy)NSString *consignee;
@property(nonatomic, copy)NSString *discount;
@property(nonatomic, copy)NSString *district;
@property(nonatomic, copy)NSString *email;
@property(nonatomic, copy)NSString *entrust_before;
@property(nonatomic, copy)NSString *entrust_money;
@property(nonatomic, copy)NSString *entrust_order_id;
@property(nonatomic, copy)NSString *exist_real_goods;
@property(nonatomic, copy)NSString *extension_code;
@property(nonatomic, copy)NSString *extension_id;
@property(nonatomic, copy)NSString *formated_add_time;
@property(nonatomic, copy)NSString *formated_bonus;
@property(nonatomic, copy)NSString *formated_discount;
@property(nonatomic, copy)NSString *formated_entrust_money;
@property(nonatomic, copy)NSString *formated_goods_amount;
@property(nonatomic, copy)NSString *formated_insure_fee;
@property(nonatomic, copy)NSString *formated_integral_money;
@property(nonatomic, copy)NSString *formated_money_paid;
@property(nonatomic, copy)NSString *formated_order_amount;
@property(nonatomic, copy)NSString *formated_pay_fee;
@property(nonatomic, copy)NSString *formated_pay_total;
@property(nonatomic, copy)NSString *formated_pay_total_ratio;
@property(nonatomic, copy)NSString *formated_shipping_fee;
@property(nonatomic, copy)NSString *formated_surplus;
@property(nonatomic, copy)NSString *formated_tax;
@property(nonatomic, copy)NSString *formated_total_fee;
@property(nonatomic, copy)NSString *get_address_id;
@property(nonatomic, copy)NSString *goods_amount;
@property(nonatomic, copy)NSString *goods_sn;
@property(nonatomic,  copy)NSString *insure_fee;
@property(nonatomic, copy)NSString *integral;
@property(nonatomic, copy)NSString *integral_money;
@property(nonatomic, copy)NSString *inv_content;
@property(nonatomic, copy)NSString *inv_payee;
@property(nonatomic, copy)NSString *inv_type;
@property(nonatomic, copy)NSString *invoice_no;
@property(nonatomic, copy)NSString *is_entrust;
@property(nonatomic, copy)NSString *is_future;
@property(nonatomic, copy)NSString *is_prepay;
@property(nonatomic, copy)NSString *logistics;
@property(nonatomic, copy)NSString *mobile;
@property(nonatomic, copy)NSString *money_paid;
@property(nonatomic, copy)NSString *order_amount;
@property(nonatomic, copy)NSString *order_from;
@property(nonatomic, copy)NSString *order_id;
@property(nonatomic, copy)NSString *order_sn;
@property(nonatomic, copy)NSString *order_status;
@property(nonatomic, copy)NSString *order_status_name;
@property(nonatomic, copy)NSString *parent_id;
@property(nonatomic, copy)NSString *pay_check;
@property(nonatomic,  copy)NSString *pay_fee;
@property(nonatomic, copy)NSString *pay_id;
@property(nonatomic, copy)NSString *pay_name;
@property(nonatomic, copy)NSString *pay_note;
@property(nonatomic, copy)NSString *pay_online;
@property(nonatomic, copy)NSString *pay_order_id;
@property(nonatomic, copy)NSString *pay_status;
@property(nonatomic, copy)NSString *pay_time;
@property(nonatomic, copy)NSString *pay_total;
@property(nonatomic, copy)NSString *pay_total_ratio;
@property(nonatomic, copy)NSString *pay_type_id;
@property(nonatomic, copy)NSString *postscript;
@property(nonatomic, copy)NSString *prepay_ratio;
@property(nonatomic, copy)NSString *province;
@property(nonatomic, copy)NSString *remark;
@property(nonatomic, copy)NSString *seller_name;
@property(nonatomic,  copy)NSString *seller_phone;
@property(nonatomic, copy)NSString *send_address_id;
@property(nonatomic, copy)NSString *shipping_fee;
@property(nonatomic, copy)NSString *shipping_id;
@property(nonatomic, copy)NSString *shipping_name;
@property(nonatomic,  copy)NSString *shipping_status;
@property(nonatomic, copy)NSString *shipping_time;
@property(nonatomic, copy)NSString *stock_remark;
@property(nonatomic, copy)NSString *stock_status;
@property(nonatomic, copy)NSString *surplus;
@property(nonatomic, copy)NSString *tax;
@property(nonatomic, copy)NSString *tel;
@property(nonatomic, copy)NSString *to_buyer;
@property(nonatomic, copy)NSString *total_fee;
@property(nonatomic, copy)NSString *user_id;
@property(nonatomic, copy)NSString *zipcode;
@end
