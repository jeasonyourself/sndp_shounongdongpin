//
//  TYDP_NewsModel.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/10.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_NewsModel.h"

@implementation TYDP_NewsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]||[key isEqualToString:@"description"]) {
        self.Id = value;
    }
}

@end
