//
//  goodsNameModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/28.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol goodsNameModel//报价类型、港口
@end

@interface goodsNameModel : JSONModel
@property(nonatomic, copy)NSString *goods_id;
@property(nonatomic, copy)NSString *goods_name;
@property(nonatomic, copy)NSString *goods_name_en;
@end
