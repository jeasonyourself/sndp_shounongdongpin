//
//  HomePageSlideModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/12.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol HomePageSlideModel
@end

@interface HomePageSlideModel : JSONModel
@property(nonatomic, copy)NSString *pic;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *link;
@end
