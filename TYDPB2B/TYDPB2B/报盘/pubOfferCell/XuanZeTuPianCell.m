//
//  XuanZeTuPianCell.m
//  tongchenghaoke
//
//  Created by chenping on 16/5/16.
//  Copyright © 2016年 zhangjunsong. All rights reserved.
//

#import "XuanZeTuPianCell.h"

@implementation XuanZeTuPianCell
{
    UIImagePickerController *_imagePickerController;
//    photoViewController * photoVC;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [_myCollectionView reloadData];
    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/4 +60) collectionViewLayout:flowLayout];
        
        self.myCollectionView.dataSource = self;
        self.myCollectionView.delegate = self;
        self.myCollectionView.showsHorizontalScrollIndicator = NO;
        self.myCollectionView.backgroundColor = [UIColor whiteColor];
        [self.myCollectionView registerClass:[XuanZeTuPianCollectionViewCell class] forCellWithReuseIdentifier:@"XuanZeTuPianCollectionViewCell"];
        [self.contentView addSubview:self.myCollectionView];
    }
    return self;
}

#pragma mark   collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger num =_imageViewArray.count/3;
    [_myCollectionView setFrame:CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width/3)*num +[UIScreen mainScreen].bounds.size.width/3)];
    return _imageViewArray.count+1;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UINib *nib = [UINib nibWithNibName:@"XuanZeTuPianCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"XuanZeTuPianCollectionViewCell"];
    XuanZeTuPianCollectionViewCell *cell = [[XuanZeTuPianCollectionViewCell alloc]init];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"XuanZeTuPianCollectionViewCell"
                                                     forIndexPath:indexPath];
    
    
    if (indexPath.row == _imageViewArray.count) {
//        cell.photoImageView.hidden = YES;
        cell.photoImageView.image = [UIImage imageNamed:@"addTM"];
    }else{
        [cell.photoImageView setImage:[_imageViewArray objectAtIndex:indexPath.row]];
    }
    cell.photoImageView.contentMode=UIViewContentModeScaleAspectFill;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-30)/3, ([UIScreen mainScreen].bounds.size.width-30)/3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//        if (indexPath.row == _imageViewArray.count) {
    
    
            UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"从相册选取", @"拍照上传", nil];
            choiceSheet.tag=101+indexPath.row;
            [choiceSheet showInView:self];
//        }
//        else{
//        }
    
    
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self.delegate downXuanZe:0 withTag:actionSheet.tag];
            
        }
            break;
        case 1:
        {
            [self.delegate downXuanZe:1 withTag:actionSheet.tag];
        }
            break;
        case 2:
        {
        }
            break;
        default:
            break;
    }
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
//        [_imageViewArray addObject:info[UIImagePickerControllerEditedImage]];
//    }
//    [_myCollectionView reloadData];
////    [self dismissViewControllerAnimated:YES completion:nil];
//}


@end
