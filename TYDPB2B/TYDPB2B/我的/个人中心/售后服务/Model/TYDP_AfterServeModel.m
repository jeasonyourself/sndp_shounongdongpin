//
//  TYDP_AfterServeModel.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/17.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_AfterServeModel.h"

@implementation TYDP_AfterServeModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if (value) {
        key = nil;
    }
}
@end
