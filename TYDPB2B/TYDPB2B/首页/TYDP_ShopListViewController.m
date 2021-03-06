//
//  TYDP_ShopListViewController.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/20.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_ShopListViewController.h"
#import "TYDP_OfferDetailViewController.h"
#import "BestGoodsModel.h"
#import "TYDP_OfferViewController.h"
#import "LocalListModel.h"
typedef enum {
    PopFilterButtonMessage = 1,
    TimeFilterButtonMessage,
    PriceFilterButtonMessage,
    LocationFilterButtonMessage,
    OfferButtonMessage
}BUTTONMESSAGE;
@interface TYDP_ShopListViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UISearchBarDelegate>
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UIView *searchView;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)UIScrollView *baseScrollView;
@property(nonatomic, strong)NSArray *topLabelArray;
@property(nonatomic, strong)UIButton *topIndicatorButton;
@property(nonatomic, strong)UILabel *bottomDecorateLabel;
@property(nonatomic, strong)NSArray *middleLabelArray;
@property(nonatomic, strong)UIButton *middleIndicatorButton;
@property(nonatomic, assign)CGFloat tmpMemory;
@property(nonatomic, strong)MBProgressHUD *MBHUD;
@property(nonatomic, strong)NSMutableArray *goodsListModelArray;
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)UIView *middleFilterView;
@property(nonatomic, strong)UIView *bottomCellContainerView;
@property(nonatomic, assign)__block NSInteger tmpPage;
@property(nonatomic, assign)NSInteger typeFlag;
@property(nonatomic, assign)NSInteger totalCount;
@property(nonatomic, strong)NSMutableArray *defaultCategoryPicArray;
@property(nonatomic, strong)NSMutableArray *defaultCategoryButtonPicArray;
@property(nonatomic, strong)NSMutableArray *defaultCategoryButtonSelectedPicArray;
@property(nonatomic, strong)UIButton *popFilterButton;
@property(nonatomic, strong)UIButton *timeFilterButton;
@property(nonatomic, strong)UIButton *priceFilterButton;
@property(nonatomic, strong)UIButton *locationFilterButton;
@property(nonatomic, assign)BOOL filterButtonFlag;
@property(nonatomic, assign)BOOL topFutureFilterFlag;
@property(nonatomic, strong)NSMutableDictionary *tmpDic;
@property(nonatomic, assign)NSInteger middleTypeFlag;
@property(nonatomic, strong)NSMutableDictionary *filterPageDic;
@property(nonatomic, strong)UIButton *searchCancelButton;
@property(nonatomic, strong)UIView *smallFilterView;
@property(nonatomic, assign)BOOL isUnfold;
@property(nonatomic, strong)UIView *smallFilterContainerView;
@property(nonatomic, strong)UIButton *smallFilterViewCancelButton;
@property(nonatomic, strong)NSMutableArray *LocalListModelArray;
@property(nonatomic, copy)NSString *localFilterString;
@end
@implementation TYDP_ShopListViewController
/**
 *  灰色筛选控件图标
 *
 *  @return
 */
-(NSArray *)defaultCategoryPicArray{
    if (!_defaultCategoryPicArray) {
        _defaultCategoryPicArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    }
    return _defaultCategoryPicArray;
}
/**
 *  第一次选中筛选控件时的图标
 *
 *  @return
 */
-(NSArray *)defaultCategoryButtonPicArray{
    if (!_defaultCategoryButtonPicArray) {
        _defaultCategoryButtonPicArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    }
    return _defaultCategoryButtonPicArray;
}
/**
 *  第二次选中筛选控件时的图标
 *
 *  @return
 */
-(NSArray *)defaultCategoryButtonSelectedPicArray{
    if (!_defaultCategoryButtonSelectedPicArray) {
        _defaultCategoryButtonSelectedPicArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    }
    return _defaultCategoryButtonSelectedPicArray;
}

-(NSArray *)topLabelArray {
    if (!_topLabelArray) {
        _topLabelArray = [NSArray arrayWithObjects:NSLocalizedString(@"Spot", nil),NSLocalizedString(@"Future", nil),NSLocalizedString(@"SpotToBe", nil),NSLocalizedString(@"FCL", nil),NSLocalizedString(@"Retail", nil), nil];
    }
    return _topLabelArray;
}
-(NSArray *)middleLabelArray {
    if (!_middleLabelArray) {
        _middleLabelArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Popular↓",nil)],[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Time",nil)],[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Price",nil)],@"筛选", nil];
    }
    return _middleLabelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWholeUI];
    // Do any additional setup after loading the view.
}
- (void)getTJorMSShopListDataWithNewDic:(NSMutableDictionary *)dic{    
    if ([dic[@"page"] intValue] > 1) {
        //pages are bigger than 1
    } else {
        [_goodsListModelArray removeAllObjects];
    }
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"other",@"productList",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"productList",@"sign":[TYDPManager md5:Sign],@"model":@"other",@"type":_more_type}];
    [params addEntriesFromDictionary:dic];
    NSLog(@"params:%@",params);
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        NSLog(@"more_typedata:%@",data);
        [_bottomCellContainerView removeFromSuperview];
        if (![data[@"error"] intValue]) {
            [_MBHUD hide:YES];
            [_goodsListModelArray addObjectsFromArray:[BestGoodsModel arrayOfModelsFromDictionaries:data[@"content"][@"goods_list"] error:nil]];
            _totalCount = [data[@"content"][@"total"][@"page_count"] intValue];
            if ([_goodsListModelArray count] == 0) {
                MBProgressHUD *tmpHud = [[MBProgressHUD alloc] init];
                [tmpHud setAnimationType:MBProgressHUDAnimationFade];
                [tmpHud setMode:MBProgressHUDModeText];
                [tmpHud setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"No results for now",nil)]];
                [self.view addSubview:tmpHud];
                [tmpHud show:YES];
                [tmpHud hide:YES afterDelay:1.5f];
            }
            _LocalListModelArray = [NSMutableArray arrayWithArray:[LocalListModel arrayOfModelsFromDictionaries:data[@"content"][@"local"] error:nil]];
            [self createBottomCell];
        } else {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Check Internet connection",nil)]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        NSLog(@"%@",error);
    }];
    //清除筛选条件
    [_filterDic removeAllObjects];
    [_baseScrollView.mj_footer endRefreshing];
}

