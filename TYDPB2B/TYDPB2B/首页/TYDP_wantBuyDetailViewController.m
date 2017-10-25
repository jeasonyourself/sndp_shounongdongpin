//
//  TYDP_wantBuyDetailViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/13.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "TYDP_wantBuyDetailViewController.h"
#import "TYDP_OfferDetailViewController.h"
#import "BestGoodsModel.h"
#import "TYDP_OfferViewController.h"
#import "LocalListModel.h"
#import "purchaseListModel.h"
#import "commentListModel.h"
#import "TYDP_commentViewController.h"
#import "TYDP_LoginController.h"
typedef enum {
    PopFilterButtonMessage = 1,
    TimeFilterButtonMessage,
    PriceFilterButtonMessage,
    LocationFilterButtonMessage,
    OfferButtonMessage
}BUTTONMESSAGE;
@interface TYDP_wantBuyDetailViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UISearchBarDelegate,commentDelegate>
{
    UIView *a_demandCellView;
}
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
@property(nonatomic, strong) purchaseListModel * purchaseListMD;
@end

@implementation TYDP_wantBuyDetailViewController

/**
 *  灰色筛选控件图标
 *
 *  @return
 */
-(NSArray *)defaultCategoryPicArray{
    if (!_defaultCategoryPicArray) {
        _defaultCategoryPicArray = [NSMutableArray arrayWithObjects:@"productlist_hot_n",@"productlist_time_n",@"productlist_price_n",@"productlist_location_n", nil];
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
        _defaultCategoryButtonPicArray = [NSMutableArray arrayWithObjects:@"productlist_hot_down",@"productlist_time_down",@"productlist_price_down",@"productlist_location_down", nil];
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
        _defaultCategoryButtonSelectedPicArray = [NSMutableArray arrayWithObjects:@"productlist_hot_up",@"productlist_time_up",@"productlist_price_up",@"productlist_location_up", nil];
    }
    return _defaultCategoryButtonSelectedPicArray;
}

-(NSArray *)topLabelArray {
    if (!_topLabelArray) {
        _topLabelArray = [NSArray arrayWithObjects:@"猪",@"牛",@"羊",@"禽类",@"水产",@"其他", nil];
    }
    return _topLabelArray;
}
-(NSArray *)middleLabelArray {
    if (!_middleLabelArray) {
        _middleLabelArray = [NSArray arrayWithObjects:@"热门11",@"时间",@"价格",@"筛选", nil];
    }
    return _middleLabelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsListModelArray = [NSMutableArray new];

    [self getDetail];
    // Do any additional setup after loading the view.
}
- (void)getDetail{
    
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"purchase",@"getPurchaseInfo",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"getPurchaseInfo",@"sign":[TYDPManager md5:Sign],@"model":@"purchase",@"id":self.qiugou_id}];
    NSLog(@"qiugouDetailparams:%@",params);
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        NSLog(@"qiugoudetaildata:%@",data);
        [_bottomCellContainerView removeFromSuperview];
        if (![data[@"error"] intValue]) {
            [_MBHUD hide:YES];
            
            _purchaseListMD=[[purchaseListModel alloc] initWithDictionary:data[@"content"] error:nil];
            
            [self getShopListDataWithNewDic:params];
        } else {
            [_MBHUD setLabelText:@"网络故障。。。"];
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
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"purchase",@"getCommentList",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"getCommentList",@"sign":[TYDPManager md5:Sign],@"model":@"purchase",@"p_id":self.qiugou_id}];
    params[@"page"]=[NSString stringWithFormat:@"%ld",_tmpPage];
