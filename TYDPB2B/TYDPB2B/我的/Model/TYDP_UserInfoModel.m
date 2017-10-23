//
//  TYDP_UserInfoModel.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/9.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_UserInfoModel.h"

@implementation TYDP_UserInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if (value) {
        key = nil;
    }
}

@end
