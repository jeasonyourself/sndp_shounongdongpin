//
//  talkPriceModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/9.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface talkPriceModel : JSONModel
@property(nonatomic, copy)NSString *base_id;
@property(nonatomic, copy)NSString *base_ids;
@property(nonatomic, copy)NSString *brand_sn;
@property(nonatomic, copy)NSString *good_face;
@property(nonatomic, copy)NSString *goods_id;
@property(nonatomic, copy)NSString *goods_name;
@property(nonatomic, copy)NSString *goods_thumb;
@property(nonatomic, copy)NSString *goods_type;
@property(nonatomic, copy)NSString *goods_type_name;
@property(nonatomic, copy)NSArray *huck_list;
@property(nonatomic, copy)NSString *huckster;
@property(nonatomic, copy)NSString *offer;
@property(nonatomic, copy)NSString *offer_name;
@property(nonatomic, copy)NSString *port_name;
@property(nonatomic, copy)NSString *region_name;
@property(nonatomic, copy)NSString *sell_type;
@property(nonatomic, copy)NSString *sell_type_name;
@property(nonatomic, copy)NSString *shop_price;

@end
