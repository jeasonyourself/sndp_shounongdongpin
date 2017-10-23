//
//  TYDP_WantController.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/14.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYDP_MyWantModel.h"

@interface TYDP_IssueWantController : UIViewController

@property (nonatomic, strong) TYDP_MyWantModel *model;
@property(nonatomic,assign)BOOL dismissOrPop;

@end
