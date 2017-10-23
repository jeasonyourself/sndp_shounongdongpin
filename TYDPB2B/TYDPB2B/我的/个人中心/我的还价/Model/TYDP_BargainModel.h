//
//  TYDP_BargainModel.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/17.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDP_BargainModel : NSObject

@property(nonatomic,copy)NSString *brand_sn;
@property(nonatomic,copy)NSString *created_at;
@property(nonatomic,copy)NSString *formated_shop_price;
@property(nonatomic,copy)NSString *goods_id;
@property(nonatomic,copy)NSString *goods_name;
@property(nonatomic,copy)NSString *goods_thumb;
@property(nonatomic,copy)NSString *goods_type;//还价状态
@property(nonatomic,copy)NSString *goods_user_id;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *is_pin;
@property(nonatomic,copy)NSString *last_price;
@property(nonatomic,copy)NSString *offer;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *sell_type;//期整还
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *user_id;
//@property(nonatomic,copy)NSString *created_at;
@property(nonatomic,copy)NSString *message;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
