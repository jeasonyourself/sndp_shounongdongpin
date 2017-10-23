//
//  TYDP_ChangeMobileController.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/25.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^retBlock)(NSString *mobile);
@interface TYDP_ChangeMobileController : UIViewController

@property (copy, nonatomic) NSString *oldMobile;
@property (nonatomic, copy) retBlock Block;

- (void)retMobileAndCodeBlock:(retBlock)block;

@end
