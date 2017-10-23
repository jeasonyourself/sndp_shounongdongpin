//
//  HomePageModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/12.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HomePageSlideModel.h"
#import "HomePageMiddlePicModel.h"
#import "BestGoodsModel.h"
#import "purchaseListModel.h"

@interface HomePageModel : JSONModel
@property(nonatomic, strong)NSArray <HomePageSlideModel>*app_slide;
@property(nonatomic, strong)HomePageMiddlePicModel <Optional>*app_index_pic;
@property(nonatomic, strong)NSArray <BestGoodsModel>*best_goods;
@property(nonatomic, strong)NSArray <BestGoodsModel>*miaosha_goods;

@property(nonatomic, strong)NSArray <purchaseListModel >*purchase_list;
@property(nonatomic, strong)NSArray <BestGoodsModel>*tejia_goods;

@end
