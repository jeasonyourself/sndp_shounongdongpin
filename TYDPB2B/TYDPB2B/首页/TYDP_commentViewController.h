//
//  TYDP_commentViewController.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/14.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol commentDelegate <NSObject>
- (void) pubcomment:(NSInteger)sender;
@end
@interface TYDP_commentViewController : UIViewController
@property(nonatomic, strong)id<commentDelegate>delegate;
@property(nonatomic, strong)NSString *qiugou_id;

@end
