//
//  CheckOrderGoodsModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/9/2.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CheckOrderGoodsModel : JSONModel
@property(nonatomic, copy)NSString *goods_id;
@property(nonatomic, copy)NSString *goods_thumb;
@property(nonatomic, copy)NSString *goods_name;
@property(nonatomic, copy)NSString *goods_number;
@property(nonatomic, copy)NSString *goods_price;
@property(nonatomic, copy)NSString *measure_unit;
@property(nonatomic, copy)NSString *part_number;
@property(nonatomic, copy)NSString *part_unit;
@property(nonatomic, copy)NSString *brand_sn;
@property(nonatomic, copy)NSString *shop_price_unit;

@property(nonatomic, copy)NSString *en_dw;
@property(nonatomic, copy)NSString *extension_code;
@property(nonatomic, copy)NSString *formated_goods_price;
@property(nonatomic, copy)NSString *formated_subtotal;
@property(nonatomic, copy)NSString *good_face;
@property(nonatomic, copy)NSString *goods_attr;
@property(nonatomic, copy)NSString *goods_attr_id;
@property(nonatomic, copy)NSString *goods_local;
@property(nonatomic, copy)NSString *goods_type;
@property(nonatomic, copy)NSString *goods_sn;
@property(nonatomic, copy)NSString *is_gift;
@property(nonatomic, copy)NSString *is_real;
@property(nonatomic, copy)NSString *is_retail;
@property(nonatomic, copy)NSString *market_price;
@property(nonatomic, copy)NSString *order_id;
@property(nonatomic, copy)NSString *parent_id;
@property(nonatomic, copy)NSString *part_weight;
@property(nonatomic, copy)NSString *port;
@property(nonatomic, copy)NSString *product_id;
@property(nonatomic, copy)NSString *rec_id;
@property(nonatomic, copy)NSString *region_name;
@property(nonatomic, copy)NSString *send_number;
@property(nonatomic, copy)NSString *shop_price;
@property(nonatomic, copy)NSString *sku;
@property(nonatomic, copy)NSString *spec_2;
@property(nonatomic, copy)NSString *storage;
@property(nonatomic, copy)NSString *subtotal;
@property(nonatomic, copy)NSString *total_weight;
@property(nonatomic, copy)NSString *user_id;

@end
