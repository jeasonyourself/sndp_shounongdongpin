//
//  userMoneyViewController.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/9.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^addMoneyMsgInfoBlock)(NSDictionary *dic);

@interface userMoneyViewController : UIViewController
@property(nonatomic,assign)int pushType;//0.从订单页面push过来; 1.从个人中心页面push过来。
@property(nonatomic, copy)addMoneyMsgInfoBlock addMoneyMsgInfoBlock;

@end
