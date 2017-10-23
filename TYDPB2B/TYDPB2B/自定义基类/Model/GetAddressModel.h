//
//  GetAddressModel.h
//  TYDPB2B
//
//  Created by Wangye on 16/9/2.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@interface GetAddressModel : JSONModel
@property(nonatomic, copy)NSString *id_number;
@property(nonatomic, copy)NSString *mobile;
@property(nonatomic, copy)NSString *name;
@end