//    [params addEntriesFromDictionary:dic];
    NSLog(@"qiugoucommentListparams:%@",params);
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"commentListdata:%@",data);
        [_bottomCellContainerView removeFromSuperview];
        if (![data[@"error"] intValue]) {
            [_MBHUD hide:YES];
            NSArray * arr=data[@"content"][@"comment_list"];
            for (int i =0 ; i<arr.count; i++) {
                commentListModel* commentListMD=    [[commentListModel alloc] initWithDictionary:arr[i] error:nil];
                debugLog(@"mmmmmmdddd:%@",commentListMD);
                [_goodsListModelArray addObject:commentListMD];
            }
//            [_goodsListModelArray addObjectsFromArray:[commentListModel arrayOfModelsFromDictionaries:data[@"content"][@"comment_list"] error:nil]];
            
            debugLog(@"commentListarrr:%@",_goodsListModelArray);

                        _totalCount = [data[@"content"][@"total"][@"page_count"] intValue];
            [self createWholeUI];
            [self createBottomCell];
            //从报盘进入没有筛选结果的时候。。。
            //            NSLog(@"_filterDic:%@, %lu",_filterDic,[[_filterDic allKeys] count]);
            if ([[_filterDic allKeys] count]) {
                
            }
            if ([_goodsListModelArray count] == 0) {
                MBProgressHUD *tmpHud = [[MBProgressHUD alloc] init];
                [tmpHud setAnimationType:MBProgressHUDAnimationFade];
                [tmpHud setMode:MBProgressHUDModeText];
                [tmpHud setLabelText:@"暂时没有评论。。。"];
                [_goodsListModelArray removeAllObjects];
                [self.view addSubview:tmpHud];
                [tmpHud show:YES];
                [tmpHud hide:YES afterDelay:1.5f];
            }
            
        } else {
            [_MBHUD setLabelText:@"网络故障。。。"];
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
    UIImage *tmpImage = [UIImage imageNamed:@"productlist_hot_down"];
    CGFloat tmpHeight = smallMiddleWidth*(tmpImage.size.height/tmpImage.size.width);
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
        [_defaultCategoryPicArray replaceObjectAtIndex:3 withObject:@"productlist_area_n"];
        [_defaultCategoryButtonPicArray replaceObjectAtIndex:3 withObject:@"productlist_area_down"];
        [_defaultCategoryButtonSelectedPicArray replaceObjectAtIndex:3 withObject:@"productlist_area_up"];
    } else {
        [_defaultCategoryPicArray replaceObjectAtIndex:3 withObject:@"productlist_location_n"];
        [_defaultCategoryButtonPicArray replaceObjectAtIndex:3 withObject:@"productlist_location_down"];
        [_defaultCategoryButtonSelectedPicArray replaceObjectAtIndex:3 withObject:@"productlist_location_up"];
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
        [primaryImageView setImage:[UIImage imageNamed:self.defaultCategoryPicArray[i]]];
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
    [_popFilterButton setBackgroundImage:[UIImage imageNamed:@"productlist_hot_down"] forState:UIControlStateNormal];
    [_popFilterButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_middleFilterView addSubview:_popFilterButton];
    _timeFilterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_timeFilterButton setBackgroundColor:[UIColor whiteColor]];
    _timeFilterButton.tag = TimeFilterButtonMessage;
    _timeFilterButton.frame = CGRectMake(smallMiddleWidth, 0, smallMiddleWidth-HomePageBordWidth, tmpHeight);
    [_timeFilterButton setBackgroundImage:[UIImage imageNamed:@"productlist_time_down"] forState:UIControlStateNormal];
    [_timeFilterButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_middleFilterView addSubview:_timeFilterButton];
    _priceFilterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_priceFilterButton setBackgroundColor:[UIColor whiteColor]];
    _priceFilterButton.tag = PriceFilterButtonMessage;
    _priceFilterButton.frame = CGRectMake(smallMiddleWidth*2, 0, smallMiddleWidth-HomePageBordWidth, tmpHeight);
    [_priceFilterButton setBackgroundImage:[UIImage imageNamed:@"productlist_price_down"] forState:UIControlStateNormal];
    [_priceFilterButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_middleFilterView addSubview:_priceFilterButton];
    _locationFilterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_locationFilterButton setBackgroundColor:[UIColor whiteColor]];
    _locationFilterButton.tag = LocationFilterButtonMessage;
    _locationFilterButton.frame = CGRectMake(smallMiddleWidth*3, 0, smallMiddleWidth, tmpHeight);
    [_locationFilterButton setBackgroundImage:[UIImage imageNamed:@"productlist_location_down"] forState:UIControlStateNormal];
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
        [_MBHUD setLabelText:@"稍等片刻。。。"];
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
        [_locationFilterButton setBackgroundImage:[UIImage imageNamed:@"productlist_area_up"] forState:UIControlStateNormal];
    } else {
        [_locationFilterButton setBackgroundImage:[UIImage imageNamed:@"productlist_location_up"] forState:UIControlStateNormal];
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
    UIImage *tmpImage = [UIImage imageNamed:@"productlist_hot_down"];
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
    [_MBHUD setLabelText:@"稍等片刻。。。"];
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
            [_popFilterButton setBackgroundImage:[UIImage imageNamed:self.defaultCategoryButtonPicArray[flag-1]]forState:UIControlStateNormal];
            break;
        }
        case TimeFilterButtonMessage:{
            _popFilterButton.hidden = YES;
            _timeFilterButton.hidden = NO;
            _priceFilterButton.hidden = YES;
            _locationFilterButton.hidden = YES;
            [_timeFilterButton setBackgroundImage:[UIImage imageNamed:self.defaultCategoryButtonPicArray[flag-1]]forState:UIControlStateNormal];
            [tmpDic setObject:@"last_update" forKey:@"sort"];
            break;
        }
        case PriceFilterButtonMessage:{
            _popFilterButton.hidden = YES;
            _timeFilterButton.hidden = YES;
            _priceFilterButton.hidden = NO;
            _locationFilterButton.hidden = YES;
            [_priceFilterButton setBackgroundImage:[UIImage imageNamed:self.defaultCategoryButtonPicArray[flag-1]]forState:UIControlStateNormal];
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
        [_MBHUD setLabelText:@"稍等片刻。。。"];
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
        }
        
        [_searchBar resignFirstResponder];
        [_searchCancelButton removeFromSuperview];
        _searchBar.text = @"";
    }
}
- (void)createWholeUI{
    _isUnfold = YES;
    [self.view setBackgroundColor:RGBACOLOR(255, 255, 255, 1)];

    //    _searchCancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //    _searchCancelButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //    [_searchCancelButton setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    //    [_searchCancelButton addTarget:self action:@selector(searchCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpNavigationBar];//导航栏
    
    _filterPageDic = [NSMutableDictionary dictionary];
    //    _topFutureFilterFlag = NO;
    _totalCount = 1;
    _typeFlag = 1;
    _tmpPage = 1;
    _MBHUD = [[MBProgressHUD alloc] init];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    if (_filterDic) {
        [_filterPageDic addEntriesFromDictionary:_filterDic];
    }
    [self.view setBackgroundColor:RGBACOLOR(255, 255, 255, 1)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight-50)];
    _baseScrollView.backgroundColor=RGBACOLOR(250, 250, 250, 1);
    _baseScrollView.delegate = self;
    [self.view addSubview:_baseScrollView];
    _containerView = [UIView new];
    [_baseScrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_baseScrollView);
        make.width.equalTo(_baseScrollView);
    }];
    
    UIButton * bottomBtn =[UIButton new];
    bottomBtn.backgroundColor=mainColor;
    bottomBtn.tag=0;
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [bottomBtn addTarget:self action:@selector(bottomBtnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.titleLabel.font=[UIFont systemFontOfSize:13.0];
    [bottomBtn setTitle:@"留言" forState:UIControlStateNormal];
    [self.view addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);

        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(ScreenWidth/2-1);
        make.height.mas_equalTo(50.0);
    }];
    
    UIButton * bottomBtn1 =[UIButton new];
    bottomBtn1.backgroundColor=mainColor;
    [bottomBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn1.tag=1;
    [bottomBtn1 addTarget:self action:@selector(bottomBtnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn1.titleLabel.font=[UIFont systemFontOfSize:13.0];
    [bottomBtn1 setTitle:@"联系对方" forState:UIControlStateNormal];
    [self.view addSubview:bottomBtn1];
    [bottomBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);

        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(50.0);
    }];

#pragma mark 设置顶部求购信息
    
   

    
    a_demandCellView = [UIView new];
    [_containerView addSubview:a_demandCellView];
    a_demandCellView.backgroundColor=[UIColor whiteColor];
    
    CGFloat demandCellHeight = ScreenWidth/5;
    CGFloat demandCellImageWidth = (ScreenWidth/5 - 2*10-10)/2;

    if (_purchaseListMD.memo&&![_purchaseListMD.memo isEqualToString:@""]) {
        demandCellHeight = ScreenWidth/5+[self heightForCellWithText:_purchaseListMD.memo andFont:[NSNumber numberWithFloat:14.0] andWidth:[NSNumber numberWithFloat:ScreenWidth-30]];
    }
    else
    {
        demandCellHeight = ScreenWidth/5;
    }

    [a_demandCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_baseScrollView.mas_top).with.offset(0);
        make.left.equalTo(_baseScrollView);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(demandCellHeight);
    }];
    
    UIImageView *headImageView = [UIImageView new];
    [a_demandCellView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(a_demandCellView).with.offset(20);
        make.top.equalTo(a_demandCellView).with.offset(10);
        make.width.mas_equalTo(demandCellImageWidth);
        make.height.mas_equalTo(demandCellImageWidth);
    }];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[_purchaseListMD.user_face isEqualToString:@""]?@"http://test.taiyanggo.com/images/no_picture.gif":_purchaseListMD.user_face] placeholderImage:nil];
    
    
    UILabel *nameLabel = [UILabel new];
    NSString *number =[NSString stringWithFormat:@"%@",_purchaseListMD.user_name];
    if ([self inputShouldNumber:number]) {
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:nil];
        number = [regularExpression stringByReplacingMatchesInString:number options:0 range:NSMakeRange(3, 4) withTemplate:@"*"];
    }
    [nameLabel setText:[NSString stringWithFormat:@"%@",number]];
    [nameLabel setFont:ThemeFont(13)];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
    [a_demandCellView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).with.offset(10);
        make.top.equalTo(headImageView.mas_top).with.offset((demandCellImageWidth-CommonHeight)/2);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(CommonHeight);
    }];
    
    
    UILabel *addressLabel = [UILabel new];
    [addressLabel setText:[NSString stringWithFormat:@"%@",_purchaseListMD.address]];
    [addressLabel setFont:ThemeFont(13)];
    [addressLabel setTextAlignment:NSTextAlignmentLeft];
    [addressLabel setTextColor:[UIColor grayColor]];
    [a_demandCellView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(a_demandCellView.mas_right).with.offset(-15);
        make.top.equalTo(nameLabel);
        //            make.width.mas_equalTo(40);
        make.height.mas_equalTo(CommonHeight);
    }];
    
    UIImageView *localImageView = [UIImageView new];
    [localImageView setImage:[UIImage imageNamed:@"home_addressLocal"]];
    [a_demandCellView addSubview:localImageView];
    [localImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addressLabel.mas_left).with.offset(0);
        make.top.equalTo(nameLabel);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    
    UILabel *needLabel = [UILabel new];
    [needLabel setText:[NSString stringWithFormat:@"求购"]];
    [needLabel setFont:ThemeFont(12)];
    [needLabel setTextAlignment:NSTextAlignmentCenter];
    [needLabel setBackgroundColor:RGBACOLOR(153, 153, 153, 1)];
    [needLabel setTextColor:[UIColor whiteColor]];
    [a_demandCellView addSubview:needLabel];
    [needLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_left).with.offset(0);
        make.top.equalTo(headImageView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(CommonHeight);
    }];
    
    UILabel *detailDemandLabel = [UILabel new];
    [detailDemandLabel setText:[NSString stringWithFormat:@"%@  %@吨  %@-%@元/吨",_purchaseListMD.goods_name,_purchaseListMD.goods_num,_purchaseListMD.price_low,_purchaseListMD.price_up]];
    [detailDemandLabel setFont:ThemeFont(13)];
    [detailDemandLabel setTextColor:RGBACOLOR(51, 51, 51, 1)];
    
    [detailDemandLabel setTextAlignment:NSTextAlignmentLeft];
    //        [detailDemandLabel setBackgroundColor:[UIColor grayColor]];
    [a_demandCellView addSubview:detailDemandLabel];
    [detailDemandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(needLabel.mas_right).with.offset(15);
        make.top.equalTo(headImageView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo(CommonHeight);
    }];
    if (_purchaseListMD.memo&&![_purchaseListMD.memo isEqualToString:@""]) {
    UILabel *needDemandLabel = [UILabel new];
    [needDemandLabel setText:[NSString stringWithFormat:@"%@",_purchaseListMD.memo]];
        needDemandLabel.numberOfLines=0;
    [needDemandLabel setFont:ThemeFont(13)];
    [needDemandLabel setTextColor:RGBACOLOR(51, 51, 51, 1)];
    [needDemandLabel setTextAlignment:NSTextAlignmentLeft];
    //                [needDemandLabel setBackgroundColor:[UIColor grayColor]];
    [a_demandCellView addSubview:needDemandLabel];
    [needDemandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(a_demandCellView.mas_left).with.offset(15);
        make.top.equalTo(detailDemandLabel.mas_bottom).with.offset(10);
        make.width.mas_equalTo(ScreenWidth-30);
        make.height.mas_equalTo([self heightForCellWithText:_purchaseListMD.memo andFont:[NSNumber numberWithFloat:14.0] andWidth:[NSNumber numberWithFloat:ScreenWidth-30]]);
    }];
    }

   
    
    
}


