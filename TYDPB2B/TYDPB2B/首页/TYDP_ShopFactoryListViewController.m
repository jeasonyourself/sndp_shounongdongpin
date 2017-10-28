//
//  TYDP_ShopFactoryListViewController.m
//  TYDPB2B
//
//  Created by Wangye on 16/8/4.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_ShopFactoryListViewController.h"
#import "TYDP_FactoryDetailViewController.h"
#import "ShopListModel.h"
#import "GoodListModel.h"
#import "TYDP_VendorController.h"
#import "TYDP_OfferDetailViewController.h"
#import "TYDP_LoginController.h"

@interface TYDP_ShopFactoryListViewController ()
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UIScrollView *baseScrollView;
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)MBProgressHUD *MBHUD;
@property(nonatomic, strong)NSArray *shopListModelArray;
@property(nonatomic, strong)NSArray *goodListModelArray;
@end

@implementation TYDP_ShopFactoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSliderFilterData];
    // Do any additional setup after loading the view.
}
- (void)getSliderFilterData {
    [self.view setBackgroundColor:RGBACOLOR(239, 239, 239, 1)];
    [self setUpNavigationBar];
    _shopListModelArray = [NSArray array];
    _MBHUD = [[MBProgressHUD alloc] init];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    [self.view addSubview:_MBHUD];
    [_MBHUD show:YES];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"user",@"get_shop_list",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"get_shop_list",@"sign":[TYDPManager md5:Sign],@"model":@"user",@"keywords":_keywords};
    NSLog(@"params:%@",params);
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        NSLog(@"diandianpudata:%@",data[@"content"]);
        if (![data[@"error"] intValue]) {
            _shopListModelArray = [ShopListModel arrayOfModelsFromDictionaries:data[@"content"] error:nil];
            if (_shopListModelArray.count) {
                [self createWholeUI];
            } else {
                [_MBHUD setLabelText:NSLocalizedString(@"No search result", nil)];
                [_MBHUD hide:YES afterDelay:1.5f];
            }
        } else{
            
        }
    } failure:^(TYDPError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)createWholeUI{
    [_MBHUD hide:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight)];
    [self.view addSubview:_baseScrollView];
    _containerView = [UIView new];
    [_baseScrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_baseScrollView);
        make.width.equalTo(_baseScrollView);
    }];
    [self createBottomUI];
}
- (void)createBottomUI {
    CGFloat smallHeight = ScreenWidth*0.56;
    CGFloat smallTopViewHeight = ScreenWidth*0.24;
    CGFloat bottomImageViewHeight = smallHeight - smallTopViewHeight;
    CGFloat bottomImageViewGap = (ScreenWidth - (smallHeight - smallTopViewHeight)*3)/2;
    for (int i = 0; i < _shopListModelArray.count; i++) {
        ShopListModel *shopListModel = _shopListModelArray[i];
        UIView *smallView = [UIView new];
        [smallView setBackgroundColor:[UIColor whiteColor]];
        [_baseScrollView addSubview:smallView];
        [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_baseScrollView).with.offset((smallHeight+Gap)*i);
            make.left.equalTo(_baseScrollView);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(smallHeight);
        }];
        UIView *smallTopView = [UIView new];
        [smallView addSubview:smallTopView];
        //        [smallTopView setBackgroundColor:[UIColor greenColor]];
        [smallTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(smallView);
            make.left.equalTo(smallView);
            make.right.equalTo(smallView);
            make.height.mas_equalTo(smallTopViewHeight);
        }];
        UIImageView *leftBigImageView = [UIImageView new];
        leftBigImageView.clipsToBounds = YES;
        leftBigImageView.layer.cornerRadius = ScreenWidth/15;
        [leftBigImageView sd_setImageWithURL:[NSURL URLWithString:shopListModel.user_face] placeholderImage:[UIImage imageNamed:@"shop_nophoto1"]];
        [smallTopView addSubview:leftBigImageView];
        [leftBigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallTopView);
            make.left.equalTo(smallTopView).with.offset(Gap);
            make.width.equalTo(leftBigImageView.mas_height);
            make.height.mas_equalTo(ScreenWidth/7.5);
        }];
        UILabel *topSmallLabel = [UILabel new];
        //        [topSmallLabel setBackgroundColor:[UIColor yellowColor]];
        UILabel *bottomSmallLabel = [UILabel new];
        [smallTopView addSubview:topSmallLabel];
        [smallTopView addSubview:bottomSmallLabel];
        [topSmallLabel setFont:ThemeFont(16)];
        [topSmallLabel setText:[NSString stringWithFormat:@"%@",shopListModel.shop_name]];
        [topSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBigImageView.mas_right).with.offset(Gap);
            make.top.equalTo(leftBigImageView);
            make.height.mas_equalTo(25);
            //            make.width.mas_equalTo(16*6);
        }];
        [bottomSmallLabel setFont:ThemeFont(13)];
        [bottomSmallLabel setText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Order volume", nil),shopListModel.order_num]];
        [bottomSmallLabel setTextColor:[UIColor grayColor]];
        [bottomSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBigImageView.mas_right).with.offset(Gap);
            make.centerY.equalTo(leftBigImageView).with.offset(Gap);
            make.height.mas_equalTo(20);
        }];
        UIImage *RightFirstImage = [UIImage imageNamed:@"shop_icon_company"];
        UIImageView *RightFirstImageView = [[UIImageView alloc] initWithImage:RightFirstImage];
        [smallTopView addSubview:RightFirstImageView];
        [RightFirstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topSmallLabel.mas_right).with.offset(Gap);
            make.centerY.equalTo(topSmallLabel);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(25*(RightFirstImage.size.width/RightFirstImage.size.height));
        }];
        UIImage *RightSecondImage = [UIImage imageNamed:@"shop_icon_deposit"];
        UIImageView *RightSecondImageView = [[UIImageView alloc] initWithImage:RightSecondImage];
        [smallTopView addSubview:RightSecondImageView];
        [RightSecondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(RightFirstImageView.mas_right);
            make.centerY.equalTo(topSmallLabel);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(25*(RightSecondImage.size.width/RightSecondImage.size.height));
        }];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [smallTopView addSubview:rightButton];
        rightButton.tag = i+1;
        [rightButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Into store", nil)] forState:UIControlStateNormal];
        [rightButton setTitleColor:RGBACOLOR(85, 85, 85, 1) forState:UIControlStateNormal];
        rightButton.clipsToBounds = YES;
        rightButton.layer.cornerRadius = 6;
        rightButton.layer.borderColor = [RGBACOLOR(85, 85, 85, 1) CGColor];
        rightButton.layer.borderWidth = HomePageBordWidth;
        [rightButton.titleLabel setFont:ThemeFont(14)];
        [rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(smallTopView).with.offset(-Gap);
            make.top.equalTo(topSmallLabel);
            make.height.mas_equalTo(ScreenWidth/15);
            make.width.mas_equalTo(ScreenWidth/5);
        }];
        _goodListModelArray = [NSArray arrayWithArray:shopListModel.good_list];
        GoodListModel *goodListModel = [GoodListModel new];
        for (int i = 0; i < _goodListModelArray.count; i++) {
            UIImageView *smallImageView = [UIImageView new];
            smallImageView.userInteractionEnabled = YES;
            goodListModel = _goodListModelArray[i];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomCellTapMethod:)];
            [smallImageView addGestureRecognizer:tap];
            UIView *tmpView = [tap view];
            tmpView.tag = [goodListModel.goods_id intValue];
            NSLog(@"%lu %@",tmpView.tag,goodListModel);
            [smallView addSubview:smallImageView];
            [smallImageView sd_setImageWithURL:[NSURL URLWithString:goodListModel.goods_thumb] placeholderImage:nil];
            [smallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(smallView).with.offset((bottomImageViewHeight + bottomImageViewGap)*i);
                make.top.equalTo(smallTopView.mas_bottom);
                make.width.equalTo(smallImageView.mas_height);
                make.height.mas_equalTo(bottomImageViewHeight);
            }];
        }
        if (i == _shopListModelArray.count - 1) {
            [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(smallView);
            }];
        }
    }
}
- (void)bottomCellTapMethod:(UITapGestureRecognizer *)tap {
    UIView *tmpView = [tap view];
    NSLog(@"%lu",tmpView.tag);
    TYDP_OfferDetailViewController *offerDetailViewCon = [[TYDP_OfferDetailViewController alloc] init];
    offerDetailViewCon.goods_id = [NSString stringWithFormat:@"%lu",tmpView.tag];
    [self.navigationController pushViewController:offerDetailViewCon animated:YES];
}
- (void)buttonClicked:(UIButton *)button {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"user_id"]) {//已登陆
        ShopListModel *shopListModel = _shopListModelArray[button.tag-1];
        TYDP_VendorController *vendorCon = [[TYDP_VendorController alloc] init];
        debugLog(@"sdkjsdkfj:%@,%@",shopListModel.shop_id,[shopListModel.shop_id class ]);
        vendorCon.shopId = shopListModel.shop_id;
        [self.navigationController pushViewController:vendorCon animated:YES];
    }
    else {//尚未登陆状态
        TYDP_LoginController *loginViewCon = [[TYDP_LoginController alloc] init];
        [self.navigationController pushViewController:loginViewCon animated:YES];
    }

    
   
}
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    [self.view addSubview:_navigationBarView];
    _navigationBarView.backgroundColor=mainColor;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationBarView addSubview:backButton];
    UIImage *backButtonImage = [UIImage imageNamed:@"navi_return_btn_nor"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 0)];
    [backButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navigationBarView).with.offset(Gap);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100*(backButtonImage.size.height/backButtonImage.size.width));
    }];
    UILabel *navigationLabel = [UILabel new];
    [_navigationBarView addSubview:navigationLabel];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setTextColor:[UIColor whiteColor]];
    [navigationLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Shop list", nil)]];
    [navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(ScreenWidth/3);
        make.height.mas_equalTo(25);
    }];
}
- (void)leftItemClicked:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
