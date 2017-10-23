//
//  brandListModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/28.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FilterSiteBrandListModel.h"
@protocol brandListModel
@end

@interface brandListModel : JSONModel
@property(nonatomic,  strong)NSArray<FilterSiteBrandListModel> *brand_list;//产地
@end
