//
//  FilterModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/5.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TopCategoryModel.h"
#import "FilterSiteListModel.h"
#import "FilterSiteBrandListModel.h"
#import "FilterSellListModel.h"
#import "FilterCatDataBigModel.h"

@interface FilterModel : JSONModel
@property(nonatomic, strong)NSArray<TopCategoryModel> *top_category;
@property(nonatomic, strong)NSArray<FilterCatDataBigModel> *cat_data;//产品
@property(nonatomic, strong)NSArray<FilterSellListModel> *sel_list;//港口
@property(nonatomic, strong)NSArray<FilterSiteListModel> *site_list;//产地
@property(nonatomic, strong)NSArray<FilterSiteBrandListModel> *brand_list;//厂号
@property(nonatomic, strong)NSArray *goods_local;//货物所在地
@end
