//
//  TYDPManager+HomePage.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/12.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDPManager.h"
@class HomePageModel;
//获取首页信息
typedef void (^getHomePageInfoSuccess)(HomePageModel *totalHomePageInfo);
@interface TYDPManager (HomePage)
+(void)GetHomePageInfo:(NSDictionary *)params
               success:(getHomePageInfoSuccess)success
               failure:(TYDPRequetFailure)failure;
@end
