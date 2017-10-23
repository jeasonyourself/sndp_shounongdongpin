//
//  TopCategoryModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/5.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol TopCategoryModel
@end

@interface TopCategoryModel : JSONModel
@property(nonatomic, copy)NSString *cat_id;
@property(nonatomic, copy)NSString *cat_name;
@end
