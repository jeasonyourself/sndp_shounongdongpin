//
//  TYDPPhotoPickerManager.h
//  TYDPB2B
//
//  Created by Wangye on 16/7/28.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^PickerCompelitionBlock)(UIImage *image);
typedef void (^PickerCancelBlock)();
@interface TYDPPhotoPickerManager : NSObject
+(TYDPPhotoPickerManager *)shared;
-(void)showActionSheetInView:(UIView *)inView fromController:(UIViewController *)fromController completion:(PickerCompelitionBlock)completion cancelBlock:(PickerCancelBlock)cancelBlock;
@end
