//
//  pubOfferModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/28.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TopCategoryModel.h"
#import "FilterSiteListModel.h"
#import "FilterSiteBrandListModel.h"
#import "FilterSellListModel.h"
#import "FilterCatDataBigModel.h"
#import "offerTypeModel.h"

@interface pubOfferModel : JSONModel
@property(nonatomic, strong)NSArray<FilterSiteListModel> *site_list;//产地
@property(nonatomic, strong)NSArray<TopCategoryModel> *cat_list;//产品分类
@property(nonatomic, strong)NSDictionary *user_info;//用户信息
@property(nonatomic, strong)NSArray<offerTypeModel> *offer_type;//报价类型
@property(nonatomic, strong)NSArray<FilterSellListModel> *port;//港口

@property(nonatomic, strong)NSArray<offerTypeModel> *prepay;//预付款


@end
