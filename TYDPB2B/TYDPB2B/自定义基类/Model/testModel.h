//
//  testModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/7/19.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface testModel : JSONModel
@property(nonatomic, copy)NSString *list;
@property(nonatomic, copy)NSString *goods_id;
@property(nonatomic, copy)NSString *goods_name;
@property(nonatomic, copy)NSString *goods_price;
@property(nonatomic, copy)NSString *goods_local;
@property(nonatomic, copy)NSString *goods_type;
@property(nonatomic, copy)NSString *sell_type;
@property(nonatomic, copy)NSString *offer;
@property(nonatomic, copy)NSString *region_name_ch;
@property(nonatomic, copy)NSString *region_thumb;
@property(nonatomic, copy)NSString *unit_name;
@property(nonatomic, copy)NSString *total;
@property(nonatomic, copy)NSString *record_count;
@property(nonatomic, copy)NSString *page_count;
@property(nonatomic, copy)NSString *page;
@end
