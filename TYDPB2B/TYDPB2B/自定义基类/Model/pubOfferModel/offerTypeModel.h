//
//  offerTypeModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/28.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol offerTypeModel//报价类型、港口
@end

@interface offerTypeModel : JSONModel
@property(nonatomic, copy)NSString *id;
@property(nonatomic, copy)NSString *val;
@end
