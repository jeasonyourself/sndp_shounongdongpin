//
//  goodsNameListModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/28.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "goodsNameModel.h"
@protocol goodsNameListModel
@end

@interface goodsNameListModel : JSONModel
@property(nonatomic,  strong)NSArray<goodsNameModel> *goods_name_list;//产品名称


@end
