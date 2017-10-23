//
//  GoodListModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/24.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol GoodListModel
@end
@interface GoodListModel : JSONModel
@property(nonatomic, copy)NSString *goods_id;
@property(nonatomic, copy)NSString *goods_name;
@property(nonatomic, copy)NSString *goods_thumb;
@end
