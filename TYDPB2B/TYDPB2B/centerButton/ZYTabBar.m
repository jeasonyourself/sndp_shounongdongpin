//
//  ZYTabBar.m
//  自定义tabbarDemo
//
//  Created by tarena on 16/7/1.
//  Copyright © 2016年 jeason. All rights reserved.
//

#import "ZYTabBar.h"
#import "UIView+LBExtension.h"
#import <objc/runtime.h>

#define ZYMagin 10

@interface ZYTabBar ()<ZYPathButtonDelegate>

@end

@implementation ZYTabBar
//对按钮的一些基本设置
- (void)setUpPathButton:(ZYPathButton *)pathButton {
    pathButton.delegate = self;
    pathButton.bloomRadius = self.bloomRadius;
    pathButton.allowCenterButtonRotation = self.allowCenterButtonRotation;
    pathButton.bottomViewColor = [UIColor lightGrayColor];
    pathButton.bloomDirection = kZYPathButtonBloomDirectionTop;
    pathButton.basicDuration = self.basicDuration;
    pathButton.bloomAngel = self.bloomAngel;
    pathButton.allowSounds = NO;
}
- (void)drawRect:(CGRect)rect {
    
    if ([[PSDefaults objectForKey:@"needCenterBtn"] isEqualToString:@"0"]) {
        [PSDefaults setObject:@"1" forKey:@"needCenterBtn"];
      self.plusBtn = [[ZYPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"icon_home_logo"]highlightedImage:[UIImage imageNamed:@"pop_close"]];
    self.plusBtn.delegate = self;
    [self setUpPathButton:self.plusBtn];
    
    
    self.plusBtn.ZYButtonCenter = CGPointMake(self.centerX, self.superview.height -32.5*Width/*- self.height * 0.5 - 2 *ZYMagin*/ );
    //plus由其他tab让出位置，可能是个长方形，最少是个65*65的正方形
    
//    self.plusBtn.backgroundColor=[UIColor redColor];
    
    
    [self.plusBtn addPathItems:self.pathButtonArray];
    //必须加到父视图上
    [self.superview addSubview:self.plusBtn];
    
    //自己debug
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        self.plusBtn.hidden=YES;
    }
    
    UILabel *label = [[UILabel alloc]init];
//    label.text = @"发布";
    label.font = [UIFont systemFontOfSize:13];
    [label sizeToFit];
    label.textColor = [UIColor grayColor];
    label.centerX = _plusBtn.centerX;
    label.centerY = CGRectGetMaxY(_plusBtn.frame) + ZYMagin;
    }
//    [self.superview addSubview:label];
}
//重新绘制按钮
- (void)layoutSubviews {
    [super layoutSubviews];
     self.backgroundColor = [UIColor whiteColor];
    //系统自带的按钮类型是UITabBarButton,找出这些类型的按钮,然后重新排布位置 ,空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
           //每一个按钮的宽度 == tabbar的五分之一
            if (self.width * 0.2>65*Width) {
            btn.width = self.width * 0.2;
            /*switch (btnIndex) {
                case 0:
                     btn.backgroundColor=[UIColor blueColor];
                    break;
                case 1:
                    btn.backgroundColor=[UIColor greenColor];
                    break;

                case 2:
                    btn.backgroundColor=[UIColor grayColor];
                    break;

                case 3:
                    btn.backgroundColor=[UIColor yellowColor];
                    break;

                case 4:
                    btn.backgroundColor=[UIColor brownColor];
                    break;

                    
                default:
                    break;
            }*/

            btn.x = btn.width * btnIndex;
            btnIndex ++;
            
            //如果是索引是2(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
            if (btnIndex == 2) {
                btnIndex++;
            }
            }
            else
            {
                if (btnIndex < 2)
                {
                    btn.width = (self.width -65*Width)/4;
                    btn.x = btn.width * btnIndex;
                    btnIndex ++;
                }
                else
                {
                    btn.width = (self.width -65.0*Width)/4;
                    btn.x = btn.width * btnIndex+65.0*Width;
                    btnIndex ++;

                }
                
            }
        }
    }
    
}
- (void)pathButton:(ZYPathButton *)ZYPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    if ([self.delegate respondsToSelector:@selector(pathButton:clickItemButtonAtIndex:)]) {
        [self.delegate pathButton:self clickItemButtonAtIndex:itemButtonIndex];
    }
}


- (void)willPresentZYPathButtonItems:(ZYPathButton *)ZYPathButton
{

}


- (void)willDismissZYPathButtonItems:(ZYPathButton *)ZYPathButton
{

}

@end















