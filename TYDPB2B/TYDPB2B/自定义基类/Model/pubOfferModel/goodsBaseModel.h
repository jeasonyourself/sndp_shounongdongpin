//
//  goodsBaseModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/4.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol goodsBaseModel
@end
@interface goodsBaseModel :JSONModel

@property(nonatomic, copy)NSString *brand_sn;
@property(nonatomic, copy)NSString *currency;
@property(nonatomic, copy)NSString *good_face;
@property(nonatomic, copy)NSString *goods_id;
@property(nonatomic, copy)NSString *goods_local;
@property(nonatomic, copy)NSString *goods_name;
@property(nonatomic, copy)NSString *goods_number;
@property(nonatomic, copy)NSString *goods_thumb;
@property(nonatomic, copy)NSString *goods_type;
@property(nonatomic, copy)NSString *goods_weight;
@property(nonatomic, copy)NSString *is_check;
@property(nonatomic, copy)NSString *is_on_sale;
@property(nonatomic, copy)NSString *is_pin;
@property(nonatomic, copy)NSString *last_update_time;
@property(nonatomic, copy)NSString *measure_unit;
@property(nonatomic, copy)NSString *offer;
@property(nonatomic, copy)NSString *region_icon;
@property(nonatomic, copy)NSString *region_name;
@property(nonatomic, copy)NSString *sell_type;
@property(nonatomic, copy)NSString *shop_price;
@property(nonatomic, copy)NSString *shop_price_am;
@property(nonatomic, copy)NSString *shop_price_eur;
@property(nonatomic, copy)NSString *shop_price_unit;
@property(nonatomic, copy)NSString *sku;
@property(nonatomic, copy)NSString *spec_1_unit;
@property(nonatomic, copy)NSString *spec_2_unit;
@property(nonatomic, copy)NSString *spec_1;
@property(nonatomic, copy)NSString *spec_2;
@property(nonatomic, copy)NSString *unit_name;

@end
