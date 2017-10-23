//
//  TYDP_MyWantModel.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/17.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDP_MyWantModel : NSObject

@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *created;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *goods_name;
@property (nonatomic,copy) NSString *goods_num;
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *memo;
@property (nonatomic,copy) NSString *memo_len;
@property (nonatomic,copy) NSString *price_low;
@property (nonatomic,copy) NSString *price_up;
@property (nonatomic,copy) NSString *sku;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,copy) NSString *user_phone;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