- (void)createBottomCell {
    
#pragma mark 搭建底部cell
    
    [_MBHUD hide:YES];
    [_bottomCellContainerView removeFromSuperview];
    _bottomCellContainerView=nil;
    _bottomCellContainerView = [UIView new];
    [_baseScrollView addSubview:_bottomCellContainerView];
    [_bottomCellContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(a_demandCellView.mas_bottom);
        
        make.left.equalTo(_containerView);
        make.right.equalTo(_containerView);
        make.bottom.equalTo(_containerView);
    }];
    
    
    UILabel *SecondsKillLabel = [UILabel new];
    
    [SecondsKillLabel setText:[NSString stringWithFormat:@"    留言"]];
    SecondsKillLabel.backgroundColor=RGBACOLOR(246, 246, 246, 1);
    [SecondsKillLabel setFont:ThemeFont(14)];
    SecondsKillLabel.textColor=RGBACOLOR(85, 85, 85, 1);
    [_bottomCellContainerView addSubview:SecondsKillLabel];
    [SecondsKillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(0);
        make.right.equalTo(_baseScrollView).with.offset(0);
        make.top.equalTo(a_demandCellView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(CommonHeight);
    }];
    
    UILabel *bottomDecorateLabel = [UILabel new];
    [bottomDecorateLabel setFont:ThemeFont(13)];
    [bottomDecorateLabel setBackgroundColor:RGBACOLOR(250, 250, 250, 0.7)];
    [_bottomCellContainerView addSubview:bottomDecorateLabel];
    [bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SecondsKillLabel);
        make.right.equalTo(SecondsKillLabel);
        make.bottom.equalTo(SecondsKillLabel);
        make.height.mas_equalTo(HomePageBordWidth);
    }];

