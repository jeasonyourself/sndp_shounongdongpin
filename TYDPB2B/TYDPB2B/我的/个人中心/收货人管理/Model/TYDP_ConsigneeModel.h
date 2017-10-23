//
//  TYDP_ConsigneeModel.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/23.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDP_ConsigneeModel : NSObject

@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *id_number;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *user_id;

//银行卡使用
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *deposit_bank;
//@property (nonatomic, copy) NSString *mobile;
//@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *is_future;
@property (nonatomic, copy) NSString *is_spot;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