- (void)getShopListDataWithNewDic:(NSMutableDictionary *)dic{
    if ([dic[@"page"] intValue] > 1) {
        //pages are bigger than 1
    } else {
        [_goodsListModelArray removeAllObjects];
    }
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"goods",@"get_list",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"get_list",@"sign":[TYDPManager md5:Sign],@"model":@"goods"}];
    [params addEntriesFromDictionary:dic];
    NSLog(@"getgoodsListparams:%@",params);
    
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        NSLog(@"shoplistttdata:%@",data);
        [_bottomCellContainerView removeFromSuperview];
        if (![data[@"error"] intValue]) {
            [_MBHUD hide:YES];
            [_goodsListModelArray addObjectsFromArray:[BestGoodsModel arrayOfModelsFromDictionaries:data[@"content"][@"list"] error:nil]];
            _totalCount = [data[@"content"][@"total"][@"page_count"] intValue];
            //从报盘进入没有筛选结果的时候。。。
            //            NSLog(@"_filterDic:%@, %lu",_filterDic,[[_filterDic allKeys] count]);
            if ([[_filterDic allKeys] count]) {
                
            }
            if ([_goodsListModelArray count] == 0) {
                MBProgressHUD *tmpHud = [[MBProgressHUD alloc] init];
                [tmpHud setAnimationType:MBProgressHUDAnimationFade];
                [tmpHud setMode:MBProgressHUDModeText];
                [tmpHud setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"No results for now",nil)]];
                [self.view addSubview:tmpHud];
                [tmpHud show:YES];
                [tmpHud hide:YES afterDelay:1.5f];
            }
            _LocalListModelArray = [NSMutableArray arrayWithArray:[LocalListModel arrayOfModelsFromDictionaries:data[@"content"][@"local"] error:nil]];
            [self createBottomCell];
        } else {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Check Internet connection",nil)]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        NSLog(@"%@",error);
    }];
    //清除筛选条件
    [_filterDic removeAllObjects];
    [_baseScrollView.mj_footer endRefreshing];
}
- (void)createMiddleFilterUI {
    [_middleFilterView removeFromSuperview];
    CGFloat smallMiddleWidth = ScreenWidth/3;
    _middleFilterView = [UIView new];
//    UIImage *tmpImage = [UIImage imageNamed:@"productlist_hot_down"];
    CGFloat tmpHeight = 50.0;
    [_baseScrollView addSubview:_middleFilterView];
    [_middleFilterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.right.equalTo(_baseScrollView).with.offset(HomePageBordWidth);
        make.top.equalTo(_baseScrollView).with.offset(40);
        make.height.mas_equalTo(tmpHeight);
    }];
    _middleFilterView.layer.borderColor = [RGBACOLOR(222, 222, 222, 0.7) CGColor];
    _middleFilterView.layer.borderWidth = HomePageBordWidth;
    if (_topFutureFilterFlag) {
        [_defaultCategoryPicArray replaceObjectAtIndex:3 withObject:@""];
        [_defaultCategoryButtonPicArray replaceObjectAtIndex:3 withObject:@""];
        [_defaultCategoryButtonSelectedPicArray replaceObjectAtIndex:3 withObject:@""];
    } else {
        [_defaultCategoryPicArray replaceObjectAtIndex:3 withObject:@""];
        [_defaultCategoryButtonPicArray replaceObjectAtIndex:3 withObject:@""];
        [_defaultCategoryButtonSelectedPicArray replaceObjectAtIndex:3 withObject:@""];
    }
    for (int i = 0; i < 3; i++) {
        UIImageView *primaryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(smallMiddleWidth*i, 0, smallMiddleWidth, tmpHeight)];
        UILabel *verticalDecorateLabel = [UILabel new];
        [primaryImageView addSubview:verticalDecorateLabel];
        [verticalDecorateLabel setBackgroundColor:RGBACOLOR(222, 222, 222, 0.7)];
        [verticalDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(primaryImageView.mas_right).with.offset(-HomePageBordWidth);
            make.centerY.equalTo(primaryImageView);
            make.width.mas_equalTo(HomePageBordWidth);
            make.height.mas_equalTo(tmpHeight);
        }];
        
        
        
        UILabel *nameLable = [UILabel new];
        [primaryImageView addSubview:nameLable];
        [nameLable setBackgroundColor:RGBACOLOR(222, 222, 222, 0.7)];
        nameLable.font=[UIFont systemFontOfSize:14.0];
        nameLable.textAlignment=NSTextAlignmentCenter;
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(primaryImageView.mas_left).with.offset(0);
            make.centerY.equalTo(primaryImageView);
            make.width.mas_equalTo(primaryImageView);
            make.height.mas_equalTo(primaryImageView);
        }];

        if (i==0) {
            nameLable.text=[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Popular",nil)];
        }
        if (i==1) {
            nameLable.text=[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Time",nil)];
        }
        if (i==2) {
            nameLable.text=[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Price",nil)];
        }
//        [primaryImageView setImage:[UIImage imageNamed:self.defaultCategoryPicArray[i]]];
        primaryImageView.userInteractionEnabled = YES;
        [primaryImageView setBackgroundColor:[UIColor whiteColor]];
        [_middleFilterView addSubview:primaryImageView];
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(middleUITapMethod:)];
        [primaryImageView addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i + 1;
    }
    _popFilterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_popFilterButton setBackgroundColor:[UIColor whiteColor]];
    _popFilterButton.tag = PopFilterButtonMessage;
    _popFilterButton.frame = CGRectMake(0, 0, smallMiddleWidth-HomePageBordWidth, tmpHeight);
    [_popFilterButton setTitle:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Popular",nil)] forState:UIControlStateNormal];
//    [_popFilterButton setBackgroundImage:[UIImage imageNamed:@"productlist_hot_down"] forState:UIControlStateNormal];
    [_popFilterButton setTitleColor:mainColor forState:UIControlStateNormal];
    [_popFilterButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_middleFilterView addSubview:_popFilterButton];
    _timeFilterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_timeFilterButton setBackgroundColor:[UIColor whiteColor]];
    _timeFilterButton.tag = TimeFilterButtonMessage;
    _timeFilterButton.frame = CGRectMake(smallMiddleWidth, 0, smallMiddleWidth-HomePageBordWidth, tmpHeight);
//    [_timeFilterButton setBackgroundImage:[UIImage imageNamed:@"productlist_time_down"] forState:UIControlStateNormal];
    [_timeFilterButton setTitle:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Time",nil)] forState:UIControlStateNormal];
    [_timeFilterButton setTitleColor:RGBACOLOR(222, 222, 222, 0.7) forState:UIControlStateNormal];

    [_timeFilterButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_middleFilterView addSubview:_timeFilterButton];
    _priceFilterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_priceFilterButton setBackgroundColor:[UIColor whiteColor]];
    _priceFilterButton.tag = PriceFilterButtonMessage;
    _priceFilterButton.frame = CGRectMake(smallMiddleWidth*2, 0, smallMiddleWidth-HomePageBordWidth, tmpHeight);
//    [_priceFilterButton setBackgroundImage:[UIImage imageNamed:@"productlist_price_down"] forState:UIControlStateNormal];

    [_priceFilterButton setTitle:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Price",nil)] forState:UIControlStateNormal];
    [_priceFilterButton setTitleColor:RGBACOLOR(222, 222, 222, 0.7) forState:UIControlStateNormal];
    [_priceFilterButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_middleFilterView addSubview:_priceFilterButton];
    _locationFilterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_locationFilterButton setBackgroundColor:[UIColor whiteColor]];
    _locationFilterButton.tag = LocationFilterButtonMessage;
    _locationFilterButton.frame = CGRectMake(smallMiddleWidth*3, 0, smallMiddleWidth, tmpHeight);
    [_locationFilterButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_locationFilterButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_middleFilterView addSubview:_locationFilterButton];
    _filterButtonFlag = NO;
    NSLog(@"_HomePageFlag:%lu",_HomePageFlag);
    [self setMiddleFilterButtonDisplayStateWithFlag:1];
    _middleTypeFlag = 1;
}
- (void)middleUITapMethod:(UITapGestureRecognizer *)tap {
    UIView *tmpView = [tap view];
    [self setMiddleFilterButtonDisplayStateWithFlag:tmpView.tag];
}