#pragma mark 搭建求购信息cell
    CGFloat totledemandCellHeight=0;
    CGFloat demandCellHeight=0;
    CGFloat demandCellImageWidth = (ScreenWidth/5 - 2*10-10)/2;
    
    UIView * lastdemandCellView = [UIView new];
    
    for (int i = 0; i < _goodsListModelArray.count; i++) {
        commentListModel *commentListMD = _goodsListModelArray[i];
        demandCellHeight=[self heightForCellWithText:commentListMD.content andFont:[NSNumber numberWithFloat:13.0] andWidth:[NSNumber numberWithFloat:ScreenWidth-30]]+demandCellImageWidth+20;
        
        //        BestGoodsModel *tmpGoodsModel = _goodsModelArray[i];
        UIView *demandCellView = [UIView new];
        [_bottomCellContainerView addSubview:demandCellView];
        demandCellView.backgroundColor=[UIColor whiteColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(demandCellViewTapMethod:)];
        [demandCellView addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i + 1;
        [demandCellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(SecondsKillLabel.mas_bottom).with.offset(totledemandCellHeight);
            make.left.equalTo(_baseScrollView);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(demandCellHeight);
        }];
        
        totledemandCellHeight=totledemandCellHeight+demandCellHeight;
        
        if (i == _goodsListModelArray.count-1) {
            lastdemandCellView=demandCellView;
        }
        UIImageView *headImageView = [UIImageView new];
        [demandCellView addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(demandCellView).with.offset(20);
            make.top.equalTo(demandCellView).with.offset(10);
            make.width.mas_equalTo(demandCellImageWidth);
            make.height.mas_equalTo(demandCellImageWidth);
        }];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[commentListMD.user_face isEqualToString:@""]?@"http://test.taiyanggo.com/images/no_picture.gif":commentListMD.user_face] placeholderImage:nil];
        
        
        UILabel *nameLabel = [UILabel new];
        NSString *number =[NSString stringWithFormat:@"%@",commentListMD.user_name];

        if ([self inputShouldNumber:number]) {
            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:nil];
            number = [regularExpression stringByReplacingMatchesInString:number options:0 range:NSMakeRange(3, 4) withTemplate:@"*"];
        }

        [nameLabel setText:[NSString stringWithFormat:@"%@",number]];
        [nameLabel setFont:ThemeFont(13)];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [demandCellView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImageView.mas_right).with.offset(10);
            make.top.equalTo(headImageView.mas_top).with.offset((demandCellImageWidth-CommonHeight)/2);
            make.width.mas_equalTo(ScreenWidth/2);
            make.height.mas_equalTo(CommonHeight);
        }];
        
        
        UILabel *addressLabel = [UILabel new];
        [addressLabel setText:[NSString stringWithFormat:@"%@",commentListMD.add_time]];
        [addressLabel setFont:ThemeFont(13)];
        [addressLabel setTextAlignment:NSTextAlignmentLeft];
        [addressLabel setTextColor:[UIColor grayColor]];
        [demandCellView addSubview:addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(demandCellView.mas_right).with.offset(-15);
            make.top.equalTo(nameLabel);
            //            make.width.mas_equalTo(40);
            make.height.mas_equalTo(CommonHeight);
        }];
        
        UILabel *detailDemandLabel = [UILabel new];
        [detailDemandLabel setText:[NSString stringWithFormat:@"%@",commentListMD.content]];
        [detailDemandLabel setFont:ThemeFont(13)];
        [detailDemandLabel setTextColor:RGBACOLOR(51, 51, 51, 1)];
        
        [detailDemandLabel setTextAlignment:NSTextAlignmentLeft];
        //        [detailDemandLabel setBackgroundColor:[UIColor grayColor]];
        [demandCellView addSubview:detailDemandLabel];
        [detailDemandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_baseScrollView.mas_left).with.offset(15);
            make.top.equalTo(headImageView.mas_bottom).with.offset(0);
            make.width.mas_equalTo(ScreenWidth-30);
            make.height.mas_equalTo(demandCellHeight-demandCellImageWidth-20);
        }];
        
        UILabel *bottomDecorateLabel = [UILabel new];
        [bottomDecorateLabel setFont:ThemeFont(13)];
        [bottomDecorateLabel setBackgroundColor:RGBACOLOR(250, 250, 250, 0.7)];
        [demandCellView addSubview:bottomDecorateLabel];
        [bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(demandCellView);
            make.right.equalTo(demandCellView);
            make.bottom.equalTo(demandCellView);
            make.height.mas_equalTo(HomePageBordWidth);
        }];
        
        if (i == _goodsListModelArray.count-1) {
            [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(lastdemandCellView);
            }];
        }
    }
}


