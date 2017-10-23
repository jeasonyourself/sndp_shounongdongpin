//
//  OfferHistoryModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/16.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol OfferHistoryModel
@end

@interface OfferHistoryModel : JSONModel
@property(nonatomic, copy)NSString *add_time;
@property(nonatomic, copy)NSString *goods_amount;
@property(nonatomic, copy)NSString *rate;
@end
