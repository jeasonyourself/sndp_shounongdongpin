//
//  PlaceholderTextView.h
//  tongchenghaoke
//
//  Created by 张俊松 on 16/5/16.
//  Copyright © 2016年 zhangjunsong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView
@property(copy,nonatomic) NSString *placeholder;
@property(strong,nonatomic) UIColor *placeholderColor;
@property(strong,nonatomic) UIFont * placeholderFont;
@property(strong,nonatomic) UILabel *PlaceholderLabel;
@end
