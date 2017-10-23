//
//  TYDPManager+Filter.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/5.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDPManager.h"
@class FilterModel;
//获取筛选信息
typedef void (^getFilterInfoSuccess)(FilterModel *totalFilterInfo);
@interface TYDPManager (Filter)
+(void)GetFilterInfo:(NSDictionary *)params
             success:(getFilterInfoSuccess)success
             failure:(TYDPRequetFailure)failure;
@end
