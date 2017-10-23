//
//  CALayer+TYDP_Category.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/23.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "CALayer+TYDP_Category.h"

@implementation CALayer (TYDP_Category)

- (void)setBorderUIColor:(UIColor*)color{
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
