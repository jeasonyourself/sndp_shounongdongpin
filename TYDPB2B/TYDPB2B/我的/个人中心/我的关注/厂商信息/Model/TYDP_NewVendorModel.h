//
//  TYDP_NewVendorModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/9/21.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TYDP_followListIntroduceGoodsModel.h"
@interface TYDP_NewVendorModel : JSONModel
@property (nonatomic, copy) NSString *follow_count;
@property(nonatomic, strong)NSArray<TYDP_followListIntroduceGoodsModel > * good_list;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *user_face;
@end
