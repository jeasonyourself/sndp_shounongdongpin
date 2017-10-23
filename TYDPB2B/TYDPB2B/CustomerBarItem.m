//
//  CustomerBarItem.m
//  myShopping
//
//  Created by Wangye on 16/6/28.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "CustomerBarItem.h"

@implementation CustomerBarItem
- (void)awakeFromNib {
    [super awakeFromNib];
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBACOLOR(51, 51, 51, 1)} forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBACOLOR(25, 181, 254, 1)} forState:UIControlStateSelected];
}
@end
