//
//  ZYPathItemButton.m
//  ZYPathButton
//
//  Created by tang dixi on 31/7/14.
//  Copyright (c) 2014 Tangdxi. All rights reserved.
//

#import "ZYPathItemButton.h"

@interface ZYPathItemButton ()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UILabel *titleLable;

@end

@implementation ZYPathItemButton

- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
              backgroundImage:(UIImage *)backgroundImage
   backgroundHighlightedImage:(UIImage *)backgroundHighlightedImage  title:(NSString *)title
{
    if (self = [super init]) {
        
        // Make sure the iteam has a certain frame
        //
        CGRect itemFrame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        
        if (!backgroundImage || !backgroundHighlightedImage) {
            itemFrame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
        self.frame = itemFrame;
        
        // Configure the item's image
        //
//        [self setImage:backgroundImage forState:UIControlStateNormal];
//        [self setImage:backgroundHighlightedImage forState:UIControlStateHighlighted];
        
        // Configure background
        //
        _backgroundImageView = [[UIImageView alloc]initWithImage:image
                                                highlightedImage:highlightedImage];
        _backgroundImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2-20);
        
        [self addSubview:_backgroundImageView];
        
        _titleLable=[[UILabel alloc] initWithFrame:CGRectMake(0, _backgroundImageView.frame.size.height+_backgroundImageView.frame.origin.y, self.bounds.size.width, 20)];
        _titleLable.text=title;
        _titleLable.textAlignment=NSTextAlignmentCenter;
        _titleLable.font=[UIFont systemFontOfSize:16.0];
        _titleLable.textColor=[UIColor darkGrayColor];
        [self addSubview:_titleLable];
        
        // Add an action for the item button
        //
        [self addTarget:_delegate action:@selector(itemButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

@end
