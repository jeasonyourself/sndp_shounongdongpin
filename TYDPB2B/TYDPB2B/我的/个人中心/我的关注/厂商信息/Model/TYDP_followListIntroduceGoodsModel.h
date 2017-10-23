//
//  TYDP_followListIntroduceGoodsModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/10.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol TYDP_followListIntroduceGoodsModel
@end
@interface TYDP_followListIntroduceGoodsModel : JSONModel
@property (nonatomic, copy) NSString *good_face;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *shop_price;
@property (nonatomic, copy) NSString *user_id;
@end
