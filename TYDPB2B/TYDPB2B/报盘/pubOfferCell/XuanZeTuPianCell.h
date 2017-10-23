//
//  XuanZeTuPianCell.h
//  tongchenghaoke
//
//  Created by chenping on 16/5/16.
//  Copyright © 2016年 zhangjunsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XuanZeTuPianCollectionViewCell.h"
#import "GWLPhotoLibrayController.h"

@protocol xuanZeTuPianDelegate <NSObject>
- (void) downXuanZe:(NSInteger)sender withTag:(NSInteger)atag;
@end


@interface XuanZeTuPianCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property(nonatomic,strong)id<xuanZeTuPianDelegate>delegate;
@end
