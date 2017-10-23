//
//  TYDP_ConsigneeController.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/27.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^addAddressInfoBlock)(NSDictionary *dic);
@interface TYDP_ConsigneeController : UIViewController

@property(nonatomic,assign)int pushType;//0.从订单页面push过来; 1.从个人中心页面push过来。
@property(nonatomic, copy)addAddressInfoBlock addAddressInfoBlock;
@property(nonatomic,assign)int type;//0.买家; 1.卖家。


@end
