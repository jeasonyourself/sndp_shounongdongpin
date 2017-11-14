//
//  UIView+Five.m
//  WXMedia
//
//  Created by User on 14-8-5.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import "UIView+Five.h"
#import <objc/runtime.h>

static char HUDKEY_BE;

@implementation UIView (Five)

#pragma 信息提示 Setter Getter
@dynamic hud;
-(void)setHud:(MBProgressHUD *)newValue{
	objc_setAssociatedObject(self.superview, &HUDKEY_BE, newValue, OBJC_ASSOCIATION_RETAIN);
}
-(MBProgressHUD *)hud{
//	MBProgressHUD * hud_0314 = objc_getAssociatedObject(self.superview, &HUDKEY_BE);
//	
//	if(hud_0314 == nil){
//		hud_0314 = [MBProgressHUD showHUDAddedTo:self animated:YES];
//		
//		self.hud =
//		[self addSubview:hud_0314];
//	}
//	
//
//	
//	return objc_getAssociatedObject(self.superview, [@"hud" UTF8String]);
	
	MBProgressHUD * hud_0314 = [MBProgressHUD HUDForView:self];

	if(hud_0314 == nil){
		hud_0314 = [MBProgressHUD showHUDAddedTo:self animated:YES];
		[self addSubview:hud_0314];
	}
	
	return hud_0314;
}

#pragma 显示
/**提示信息*/
- (void)Message:(NSString *)message{
	[self Message:message HiddenAfterDelay:2.0];
}

/**提示信息，N秒后关闭*/
- (void)Message:(NSString *)message HiddenAfterDelay:(NSTimeInterval)delay{
	[self Message:message YOffset:0.0 HiddenAfterDelay:delay];
}

/**自定义提示框位置*/
- (void)Message:(NSString *)message YOffset:(float)yoffset HiddenAfterDelay:(NSTimeInterval)delay{
	MBProgressHUD * hud_0314 = self.hud;
    hud_0314.labelText=@"";

	hud_0314.yOffset = yoffset;
	hud_0314.mode = MBProgressHUDModeText;
	hud_0314.detailsLabelText = message;
	[hud_0314  show:true];
	
	[hud_0314  hide:true afterDelay:delay];

}

/**展示Loading标示*/
- (void)Loading:(NSString *)message{
	MBProgressHUD * hud_0314 = self.hud;
	hud_0314.yOffset = 0.0;
	hud_0314.mode = MBProgressHUDModeIndeterminate;
	hud_0314.labelText = message;
	[hud_0314  show:true];
}

/**隐藏*/
- (void)HiddenAfterDelay:(NSTimeInterval)delay{
	[self.hud  hide:true afterDelay:delay];
}

/**隐藏*/
- (void)Hidden{
	[self.hud hide:YES];
}

- (void)Loading_0314{
	[self touchesEnded:nil withEvent:nil];

	MBProgressHUD * hud_0314 = self.hud;
	
	hud_0314.mode = MBProgressHUDModeIndeterminate;
	[hud_0314  show:true];
}

- (void)Loading_0314HiddenAfterDelay:(NSTimeInterval)delay{

    [self touchesEnded:nil withEvent:nil];
    
    MBProgressHUD * hud_0314 = self.hud;
    
    hud_0314.mode = MBProgressHUDModeIndeterminate;
    [hud_0314  show:true];
[hud_0314  hide:true afterDelay:delay];
}

/*是否Loading中*/
- (BOOL)IsLoading{
	MBProgressHUD * hud_0314 = self.hud;
	
	if((hud_0314.mode == MBProgressHUDModeIndeterminate || hud_0314.mode == MBProgressHUDModeIndeterminate) &&
	   !hud_0314.isHidden){
		return YES;
	}
	else{
		return NO;
	}
}

@end
