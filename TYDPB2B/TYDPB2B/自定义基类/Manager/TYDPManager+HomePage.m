//
//  TYDPManager+HomePage.m
//  TYDPB2B
//
//  Created by Wangye on 16/8/12.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDPManager+HomePage.h"
#import "HomePageModel.h"

@implementation TYDPManager (HomePage)
+(void)GetHomePageInfo:(NSDictionary *)params success:(getHomePageInfoSuccess)success failure:(TYDPRequetFailure)failure{
    [self tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"数据：%@",data);
        if (![data[@"error"] intValue]) {
            HomePageModel *model = [[HomePageModel alloc] initWithDictionary:data[@"content"] error:nil];
            success(model);
        }
    } failure:^(TYDPError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
