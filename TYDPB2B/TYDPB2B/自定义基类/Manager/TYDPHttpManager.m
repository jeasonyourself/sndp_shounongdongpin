//
//  TYDPHttpManager.m
//  myShopping
//
//  Created by Wangye on 16/6/30.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDPHttpManager.h"
@implementation TYDPHttpManager
+(AFHTTPSessionManager *)sharedAFManager:(NSString *)baseUrlStr {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrlStr]];
    //解析去除null
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    manager.requestSerializer.timeoutInterval = TYDPTimeoutInterval;
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"User-Agent"];
    return manager;
}
+ (void)reqWithBaseUrlStr:(NSString *)baseUrlStr
                   urlStr:(NSString *)urlStr
                   method:(NSString *)method
                   params:(NSDictionary *)params
                  success:(HttpRequestSuccessBlock)success
                  failure:(HttpRequestFailureBlock)failure
{
    AFHTTPSessionManager *manager = [TYDPHttpManager sharedAFManager:baseUrlStr];
    //解析去除null

    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;

    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:urlStr relativeToURL:manager.baseURL] absoluteString] parameters:params error:nil];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error){
        if (error) {
            failure(error);
        }else{
            success(responseObject);
        }
    }];
    [task resume];
}

@end