- (void)leftItemClicked:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 求购详情
- (void)demandCellViewTapMethod:(UITapGestureRecognizer *)tap
{
    
}

- (void)setReFreshMethod {
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
//    [tmpDic setObject:[_topLabelArray objectAtIndex:_typeFlag-1] forKey:@"type"];
    //上拉刷新
    _baseScrollView.mj_footer.automaticallyHidden = YES;
    _baseScrollView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        //根据后台返回来的page总数限制刷新次数
        if (_tmpPage < _totalCount) {
            [_MBHUD setLabelText:@"稍等片刻。。。"];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            _tmpPage++;
            NSString *tmpPageString = [NSString stringWithFormat:@"%lu",_tmpPage];
            [tmpDic setObject: tmpPageString forKey:@"page"];
            
            [self getShopListDataWithNewDic:tmpDic];
            
            
        } else {
            MBProgressHUD *tmpHud = [[MBProgressHUD alloc] init];
            [tmpHud setAnimationType:MBProgressHUDAnimationFade];
            [tmpHud setMode:MBProgressHUDModeText];
            [tmpHud setLabelText:@"已经是最后一页～"];
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
    [self setTopIndicatorButtonVisible:tmpView];
}
- (void)setTopIndicatorButtonVisible:(UIView *)superView {
    _topFutureFilterFlag = NO;
    [_MBHUD setLabelText:@"稍等片刻。。。"];
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
    _tmpDic = [NSMutableDictionary dictionary];
    _typeFlag = superView.tag;
    [_tmpDic setObject:[_topLabelArray objectAtIndex:_typeFlag-1] forKey:@"type"];
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
            [self getShopListDataWithNewDic:_tmpDic];
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
    
    UILabel *titleLable = [UILabel new];
    [_navigationBarView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [titleLable setText:@"求购详情"];
    
    titleLable.textColor=[UIColor whiteColor];
    [titleLable setFont:ThemeFont(16)];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    
    
    
}
- (void)offerButtonClicked:(UIButton *)button {
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)bottomBtnItemClicked:(UIButton*)item{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"user_id"]) {//已登陆
        if (item.tag==0) {
            TYDP_commentViewController * commentVC=[[TYDP_commentViewController alloc] init];
            commentVC.delegate=self;
            commentVC.qiugou_id=self.qiugou_id;
            [self.navigationController pushViewController:commentVC animated:YES];
            
        }
        if (item.tag==1)
        {
//            purchaseListModel *tmpGoodsModel = _goodsListModelArray[item.tag];
            UIWebView*callWebview =[[UIWebView alloc] init];
            NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_purchaseListMD.user_phone]];// 貌似tel:// 或者 tel: 都行
            [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
            
            //记得添加到view上
            [self.view addSubview:callWebview];
        }
    }
    else {//尚未登陆状态
        TYDP_LoginController *loginViewCon = [[TYDP_LoginController alloc] init];
        [self.navigationController pushViewController:loginViewCon animated:YES];
    }

    
}
- (void) pubcomment:(NSInteger)sender
{
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    dic[@"page"]=@"1";
    [self getShopListDataWithNewDic:dic];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [MobClick beginLogPageView:@"求购详情界面"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"求购详情界面"];
}

#pragma mark 字符串高度
- (CGFloat)heightForCellWithText:(NSString *)text andFont:(NSNumber*)fontSize andWidth:(NSNumber*)width{
    static CGFloat padding = 10.0;
    
    UIFont *systemFont = [UIFont systemFontOfSize:[fontSize floatValue]];
    CGSize textSize = CGSizeMake([width floatValue], CGFLOAT_MAX);
    
    //        CGSize sizeWithFont = [text sizeWithFont:systemFont constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];//ios7开始禁用
    
    CGRect rectToFit = [text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: systemFont} context:nil];
    
#if defined(__LP64__) && __LP64__
    return ceil(rectToFit.size.height) + padding;
#else
    return ceilf(rectToFit.size.height) + padding;
#endif
}

- (BOOL)inputShouldNumber:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

@end
