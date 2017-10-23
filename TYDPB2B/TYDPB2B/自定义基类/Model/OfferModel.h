//
//  OfferModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/16.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol OfferModel
@end

@interface OfferModel : JSONModel
@property(nonatomic, copy)NSString *unit;
@property(nonatomic, copy)NSString *formated_price;
@property(nonatomic, copy)NSString *created_at;
@property(nonatomic, copy)NSString *user_name;
@end
