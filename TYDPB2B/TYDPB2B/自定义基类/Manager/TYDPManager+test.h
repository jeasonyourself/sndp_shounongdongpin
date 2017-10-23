//
//  TYDPManager+test.h
//  TYDPB2B
//
//  Created by Wangye on 16/7/19.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDPManager.h"
@class testModel;
typedef void (^testSuccess)(testModel *test);
@interface TYDPManager (test)
+(void)userLoginWithAcount:(NSDictionary *)params
                   success:(testSuccess)success
                   failure:(TYDPRequetFailure)failure;

@end
