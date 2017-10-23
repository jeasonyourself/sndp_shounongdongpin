//
//  TYDPPhotoPickerManager.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/28.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDPPhotoPickerManager.h"
@interface TYDPPhotoPickerManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, weak)UIViewController *fromController;
@property (nonatomic, copy)PickerCompelitionBlock completion;
@property (nonatomic, copy)PickerCancelBlock cancelBlock;
@end
@implementation TYDPPhotoPickerManager
+(TYDPPhotoPickerManager *)shared {
    static TYDPPhotoPickerManager *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedObject) {
            sharedObject = [[[self class] alloc] init];
        }
    });
    return sharedObject;
}
-(void)showActionSheetInView:(UIView *)inView fromController:(UIViewController *)fromController completion:(PickerCompelitionBlock)completion cancelBlock:(PickerCancelBlock)cancelBlock {
    self.completion = [completion copy];
    self.cancelBlock = [cancelBlock copy];
    self.fromController = fromController;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIActionSheet *actionSheet = nil;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照上传", nil];
        }else{
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [actionSheet showInView:inView];
        });
    });
    return;
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.navigationBar.barTintColor = self.fromController.navigationController.navigationBar.barTintColor;
            [self.fromController presentViewController:picker animated:YES completion:nil];
        }
    } else if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.navigationBar.barTintColor = self.fromController.navigationController.navigationBar.barTintColor;
            [self.fromController presentViewController:picker animated:YES completion:nil];
        }
    }
    return;
}
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (image&&self.completion) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completion(image);
            });
        });
    }
}

@end
