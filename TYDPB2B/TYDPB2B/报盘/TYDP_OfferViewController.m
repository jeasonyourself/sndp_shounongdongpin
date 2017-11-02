//
//  TYDP_OfferViewController.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/18.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_OfferViewController.h"
#import "OfferRightViewCell.h"
#import "TYDPManager+Filter.h"
#import "FilterModel.h"
#import "TopCategoryModel.h"
#import "FilterSiteListModel.h"
#import "FilterSiteBrandListModel.h"
#import "FilterSellListModel.h"
#import "FilterCatDataBigModel.h"
#import "FilterCatDataSmallModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TYDP_ShopListViewController.h"
#import "ZYTabBar.h"

@interface TYDP_OfferViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    NSInteger leftTag;
}
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UIButton *leftIndicatorButton;
@property(nonatomic, strong)UILabel *leftIndicatorLable;

@property(nonatomic, strong)NSArray *leftViewPicArray;
@property(nonatomic, strong)NSArray *leftViewSelectPicArray;
@property(nonatomic, strong)NSArray *leftTitleArray;

@property(nonatomic, strong)NSArray *rightFirstListArray;
@property(nonatomic, strong)UITableView *rightTableView;
@property(nonatomic, strong)UILabel *rightTopLabel;
@property(nonatomic, strong)UIButton *rightTopButton;
@property(nonatomic, assign)BOOL isOpen;
@property(nonatomic, strong)NSIndexPath* selectedIndex;
@property(nonatomic, strong)NSMutableArray *tmpArray;
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)NSMutableArray *saveFlagArray;
@property(nonatomic, strong)NSMutableArray *saveFlagStateArray;
@property(nonatomic, assign)NSInteger firstFrontSelectedRowNumber;
@property(nonatomic, assign)NSInteger secondFrontSelectedRowNumber;
@property(nonatomic, copy)NSString *judgeCellString;
@property(nonatomic, strong)NSMutableArray *otherCellSaveFlagArray;
@property(nonatomic, strong)NSMutableArray *otherCellSaveFlagStateArray;
@property(nonatomic, strong)UITableView *rightSmallTableView;
@property(nonatomic, strong)MBProgressHUD *MBHUD;
@property(nonatomic, strong) FilterModel *totalFilterMD;
@property(nonatomic, strong)NSMutableArray *leftCategoryArray;
@property(nonatomic, strong)NSMutableArray *siteBrandArray;
@property(nonatomic, strong)NSMutableArray *siteListArray;
@property(nonatomic, strong)NSMutableArray *catDataBigArray;
@property(nonatomic, strong)NSMutableArray *sellListArray;
@property(nonatomic, strong)NSMutableArray *goodsLocalListArray;
@property(nonatomic, strong)NSMutableArray *rightSecondListArray;
@property(nonatomic, strong)NSMutableArray *rightSecondAgencyArray;
@property(nonatomic, strong)NSMutableDictionary *totalCellSaveFlagDic;
@property(nonatomic, assign)NSInteger leftFrontSelectedRowNumber;
@property(nonatomic, strong)NSMutableDictionary *TotalExpandCellSaveFlagDic;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic,strong)UIButton *searchCancelButton;
@end
typedef enum {
    TopConfirmButtonMessage = 1,
    BottomConfirmButtonMessage,
    SearchCancelButtonMessage
}BUTTONMESSAGE;

@implementation TYDP_OfferViewController
-(NSArray *)leftViewPicArray {
    if (!_leftViewPicArray) {
        _leftViewPicArray = [NSArray arrayWithObjects:@"leftbar_pig",@"leftbar_cow",@"leftbar_sheep",@"leftbar_chicken",@"leftbar_fish",@"leftbar_more",nil];
    }
    return _leftViewPicArray;
}
-(NSArray *)leftViewSelectPicArray {
    if (!_leftViewSelectPicArray) {
        _leftViewSelectPicArray = [NSArray arrayWithObjects:@"leftbar_pig_pre",@"leftbar_cow_pre",@"leftbar_sheep_pre",@"leftbar_chicken_pre",@"leftbar_fish_pre",@"leftbar_more_pre", nil];
    }
    return _leftViewSelectPicArray;
}

-(NSArray *)leftTitleArray {
    if (!_leftTitleArray) {
        _leftTitleArray = [NSArray arrayWithObjects:NSLocalizedString(@"Pork",nil),NSLocalizedString(@"Beef",nil),NSLocalizedString(@"Lamb",nil),NSLocalizedString(@"Poultry",nil),NSLocalizedString(@"Seafoods",nil),NSLocalizedString(@"Other",nil), nil];
    }
    return _leftTitleArray;
}

//-(NSArray *)leftViewPicArray {
//    if (!_leftViewPicArray) {
//        _leftViewPicArray = [NSArray arrayWithObjects:@"leftbar_pig",@"leftbar_cow",@"leftbar_sheep",@"leftbar_chicken",@"leftbar_fish",@"leftbar_more",nil];
//    }
//    return _leftViewPicArray;
//}
//-(NSArray *)leftViewSelectPicArray {
//    if (!_leftViewSelectPicArray) {
//        _leftViewSelectPicArray = [NSArray arrayWithObjects:@"leftbar_pig_pre",@"leftbar_cow_pre",@"leftbar_sheep_pre",@"leftbar_chicken_pre",@"leftbar_fish_pre",@"leftbar_more_pre", nil];
//    }
//    return _leftViewSelectPicArray;
//}


