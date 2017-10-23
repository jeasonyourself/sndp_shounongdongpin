//
//  OfferDetailModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/16.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OfferHistoryModel.h"
#import "OfferModel.h"
#import "PicListModel.h"
#import "goodsDetailModel.h"
#import "goodsBaseModel.h"

@interface OfferDetailModel : JSONModel
@property(nonatomic, copy)NSString *goods_name;
@property(nonatomic, copy)NSString *sku;
@property(nonatomic, copy)NSString *region_name;
@property(nonatomic, copy)NSString *brand_sn;
@property(nonatomic, copy)NSString *spec_1;
@property(nonatomic, copy)NSString *spec_1_unit;
@property(nonatomic, copy)NSString *spec_2;
@property(nonatomic, copy)NSString *spec_2_unit;
@property(nonatomic, copy)NSString *spec_txt;
@property(nonatomic, copy)NSString *goods_number;
@property(nonatomic, copy)NSString *pack_name;
@property(nonatomic, copy)NSString *goods_lcoal;
@property(nonatomic, copy)NSString *port_name;
@property(nonatomic, copy)NSString *prepay_name;
@property(nonatomic, copy)NSString *prepay_type;
@property(nonatomic, copy)NSString *prepay_num;
@property(nonatomic, copy)NSString *goods_txt;
@property(nonatomic, copy)NSString *offer_type;
@property(nonatomic, copy)NSString *sell_type;
@property(nonatomic, copy)NSString *goods_type;
@property(nonatomic, copy)NSString *offer;
@property(nonatomic, copy)NSString *shop_price;
@property(nonatomic, copy)NSString *goods_unit;
@property(nonatomic, copy)NSString *unit_name;

@property(nonatomic, copy)NSString *goods_weight;
@property(nonatomic, copy)NSString *shop_name;
@property(nonatomic, copy)NSString *shop_id;
@property(nonatomic, copy)NSString *formated_arrive_date;
@property(nonatomic, copy)NSString *formated_lading_date;
@property(nonatomic, copy)NSString *is_pin;
@property(nonatomic, copy)NSString *goods_thumb;
@property(nonatomic, copy)NSString *make_date;
@property(nonatomic, copy)NSString *last_update;
@property(nonatomic, strong)NSArray<PicListModel> *picture_list;
@property(nonatomic, strong)NSArray<OfferHistoryModel> *bp_list;
@property(nonatomic, strong)NSArray <OfferModel> *huck_list;
@property(nonatomic, strong)NSArray<goodsDetailModel> *goods_base;
@property(nonatomic, strong)NSArray <goodsBaseModel> *goods_base_list;
@property(nonatomic, copy)NSString *user_id;
@property(nonatomic, copy)NSString *goods_id;


@property(nonatomic, copy)NSString *follow_count;
@property(nonatomic, copy)NSString *formated_shop_price;
@property(nonatomic, copy)NSString *goods_local;
@property(nonatomic, copy)NSString *shop_goods_num;
@property(nonatomic, copy)NSString *shop_logo;
@property(nonatomic, copy)NSString *shop_order_num;
@property(nonatomic, copy)NSString *shop_price_unit;
@end
