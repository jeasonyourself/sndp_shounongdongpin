//
//  TYDP_SelectAddressController.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/12.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sendAddressBlock)(NSString *addressName,NSString *privinceId,NSString *cityId);
@interface TYDP_SelectAddressController : UIViewController

@property (nonatomic,copy)sendAddressBlock retBlock;
@property (nonatomic,copy)NSString *provinceId;
@property (nonatomic,copy)NSString *cityId;

- (void)retTextBlock:(sendAddressBlock)block;

@end
