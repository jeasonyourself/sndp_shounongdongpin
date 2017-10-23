//
//  TYDP_MyWantModel.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/17.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_MyWantModel.h"

@implementation TYDP_MyWantModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.Id = value;
    }
}
@end
