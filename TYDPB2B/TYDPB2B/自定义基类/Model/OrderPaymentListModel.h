//
//  OrderPaymentListModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/9/1.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol OrderPaymentListModel
@end
@interface OrderPaymentListModel : JSONModel
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *value;
@end
