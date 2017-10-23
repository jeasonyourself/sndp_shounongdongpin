//
//  HomePageFilterModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/24.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HomePageFilterSmallModel.h"

@interface HomePageFilterModel : JSONModel
@property(nonatomic, copy)NSString *cat_id;
@property(nonatomic, copy)NSString *cat_name;
@property(nonatomic, strong)NSArray<HomePageFilterSmallModel> *son;
@end
