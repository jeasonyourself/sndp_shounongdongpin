//
//  PicListModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/8/16.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol PicListModel
@end

@interface PicListModel : JSONModel
@property(nonatomic, copy)NSString *thumb_url;
@end
