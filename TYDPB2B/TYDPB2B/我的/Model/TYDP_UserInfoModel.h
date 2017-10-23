//
//  TYDP_UserInfoModel.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/9.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDP_UserInfoModel : NSObject

@property(nonatomic , copy)NSString* address;
@property(nonatomic , copy)NSString* address_id;
@property(nonatomic , copy)NSString* alias;
@property(nonatomic , copy)NSString* birthday;
@property(nonatomic , copy)NSString* bonus_number;
@property(nonatomic , copy)NSString* city;
@property(nonatomic , copy)NSString* credit_line;
@property(nonatomic , copy)NSString* email;
@property(nonatomic , copy)NSString* formated_frozen_money;
@property(nonatomic , copy)NSString* formated_last_login;
@property(nonatomic , copy)NSString* formated_reg_time;
@property(nonatomic , copy)NSString* formated_user_money;
@property(nonatomic , copy)NSString* frozen_money;
@property(nonatomic , copy)NSString* home_phone;
@property(nonatomic , copy)NSString* is_validated;
@property(nonatomic , copy)NSString* kefu_id;
@property(nonatomic , copy)NSString* last_ip;
@property(nonatomic , copy)NSString* last_login;
@property(nonatomic , copy)NSString* mobile_phone;
@property(nonatomic , copy)NSString* msn;
@property(nonatomic , copy)NSString* office_phone;
@property(nonatomic , copy)NSString* parent_id;
@property(nonatomic , copy)NSString* pay_points;
@property(nonatomic , copy)NSString* province;
@property(nonatomic , copy)NSString* qq;
@property(nonatomic , copy)NSString* join;
@property(nonatomic , copy)NSString* rank_name;
@property(nonatomic , copy)NSString* rank_points;
@property(nonatomic , copy)NSString* reg_time;
@property(nonatomic , copy)NSString* sex;
@property(nonatomic , copy)NSString* shop_name;
@property(nonatomic , copy)NSString* user_face;
@property(nonatomic , copy)NSString* user_id;
@property(nonatomic , copy)NSString* user_money;
@property(nonatomic , copy)NSString* user_name;
@property(nonatomic , copy)NSString* user_rank;
@property(nonatomic , copy)NSString* visit_count;
@property(nonatomic , copy)NSString* shop_info;
//@property(nonatomic , copy)NSString* token;
@property(nonatomic , assign)int huck_num;
@property(nonatomic , copy)NSString* kefu_mobile;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