- (NSArray *)rightFirstListArray {
    if (!_rightFirstListArray) {
        _rightFirstListArray = [NSArray arrayWithObjects:NSLocalizedString(@"Origin", nil),NSLocalizedString(@"Plant No.", nil),NSLocalizedString(@"Product", nil),NSLocalizedString(@"Port", nil),NSLocalizedString(@"Offer type", nil),[NSString stringWithFormat:@"%@/%@/%@",NSLocalizedString(@"SpotToBe", nil),NSLocalizedString(@"Future", nil),NSLocalizedString(@"Spot", nil)],NSLocalizedString(@"Location", nil),NSLocalizedString(@"Estimated time of arrival", nil),[NSString stringWithFormat:@"%@/%@",NSLocalizedString(@"FCL", nil),NSLocalizedString(@"Retail", nil)], nil];
//        _rightFirstListArray = [NSArray arrayWithObjects:@"产地",@"厂号",@"产品",@"港口",@"报盘类型",@"准/期／现货",@"所在地",@"预计到港时间",@"整柜/零售", nil];
    }
    return _rightFirstListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationUI];
    // Do any additional setup after loading the view.
}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // 当为根控制器时，手势不执行。
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}
- (void)getFilterDataWithIndex:(NSString *)index{
    //    _otherCellSaveFlagArray[_firstFrontSelectedRowNumber] = _otherCellSaveFlagStateArray;
    //存储上一次点击左边按钮后的筛选状态
    //    if (_leftFrontSelectedRowNumber == 0) {
    //        _leftFrontSelectedRowNumber = 1;
    //    }
    _leftFrontSelectedRowNumber = [index integerValue];
    //    NSLog(@"leftrowNumber:%lu",_leftFrontSelectedRowNumber);
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"goods",@"get_category",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"get_category",@"sign":[TYDPManager md5:Sign],@"model":@"goods",@"id":index};
    [TYDPManager GetFilterInfo:[TYDPManager addCommomParam:params] success:^(FilterModel *totalFilterInfo) {
        [_MBHUD hide:YES];
        _totalFilterMD=totalFilterInfo;
        //左边第一分类
        _leftCategoryArray = [NSMutableArray arrayWithArray:totalFilterInfo.top_category];
        //产地
        _siteListArray = [NSMutableArray arrayWithArray:totalFilterInfo.site_list];
        //厂号
        _siteBrandArray = [NSMutableArray arrayWithArray:totalFilterInfo.brand_list];
        //产品
        _catDataBigArray = [NSMutableArray arrayWithArray:totalFilterInfo.cat_data];
        //港口
        _sellListArray = [NSMutableArray arrayWithArray:totalFilterInfo.sel_list];
        
        //所在地
        _goodsLocalListArray=[NSMutableArray arrayWithArray:totalFilterInfo.goods_local];
        
        _rightSecondListArray = [NSMutableArray arrayWithObjects:_siteListArray,_siteBrandArray,_catDataBigArray,_sellListArray,@[@{/*报盘类型*/@"id":@"1",@"name":@"CIF"},@{@"id":@"2",@"name":@"FOB"},@{@"id":@"3",@"name":@"DDP"},@{@"id":@"34",@"name":@"CFR"}],/*准、期、现货*/@[@{@"id":@"6",@"name":NSLocalizedString(@"Future",nil)},@{@"id":@"7",@"name":NSLocalizedString(@"Spot",nil)},@{@"id":@"8",@"name":NSLocalizedString(@"SpotToBe",nil)}],/*所在地*/_goodsLocalListArray,/*到港时间*/@[@{@"id":@"1",@"name":@"15天"},@{@"id":@"2",@"name":@"30天"},@{@"id":@"3",@"name":@"60天"},@{@"id":@"4",@"name":@"90天"}],/*整柜、零售*/@[@{@"sell_type":@"5",@"name":NSLocalizedString(@"FCL",nil)},@{@"sell_type":@"4",@"name":NSLocalizedString(@"Retail",nil)}], nil];
        [self resetRightUIDataWithFlag:@"clickRightButton"];
        [self refreshOtherCellState];
        //        NSLog(@"WY:%@",[_otherCellSaveFlagArray firstObject]);
        [self refreshSiteListData];
        [self createRightUI];
    } failure:^(TYDPError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)refreshOtherCellState{
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i = 0; i < _rightSecondListArray.count; i++) {
        NSMutableArray*smallArray = [NSMutableArray array];
        NSArray *flagArray = [NSArray arrayWithArray:_rightSecondListArray[i]];
        for (int i = 0; i < flagArray.count; i++) {
            [smallArray addObject:@"0"];
        }
        [tmpArray addObject:smallArray];
    }
    _otherCellSaveFlagArray = [NSMutableArray arrayWithArray:tmpArray];
}
#pragma mark 配置界面UI
- (void)configurationUI{
    [self setUpNavigationBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
    [self createLeftUI];
}
#pragma mark 设置导航栏
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    _navigationBarView.backgroundColor=mainColor;
    [self.view addSubview:_navigationBarView];
//    //设置渐变效果
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.borderWidth = 0;
//    gradientLayer.frame = _navigationBarView.frame;
//    gradientLayer.colors = [NSArray arrayWithObjects:(id)[RGBACOLOR(69, 135, 231, 1) CGColor],(id)[RGBACOLOR(55, 181, 213, 1) CGColor],nil];
//    gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:1.0],nil];
//    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
//    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
//    [_navigationBarView.layer insertSublayer:gradientLayer atIndex:0];
    UILabel *navigationLabel = [UILabel new];
    [navigationLabel setText:NSLocalizedString(@"Filter",nil)];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setTextColor:[UIColor whiteColor]];
    [_navigationBarView addSubview:navigationLabel];
    [navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap/2);
        make.width.mas_equalTo(NavHeight);
        make.height.mas_equalTo(NavHeight/2);
    }];
}
#pragma mark 设置左侧滑动UI
- (void)createLeftUI {
    UIScrollView *leftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth/OfferViewCommonMultiple, ScreenHeight - NavHeight - TabbarHeight)];
    leftScrollView.showsHorizontalScrollIndicator=NO;
    leftScrollView.showsVerticalScrollIndicator=NO;

    [self.view addSubview:leftScrollView];
    UIView *leftContainerView = [UIView new];
    [leftScrollView addSubview:leftContainerView];
    [leftContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(leftScrollView);
        make.width.equalTo(leftScrollView);
    }];
    CGFloat smallViewWidth = leftScrollView.frame.size.width;
    CGFloat smallViewHeight = leftScrollView.frame.size.height/5;
    CGFloat smallViewBordWidth = 0.7;
    for (int i = 0; i < 6; i++) {
        UIView *leftSmallView = [[UIView alloc] initWithFrame:CGRectMake(-smallViewBordWidth, (smallViewHeight-smallViewBordWidth)*i, smallViewWidth, smallViewHeight)];
        leftSmallView.layer.borderColor = [RGBACOLOR(205, 205, 205, 0.7)  CGColor];
        leftSmallView.layer.borderWidth = smallViewBordWidth;
        [leftSmallView setBackgroundColor:[UIColor whiteColor]];
        [leftScrollView addSubview:leftSmallView];
        if (i == 5) {
            [leftContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(leftSmallView);
            }];
        }
        UIImageView *circleImageView = [UIImageView new];
        [leftSmallView addSubview:circleImageView];
        CGFloat circleImageWidth = smallViewWidth/OfferLeftViewSmallCircelMultiple;
        [circleImageView setImage:[UIImage imageNamed:self.leftViewPicArray[i]]];
        [circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(leftSmallView);
            make.centerY.equalTo(leftSmallView);
            make.width.mas_equalTo(circleImageWidth);
            make.height.mas_equalTo(circleImageWidth);
        }];
                UILabel *introduceLabel = [UILabel new];