- (void)filterButtonClicked:(UIButton *)button {
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
    NSString *tmpString = [NSString new];
    switch (button.tag) {
        case PopFilterButtonMessage:{
            tmpString = [NSString stringWithFormat:@""];
            break;
        }
        case TimeFilterButtonMessage:{
            tmpString = [NSString stringWithFormat:@"last_update"];
            break;
        }
        case PriceFilterButtonMessage:{
            tmpString = [NSString stringWithFormat:@"shop_price"];
            break;
        }
        case LocationFilterButtonMessage:{
            tmpString = [NSString stringWithFormat:@""];
        }
        default:
            break;
    }
    NSLog(@"_filterButtonFlag:%d",_filterButtonFlag);
    [tmpDic setObject:tmpString forKey:@"sort"];
    if ( _filterButtonFlag) {
        [button setBackgroundImage:[UIImage imageNamed:self.defaultCategoryButtonSelectedPicArray[button.tag-1]] forState:UIControlStateNormal];
        [tmpDic setObject:@"ASC" forKey:@"order"];
    } else {
        [button setBackgroundImage:[UIImage imageNamed:self.defaultCategoryButtonPicArray[button.tag-1]]forState:UIControlStateNormal];
        [tmpDic setObject:@"DESC" forKey:@"order"];
    }
    //添加顶部筛选条件
    if (_tmpDic) {
        [tmpDic addEntriesFromDictionary:_tmpDic];
    }
    _filterButtonFlag = !_filterButtonFlag;
    _tmpPage = 1;
    if (button.tag != LocationFilterButtonMessage) {
        [_smallFilterView removeFromSuperview];
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        [self getShopListDataWithNewDic:tmpDic];
        [self setReFreshMethod];
    } else {
        if (_isUnfold) {
            //产地、货物所在地筛选
            if (_topFutureFilterFlag) {//产地(期货)
                
            } else {//货物所在地
                
            }
            [self createSmallFilterView];
        } else {
            [_smallFilterView removeFromSuperview];
        }
        _isUnfold = !_isUnfold;
    }
}
- (void)smallFilterViewCancelButtonClicked:(UIButton *)button {
    [_smallFilterViewCancelButton removeFromSuperview];
    [_smallFilterView removeFromSuperview];
    _isUnfold = YES;
    if (_topFutureFilterFlag) {
        [_locationFilterButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    } else {
        [_locationFilterButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    _filterButtonFlag = NO;
}
- (void)createSmallFilterView {
    _smallFilterViewCancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _smallFilterViewCancelButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_smallFilterViewCancelButton];
    [_smallFilterViewCancelButton addTarget:self action:@selector(smallFilterViewCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat smallMiddleWidth = ScreenWidth/4;
    CGFloat bottomCellHeight = ScreenWidth/3;
    _smallFilterView = [UIScrollView new];
    UIImage *tmpImage = [UIImage imageNamed:@""];
    CGFloat tmpHeight = smallMiddleWidth*(tmpImage.size.height/tmpImage.size.width);
    _smallFilterView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    _smallFilterView.center = CGPointMake(ScreenWidth/4.0+ScreenWidth*3/8.0-1, tmpHeight+40+NavHeight+(bottomCellHeight + Gap)*3/2.0);
    [_smallFilterView setBackgroundColor:RGBACOLOR(231, 231, 232, 1)];
    _smallFilterView.alpha = 0.93;
    [self.view addSubview:_smallFilterView];
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, ScreenWidth*3/4.0, (bottomCellHeight + Gap)*3)];
    [_smallFilterView pop_addAnimation:anim forKey:@"size"];
    _smallFilterContainerView = [UIView new];
    [_smallFilterView addSubview:_smallFilterContainerView];
    [_smallFilterContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_smallFilterView);
    }];
    [self createSmallButtonWithNumbers:_LocalListModelArray.count];
}
- (void)createSmallButtonWithNumbers:(NSInteger)numbers {
    CGFloat smallButtonWidth = ScreenWidth*3/8.0 ;
    CGFloat smallButtonHeight = 40;
    for (int i = 0; i < numbers; i++) {
        LocalListModel *model = _LocalListModelArray[i];
        UIButton *smallButton = [UIButton buttonWithType:UIButtonTypeCustom];
        smallButton.tag = i+1;
        [_smallFilterView addSubview:smallButton];
        smallButton.frame = CGRectMake(smallButtonWidth*(i%2), smallButtonHeight*(i/2), smallButtonWidth, smallButtonHeight);
        [smallButton setTitle:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
        [smallButton.titleLabel setFont:ThemeFont(CommonFontSize)];
        smallButton.titleLabel.numberOfLines = 0;
        smallButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [smallButton setTitleEdgeInsets:UIEdgeInsetsMake(0,15,0,0)];
        [smallButton addTarget:self action:@selector(smallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [smallButton setTitleColor:RGBACOLOR(109, 109, 109, 1) forState:UIControlStateNormal];
        if (i == numbers - 1) {
            [_smallFilterContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(smallButton.mas_bottom);
            }];
        }
    }
}
- (void)smallButtonClicked:(UIButton *)button{
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    [self.view addSubview:_MBHUD];
    [_MBHUD show:YES];
    LocalListModel *localListModel = _LocalListModelArray[button.tag-1];
    NSLog(@"%@,%@",localListModel.id,localListModel.name);
    NSMutableDictionary *tmpMutableDic = [NSMutableDictionary dictionary];
    switch (_typeFlag) {
        case 1:{
            //                    tmpDic = nil;
            break;
        }
        case 2:{
            [tmpMutableDic setObject:@"7" forKey:@"goods_type"];
            break;
        }
        case 3:{
            [tmpMutableDic setObject:@"6" forKey:@"goods_type"];
            break;
        }
        case 4:{
            [tmpMutableDic setObject:@"8" forKey:@"goods_type"];
            break;
        }
        case 5:{
            [tmpMutableDic setObject:@"5" forKey:@"sell_type"];
            break;
        }
        case 6:{
            [tmpMutableDic setObject:@"4" forKey:@"sell_type"];
            break;
        }
        default:
            break;
    }
    if (_topFutureFilterFlag) {
        [tmpMutableDic setObject:localListModel.id forKey:@"region_id"];
        _localFilterString = [NSString stringWithFormat:@"%@",localListModel.id];
    } else {
        [tmpMutableDic setObject:localListModel.name forKey:@"goods_local"];
        _localFilterString = [NSString stringWithFormat:@"%@",localListModel.name];
    }
    [self getShopListDataWithNewDic:tmpMutableDic];
    [self smallFilterViewCancelButtonClicked:nil];
    [self setReFreshMethod];
}
- (void)setMiddleFilterButtonDisplayStateWithFlag:(NSInteger)flag {
    _tmpPage = 1;
    _filterButtonFlag = YES;
    _middleTypeFlag = flag;
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
    switch (flag) {
        case PopFilterButtonMessage:{
            _popFilterButton.hidden = NO;
            _timeFilterButton.hidden = YES;
            _priceFilterButton.hidden = YES;
            _locationFilterButton.hidden = YES;
//            [_popFilterButton setBackgroundImage:[UIImage imageNamed:self.defaultCategoryButtonPicArray[flag-1]]forState:UIControlStateNormal];
            [_popFilterButton setTitleColor:mainColor forState:UIControlStateNormal];
            [_timeFilterButton setTitleColor:RGBACOLOR(222, 222, 222, 0.7) forState:UIControlStateNormal];
            [_priceFilterButton setTitleColor:RGBACOLOR(222, 222, 222, 0.7) forState:UIControlStateNormal];
            break;
        }
        case TimeFilterButtonMessage:{
            _popFilterButton.hidden = YES;
            _timeFilterButton.hidden = NO;
            _priceFilterButton.hidden = YES;
            _locationFilterButton.hidden = YES;
//            [_timeFilterButton setBackgroundImage:[UIImage imageNamed:self.defaultCategoryButtonPicArray[flag-1]]forState:UIControlStateNormal];
            [tmpDic setObject:@"last_update" forKey:@"sort"];
            [_popFilterButton setTitleColor:RGBACOLOR(222, 222, 222, 0.7) forState:UIControlStateNormal];
            [_timeFilterButton setTitleColor:mainColor forState:UIControlStateNormal];
            [_priceFilterButton setTitleColor:RGBACOLOR(222, 222, 222, 0.7) forState:UIControlStateNormal];
            break;
        }
        case PriceFilterButtonMessage:{
            _popFilterButton.hidden = YES;
            _timeFilterButton.hidden = YES;
            _priceFilterButton.hidden = NO;
            _locationFilterButton.hidden = YES;
//            [_priceFilterButton setBackgroundImage:[UIImage imageNamed:self.defaultCategoryButtonPicArray[flag-1]]forState:UIControlStateNormal];
            [_popFilterButton setTitleColor:RGBACOLOR(222, 222, 222, 0.7) forState:UIControlStateNormal];
            [_timeFilterButton setTitleColor:RGBACOLOR(222, 222, 222, 0.7) forState:UIControlStateNormal];
            [_priceFilterButton setTitleColor:mainColor forState:UIControlStateNormal];
            [tmpDic setObject:@"shop_price" forKey:@"sort"];
            break;
        }
        case LocationFilterButtonMessage:{
            _popFilterButton.hidden = YES;
            _timeFilterButton.hidden = YES;
            _priceFilterButton.hidden = YES;
            _locationFilterButton.hidden = NO;
            [_locationFilterButton setBackgroundImage:[UIImage imageNamed:self.defaultCategoryButtonPicArray[flag-1]]forState:UIControlStateNormal];
        }
        default:
            break;
    }
    [tmpDic setObject:@"DESC" forKey:@"order"];
    if (_filterPageDic) {
        [tmpDic addEntriesFromDictionary:_filterPageDic];
    }
    if (_tmpDic) {
        [tmpDic addEntriesFromDictionary:_tmpDic];
    }
    if (flag != 4) {
        [_smallFilterView removeFromSuperview];
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        [self getShopListDataWithNewDic:tmpDic];
    } else {
        //产地、货物所在地筛选
        if (_topFutureFilterFlag) {//产地(期货)
            
        } else {//货物所在地
            
        }
        [self createSmallFilterView];
        _isUnfold = NO;
    }
    [self setReFreshMethod];
}
- (void)searchCancelButtonClicked:(UIButton *)button {
    [_searchBar resignFirstResponder];
    [_searchCancelButton removeFromSuperview];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view addSubview:_searchCancelButton];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchActionMethod];
}
- (void)searchActionMethod {
    NSMutableDictionary *filterDic = [NSMutableDictionary dictionary];
    [filterDic setObject:_searchBar.text forKey:@"keywords"];
    if ([_searchBar.text isEqualToString:@""]||_searchBar.text == nil) {
        [_MBHUD setLabelText:@"亲，没有输入搜索关键字哦。"];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        [_MBHUD hide:YES afterDelay:1.0f];
    } else {
        if (!_sign_MSandTJ) {
             [self getShopListDataWithNewDic:filterDic];
        }
        else
        {
         [self getTJorMSShopListDataWithNewDic:filterDic];
        }
       
        [_searchBar resignFirstResponder];
        [_searchCancelButton removeFromSuperview];
        _searchBar.text = @"";
    }
}
- (void)createWholeUI{
    _isUnfold = YES;
    _searchCancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _searchCancelButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [_searchCancelButton setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    [_searchCancelButton addTarget:self action:@selector(searchCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
     [self setUpNavigationBar];//搜索框
    
    _filterPageDic = [NSMutableDictionary dictionary];
    //    _topFutureFilterFlag = NO;
    _totalCount = 1;
    _typeFlag = 1;
    _goodsListModelArray = [NSMutableArray array];
    _tmpPage = 1;
    _MBHUD = [[MBProgressHUD alloc] init];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    _goodsListModelArray = [NSMutableArray new];
    if (_filterDic) {
        [_filterPageDic addEntriesFromDictionary:_filterDic];
    }
    [self.view setBackgroundColor:RGBACOLOR(255, 255, 255, 1)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight)];
    _baseScrollView.delegate = self;
    [self.view addSubview:_baseScrollView];
    _containerView = [UIView new];
    [_baseScrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_baseScrollView);
        make.width.equalTo(_baseScrollView);
    }];
#pragma mark 设置顶部筛选按钮
    if (!_sign_MSandTJ) {
    NSInteger smallTopWidth = (NSInteger)ScreenWidth/5;
    NSInteger smallTopHeight = 40;
    for (int i = 0; i <5; i++) {
        UILabel *topSmallLabel = [[UILabel alloc] initWithFrame:CGRectMake(smallTopWidth*i, 0, smallTopWidth, smallTopHeight)];
        [_baseScrollView addSubview:topSmallLabel];
        [topSmallLabel setBackgroundColor:[UIColor whiteColor]];
        [topSmallLabel setText:self.topLabelArray[i]];
        topSmallLabel.numberOfLines=0;
        topSmallLabel.lineBreakMode=NSLineBreakByTruncatingHead;
        [topSmallLabel setTextAlignment:NSTextAlignmentCenter];
        [topSmallLabel setFont:ThemeFont(CommonFontSize)];
        topSmallLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topLabelTapMethod:)];
        [topSmallLabel addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i + 1;
        //默认设置不从首页进入的标志
        NSInteger tmpInteger = 1;
        switch (_HomePageFlag) {
            case 1:{
                tmpInteger = 0;
                break;
            }
            case 2:{
                tmpInteger = 1;
                break;
            }
            case 3:{
                tmpInteger = 2;
                break;
            }
            case 4:{
                tmpInteger = 3;
                break;
            }
            case 5:{
                tmpInteger = 4;
                break;
            }
            default:
                break;
        }
        if (i == tmpInteger) {
            if (_filterDic)//筛选页面过来的不显示顶部当前类别
            {
                
            }
            else
            {
            [self setTopIndicatorButtonVisible:topSmallLabel];
            }
           
        } else {
            if ([[_filterDic allKeys] count]) {
                //搜索商品
//                [self getShopListDataWithNewDic:_filterDic];
                [self createMiddleFilterUI];
               
            }
        }
    }
#pragma mark 设置中部筛选按钮
    //保证从首页进入商品列表数据不会加载多次
    if (_filterDic) {
        //                [self getShopListDataWithNewDic:_filterDic];

    }
    }
    else
    {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        [self getTJorMSShopListDataWithNewDic:tmpDic];
         [self setReFreshMethod];

    }

}

