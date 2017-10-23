//
//  ShopListModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/24.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GoodListModel.h"

@interface ShopListModel : JSONModel
@property(nonatomic, copy)NSString *user_id;
@property(nonatomic, copy)NSString *user_face;
@property(nonatomic, copy)NSString *shop_id;
@property(nonatomic, copy)NSString *shop_name;
@property(nonatomic, copy)NSString *order_num;
@property(nonatomic, strong)NSArray<GoodListModel> *good_list;
@end
