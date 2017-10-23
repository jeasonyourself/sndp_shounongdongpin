//
//  commentListModel.h
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/13.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol commentListModel
@end

@interface commentListModel : JSONModel
@property(nonatomic, copy)NSString *add_time;
@property(nonatomic, copy)NSString *content;
@property(nonatomic, copy)NSString *id;
@property(nonatomic, copy)NSString *p_id;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *user_face;

@property(nonatomic, copy)NSString *user_id;
@property(nonatomic, copy)NSString *user_name;

@end
