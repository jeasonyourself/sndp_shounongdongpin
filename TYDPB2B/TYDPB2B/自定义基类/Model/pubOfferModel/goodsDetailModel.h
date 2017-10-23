//
//  goodsDetailModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/3.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol goodsDetailModel
@end
@interface goodsDetailModel : JSONModel

@property(nonatomic, copy)NSString *base_ids;
@property(nonatomic, copy)NSString *base_ids_name;
@property(nonatomic, copy)NSString *brand_ids;
@property(nonatomic, copy)NSString *brand_logo;
@property(nonatomic, copy)NSString *brand_name;
@property(nonatomic, copy)NSString *brand_sn;
@property(nonatomic, copy)NSString *cat_id_first;
@property(nonatomic, copy)NSString *cat_ids;
@property(nonatomic, copy)NSString *goods_images;
@property(nonatomic, copy)NSString *goods_names;
@property(nonatomic, copy)NSString *make_date;
@property(nonatomic, copy)NSString *packs;
@property(nonatomic, copy)NSString *packs_name;
@property(nonatomic, copy)NSString *region;
@property(nonatomic, copy)NSString *region_name;
@property(nonatomic, copy)NSString *spec_txts;
@property(nonatomic, copy)NSString *specs_1;
@property(nonatomic, copy)NSString *specs_1_unit;
@property(nonatomic, copy)NSString *specs_2;
@property(nonatomic, copy)NSString *specs_2_unit;
@property(nonatomic, copy)NSString *specs_3;
@property(nonatomic, copy)NSString *specs_3_unit;

@end
