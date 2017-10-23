//
//  purchaseListModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/13.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol purchaseListModel
@end

@interface purchaseListModel : JSONModel
@property(nonatomic, copy)NSString *address;
@property(nonatomic, copy)NSString *created_at;
@property(nonatomic, copy)NSString *goods_name;
@property(nonatomic, copy)NSString *goods_num;
@property(nonatomic, copy)NSString *id;
@property(nonatomic, copy)NSString *memo;
@property(nonatomic, copy)NSString *price_low;
@property(nonatomic, copy)NSString *price_up;
@property(nonatomic, copy)NSString *sku;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *user_face;
@property(nonatomic, copy)NSString *user_id;
@property(nonatomic, copy)NSString *user_name;
@property(nonatomic, copy)NSString *user_phone;
@end
