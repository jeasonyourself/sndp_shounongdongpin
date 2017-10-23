//
//  HomePageMiddlePicModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/12.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HomePageMiddlePicModel : JSONModel
@property(nonatomic, copy)NSString *url;
@property(nonatomic, copy)NSString *link;
@property(nonatomic, copy)NSString *width;
@property(nonatomic, copy)NSString *height;
@property(nonatomic, copy)NSString *text;
@end
