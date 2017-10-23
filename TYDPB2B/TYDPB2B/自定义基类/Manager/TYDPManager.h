//
//  TYDPManager.h
//  myShopping
//
//  Created by Wangye on 16/6/30.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TYDPError;
typedef void(^TYDPRequetSuccess)(id data);
typedef void(^TYDPRequetFailure)(TYDPError *error);

@interface TYDPManager : NSObject
/**
 *   @brief 管理类
 */

+(TYDPManager *)sharedTYDPManager;

/**
 *   @brief 接口get请求基础方法
 *
 *   @param urlStr        接口URL
 *   @param params        接口参数
 *   @param success       请求成功
 *   @param failure       请求失败
 */
+ (void)tydp_baseGetReqWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params success:(TYDPRequetSuccess)success failure:(TYDPRequetFailure)failure;

/**
 *   @brief 接口post请求基础方法
 *
 *   @param urlStr  接口URL
 *   @param params  接口参数
 *   @param success 请求成功
 *   @param failure 请求失败
 */
+ (void)tydp_basePostReqWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params success:(TYDPRequetSuccess)success failure:(TYDPRequetFailure)failure;
+(NSString*)tydp_dictionaryToJson:(NSDictionary *)dic;
+(NSDictionary *)addCommomParam:(NSDictionary *)params;
+(NSString *)md5:(NSString *)str;
+(void)upLoadPic:(NSDictionary *)params withImage:(UIImage *)image withName:(NSString*)nameString withView:(UIView *)superView;
+(NSData *)resetSizeOfImageData:(UIImage*)sourceImage maxSize:(NSInteger)maxSize;
@end
