//
//  TYDP_selectViewController.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/29.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol selectTitleDelegate <NSObject>
- (void) selectTitleClick:(NSString *)name andId:(NSString *)s_id byTag:(NSInteger)tag;
@end

@interface TYDP_selectViewController : UIViewController
@property(nonatomic, strong)NSArray *goodsCharacterArr;
@property(nonatomic, assign)NSInteger goods_num;
//先判断现货、期货、零售、整柜
@property(nonatomic, assign)NSInteger firstFrontSelectedRowNumber;//0是国家，1是厂号，2是产品分类，3是产品名称，4是预付款 ，5是报价类型，6是到达港口
@property(nonatomic, strong)NSString *fid;//厂号、产品名称添加用到
@property(nonatomic, strong)NSArray *rightSecondAgencyArray;
@property(nonatomic, strong)id<selectTitleDelegate>delegate;

@end
