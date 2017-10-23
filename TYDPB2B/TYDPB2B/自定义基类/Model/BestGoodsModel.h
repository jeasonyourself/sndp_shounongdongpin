//
//  BestGoodsModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/12.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol BestGoodsModel
@end

@interface BestGoodsModel : JSONModel
@property(nonatomic, copy)NSString *goods_id;
@property(nonatomic, copy)NSString *brand_id;
@property(nonatomic, copy)NSString *goods_name;
@property(nonatomic, copy)NSString *brand_sn;
@property(nonatomic, copy)NSString *shop_price;
@property(nonatomic, copy)NSString *goods_local;
@property(nonatomic, copy)NSString *goods_type;
@property(nonatomic, copy)NSString *sell_type;
@property(nonatomic, copy)NSString *offer;
@property(nonatomic, copy)NSString *region_name;
@property(nonatomic, copy)NSString *region_name_ch;
@property(nonatomic, copy)NSString *goods_thumb;
@property(nonatomic, copy)NSString *spec_1;
@property(nonatomic, copy)NSString *spec_1_unit;
@property(nonatomic, copy)NSString *spec_2;
@property(nonatomic, copy)NSString *spec_2_unit;
@property(nonatomic, copy)NSString *goods_weight;
@property(nonatomic, copy)NSString *is_pin;
@property(nonatomic, copy)NSString *unit_name;
@property(nonatomic, copy)NSString *picture;
@property(nonatomic, copy)NSString *region_icon;
@property(nonatomic, copy)NSString *goods_number;
@property(nonatomic, copy)NSString *shop_price_fake;
@property(nonatomic, copy)NSString *arrive_count;
@end
