//
//  TYDP_NewsModel.h
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/10.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDP_NewsModel : NSObject

@property(nonatomic,copy)NSString *add_time;
@property(nonatomic,copy)NSString *arc_img;
@property(nonatomic,copy)NSString *author;
@property(nonatomic,copy)NSString *Description;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *is_new;
@property(nonatomic,copy)NSString *short_title;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *url;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