- (void)createBottomCell {
    _bottomCellContainerView = [UIView new];
    [_baseScrollView addSubview:_bottomCellContainerView];
    [_bottomCellContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!_sign_MSandTJ)
        {
        make.top.equalTo(_middleFilterView.mas_bottom);
        }
        else
        {
        make.top.equalTo(_baseScrollView).with.offset(0);;
        }
        make.left.equalTo(_containerView);
        make.right.equalTo(_containerView);
        make.bottom.equalTo(_containerView);
    }];
#pragma mark 搭建底部cell
    [_MBHUD hide:YES];
    CGFloat bottomCellHeight = ScreenWidth/3;
    CGFloat smallBottomCellImageWidth = (ScreenWidth/3 - 2*Gap)/3;
    for (int i = 0; i < _goodsListModelArray.count; i++) {
        BestGoodsModel *tmpGoodsModel = _goodsListModelArray[i];
        UIView *bottomCellView = [UIView new];
        //        [bottomCellView setBackgroundColor:[UIColor yellowColor]];
        [_bottomCellContainerView addSubview:bottomCellView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomCellTapMethod:)];
        [bottomCellView addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i + 1;
        [bottomCellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomCellContainerView).with.offset((bottomCellHeight+1+Gap)*i);
            make.left.equalTo(_baseScrollView);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(bottomCellHeight+Gap);
        }];
        UIImageView *leftBigImageView = [UIImageView new];
        [bottomCellView addSubview:leftBigImageView];
        [leftBigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomCellView).with.offset(Gap);
            make.centerY.equalTo(bottomCellView);
            make.width.equalTo(leftBigImageView.mas_height);
            make.height.mas_equalTo(bottomCellHeight - 2*Gap);
        }];
        [leftBigImageView sd_setImageWithURL:[NSURL URLWithString:tmpGoodsModel.goods_thumb] placeholderImage:nil];
        
        UILabel *smallLocalLabel = [UILabel new];
        [smallLocalLabel setText:[NSString stringWithFormat:@"%@",tmpGoodsModel.region_name_ch?tmpGoodsModel.region_name_ch:tmpGoodsModel.region_name]];
        [smallLocalLabel setFont:ThemeFont(12)];
        [smallLocalLabel setBackgroundColor:RGBACOLOR(102, 102, 102, 1)];
        smallLocalLabel.alpha=0.7;
        [smallLocalLabel setTextColor:[UIColor whiteColor]];
        //        [middleTopLabel setTextColor:[UIColor grayColor]];
        [leftBigImageView addSubview:smallLocalLabel];
        [smallLocalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(leftBigImageView);
            make.left.equalTo(leftBigImageView);
            make.width.equalTo(leftBigImageView.mas_width);
            make.height.mas_equalTo(20);
        }];
        


        
