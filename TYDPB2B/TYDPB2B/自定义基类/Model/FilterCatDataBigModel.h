//
//  FilterCatDataBigModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/5.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FilterCatDataSmallModel.h"
@protocol FilterCatDataBigModel
@end

@interface FilterCatDataBigModel : JSONModel
@property(nonatomic, copy)NSString *cat_id;
@property(nonatomic, copy)NSString *cat_name;
@property(nonatomic, strong)NSArray<FilterCatDataSmallModel> *cat_list;
@end