//                [introduceLabel setBackgroundColor:[UIColor greenColor]];
                [leftSmallView addSubview:introduceLabel];
                [introduceLabel setText:self.leftTitleArray[i]];
                [introduceLabel setTextColor:[UIColor grayColor]];
                [introduceLabel setFont:ThemeFont(13.0)];
                [introduceLabel setTextAlignment:NSTextAlignmentCenter];
                [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(leftSmallView);
                    make.top.equalTo(circleImageView.mas_bottom);
                    make.width.mas_equalTo(leftSmallView);
                    make.height.mas_equalTo(CommonHeight);
                }];
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
        [leftSmallView addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i + 1;
        if (i == 0) {
            leftTag=1;
            [self setLeftIndicatorButtonVisible:leftSmallView];
        }
    }
    _TotalExpandCellSaveFlagDic = [NSMutableDictionary dictionary];
    _saveFlagArray = [NSMutableArray array];
    _saveFlagStateArray = [NSMutableArray array];
    _otherCellSaveFlagArray = [NSMutableArray array];
    _rightSecondAgencyArray = [NSMutableArray array];
    _totalCellSaveFlagDic = [NSMutableDictionary dictionary];
    _otherCellSaveFlagStateArray = [NSMutableArray array];
    [self getFilterDataWithIndex:@"1"];
}
- (void)tapMethod:(UITapGestureRecognizer *)tap {
    UIView *tmpView = [tap view];
    leftTag=tmpView.tag;
    [self setLeftIndicatorButtonVisible:tmpView];
}
- (void)setLeftIndicatorButtonVisible:(UIView *)superView {
    _MBHUD = [[MBProgressHUD alloc] init];
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [self.view addSubview:_MBHUD];
    [_MBHUD show:YES];
    if (!_leftIndicatorButton) {
        _leftIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftIndicatorButton setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
        [_leftIndicatorButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [superView addSubview:_leftIndicatorButton];
    [_leftIndicatorButton setImage:[UIImage imageNamed:self.leftViewSelectPicArray[superView.tag-1]] forState:UIControlStateNormal];
    [_leftIndicatorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    
    if (!_leftIndicatorLable) {
        _leftIndicatorLable = [[UILabel alloc] init];
    }
    [_leftIndicatorLable setTextColor:mainColor];
    _leftIndicatorLable.textAlignment=NSTextAlignmentCenter;
    _leftIndicatorLable.font=[UIFont systemFontOfSize:13];
    _leftIndicatorLable.text= self.leftTitleArray[superView.tag-1];

    [_leftIndicatorButton addSubview:_leftIndicatorLable];
    debugLog(@"superViewframe:%ld",superView.tag);
    [_leftIndicatorLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.top.mas_equalTo(superView.frame.size.width/OfferLeftViewSmallCircelMultiple/2+superView.center.y);
        make.width.mas_equalTo(superView);
        make.height.mas_equalTo(CommonHeight);
    }];
    debugLog(@"superView1111:%@",NSStringFromCGRect(_leftIndicatorLable.frame));

    
    
    TopCategoryModel *categoryModel = _leftCategoryArray[superView.tag-1];
    NSLog(@"%@ %@\n",categoryModel.cat_name,categoryModel.cat_id);
    if (categoryModel.cat_id != nil) {
        [self getFilterDataWithIndex:categoryModel.cat_id];
    }
}
- (void)refreshExpandCellState{
    [_saveFlagArray removeAllObjects];
    for (FilterCatDataBigModel *model in _catDataBigArray) {
        NSMutableArray *smallArray = [NSMutableArray array];
        for (int i = 0; i < model.cat_list.count; i++) {
            [smallArray addObject:@"0"];
        }
        [_saveFlagArray addObject:smallArray];
    }
    [self resetRightUIDataWithFlag:nil];
}

- (void)resetRightUIDataWithFlag:(NSString *)flagString {
    if ([flagString isEqualToString:@"clickRightButton"]) {
        if (_otherCellSaveFlagStateArray.count) {
            _otherCellSaveFlagArray[_firstFrontSelectedRowNumber] = _otherCellSaveFlagStateArray;
        }
    }
    [_rightTableView removeFromSuperview];
    //消除上一次点击事件对此次展示cell的影响
    _isOpen = NO;
    //给一级表视图添加筛选状态
    for (int i = 0; i < _rightSmallTableView.visibleCells.count; i++) {
        UITableViewCell *cell = _rightSmallTableView.visibleCells[i];
        for (UILabel *tmpLabel in cell.contentView.subviews) {
            if ([tmpLabel.text isEqualToString:NSLocalizedString(@"Selected",nil)]) {
                if (i == 2&&_saveFlagArray.count) {
                    //筛选产品
                    int flag = 0;
                    //检查用户是否有过筛选的动作
                    for (NSMutableArray *tmpArray in _saveFlagArray) {
                        for (NSString *tmpString in tmpArray) {
                            if ([tmpString intValue]%2 > 0) {
                                //只要有一次这样的情况发生就结束循环
                                flag = 1;
                                break;
                            }
                        }
                    }
                    if (flag) {
                        tmpLabel.hidden = NO;
                    }else {
                        tmpLabel.hidden = YES;
                    }
                    
                }//产品
                else if(_otherCellSaveFlagArray.count){
                    //筛选其它
                    int flag = 0;
                    //检查用户是否有过筛选的动作
                    for (NSString *tmpString in _otherCellSaveFlagArray[i]) {
                        if ([tmpString intValue]%2 > 0) {
                            //只要有一次这样的情况发生就结束循环
                            flag = 1;
                            break;
                        }
                    }
                    if (flag) {
                        tmpLabel.hidden = NO;
                    } else {
                        tmpLabel.hidden = YES;
                    }
                }
            }
        }
    }
}
- (void)buttonClicked:(UIButton *)button {
    
    if (button.tag/100==1)
    {
        if (button.tag%100==0) {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
            [self resetRightUIDataWithFlag:@"clickRightButton"];
            [self refreshSiteListData];
        }
        else
        {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
            [self resetRightUIDataWithFlag:@"clickRightButton"];

        }
    }
    else
    {
    switch (button.tag) {
               case BottomConfirmButtonMessage:{
            //找出筛选状态
            NSMutableDictionary *filterDic = [NSMutableDictionary dictionaryWithDictionary:[self lastFilterState]];
//            NSLog(@"filterDic:%@",filterDic);
            if ([[filterDic allKeys] count] != 0) {
                //检查用户是否有过筛选的动作
                TYDP_ShopListViewController *shopListViewCon = [[TYDP_ShopListViewController alloc] init];
                shopListViewCon.sign_MSandTJ = NO;
                shopListViewCon.HomePageFlag=6;
                debugLog(@"filterDicfilterDic:%@",filterDic);
                shopListViewCon.filterDic = [NSMutableDictionary dictionaryWithDictionary:filterDic];
                [self.navigationController pushViewController:shopListViewCon animated:YES];
                [self refreshOtherCellState];
                [self refreshExpandCellState];
            } else {
                [_MBHUD setLabelText:@"亲，没有筛选条件哦。。。"];
                [self.view addSubview:_MBHUD];
                [_MBHUD show:YES];
                [_MBHUD hide:YES afterDelay:1.0f];
            }
            break;
        }
        case SearchCancelButtonMessage:
        {
            [_searchBar resignFirstResponder];
            [_searchCancelButton removeFromSuperview];
            break;
        }
        default:
            break;
    }
    }
}
- (NSMutableDictionary *)lastFilterState{
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
    switch (leftTag) {
        case 1:
            tmpDic[@"cat_id"]=@"1";
            break;
        case 2:
            tmpDic[@"cat_id"]=@"2";
            break;
        case 3:
            tmpDic[@"cat_id"]=@"3";
            break;
        case 4:
            tmpDic[@"cat_id"]=@"289";
            break;
        case 5:
            tmpDic[@"cat_id"]=@"5";
            break;
        case 6:
            tmpDic[@"cat_id"]=@"290";
            break;
            
        default:
            break;
    }
    
    for (int i = 0; i < _rightFirstListArray.count; i++) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        NSArray *tmpStateArray = [NSArray arrayWithArray:_otherCellSaveFlagArray[i]];
        //产地筛选
        if (i == 0) {
            //检查用户是否有过筛选的动作
            for (int j = 0; j < tmpStateArray.count; j++) {
                if ([tmpStateArray[j] intValue]%2 != 0) {
                    FilterSiteListModel *model = _rightSecondListArray[i][j];
                    [tmpArray addObject:model];
                }
            }
            if (tmpArray.count) {
                NSMutableString *tmpString = [NSMutableString new];
                for (FilterSiteListModel *model in tmpArray) {
                    if (tmpString.length==0) {
                        [tmpString appendString:[NSString stringWithFormat:@"%@",model.id]];
                    }
                    else
                    {
                    [tmpString appendString:[NSString stringWithFormat:@"%@,",model.id]];
                    }
                }
                [tmpDic setObject:tmpString forKey:@"region_ids"];
            }
        }
        else if (i == 1)
        {//厂号筛选
            for (int j = 0; j < tmpStateArray.count; j++) {
                if ([tmpStateArray[j] intValue]%2 != 0) {
                    FilterSiteBrandListModel *model = _rightSecondListArray[i][j];
                    [tmpArray addObject:model];
                }
            }
            if (tmpArray.count) {
                NSMutableString *tmpString = [NSMutableString new];
                for (FilterSiteBrandListModel *model in tmpArray) {
                    if (tmpString.length==0) {
                        [tmpString appendString:[NSString stringWithFormat:@"%@",model.brand_id]];
                    }
                    else
                    {
                    [tmpString appendString:[NSString stringWithFormat:@"%@,",model.brand_id]];
                    }
                }
                [tmpDic setObject:tmpString forKey:@"brand_ids"];
            }
        }
        else if (i == 2) {//产品筛选
            for (int j = 0; j < [_rightSecondListArray[2] count]; j++) {
                FilterCatDataBigModel *bigModel = _rightSecondListArray[2][j];
                NSArray  *smallModelArray = bigModel.cat_list;
                NSArray *smallSaveFlagArray = _saveFlagArray[j];
                for (int k = 0; k < smallSaveFlagArray.count; k++) {
                    if ([smallSaveFlagArray[k] intValue]%2 != 0) {
                        FilterCatDataSmallModel *model = smallModelArray[k];
                        [tmpArray addObject:model];
                    }
                }
            }
            if (tmpArray.count) {
                NSMutableString *tmpString = [NSMutableString new];
                for (FilterCatDataSmallModel *model in tmpArray) {
                    if (tmpString.length==0) {
                        [tmpString appendString:[NSString stringWithFormat:@"%@",model.goods_id]];
                    }else
                    {
                    [tmpString appendString:[NSString stringWithFormat:@"%@,",model.goods_id]];
                    }
                }
                [tmpDic setObject:tmpString forKey:@"base_ids"];
            }
        }
        else if (i == 3) {//港口筛选
            for (int j = 0; j < tmpStateArray.count; j++) {
                if ([tmpStateArray[j] intValue]%2 != 0) {
                    FilterSellListModel *model = _rightSecondListArray[i][j];
                    [tmpArray addObject:model];
                }
            }
            if (tmpArray.count) {
                NSMutableString *tmpString = [NSMutableString new];
                for (FilterSellListModel *model in tmpArray) {
                    if (tmpString.length==0) {
                        [tmpString appendString:[NSString stringWithFormat:@"%@",model.id]];
                    }
                    else
                    {
                    [tmpString appendString:[NSString stringWithFormat:@"%@,",model.id]];
                    }
                }
                [tmpDic setObject:tmpString forKey:@"ports"];
            }
        }
        else if (i == 4) {//报盘类型
            for (int j = 0; j < tmpStateArray.count; j++) {
                if ([tmpStateArray[j] intValue]%2 != 0) {
                    NSDictionary *model = _rightSecondListArray[i][j];
                    [tmpArray addObject:model];
                }
            }
            if (tmpArray.count) {
                NSMutableString *tmpString = [NSMutableString new];
                for (NSDictionary *model in tmpArray) {
                    if (tmpString.length==0) {
                        [tmpString appendString:[NSString stringWithFormat:@"%@",model[@"id"]]];
                    }
                    else
                    {
                    [tmpString appendString:[NSString stringWithFormat:@"%@,",model[@"id"]]];
                    }
                }
                [tmpDic setObject:tmpString forKey:@"offer_types"];
            }

        }
        else if (i == 5) {//期现货
            for (int j = 0; j < tmpStateArray.count; j++) {
                if ([tmpStateArray[j] intValue]%2 != 0) {
                    NSDictionary *model = _rightSecondListArray[i][j];
                    [tmpArray addObject:model];
                }
            }
            if (tmpArray.count) {
                NSMutableString *tmpString = [NSMutableString new];
                for (NSDictionary *model in tmpArray) {
                    if (tmpString.length==0) {
                        [tmpString appendString:[NSString stringWithFormat:@"%@",model[@"id"]]];
                    }
                    else
                    {
                    [tmpString appendString:[NSString stringWithFormat:@"%@,",model[@"id"]]];
                    }
                }
                [tmpDic setObject:tmpString forKey:@"goods_types"];
            }
        }
        else if (i == 6) {//所在地
            //检查用户是否有过筛选的动作
            for (int j = 0; j < tmpStateArray.count; j++) {
                if ([tmpStateArray[j] intValue]%2 != 0) {
                    NSString *local_address = _rightSecondListArray[i][j];
                    [tmpArray addObject:local_address];
                }
            }
            if (tmpArray.count) {
                NSMutableString *tmpString = [NSMutableString new];
                for (NSString *model in tmpArray) {
                    if (tmpString.length==0) {
                        [tmpString appendString:[NSString stringWithFormat:@"%@",model]];
                    }
                    else
                    {
                    [tmpString appendString:[NSString stringWithFormat:@"%@,",model]];
                    }
                }
                [tmpDic setObject:tmpString forKey:@"goods_local"];
            }
        }

        else if (i == 7) {//预计到岗时间
            for (int j = 0; j < tmpStateArray.count; j++) {
                if ([tmpStateArray[j] intValue]%2 != 0) {
                    NSDictionary *model = _rightSecondListArray[i][j];
                    [tmpArray addObject:model];
                }
            }
            if (tmpArray.count) {
                NSMutableString *tmpString = [NSMutableString new];
                for (NSDictionary *model in tmpArray) {
                    if (tmpString.length==0) {
                        [tmpString appendString:[NSString stringWithFormat:@"%@",model[@"id"]]];
                    }
                    else
                    {
                    [tmpString appendString:[NSString stringWithFormat:@"%@,",model[@"id"]]];
                    }
                }
                [tmpDic setObject:tmpString forKey:@"arrive_date_types"];
            }
        }
        else if (i == 8) {//整柜、零售
            for (int j = 0; j < tmpStateArray.count; j++) {
                if ([tmpStateArray[j] intValue]%2 != 0) {
                    NSDictionary *model = _rightSecondListArray[i][j];
                    [tmpArray addObject:model];
                }
            }
            if (tmpArray.count) {
                NSMutableString *tmpString = [NSMutableString new];
                for (NSDictionary *model in tmpArray) {
                    if (tmpString.length==0) {
                        [tmpString appendString:[NSString stringWithFormat:@"%@",model[@"sell_type"]]];
                    }
                    else
                    {
                    [tmpString appendString:[NSString stringWithFormat:@"%@,",model[@"sell_type"]]];
                    }
                }
                [tmpDic setObject:tmpString forKey:@"sell_type"];
            }
        }

    }
    return tmpDic;
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
        TYDP_ShopListViewController *shopListViewCon = [[TYDP_ShopListViewController alloc] init];
        shopListViewCon.sign_MSandTJ = NO;

        shopListViewCon.filterDic = [NSMutableDictionary dictionaryWithDictionary:filterDic];
        [self.navigationController pushViewController:shopListViewCon animated:YES];
        _searchBar.text = @"";
        [_searchBar resignFirstResponder];
        [_searchCancelButton removeFromSuperview];
    }
}
- (void)createRightUI {
    if (!_rightSmallTableView) {
        UIView *topView = [UIView new];
        [topView setBackgroundColor:[UIColor whiteColor]];
        topView.clipsToBounds = YES;
        topView.layer.cornerRadius = 5;
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_navigationBarView.mas_bottom).with.offset(MiddleGap);
            make.left.equalTo(self.view).with.offset(ScreenWidth/OfferViewCommonMultiple + Gap);
            make.right.equalTo(self.view).with.offset(-Gap);
            make.height.mas_equalTo(CommonSearchViewHeight);
        }];

        _searchBar = [[UISearchBar alloc] init];
        [topView addSubview:_searchBar];
        _searchBar.returnKeyType=UIReturnKeySearch;
        _searchBar.delegate = self;
        [_searchBar setSearchBarStyle:UISearchBarStyleDefault];
        _searchBar.placeholder = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Factory number / Product name / Origin", nil)];
        [_searchBar setBackgroundColor:[UIColor whiteColor]];
        _searchBar.showsCancelButton = NO;
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView).with.offset(10);
            make.top.equalTo(topView.mas_top).with.offset(0);
            make.height.mas_equalTo(CommonSearchViewHeight);
            make.right.equalTo(topView).with.offset(-10);
            //        make.edges.equalTo(_searchView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _searchBar.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
        _searchBar.layer.borderWidth = 0;
        _searchBar.clipsToBounds = YES;
        _searchBar.layer.cornerRadius = CommonSearchViewHeight/2;
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
                    [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Factory number / Product name / Origin",nil)]
                                                                                        attributes:@{NSForegroundColorAttributeName:color}]];
                    //                //修改默认的放大镜图片
                    //                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
                    //                imageView.backgroundColor = [UIColor clearColor];
                    //                imageView.image = [UIImage imageNamed:@"gww_search_ misplaces"];
                    //                textField.leftView = imageView;
                }
            }
        }

        
        UIButton *rightBottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightBottomButton setBackgroundColor:mainColor];
        [rightBottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBottomButton setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Confirm",nil)] forState:UIControlStateNormal];
        rightBottomButton.tag = BottomConfirmButtonMessage;
        [rightBottomButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        rightBottomButton.clipsToBounds = YES;
        rightBottomButton.layer.cornerRadius = 5;
        [rightBottomButton.titleLabel setFont:ThemeFont(17)];
        [self.view addSubview:rightBottomButton];
        [rightBottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(-TabbarHeight - MiddleGap);
            make.right.equalTo(topView);
            make.left.equalTo(topView);
            make.height.mas_equalTo(CommonHeight*2);
        }];
        
        _rightSmallTableView = [[UITableView alloc] init];
        [self.view addSubview:_rightSmallTableView];
        [_rightSmallTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).with.offset(MiddleGap);
            make.right.equalTo(topView);
            make.left.equalTo(topView);
            make.bottom.equalTo(rightBottomButton.mas_top).with.offset(-2*MiddleGap);
        }];
        _rightSmallTableView.clipsToBounds = YES;
        _rightSmallTableView.layer.cornerRadius = 5;
        _rightSmallTableView.dataSource = self;
        _rightSmallTableView.delegate = self;
        
    }
    _searchCancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _searchCancelButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [_searchCancelButton setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    _searchCancelButton.alpha = 0.3;
    _searchCancelButton.tag = SearchCancelButtonMessage;
    [_searchCancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshExpandCellState];
    //    NSLog(@"_otherCellSaveFlagArray:%@",[_otherCellSaveFlagArray firstObject]);
    //    NSLog(@"%@",_rightSmallTableView.visibleCells);
    //创建存储处了产品cell外的其它cell的筛选状态数组
    //    for (int i = 0; i < _rightSecondListArray.count; i++) {
    //        NSMutableArray*smallArray = [NSMutableArray array];
    //        NSArray *flagArray = [NSArray arrayWithArray:_rightSecondListArray[i]];
    //        for (int i = 0; i < flagArray.count; i++) {
    //            [smallArray addObject:@"0"];
    //        }
    //        [_otherCellSaveFlagArray addObject:smallArray];
    //}
}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        return _rightSecondAgencyArray.count;
    }
    return self.rightFirstListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _rightTableView) {
        OfferRightViewCell *cell = [OfferRightViewCell cellWithTableView:tableView];
//        [cell.mainImageView setImage:[UIImage imageNamed:@"offer_line_blue"]];
        [cell.nameLabel setTextColor:[UIColor lightGrayColor]];
        if ([_judgeCellString isEqualToString:@"expandCell"]) {
            FilterCatDataBigModel *model = _rightSecondAgencyArray[indexPath.row];
            [cell.nameLabel setText:[NSString stringWithFormat:@"%@",model.cat_name]];
            [cell.indicateImageView setImage:[UIImage imageNamed:@"offer_icon_down_n"]];
            if (indexPath.row == _selectedIndex.row) {
                if (_isOpen == YES) {
                    NSLog(@"WY:展开");
                    [cell.nameLabel setTextColor:mainColor];
                    [cell.indicateImageView setImage:[UIImage imageNamed:@"offer_icon_down_n"]];
                    cell.containerView.hidden = NO;
                    _containerView = [UIView new];
                    [_containerView setBackgroundColor:[UIColor whiteColor]];
                    [cell.containerView addSubview:_containerView];
                    [self createSmallButtonWithNumbers:_tmpArray.count];
                    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(cell.containerView);
                    }];
                } else {
                    NSLog(@"WY:收起");
                    cell.containerView.hidden = YES;
                    [_containerView removeFromSuperview];
                }
            } else {
            }
        }
        else {
            //除产品cell外其它cell的处理过程
            NSString *agencyString = [[NSString alloc] init];
            switch (_firstFrontSelectedRowNumber){
                case 0:{
                    FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                    break;
                }
                case 1:{
                    FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                    break;
                }
                case 3:{
                    FilterSellListModel *model =_rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                case 4:{
                    NSDictionary *dic = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",dic[@"name"]];
                    break;
                }
                case 5:{
                    NSDictionary *dic = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",dic[@"name"]];
                    break;
                }
                case 6:{
                    NSString  *address = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",address];
                    break;
                }
                case 7:{
                    NSDictionary *dic = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",dic[@"name"]];
                    break;
                }
                case 8:{
                    NSDictionary *dic = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",dic[@"name"]];
                    break;
                }
                default:
                    break;
            }
            //其它cell
            [cell.nameLabel setText:[NSString stringWithFormat:@"%@",agencyString]];
            [cell.nameLabel setTextColor:[UIColor lightGrayColor]];
            UIImage *selectedImage = [UIImage imageNamed:@"offer_icon_right"];
            [cell.indicateImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).with.offset(-MiddleGap);
                make.centerY.mas_equalTo(cell.contentView);
                make.width.mas_equalTo(selectedImage.size.width);
                make.height.mas_equalTo(selectedImage.size.height);
            }];
            //判断是否为选中状态 奇数为选中 偶数为未选中
            debugLog(@"_otherCellSaveFlagStateArraycount:%lu",_otherCellSaveFlagStateArray.count);
            
            if (_otherCellSaveFlagStateArray.count) {
                if ([_otherCellSaveFlagStateArray[indexPath.row] intValue]%2) {
                    [cell.indicateImageView setImage:selectedImage];
                } else {
                    [cell.indicateImageView setImage:nil];
                }
                cell.containerView.hidden = YES;
            }
        }
        return cell;
    }
    else{
        static NSString *ident = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
        if (!cell) {
            cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            //消除text重复显示
            NSInteger flag = 0;
            for (UILabel *tmpLabel in cell.contentView.subviews) {
                if ([tmpLabel.text isEqualToString:NSLocalizedString(@"Selected",nil)]) {
                    flag = 1;
                }
            }
            if (!flag) {
                UILabel *indicatorLabel = [UILabel new];
                [indicatorLabel setTextColor:[UIColor redColor]];
                [indicatorLabel setText:NSLocalizedString(@"Selected",nil)];
                [indicatorLabel setFont:ThemeFont(16)];
                [indicatorLabel setTextAlignment:NSTextAlignmentRight];
                [cell.contentView addSubview:indicatorLabel];
                [indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.right.equalTo(cell.contentView);
                    make.width.mas_equalTo(70);
                    make.height.mas_equalTo(25);
                }];
                indicatorLabel.hidden = YES;
            }
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",self.rightFirstListArray[indexPath.row]]];
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
}
- (void)createSmallButtonWithNumbers:(NSInteger)numbers {
    CGFloat smallButtonWidth = (ScreenWidth - ScreenWidth/OfferViewCommonMultiple - 2*Gap-Gap)/3 ;
    CGFloat smallButtonHeight = 50;
    for (int i = 0; i < numbers; i++) {
        FilterCatDataSmallModel *model = _tmpArray[i];
        UIButton *smallButton = [UIButton buttonWithType:UIButtonTypeCustom];
        smallButton.tag = i+1;
        [_containerView addSubview:smallButton];
        smallButton.frame = CGRectMake(Gap+smallButtonWidth*(i%3), smallButtonHeight*(i/3), smallButtonWidth-Gap, smallButtonHeight-Gap);
//        [smallButton setBackgroundImage:[UIImage imageNamed:@"offer_webcheckbox_n"] forState:UIControlStateNormal];
        [smallButton setTitle:[NSString stringWithFormat:@"%@",model.goods_name] forState:UIControlStateNormal];
        [smallButton.titleLabel setFont:ThemeFont(14)];
        smallButton.titleLabel.numberOfLines = 0;
        [smallButton addTarget:self action:@selector(smallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [smallButton setTitleColor:RGBACOLOR(85, 85, 85, 1) forState:UIControlStateNormal];
    }
}
- (void)smallButtonClicked:(UIButton*)button {
    int flag = [_saveFlagStateArray[button.tag-1] intValue];
    flag++;
    _saveFlagStateArray[button.tag - 1] = [NSString stringWithFormat:@"%d",flag];
    for (UIButton *button in _containerView.subviews) {
        //判断是否为选中状态 奇数为选中 偶数为未选中
        if ([_saveFlagStateArray[button.tag - 1] intValue]%2) {
            button.layer.cornerRadius = 0;//设置那个圆角的有多圆
            button.layer.borderWidth =2;//设置边框的宽度，当然可以不要
            button.layer.borderColor = [mainColor CGColor];//设置边框的颜色
            button.layer.masksToBounds = YES;//设为NO去试试
//            [button setBackgroundImage:[UIImage imageNamed:@"offer_webcheckbox_s"] forState:UIControlStateNormal];
        } else {
            button.layer.cornerRadius = 0;//设置那个圆角的有多圆
            button.layer.borderWidth =2;//设置边框的宽度，当然可以不要
            button.layer.borderColor = [[UIColor lightGrayColor] CGColor];//设置边框的颜色
            button.layer.masksToBounds = YES;//设为NO去试试
//            [button setBackgroundImage:[UIImage imageNamed:@"offer_webcheckbox_n"] forState:UIControlStateNormal];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _rightTableView) {
        if (indexPath == _selectedIndex) {
            if (indexPath.row == _selectedIndex.row && _selectedIndex != nil) {
                if (_isOpen == YES) {
                    //调整伸展后cell的高度
                    NSInteger tmpAngencyInteger = 0;
                    if (_tmpArray.count/3.0 > _tmpArray.count/3) {
                        tmpAngencyInteger = _tmpArray.count/3+1;
                    } else {
                        tmpAngencyInteger = _tmpArray.count/3;
                    }
                    return 50*(tmpAngencyInteger+1);
                } else {
                    return 50;
                }
            } else {
            }
        } else {
            return 50;
        }
        return 50;
    }
    return tableView.frame.size.height/8.9;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _rightTableView) {
        if ([_judgeCellString isEqualToString:@"expandCell"]) {
            FilterCatDataBigModel* tmpFilterCatDataBigModel = _rightSecondAgencyArray[indexPath.row];
            NSArray *tmpFilterCatDataSmallModelArray = tmpFilterCatDataBigModel.cat_list;
            _tmpArray = [NSMutableArray arrayWithArray:tmpFilterCatDataSmallModelArray];
            //记录上一次点击的cell
            _secondFrontSelectedRowNumber = indexPath.row;
            //记录cell里button点击事件
            _saveFlagStateArray = _saveFlagArray[indexPath.row];
            //将上一次cell里的button点击事件保存到saveFlagArray数组里
            _saveFlagArray[_secondFrontSelectedRowNumber] = _saveFlagStateArray;
            //将索引添加到数组中
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            //判断选中不同row状态时候
            if (indexPath.row == _selectedIndex.row) {
                indexPaths = [NSArray arrayWithObjects: indexPath,_selectedIndex, nil];
                _isOpen = !_isOpen;
            }else if(indexPath.row != _selectedIndex.row) {
                indexPaths = [NSArray arrayWithObjects:indexPath, _selectedIndex, nil];
                _isOpen = YES;
                [_containerView removeFromSuperview];
            }
            _selectedIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            for (UIButton *button in _containerView.subviews) {
                if ([_saveFlagStateArray[button.tag-1] intValue]%2) {
                    button.layer.cornerRadius = 0;//设置那个圆角的有多圆
                    button.layer.borderWidth =2;//设置边框的宽度，当然可以不要
                    button.layer.borderColor = [mainColor CGColor];//设置边框的颜色
                    button.layer.masksToBounds = YES;//设为NO去试试
//                    [button setBackgroundImage:[UIImage imageNamed:@"offer_webcheckbox_s"] forState:UIControlStateNormal];
                } else {
                    button.layer.cornerRadius = 0;//设置那个圆角的有多圆
                    button.layer.borderWidth =2;//设置边框的宽度，当然可以不要
                    button.layer.borderColor = [[UIColor lightGrayColor] CGColor];//设置边框的颜色
                    button.layer.masksToBounds = YES;//设为NO去试试
//                    [button setBackgroundImage:[UIImage imageNamed:@"offer_webcheckbox_n"] forState:UIControlStateNormal];
                }
            }
        }
        else {
            //处理其它cell的点击事件
//            int flag = [_otherCellSaveFlagStateArray[indexPath.row] intValue];
//            flag=1;
            for (int i = 0 ; i<_otherCellSaveFlagStateArray.count; i++) {
                if (i==indexPath.row) {
                    if ([_otherCellSaveFlagStateArray[indexPath.row] isEqualToString:@"0"]) {
                        _otherCellSaveFlagStateArray[indexPath.row] = [NSString stringWithFormat:@"1"];
                    }
                    else{
                    _otherCellSaveFlagStateArray[indexPath.row] = [NSString stringWithFormat:@"0"];
                    }
                    
                }
                else
                {
                _otherCellSaveFlagStateArray[i] = [NSString stringWithFormat:@"0"];
                }
            }
            [tableView reloadData];
//            _otherCellSaveFlagStateArray[indexPath.row] = [NSString stringWithFormat:@"%d",flag];
//            UIImage *selectedImage = [UIImage imageNamed:@"offer_icon_right"];
//            OfferRightViewCell *cell = [_rightTableView cellForRowAtIndexPath:indexPath];
//            if ([_otherCellSaveFlagStateArray[indexPath.row] intValue]%2) {
//                [cell.indicateImageView setImage:selectedImage];
//            } else {
//                [cell.indicateImageView setImage:nil];
//            }
            //            for (int i = 0; i < _rightTableView.visibleCells.count; i++) {
            //                OfferRightViewCell *cell = _rightTableView.visibleCells[i];
            //                //判断是否为选中状态 奇数为选中 偶数为未选中
            //                if ([_otherCellSaveFlagStateArray[i] intValue]%2) {
            //                    NSLog(@"数字状态:%d",[_otherCellSaveFlagStateArray[i] intValue]);
            //                    NSLog(@"被选中啦");
            //                    [cell.indicateImageView setImage:selectedImage];
            //                } else {
            //                    NSLog(@"没有被选中");
            //                    [cell.indicateImageView setImage:nil];
            //                }
            //            }
        }
    }
    else {
        
            _rightTableView = [UITableView new];
            //清除上次伸展序列的影响
            _selectedIndex = nil;
            [_rightTableView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
            [self.view addSubview:_rightTableView];
            [_rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tableView);
                make.left.equalTo(tableView);
                make.right.equalTo(tableView);
                make.bottom.equalTo(self.view).with.offset(-TabbarHeight-MiddleGap);
            }];
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
            [topView setBackgroundColor:mainColor];
            _rightTopLabel = [UILabel new];
            [_rightTopLabel setTextColor:[UIColor whiteColor]];
            [topView addSubview:_rightTopLabel];
            [_rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(topView);
                make.left.equalTo(topView).with.offset(Gap);
                make.width.mas_equalTo(topView.frame.size.width/2);
                make.height.mas_equalTo(CommonHeight);
            }];
            _rightTableView.tableHeaderView = topView;
            _rightTableView.tableFooterView = [UIView new];
            _rightTableView.dataSource = self;
            _rightTableView.delegate = self;
            _rightTopButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [topView addSubview:_rightTopButton];
            [_rightTopButton setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Confirm",nil)] forState:UIControlStateNormal];
            [_rightTopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _rightTopButton.tag = TopConfirmButtonMessage*100+indexPath.row;
            [_rightTopButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [topView addSubview:_rightTopButton];
            [_rightTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(topView);
                make.right.equalTo(topView).with.offset(-Gap);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(CommonHeight);
            }];
            [self createRightTableViewWithCategory:self.rightFirstListArray[indexPath.row]];
            //只有产品界面可以伸展cell
            if (indexPath.row == 2) {
                _judgeCellString = [NSString stringWithFormat:@"expandCell"];
            } else {
                //点击一级表视图的其它cell
                _judgeCellString = [NSString stringWithFormat:@"otherCell"];
            }
            _firstFrontSelectedRowNumber = indexPath.row;
            _otherCellSaveFlagStateArray = [NSMutableArray arrayWithArray:_otherCellSaveFlagArray[indexPath.row]];
            //将每一级的数据传入下一级界面
            _rightSecondAgencyArray = _rightSecondListArray[indexPath.row];
            debugLog(@"_rightSecondAgencyArray_rightSecondAgencyArray:%lu",_rightSecondAgencyArray.count);
            //以上为一级表视图的cell的点击触发事件
        
        
       
    }
}
- (void)refreshSiteListData {
    [self.view addSubview:_MBHUD];
    [_MBHUD show:YES];
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSArray *tmpSiteListModelArray = [NSArray arrayWithArray:[_otherCellSaveFlagArray firstObject]];
    
    //检查用户是否有过筛选的动作
    for (int i = 0; i < tmpSiteListModelArray.count; i++) {
        if ([tmpSiteListModelArray[i] intValue]%2 != 0) {
            FilterSiteListModel *model = [_rightSecondListArray firstObject][i];
            [tmpArray addObject:model];
        }
    }
    //                for (NSString *tmpString in [_otherCellSaveFlagArray firstObject]) {
    //                    if ([tmpString intValue]%2 != 0) {
    //                        //在厂商列表里面寻找对应id的model 如果找到则加到tmpArray中以待筛选
    //                        for (FilterSiteListModel *model in [_rightSecondListArray firstObject]) {
    //                            if ([tmpString isEqualToString: model.id]) {
    //                                [tmpArray addObject:model];
    //                            }
    //                        }
    //                    }
    //                }
    //如果用户有筛选行为
    if (tmpArray.count) {
     
        NSMutableString *tmpString = [NSMutableString new];
        
        for (FilterSiteListModel *model in tmpArray) {
            [tmpString appendString:[NSString stringWithFormat:@"%@,",model.id]];
        }
        //                    NSLog(@"tmpString:%@",tmpString);
        NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"goods",@"get_brand",ConfigNetAppKey];
        NSDictionary *params = @{@"action":@"get_brand",@"sign":[TYDPManager md5:Sign],@"model":@"goods",@"region_id":tmpString};
        [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
            debugLog(@"rightSecondListArray:%@",data);
            if (![data[@"error"] intValue]) {
                [_MBHUD hide:YES];
                //_rightSecondListArray数组第二个元素是厂商列表数组
                //                            NSLog(@"%@",data[@"content"]);
                NSArray *arr = [FilterSiteBrandListModel arrayOfModelsFromDictionaries:data[@"content"] error:nil];
                [_rightSecondListArray replaceObjectAtIndex:1 withObject:arr];
            
                //把之前的厂号筛选状态清空
                        NSMutableArray *smallTmpArray = [NSMutableArray array];
                        for (int i = 0; i < [arr count]; i++) {
                            [smallTmpArray addObject:@"0"];
                        }
                        _otherCellSaveFlagArray[1] = smallTmpArray;
                [self resetRightUIDataWithFlag:@"clickRightButton"];
                NSLog(@"counnnnt：%lu",[(NSMutableArray*)_rightSecondListArray[1] count]);
            }
        } failure:^(TYDPError *error) {
            NSLog(@"%@",error);
        }];
    } else {
        [_MBHUD hide:YES];
        _rightSecondListArray[1] = _siteBrandArray;
    }
}
- (void)createRightTableViewWithCategory:(NSString *)CategoryString{
    [_rightTopLabel setText:CategoryString];
}
/**
 *  重写navigationBar所以把原生的隐藏
 *
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=NO;
    [MobClick beginLogPageView:@"筛选一级界面"];
}

- (void)viewDidAppear:(BOOL)animated {

ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
myBar.plusBtn.hidden=NO;
self.tabBarController.tabBar.hidden = NO;
}
    
- (void)viewWillDisappear:(BOOL)animated {
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=YES;
    self.tabBarController.tabBar.hidden = YES;

    [MobClick endLogPageView:@"筛选一级界面"];
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