//        UIImageView *smallTopImageView = [UIImageView new];
//        [smallTopImageView sd_setImageWithURL:[NSURL URLWithString:tmpGoodsModel.region_icon] placeholderImage:nil];
//        [leftBigImageView addSubview:smallTopImageView];
//        [smallTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(leftBigImageView);
//            make.left.equalTo(leftBigImageView);
//            make.width.equalTo(smallTopImageView.mas_height);
//            make.height.mas_equalTo(smallBottomCellImageWidth);
//        }];
        UILabel *middleTopLabel = [UILabel new];
        [middleTopLabel setText:[NSString stringWithFormat:@"%@",tmpGoodsModel.goods_name]];
        [middleTopLabel setFont:ThemeFont(16)];
        //        [middleTopLabel setTextColor:[UIColor grayColor]];
        [bottomCellView addSubview:middleTopLabel];
        [middleTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBigImageView.mas_right).with.offset(Gap);
            make.top.equalTo(leftBigImageView);
            //            make.width.mas_equalTo(bottomCellHeight);
            make.height.mas_equalTo(CommonHeight);
        }];
        UILabel *middleMiddleLabel = [UILabel new];
        [middleMiddleLabel setText:[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"Plant No.",nil),tmpGoodsModel.brand_sn]];
        //        [middleMiddleLabel setTextColor:[UIColor grayColor]];
        [middleMiddleLabel setFont:ThemeFont(16)];
        [bottomCellView addSubview:middleMiddleLabel];
        [middleMiddleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBigImageView.mas_right).with.offset(Gap);
            make.top.equalTo(middleTopLabel.mas_bottom).with.offset(Gap);
            //            make.width.mas_equalTo(ScreenWidth/2);
            make.height.mas_equalTo(CommonHeight);
        }];
        UILabel *bottomPriceLabel = [UILabel new];
        [bottomPriceLabel setText:[NSString stringWithFormat:@"%@",tmpGoodsModel.shop_price]];
        [bottomPriceLabel setFont:ThemeFont(22)];
        [bottomPriceLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
        [bottomCellView addSubview:bottomPriceLabel];
        [bottomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBigImageView.mas_right).with.offset(Gap);
            make.bottom.equalTo(leftBigImageView);
            //            make.width.mas_equalTo(bottomCellHeight);
            make.height.mas_equalTo(25);
        }];
        UILabel *bottomMeasureLabel = [UILabel new];
        [bottomMeasureLabel setText:[NSString stringWithFormat:@"/%@",tmpGoodsModel.unit_name]];
        [bottomMeasureLabel setFont:ThemeFont(CommonFontSize)];
        [bottomMeasureLabel setTextColor:[UIColor blackColor]];
        [bottomCellView addSubview:bottomMeasureLabel];
        [bottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomPriceLabel.mas_right);
            make.bottom.equalTo(leftBigImageView);
            //            make.width.mas_equalTo(bottomCellHeight/2);
            make.height.mas_equalTo(CommonHeight);
        }];
        UILabel *bottomAmountLabel = [UILabel new];
        //        [bottomAmountLabel setText:[NSString stringWithFormat:@"%@%@",tmpGoodsModel.spec_1,tmpGoodsModel.spec_1_unit]];
        [bottomAmountLabel setFont:ThemeFont(CommonFontSize)];
        [bottomAmountLabel setTextColor:[UIColor blackColor]];
        [bottomCellView addSubview:bottomAmountLabel];
        
        
        UILabel *bottomOriginLabel = [UILabel new];
        
        [bottomOriginLabel setText:[NSString stringWithFormat:@"%@ %@",tmpGoodsModel.goods_local,tmpGoodsModel.arrive_count]];
        [bottomOriginLabel setTextAlignment:NSTextAlignmentRight];
        [bottomOriginLabel setFont:ThemeFont(CommonFontSize)];
        [bottomOriginLabel setTextColor:[UIColor blackColor]];
        [bottomCellView addSubview:bottomOriginLabel];
        [bottomOriginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomMeasureLabel.mas_right);
            make.bottom.equalTo(leftBigImageView);
            make.right.equalTo(bottomCellView).with.offset(-Gap);
            make.height.mas_equalTo(CommonHeight);
        }];
        [bottomAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomMeasureLabel.mas_right).with.offset(Gap);
            make.bottom.equalTo(leftBigImageView);
            //            make.width.mas_equalTo(bottomCellHeight/1.5);
            make.height.mas_equalTo(CommonHeight);
        }];
        UIImageView *smallRightFirstImageView = [UIImageView new];
        UIImageView *smallRightSecondImageView = [UIImageView new];
        UIImageView *smallRightThirdImageView = [UIImageView new];
        UIImageView *smallRightFouthImageView = [UIImageView new];
        NSString *firstImageViewString;
        switch ([tmpGoodsModel.goods_type intValue]) {
            case 8:{
                firstImageViewString = [NSString stringWithFormat:NSLocalizedString(@"pic_cash_en",nil)];
                break;
            }
            case 7:{
                firstImageViewString = [NSString stringWithFormat:NSLocalizedString(@"pic_cash_en",nil)];
                break;
            }
            case 6:{
                firstImageViewString = [NSString stringWithFormat:NSLocalizedString(@"pic_futures_en",nil)];
                break;
            }
            default:
                break;
        }
        NSString *secondImageViewString;
        switch ([tmpGoodsModel.sell_type intValue]) {
            case 4:{
                secondImageViewString = [NSString stringWithFormat:NSLocalizedString(@"pic_zero_en",nil)];
                break;
            }
            case 5:{
                secondImageViewString = [NSString stringWithFormat:NSLocalizedString(@"pic_fcl_en",nil)];
                break;
            }
            default:
                break;
        }
        [smallRightFirstImageView setImage:[UIImage imageNamed:firstImageViewString]];
        [smallRightSecondImageView setImage:[UIImage imageNamed:secondImageViewString]];
        
        
        if ([tmpGoodsModel.offer isEqualToString:@"11"]) {
            [smallRightThirdImageView setImage:[UIImage imageNamed:NSLocalizedString(@"pic_bargaining_en",nil)]];
            if ([tmpGoodsModel.is_pin isEqualToString:@"1"]) {
                [smallRightFouthImageView setImage:[UIImage imageNamed:NSLocalizedString(@"pic_lcl_en",nil)]];
            }
        } else {
            if ([tmpGoodsModel.is_pin isEqualToString:@"1"]) {
                [smallRightThirdImageView setImage:[UIImage imageNamed:NSLocalizedString(@"pic_lcl_en",nil)]];
            }
        }
        [bottomCellView addSubview:smallRightFirstImageView];
        [bottomCellView addSubview:smallRightSecondImageView];
        [bottomCellView addSubview:smallRightThirdImageView];
        [bottomCellView addSubview:smallRightFouthImageView];
        [smallRightFirstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomCellView).with.offset(-Gap);
            make.top.equalTo(leftBigImageView);
            make.width.mas_equalTo(CommonHeight);
            make.height.mas_equalTo(CommonHeight);
        }];
        [smallRightSecondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(smallRightFirstImageView.mas_left).with.offset(-5);
            make.top.equalTo(leftBigImageView);
            make.width.mas_equalTo(CommonHeight);
            make.height.mas_equalTo(CommonHeight);
        }];
        [smallRightThirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(smallRightSecondImageView.mas_left).with.offset(-5);
            make.top.equalTo(leftBigImageView);
            make.width.mas_equalTo(CommonHeight);
            make.height.mas_equalTo(CommonHeight);
        }];
        [smallRightFouthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(smallRightThirdImageView.mas_left).with.offset(-5);
            make.top.equalTo(leftBigImageView);
            make.width.mas_equalTo(CommonHeight);
            make.height.mas_equalTo(CommonHeight);
        }];
        UILabel *bottomDecorateLabel = [UILabel new];
        [bottomDecorateLabel setBackgroundColor:RGBACOLOR(222, 222, 222, 0.7)];
        [bottomCellView addSubview:bottomDecorateLabel];
        [bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_baseScrollView);
            make.right.equalTo(_baseScrollView);
            make.top.equalTo(leftBigImageView.mas_bottom).with.offset(Gap);
            make.height.mas_equalTo(HomePageBordWidth);
        }];
        //库存为0或者为负时不能点击
        BOOL JudgeStoreNumber = YES;
        NSLog(@"tmpGoodsModel.goods_number:%@",tmpGoodsModel.goods_number);
        if ([tmpGoodsModel.goods_number length] >= 1) {
            if ([[tmpGoodsModel.goods_number substringToIndex:1] isEqualToString:@"-"]) {
                JudgeStoreNumber = NO;
            }
        }
        if ([tmpGoodsModel.goods_number intValue] == 0||JudgeStoreNumber == NO) {
            bottomCellView.userInteractionEnabled = NO;
            UIImageView *backGroundImageView = [UIImageView new];
//            backGroundImageView.image = [UIImage imageNamed:@"home_icon_sell"];
            backGroundImageView.backgroundColor = [UIColor whiteColor];
            backGroundImageView.alpha = 0.7;
            [bottomCellView addSubview:backGroundImageView];
            [backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
make.edges.equalTo(bottomCellView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));            }];
            
            UIImageView *cycImg = [UIImageView new];
            cycImg.image = [UIImage imageNamed:NSLocalizedString(@"icon_sellout_en", nil)];
            [backGroundImageView addSubview:cycImg];
            [cycImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(backGroundImageView.mas_right).with.offset(-60);
                make.bottom.equalTo(backGroundImageView.mas_bottom).with.offset(-10);
                make.width.mas_equalTo(1.175*(bottomCellHeight-20));
                make.height.mas_equalTo(bottomCellHeight-20);
            }];
            
        }
        if (i == _goodsListModelArray.count-1) {
            [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(bottomCellView);
            }];
        }
    }
}
- (void)setReFreshMethod {
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
    switch (_typeFlag) {
        case 1:{
            [tmpDic setObject:@"7" forKey:@"goods_type"];
            break;
        }
        case 2:{
            [tmpDic setObject:@"6" forKey:@"goods_type"];
            break;
        }
        case 3:{
            [tmpDic setObject:@"8" forKey:@"goods_type"];
            break;
        }
        case 4:{
            [tmpDic setObject:@"5" forKey:@"sell_type"];
            break;
        }
        case 5:{
            [tmpDic setObject:@"4" forKey:@"sell_type"];
            break;
        }
        default:
            break;
    }
    NSString *tmpString = [NSString new];
    NSMutableDictionary *smallLocalFilterDic = [NSMutableDictionary dictionary];
    switch (_middleTypeFlag) {
        case 1:{
            tmpString = [NSString stringWithFormat:@""];
            break;
        }
        case 2:{
            tmpString = [NSString stringWithFormat:@"last_update"];
            break;
        }
        case 3:{
            tmpString = [NSString stringWithFormat:@"shop_price"];
            break;
        }
        case 4:{
            tmpString = [NSString stringWithFormat:@""];
        }
        default:
            break;
    }
    if (_localFilterString) {
        if (_topFutureFilterFlag) {
            [smallLocalFilterDic setObject:_localFilterString forKey:@"region_id"];
        } else {
            [smallLocalFilterDic setObject:_localFilterString forKey:@"goods_local"];
        }
    }
    [tmpDic addEntriesFromDictionary:smallLocalFilterDic];
    [tmpDic setObject:tmpString forKey:@"sort"];
    if (_filterPageDic) {
        [tmpDic addEntriesFromDictionary:_filterPageDic];
    }
    if ( !_filterButtonFlag) {
        [tmpDic setObject:@"ASC" forKey:@"order"];
    } else {
        [tmpDic setObject:@"DESC" forKey:@"order"];
    }
    //上拉刷新
    _baseScrollView.mj_footer.automaticallyHidden = YES;
    _baseScrollView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        //根据后台返回来的page总数限制刷新次数
        if (_tmpPage < _totalCount) {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            _tmpPage++;
            NSString *tmpPageString = [NSString stringWithFormat:@"%lu",_tmpPage];
            [tmpDic setObject: tmpPageString forKey:@"page"];
            if (!_sign_MSandTJ) {
                 [self getShopListDataWithNewDic:tmpDic];
            }
            else
            {
             [self getTJorMSShopListDataWithNewDic:tmpDic];
            }
           
        } else {
            MBProgressHUD *tmpHud = [[MBProgressHUD alloc] init];
            [tmpHud setAnimationType:MBProgressHUDAnimationFade];
            [tmpHud setMode:MBProgressHUDModeText];
            [tmpHud setLabelText:NSLocalizedString(@"No more",nil)];
            [self.view addSubview:tmpHud];
            [tmpHud show:YES];
            [tmpHud hide:YES afterDelay:1.5f];
            [_baseScrollView.mj_footer endRefreshing];
        }
    }];
}
- (void)bottomCellTapMethod:(UITapGestureRecognizer *)tap {
    UIView *tmpView = [tap view];
    BestGoodsModel *tmpGoodsModel = _goodsListModelArray[tmpView.tag-1];
    NSLog(@"goods_id:%@",tmpGoodsModel.goods_id);
    TYDP_OfferDetailViewController *offerDetailViewCon = [[TYDP_OfferDetailViewController alloc] init];
    offerDetailViewCon.goods_id = tmpGoodsModel.goods_id;
    [self.navigationController pushViewController:offerDetailViewCon animated:YES];
}
//- (void)middleLabelTapMethod:(UITapGestureRecognizer *)tap {
//    UIView *tmpView = [tap view];
//    [self setMiddleIndicatorButtonVisible:tmpView];
//}
//- (void)setMiddleIndicatorButtonVisible:(UIView *)superView {
//    if (!_middleIndicatorButton) {
//        _middleIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_middleIndicatorButton.titleLabel setFont:ThemeFont(CommonFontSize)];
//    }
//    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
//    if (superView.tag == 4) {
//        [_middleIndicatorButton setBackgroundColor:[UIColor clearColor]];
//        [_middleIndicatorButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//        [center postNotificationName:@"changeTabBarIndex" object:self userInfo:@{@"index":@"1"}];
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }else{
//        [_middleIndicatorButton setBackgroundColor:[UIColor whiteColor]];
//        [_middleIndicatorButton setTitleColor:RGBACOLOR(251, 91, 50, 1) forState:UIControlStateNormal];
//        switch (superView.tag) {
//            case 1:{
//                [tmpDic setObject:@"DESC" forKey:@"sort"];
//                break;
//            }
//            case 2:{
//                [tmpDic setObject:@"last_update" forKey:@"sort"];
//                break;
//            }
//            case 3:{
//                [tmpDic setObject:@"shop_price" forKey:@"sort"];
//                break;
//            }
//            default:
//                break;
//        }
//
//    }
//    _middleIndicatorButton.frame = CGRectMake(superView.frame.origin.x, superView.frame.origin.y+1, superView.frame.size.width, superView.frame.size.height-2);
//    [_baseScrollView addSubview:_middleIndicatorButton];
//    [_middleIndicatorButton setTitle:self.middleLabelArray[superView.tag-1] forState:UIControlStateNormal];
//    //    [_middleIndicatorButton mas_makeConstraints:^(MASConstraintMaker *make) {
//    //        make.edges.equalTo(superView).with.insets(UIEdgeInsetsMake(1, 0, 1, 0));
//    //    }];
//    [self getShopListDataWithNewDic:tmpDic];
//}
- (void)topLabelTapMethod:(UITapGestureRecognizer *)tap {
    UIView *tmpView = [tap view];
    [_filterPageDic removeAllObjects];
    [_filterDic removeAllObjects];
    [self setTopIndicatorButtonVisible:tmpView];
}
- (void)setTopIndicatorButtonVisible:(UIView *)superView {
    _topFutureFilterFlag = NO;
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    [self.view addSubview:_MBHUD];
    [_MBHUD show:YES];
    _tmpPage = 1;
    if (!_topIndicatorButton) {
        _topIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topIndicatorButton setBackgroundColor:[UIColor whiteColor]];
        [_topIndicatorButton.titleLabel setFont:ThemeFont(CommonFontSize)];
        [_topIndicatorButton setTitleColor:RGBACOLOR(251, 91, 50, 1) forState:UIControlStateNormal];
        _bottomDecorateLabel = [UILabel new];
        [_bottomDecorateLabel setBackgroundColor:RGBACOLOR(251, 91, 50, 1)];
        _tmpMemory = (NSInteger)ScreenWidth/10;
    }
    _topIndicatorButton.frame = superView.frame;
    _bottomDecorateLabel.frame = CGRectMake(0, superView.frame.size.height - 1.5,superView.frame.size.width,1.5);
    [_baseScrollView addSubview:_topIndicatorButton];
    [_baseScrollView addSubview:_bottomDecorateLabel];
    //    [_bottomDecorateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(_topIndicatorButton).with.offset(-1.5);
    //        make.left.equalTo(_topIndicatorButton).with.offset(5);
    //        make.right.equalTo(_topIndicatorButton).with.offset(-5);
    //        make.height.mas_equalTo(1.5);
    //    }];
    [_topIndicatorButton setTitle:self.topLabelArray[superView.tag-1] forState:UIControlStateNormal];
    _topIndicatorButton.titleLabel.numberOfLines=0;
    _topIndicatorButton.titleLabel.lineBreakMode=NSLineBreakByTruncatingHead;
    _topIndicatorButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    _tmpDic = [NSMutableDictionary dictionary];
    _typeFlag = superView.tag;
    switch (superView.tag) {
                case 1:{
            [_tmpDic setObject:@"7" forKey:@"goods_type"];
            break;
        }
        case 2:{
            [_tmpDic setObject:@"6" forKey:@"goods_type"];
            _topFutureFilterFlag = YES;
            break;
        }
        case 3:{
            [_tmpDic setObject:@"8" forKey:@"goods_type"];
            _topFutureFilterFlag = YES;
            break;
        }
        case 4:{
            [_tmpDic setObject:@"5" forKey:@"sell_type"];
            break;
        }
        case 5:{
            [_tmpDic setObject:@"4" forKey:@"sell_type"];
            break;
        }
        default:
            break;
    }
    //设置对象动画属性
    POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anBasic.fromValue = @(_tmpMemory);
    anBasic.toValue = @(_topIndicatorButton.center.x);
    anBasic.beginTime = CACurrentMediaTime();
    [_bottomDecorateLabel pop_addAnimation:anBasic forKey:@"positionX"];
    _tmpMemory = _topIndicatorButton.center.x;
    [anBasic setAnimationDidStartBlock:^(POPAnimation *ani) {
    }];
    [anBasic setCompletionBlock:^(POPAnimation * ani, BOOL fin) {
        if(fin) {
            [self createMiddleFilterUI];
        }
    }];
}
#pragma mark 设置导航栏
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.backgroundColor=mainColor;
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    [self.view addSubview:_navigationBarView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationBarView addSubview:backButton];
    UIImage *backButtonImage = [UIImage imageNamed:@"product_icon_return"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30*(backButtonImage.size.height/backButtonImage.size.width));
    }];
