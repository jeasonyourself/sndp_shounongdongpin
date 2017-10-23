//
//  TYDP_SelectCommentTypeController.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/22.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnBlock)(NSString *typeSAtr,NSString *msg_type);

@interface TYDP_SelectCommentTypeController : UIViewController

@property(nonatomic,copy)returnBlock returnBlock;

- (void)returnTypr:(returnBlock)block;

@end
