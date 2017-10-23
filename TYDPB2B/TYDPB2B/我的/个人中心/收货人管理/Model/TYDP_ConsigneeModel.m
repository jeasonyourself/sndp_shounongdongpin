//
//  TYDP_ConsigneeModel.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/23.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_ConsigneeModel.h"

@implementation TYDP_ConsigneeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;{
    if ([key isEqualToString:@"id"]) {
        self.Id = value;
    }
}

@end
