//
//  TYDPError.h
//  myShopping
//
//  Created by Wangye on 16/6/30.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *   @brief 接口返回码
 */
typedef int TYDPReturnCode;
/**
 *   @brief 返回成功
 */
extern TYDPReturnCode const KODReturnSuccess;
/**
 *   @brief 返回失败
 */
extern TYDPReturnCode const KODReturnFailure;
@interface TYDPError : NSObject
-(instancetype)initWithErrorCode:(TYDPReturnCode)code errorMsg:(NSString *)msg;
+(instancetype)errorWithErrorCode:(TYDPReturnCode)code errorMsg:(NSString *)msg;
@property (assign, nonatomic) TYDPReturnCode code;
@property (copy, nonatomic) NSString *msg;
@end
