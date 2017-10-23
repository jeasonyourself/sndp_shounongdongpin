//
//  FilterSiteListModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/5.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol FilterSiteListModel
@end

@interface FilterSiteListModel : JSONModel
@property(nonatomic, copy)NSString *id;
@property(nonatomic, copy)NSString *site_name;
@property(nonatomic, copy)NSString *site_icon;
@end
