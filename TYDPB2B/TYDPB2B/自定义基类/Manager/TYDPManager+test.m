//
//  TYDPManager+test.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/19.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDPManager+test.h"
//用户登录
static NSString * const testUrl =@"";

@implementation TYDPManager (test)
+(void)userLoginWithAcount:(NSDictionary *)params
                   success:(testSuccess)success
                   failure:(TYDPRequetFailure)failure{
    [self tydp_basePostReqWithUrlStr:testUrl params:params success:^(id data) {
        NSLog(@"%@",data);
    } failure:^(TYDPError *error) {
        
    }];
}
@end