#pragma mark 设置搜索框
     if (!_sign_MSandTJ) {
    _searchView = [UIView new];
    _searchView.clipsToBounds = YES;
    [_searchView setBackgroundColor:[UIColor whiteColor]];
    _searchView.layer.cornerRadius = 15;
    [_navigationBarView addSubview:_searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton.mas_right).with.offset(35);
        make.centerY.equalTo(_navigationBarView).with.offset(10);
        make.right.equalTo(_navigationBarView).with.offset(-50);
        make.height.mas_equalTo(30);
    }];
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.alpha = 0.3;
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchView addSubview:_searchBar];
    _searchBar.placeholder = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Search the Product", nil)];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_searchView).with.insets(UIEdgeInsetsMake(0,-Gap,0, -Gap));
    }];
         
         [_searchBar setBackgroundColor:[UIColor whiteColor]];
         for (UIView *subView in _searchBar.subviews) {
             if ([subView isKindOfClass:[UIView  class]]) {
                 [[subView.subviews objectAtIndex:0] removeFromSuperview];
                 if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                     UITextField *textField = [subView.subviews objectAtIndex:0];
                     textField.backgroundColor = [UIColor whiteColor];
                     
                     //设置输入框边框的颜色
                     //                    textField.layer.borderColor = [UIColor blackColor].CGColor;
                     //                    textField.layer.borderWidth = 1;
                     
                     //设置输入字体颜色
                     //                    textField.textColor = [UIColor lightGrayColor];
                     
                     //设置默认文字颜色
                     UIColor *color = [UIColor grayColor];
                     [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Search the Product", nil)
                                                                                         attributes:@{NSForegroundColorAttributeName:color}]];
                     //                //修改默认的放大镜图片
                     //                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
                     //                imageView.backgroundColor = [UIColor clearColor];
                     //                imageView.image = [UIImage imageNamed:@"gww_search_ misplaces"];
                     //                textField.leftView = imageView;
                 }
             }
         }

         
    UIButton *offerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [offerButton setTitle:NSLocalizedString(@"Filter", nil) forState:UIControlStateNormal];
    offerButton.tag = OfferButtonMessage;
    [offerButton addTarget:self action:@selector(offerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [offerButton.titleLabel setFont:ThemeFont(16)];
    [offerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_navigationBarView addSubview:offerButton];
    [offerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_searchView.mas_right);
        make.centerY.equalTo(_navigationBarView).with.offset(10);
        make.right.equalTo(_navigationBarView);
        make.height.mas_equalTo(30);
    }];
     }
    else
    {
        UILabel *titleLable = [UILabel new];
        [_navigationBarView addSubview:titleLable];
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_navigationBarView);
            make.centerY.equalTo(_navigationBarView).with.offset(Gap);
            make.width.mas_equalTo(280);
            make.height.mas_equalTo(20);
        }];
        if ([_more_type isEqualToString:@"hot"]) {
            [titleLable setText:NSLocalizedString(@"Timed special", nil)];
        }
        if ([_more_type isEqualToString:@"promote"]) {
            [titleLable setText:NSLocalizedString(@"Today\'s deal", nil)];
        }
        if ([_more_type isEqualToString:@"best"]) {
            [titleLable setText:NSLocalizedString(@"Recommended products", nil)];
        }
        titleLable.textColor=[UIColor whiteColor];
        [titleLable setFont:ThemeFont(16)];
        [titleLable setTextAlignment:NSTextAlignmentCenter];
        
        
    }
}
- (void)offerButtonClicked:(UIButton *)button {
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)leftItemClicked:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    [MobClick beginLogPageView:@"商品列表界面"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"商品列表界面"];
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
