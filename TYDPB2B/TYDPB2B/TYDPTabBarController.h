//
//  TYDPTabBarController.h
//  myShopping
//
//  Created by tycdong on 16/7/8.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectTabBarBlock )(NSInteger index);
@interface TYDPTabBarController : UITabBarController
@property(nonatomic, copy)SelectTabBarBlock selectTabBarBlock;
@end
