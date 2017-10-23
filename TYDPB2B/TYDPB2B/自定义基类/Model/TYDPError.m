//
//  TYDPError.m
//  myShopping
//
//  Created by Wangye on 16/6/30.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDPError.h"

const int TYDPReturnSuccess = 0;
const int TYDPReturnFailure = -1;
@implementation TYDPError
{
    NSDictionary *kErrMsgDict;
}
+(instancetype)errorWithErrorCode:(TYDPReturnCode)code errorMsg:(NSString *)msg
{
    return [[self alloc] initWithErrorCode:code errorMsg:msg];
}
-(instancetype)initWithErrorCode:(TYDPReturnCode)code errorMsg:(NSString *)msg
{
    self = [super init];
    if (self) {
        _code = code;
        _msg  = msg.length ? msg : [self p_errMsgWithCode:code];
    }
    return self;
}
-(NSString *)p_errMsgWithCode:(TYDPReturnCode)code
{
    if (kErrMsgDict == nil) {
        kErrMsgDict = @{
                        @"0" : @"操作成功",
                        @"1000": @"操作失败",
                        @"2000": @"账户不存在",
                        @"2002": @"用户名重复",
                        @"2007": @"手机号重复",
                        @"2008": @"密码错误",
                        @"2010": @"验证码错误",
                        @"9999": @"其他错误",
                        };
    }
    return kErrMsgDict[[NSString stringWithFormat:@"%d",code]];
}

@end
