//
//  FilterCatDataSmallModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/5.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol FilterCatDataSmallModel
@end

@interface FilterCatDataSmallModel : JSONModel
@property(nonatomic, copy)NSString *goods_id;
@property(nonatomic, copy)NSString *goods_name;
@end
