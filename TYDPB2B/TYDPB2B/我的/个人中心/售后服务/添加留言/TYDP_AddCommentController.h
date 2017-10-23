//
//  TYDP_AddCommentController.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/21.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDP_AddCommentController : UIViewController

@property (assign, nonatomic) NSInteger pushType;//从留言列表页进入为0，从订单详情页进入为1
@property (nonatomic, copy) NSString *titleStr;//从订单也跳转过来后给留言主题赋值

@end
