//
//  FilterSiteBrandListModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/5.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol FilterSiteBrandListModel
@end

@interface FilterSiteBrandListModel : JSONModel
@property(nonatomic, copy)NSString *brand_id;
@property(nonatomic, copy)NSString *brand_sn;
@property(nonatomic, copy)NSString *brand_name;

@end
