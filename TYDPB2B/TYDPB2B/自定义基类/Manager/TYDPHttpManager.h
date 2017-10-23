//
//  TYDPHttpManager.h
//  myShopping
//
//  Created by Wangye on 16/6/30.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TYDPError;
typedef void(^HttpRequestSuccessBlock)(id json);
typedef void(^HttpRequestFailureBlock)(NSError *error);

@interface TYDPHttpManager : NSObject
/**
 *  请求
 *
 *  @param baseUrlStr 基准urlStr
 *  @param method     请求方式
 *  @param urlStr     api url
 *  @param params     参数
 *  @param success    成功回调block
 *  @param failure    失败回调block
 */
+ (void)reqWithBaseUrlStr:(NSString *)baseUrlStr
                   urlStr:(NSString *)urlStr
                   method:(NSString *)method
                   params:(NSDictionary *)params
                  success:(HttpRequestSuccessBlock)success
                  failure:(HttpRequestFailureBlock)failure;
+(AFHTTPSessionManager *)sharedAFManager:(NSString *)baseUrlStr;
@end
