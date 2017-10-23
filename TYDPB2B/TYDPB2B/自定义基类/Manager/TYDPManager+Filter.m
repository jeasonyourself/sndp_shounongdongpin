//
//  TYDPManager+Filter.m
//  TYDPB2B
//
//  Created by Wangye on 16/8/5.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDPManager+Filter.h"
#import "FilterModel.h"

@implementation TYDPManager (Filter)
+(void)GetFilterInfo:(NSDictionary *)params success:(getFilterInfoSuccess)success failure:(TYDPRequetFailure)failure{
    [self tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"alldddate:%@",data);
        if (![data[@"error"] intValue]) {
            FilterModel *model = [[FilterModel alloc] initWithDictionary:data[@"content"] error:nil];
            success(model);
        }
    } failure:^(TYDPError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
