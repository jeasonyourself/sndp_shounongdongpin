//
//  TYDP_OfferDetailViewController.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/21.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_OfferDetailViewController.h"
#import "TYDP_FactoryDetailViewController.h"
#import "TYDP_HistoryOfferViewController.h"
#import "TYDP_ConfirmOrderViewController.h"
#import "OfferDetailModel.h"
#import "OfferHistoryModel.h"
#import "OfferModel.h"
#import "PicListModel.h"
#import "TYDP_VendorController.h"
#import "TYDP_LoginController.h"
#import "goodsBaseModel.h"
#import "goodsDetailModel.h"
#import "TTTAttributedLabel.h"
#import "TYDP_offerIntroViewController.h"
#import <UShareUI/UShareUI.h>
#import "OfferHistoryModel.h"

@interface TYDP_OfferDetailViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UIScrollView *baseScrollView;
@property(nonatomic, strong)NSArray *middleListArray;
@property(nonatomic, strong)NSArray *testDataArray;
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)UIView *blackView;
@property(nonatomic, strong)UIButton *factoryDeatilButton;
@property(nonatomic, strong)UIButton *historyOfferButton;
@property(nonatomic, strong)UIButton *offerButton;
@property(nonatomic, strong)UIButton *orderButton;
@property(nonatomic, strong)UIView *offerShowView;
@property(nonatomic, strong)UITextField *offerTextField;
@property(nonatomic, strong)UITextField *liuyanTextField;

@property(nonatomic, strong)UIButton *cancelButton;
@property(nonatomic, strong)UIView *orderShowView;
@property(nonatomic, strong)UITextField *orderTextField;
@property(nonatomic, strong)UIButton *orderReduceButton;
@property(nonatomic, strong)UIButton *orderPlusButton;
@property(nonatomic, strong)UIScrollView *fullScreenShowScrollView;
@property(nonatomic, strong)MBProgressHUD *MBHUD;
@property(nonatomic, strong)OfferDetailModel *offerDetailModel;
@property(nonatomic, strong)NSArray *offerModelArray;
@property(nonatomic, strong)UIScrollView *smallScrollView;
@property(nonatomic, strong)UIView *smallContainerView;
@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UILabel *bottomPriceLabel;
@property(nonatomic, strong)NSMutableArray *picListArray;
@property(nonatomic, strong)UIScrollView *bannerScrollView;

@end
typedef enum {
    FactoryDetailButtonMessage = 1,
    HistoryOfferButtonMessage,
    OfferButtonMessage,
    OrderButtonMessage,
    BigCancelMessage,
    SmallOfferButtonCancelMessage,
    SmallOrderButtonCancelMessage,
    OrderPlusButtonMessage,
    OrderReduceButtonMessage
}BUTTONMESSAGE;

@implementation TYDP_OfferDetailViewController
-(NSArray *)middleListArray {
    if (!_middleListArray) {
        if ([[NSString stringWithFormat:@"%@",_offerDetailModel.goods_type] isEqualToString:@"7"])//现货
        {
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"4"])//零售
            {
                _middleListArray = [NSArray arrayWithObjects:NSLocalizedString(@"Serial Number", nil),NSLocalizedString(@"Country", nil),NSLocalizedString(@"Plant No.", nil),NSLocalizedString(@"Specification", nil),NSLocalizedString(@"Stock", nil),NSLocalizedString(@"Packing specification", nil),NSLocalizedString(@"Date of Manufacture", nil),NSLocalizedString(@"Prepayment Rules", nil),NSLocalizedString(@"Container Location", nil),NSLocalizedString(@"Edit time", nil), nil];

//             _middleListArray = [NSArray arrayWithObjects:@"编       号：",@"国       家：",@"厂       号：",@"规       格：",@"库       存：",@"包装规格：",@"生产日期：",@"预付条约：",@"货物地址：",@"编辑时间：", nil];
            }
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"5"]) {
                
                 _middleListArray = [NSArray arrayWithObjects:NSLocalizedString(@"Serial Number", nil),NSLocalizedString(@"Country", nil),NSLocalizedString(@"Plant No.", nil),NSLocalizedString(@"Stock", nil),NSLocalizedString(@"Packing specification", nil),NSLocalizedString(@"Prepayment Rules", nil),NSLocalizedString(@"Container Location", nil),NSLocalizedString(@"Edit time", nil), nil];
                _middleListArray = [NSArray arrayWithObjects:NSLocalizedString(@"Serial Number",nil),NSLocalizedString(@"Country",nil),NSLocalizedString(@"Plant No.",nil),NSLocalizedString(@"Stock",nil),NSLocalizedString(@"Packing specification",nil),NSLocalizedString(@"Prepayment Rules",nil),NSLocalizedString(@"Container Location",nil),NSLocalizedString(@"Edit time",nil), nil];
            }
        }
        if ([[NSString stringWithFormat:@"%@",_offerDetailModel.goods_type] isEqualToString:@"6"])//期货
        {
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"4"])//零售
            {
                _middleListArray = [NSArray arrayWithObjects:NSLocalizedString(@"Serial Number", nil),NSLocalizedString(@"Country", nil),NSLocalizedString(@"Plant No.", nil),NSLocalizedString(@"Specification", nil),NSLocalizedString(@"Stock", nil),NSLocalizedString(@"Packing specification", nil),NSLocalizedString(@"Date of Manufacture", nil),NSLocalizedString(@"Prepayment Rules", nil),NSLocalizedString(@"Edit time", nil),NSLocalizedString(@"Port", nil),NSLocalizedString(@"Estimated time of arrival", nil),NSLocalizedString(@"date of shipment", nil),NSLocalizedString(@"Offer type", nil), nil];
//             _middleListArray = [NSArray arrayWithObjects:NSLocalizedString(@"Serial Number", nil),@"国       家：",@"厂       号：",@"规       格：",@"库       存：",@"包装规格：",@"生产日期：",@"预付条约：",@"编辑时间：",@"港       口：",@"预计到港：",@"装船日期：",@"报盘类型：", nil];
            }
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"5"])//整柜
            {
                
                 _middleListArray = [NSArray arrayWithObjects:NSLocalizedString(@"Serial Number", nil),NSLocalizedString(@"Country", nil),NSLocalizedString(@"Plant No.", nil),NSLocalizedString(@"Stock", nil),NSLocalizedString(@"Packing specification", nil),NSLocalizedString(@"Prepayment Rules", nil),NSLocalizedString(@"Edit time", nil),NSLocalizedString(@"Port", nil),NSLocalizedString(@"Estimated time of arrival", nil),NSLocalizedString(@"date of shipment", nil),NSLocalizedString(@"Offer type", nil), nil];
//                _middleListArray = [NSArray arrayWithObjects:@"编       号：",@"国       家：",@"厂       号：",@"库       存：",@"包装规格：",@"预付条约：",@"编辑时间：",@"港       口：",@"预计到港：",@"装船日期：",@"报盘类型：", nil];
            }
        }
       
    }
    return _middleListArray;
}
-(NSArray *)testDataArray {
    if (!_testDataArray) {
        if ([[NSString stringWithFormat:@"%@",_offerDetailModel.goods_type] isEqualToString:@"7"]) {
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"4"])//零售
            {
        _testDataArray = [NSArray arrayWithObjects:@"12345",@"德国",@"DE202",@"25吨／柜",@"3柜",@"定装",@"2016-07-18",@"30%",@"北京",@"2016-07-18", nil];
            }
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"5"])//整柜
            {
                 _testDataArray = [NSArray arrayWithObjects:@"12345",@"德国",@"DE202",@"3柜",@"定装",@"30%",@"北京",@"2016-07-18", nil];
            }
        }
        if ([[NSString stringWithFormat:@"%@",_offerDetailModel.goods_type] isEqualToString:@"6"]) {
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"4"])//零售
            {
            _testDataArray = [NSArray arrayWithObjects:@"12345",@"德国",@"DE202",@"25吨／柜",@"3柜",@"定装",@"30%",@"2016-07-18",@"上海",@"2016-07-18",@"2016-07-18",@"CFR", nil];
            }
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"4"])//整柜
            {
                 _testDataArray = [NSArray arrayWithObjects:@"12345",@"德国",@"DE202",@"3柜",@"定装",@"2016-07-18",@"30%",@"2016-07-18",@"上海",@"2016-07-18",@"2016-07-18",@"CFR", nil];
            }
        }
    }
    return _testDataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _picListArray=[[NSMutableArray alloc] init];
    [self.view setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
    [self setUpNavigationBar];
    // Do any additional setup after loading the view.
}
- (void)getOfferDetailData {
    _MBHUD = [[MBProgressHUD alloc] init];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    [self.view addSubview:_MBHUD];
    [_MBHUD show:YES];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"goods",@"get_info",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"get_info",@"sign":[TYDPManager md5:Sign],@"model":@"goods",@"goods_id":_goods_id};
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        NSLog(@"detailData:%@",data);
        if ([data[@"error"] intValue]==404) {
            [_MBHUD show:YES];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window Message:@"商品已下架" HiddenAfterDelay:1.5];
            [self leftItemClicked:nil];
        }
        
        if (![data[@"error"] intValue]) {
            _offerDetailModel = [[OfferDetailModel alloc] initWithDictionary:data[@"content"] error:nil];
            [_picListArray removeAllObjects];
            [_picListArray addObject:_offerDetailModel.goods_thumb];
            for (PicListModel *PicListMD in _offerDetailModel.picture_list) {
                [_picListArray addObject:PicListMD.thumb_url];

            }
            NSLog(@"_offerDetailModel:%@",_offerDetailModel);
            [self createWholeUI];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD show:YES];
        NSLog(@"%@",error);
    }];
}
- (void)createWholeUI{
    [_MBHUD hide:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight-TabbarHeight)];
    [self.view addSubview:_baseScrollView];
    _containerView = [UIView new];
    [_baseScrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_baseScrollView);
        make.width.equalTo(_baseScrollView);
    }];
    [self createTopUI];
}
#pragma mark 设置导航栏
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    [self.view addSubview:_navigationBarView];
    _navigationBarView.backgroundColor=mainColor;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationBarView addSubview:backButton];
    UIImage *backButtonImage = [UIImage imageNamed:@"navi_return_btn_nor"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 0)];
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
    [navigationLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Offer information", nil)]];
    [navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(25);
    }];
    [self getOfferDetailData];
}
- (void)addedTopViewTap:(UITapGestureRecognizer *)tap {
    if (_offerDetailModel.shop_id) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        if ([userDefaults objectForKey:@"user_id"]) {//已登陆
            TYDP_VendorController *vendorCon = [[TYDP_VendorController alloc] init];
            vendorCon.shopId = _offerDetailModel.shop_id;
            [self.navigationController pushViewController:vendorCon animated:YES];

        }
        else {//尚未登陆状态
            TYDP_LoginController *loginViewCon = [[TYDP_LoginController alloc] init];
            [self.navigationController pushViewController:loginViewCon animated:YES];
        }

            } else {
        [_MBHUD setLabelText:@"暂无厂商信息～"];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        [_MBHUD hide:YES afterDelay:1.5f];
    }
}
- (void)addTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoScroll:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)autoScroll:(NSTimer *)timer {
    [_bannerScrollView setContentOffset:CGPointMake(_bannerScrollView.contentOffset.x+ScreenWidth,0) animated:YES];
    CGPoint temp = _bannerScrollView.contentOffset;
    temp.x = -ScreenWidth;
    NSInteger tmpNumber = _picListArray.count-1;
    if (_bannerScrollView.contentOffset.x >= (ScreenWidth*tmpNumber)) {
        _bannerScrollView.contentOffset = temp;
    }
    
}

- (void)createTopUI {
    UIView *topView = [UIView new];
    [topView setBackgroundColor:[UIColor whiteColor]];
    topView.clipsToBounds = YES;
    topView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(0);
        make.top.equalTo(_baseScrollView).with.offset(0);
        make.right.equalTo(_baseScrollView).with.offset(0);
        make.height.mas_equalTo(ScreenWidth/2.0+80.0);
    }];

    
#pragma mark 设置顶部滚动视图
    _bannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2.0)];
    _bannerScrollView.delegate = self;
    _bannerScrollView.contentSize = CGSizeMake(ScreenWidth*_picListArray.count,0);
    _bannerScrollView.showsHorizontalScrollIndicator = YES;
    _bannerScrollView.pagingEnabled = YES;
    [topView addSubview:_bannerScrollView];
    //使图片滑动的时候过渡更自然
    NSString *firstSlideModel;
    NSString *lastSlideModel;
    UIImageView *firstImageView;
    UIImageView *lastImageView;
    debugLog(@"_picListArray_picListArray:%@",_picListArray);
        firstSlideModel = [_picListArray lastObject];
        lastSlideModel = [_picListArray firstObject];
        firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-ScreenWidth, 0, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
        [firstImageView sd_setImageWithURL:[NSURL URLWithString:firstSlideModel] placeholderImage:nil];
    firstImageView.contentMode=   UIViewContentModeScaleAspectFit;
        [_bannerScrollView addSubview:firstImageView];
        lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*_picListArray.count, 0, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
        [lastImageView sd_setImageWithURL:[NSURL URLWithString:lastSlideModel] placeholderImage:nil];
    lastImageView.contentMode=   UIViewContentModeScaleAspectFit;
        [_bannerScrollView addSubview:lastImageView];
        
         for (int i = 0 ; i < _picListArray.count; i++) {
         NSString *tmpModel = _picListArray[i];
         UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
             tmpImageView.contentMode=   UIViewContentModeScaleAspectFit;
         [tmpImageView sd_setImageWithURL:[NSURL URLWithString:tmpModel] placeholderImage:nil];
         [_bannerScrollView addSubview:tmpImageView];
         }
         [self addTimer];
        

    
   
#pragma mark 名称时间
    UIView *bottomCellView = [UIView new];
    [_baseScrollView addSubview:bottomCellView];
    [bottomCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bannerScrollView.mas_bottom).with.offset(0);
        make.left.equalTo(_baseScrollView);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(80.0);
    }];

    UILabel *nameLabel = [UILabel new];
    [nameLabel setText:[NSString stringWithFormat:@"%@",_offerDetailModel.goods_name]];
    [nameLabel setFont:ThemeFont(14)];
    [nameLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [bottomCellView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomCellView.mas_left).with.offset(20);
        make.top.equalTo(bottomCellView.mas_top).with.offset(0);
//                    make.width.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.hidden=YES;
    [timeLabel setText:[NSString stringWithFormat:@"%@",_offerDetailModel.make_date]];
    [timeLabel setFont:ThemeFont(14)];
    [timeLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
    [bottomCellView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).with.offset(20);
        make.top.equalTo(nameLabel.mas_top).with.offset(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    UIImageView *smallRightFirstImageView = [UIImageView new];
    UIImageView *smallRightSecondImageView = [UIImageView new];
    UIImageView *smallRightThirdImageView = [UIImageView new];
    UIImageView *smallRightFouthImageView = [UIImageView new];
    NSString *firstImageViewString;
    switch ([_offerDetailModel.goods_type intValue]) {
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
    switch ([_offerDetailModel.sell_type intValue]) {
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
    if ([_offerDetailModel.offer isEqualToString:@"11"]) {
        [smallRightThirdImageView setImage:[UIImage imageNamed:NSLocalizedString(@"pic_bargaining_en",nil)]];
        if ([_offerDetailModel.is_pin isEqualToString:@"1"]) {
            [smallRightFouthImageView setImage:[UIImage imageNamed:NSLocalizedString(@"pic_lcl_en",nil)]];
        }
    } else {
        if ([_offerDetailModel.is_pin isEqualToString:@"1"]) {
            [smallRightThirdImageView setImage:[UIImage imageNamed:NSLocalizedString(@"pic_lcl_en",nil)]];
        }
    }
    [bottomCellView addSubview:smallRightFirstImageView];
    [bottomCellView addSubview:smallRightSecondImageView];
    [bottomCellView addSubview:smallRightThirdImageView];
    [bottomCellView addSubview:smallRightFouthImageView];
    [smallRightFirstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomCellView).with.offset(-Gap);
        make.centerY.equalTo(timeLabel);
        make.width.mas_equalTo(CommonHeight);
        make.height.mas_equalTo(CommonHeight);
    }];
    [smallRightSecondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(smallRightFirstImageView.mas_left).with.offset(-5);
        make.centerY.equalTo(timeLabel);
        make.width.mas_equalTo(CommonHeight);
        make.height.mas_equalTo(CommonHeight);
    }];
    [smallRightThirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(smallRightSecondImageView.mas_left).with.offset(-5);
        make.centerY.equalTo(timeLabel);
        make.width.mas_equalTo(CommonHeight);
        make.height.mas_equalTo(CommonHeight);
    }];
    [smallRightFouthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(smallRightThirdImageView.mas_left).with.offset(-5);
        make.centerY.equalTo(timeLabel);
        make.width.mas_equalTo(CommonHeight);
        make.height.mas_equalTo(CommonHeight);
    }];


//    UILabel *bottomDecorateLabel = [UILabel new];
//    [bottomDecorateLabel setFont:ThemeFont(13)];
//    [bottomDecorateLabel setBackgroundColor:RGBACOLOR(122, 122, 122, 0.7)];
//    [bottomCellView addSubview:bottomDecorateLabel];
//    [bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(bottomCellView.mas_left).with.offset(Gap);
//        make.right.equalTo(bottomCellView.mas_right).with.offset(-Gap);
//        make.top.equalTo(timeLabel.mas_bottom);
//        make.height.mas_equalTo(HomePageBordWidth);
//    }];
    
    
    UILabel *PriceLabel = [UILabel new];
    [PriceLabel setText:[NSString stringWithFormat:@"%@",_offerDetailModel.formated_shop_price]];
    [PriceLabel setFont:ThemeFont(14)];
    [PriceLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [bottomCellView addSubview:PriceLabel];
    [PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomCellView.mas_left).with.offset(20);
        make.top.equalTo(timeLabel.mas_bottom).with.offset(0);
        //            make.width.mas_equalTo(bottomCellHeight);
        make.height.mas_equalTo(40);
    }];
    UILabel *MeasureLabel = [UILabel new];
    [MeasureLabel setText:[NSString stringWithFormat:@"/%@",_offerDetailModel.shop_price_unit]];
    [MeasureLabel setFont:ThemeFont(14)];
    [MeasureLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
    [bottomCellView addSubview:MeasureLabel];
    [MeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(PriceLabel.mas_right);
        make.top.equalTo(timeLabel.mas_bottom).with.offset(0);
        //            make.width.mas_equalTo(bottomCellHeight/2);
        make.height.mas_equalTo(40);
    }];

    
//    UILabel *bottomOriginLabel = [UILabel new];
//    [bottomOriginLabel setText:[NSString stringWithFormat:@"%@",_offerDetailModel.goods_lcoal]];
//    [bottomOriginLabel setTextAlignment:NSTextAlignmentRight];
//    [bottomOriginLabel setFont:ThemeFont(13)];
//    [bottomOriginLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
//    [bottomCellView addSubview:bottomOriginLabel];
//    [bottomOriginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(bottomCellView);
//        make.right.equalTo(bottomCellView).with.offset(-Gap);
//        make.height.mas_equalTo(40);
//    }];
    
    UILabel *bottomAmountLabel = [UILabel new];
    [bottomAmountLabel setFont:ThemeFont(14)];
    [bottomAmountLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
    bottomAmountLabel.text=NSLocalizedString(@"Offer introduction", nil);
    bottomAmountLabel.textAlignment=NSTextAlignmentRight;
    bottomAmountLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *bottomAmountLabelViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomAmountLabelViewTap:)];
    [bottomAmountLabel addGestureRecognizer:bottomAmountLabelViewTap];
    [bottomCellView addSubview:bottomAmountLabel];
    [bottomAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomCellView).with.offset(-Gap);;
        make.right.equalTo(bottomCellView).with.offset(-Gap);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(CommonHeight);
    }];
    
    [self createMiddleUI:topView];
}
- (void)show:(UITapGestureRecognizer *)tap
{
    if (_picListArray.count) {
        NSMutableArray *picArray = [NSMutableArray array];
        UIView *tmpView = [tap view];
        for (PicListModel *picModel in _picListArray) {
            UIImageView *imageView = [UIImageView new];
            NSString *url = [picModel.thumb_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"no_pic"]];
            [picArray addObject:imageView.image];
        }
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:picArray currentIndex:tmpView.tag - 1];
        [broser show];
    }
}
- (void)createMiddleUI:(UIView *)frontView {
    UIView *middleView = [UIView new];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    middleView.clipsToBounds = YES;
    middleView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:middleView];
    UIImage *topDecorateImage = [UIImage imageNamed:@"offer_img_information"];
    NSInteger topDecorateImageHeight = 90*(topDecorateImage.size.height/topDecorateImage.size.width);
    NSInteger smallViewHeight = 50;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(Gap);
        make.top.equalTo(frontView.mas_bottom).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(-Gap);
        make.height.mas_equalTo(smallViewHeight*self.middleListArray.count+topDecorateImageHeight+5);
    }];
    
    UILabel *topleftSmallLabel = [UILabel new];
    [_baseScrollView addSubview:topleftSmallLabel];
    [topleftSmallLabel setText:NSLocalizedString(@"Spicification Parameter", nil)];
    [topleftSmallLabel setFont:ThemeFont(CommonFontSize+1)];
    [topleftSmallLabel setTextColor:[UIColor grayColor]];
    [topleftSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView).with.offset(-5);
        make.left.equalTo(middleView).with.offset(30);
        make.width.mas_equalTo(ScreenWidth-30);
        make.height.mas_equalTo(smallViewHeight);
    }];
    
    UILabel *redLineLabel3 = [UILabel new];
    [_baseScrollView addSubview:redLineLabel3];
    redLineLabel3.backgroundColor=mainColor;
    [redLineLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topleftSmallLabel.mas_left).with.offset(-5);
        make.centerY.equalTo(topleftSmallLabel).with.offset(0);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *topDecorateLabel = [UILabel new];
    [topDecorateLabel setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
    [middleView addSubview:topDecorateLabel];
    [topDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topleftSmallLabel.mas_bottom);
        make.left.equalTo(middleView);
        make.right.equalTo(middleView);
        make.height.mas_equalTo(1);
    }];
    for (int i = 0; i < self.middleListArray.count; i++) {
        UIView *smallView = [UIView new];
        [middleView addSubview:smallView];
        [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topDecorateLabel.mas_bottom).with.offset(smallViewHeight*i);;
            make.left.equalTo(middleView);
            make.right.equalTo(middleView);
            make.height.mas_equalTo(smallViewHeight);
        }];
        UILabel *smallBottomDecorateLabel = [UILabel new];
        [smallBottomDecorateLabel setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
        [smallView addSubview:smallBottomDecorateLabel];
        [smallBottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(smallView.mas_bottom);
            make.left.equalTo(middleView).with.offset(Gap);
            make.right.equalTo(middleView).with.offset(-Gap);
            make.height.mas_equalTo(1);
        }];
        UILabel *leftSmallLabel = [UILabel new];
        leftSmallLabel.numberOfLines=0;
        leftSmallLabel.lineBreakMode=NSLineBreakByTruncatingHead;

        [smallView addSubview:leftSmallLabel];
        [leftSmallLabel setText:self.middleListArray[i]];
        [leftSmallLabel setFont:ThemeFont(14)];
        [leftSmallLabel setTextColor:[UIColor grayColor]];
        [leftSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallView);
            make.left.equalTo(smallView).with.offset(30);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(smallViewHeight);
        }];
        UILabel *rightSmallLabel = [UILabel new];
        [smallView addSubview:rightSmallLabel];
        NSString *infoString = [NSString stringWithFormat:@"暂无"];
        if ([[NSString stringWithFormat:@"%@",_offerDetailModel.goods_type] isEqualToString:@"7"])//现货
        {
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"4"])//零售
            {
                switch (i) {
                    case 0:{
                        if (![_offerDetailModel.sku isEqualToString:@""]&&_offerDetailModel.sku) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.sku];
                        }
                        break;
                    }
                    case 1:{
                        if (![_offerDetailModel.region_name isEqualToString:@""]&&_offerDetailModel.region_name) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.region_name];
                        }
                        break;
                    }
                    case 2:{
                        if (![_offerDetailModel.brand_sn isEqualToString:@""]&&_offerDetailModel.brand_sn) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.brand_sn];
                        }
                        break;
                    }
                    case 3:{
                        if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                            if ((![_offerDetailModel.spec_1 isEqualToString:@""]&&_offerDetailModel.spec_1)||(![_offerDetailModel.spec_2 isEqualToString:@""]&&_offerDetailModel.spec_2)) {
                                infoString = [NSString stringWithFormat:@"%@%@      %@%@",_offerDetailModel.spec_1,_offerDetailModel.spec_1_unit,_offerDetailModel.spec_2,_offerDetailModel.spec_2_unit];
                            }
                        } else {
                            if (![_offerDetailModel.goods_weight isEqualToString:@""]&&_offerDetailModel.goods_weight) {
                                infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_weight,NSLocalizedString(@"MT/Ctn",nil)];
                            }
                        }
                        break;
                    }
                    case 4:{
                        if (![_offerDetailModel.goods_number isEqualToString:@""]&&_offerDetailModel.goods_number) {
                            if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                                infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_number,NSLocalizedString(@"pc",nil)];
                            }
                            else
                            {
                                infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_number,NSLocalizedString(@"Caninet",nil)];
                            }
                            
                        }

                        break;
                    }
                        
                    case 5:{
                        if (![_offerDetailModel.pack_name isEqualToString:@""]&&_offerDetailModel.pack_name) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.pack_name];
                        }
                        break;
                    }
                        //            case 8:{
                        //                if ([_offerDetailModel.offer_type isEqualToString:@"1"]) {
                        //                    infoString = [NSString stringWithFormat:@"CIF"];
                        //                } else if ([_offerDetailModel.offer_type isEqualToString:@"2"]) {
                        //                    infoString = [NSString stringWithFormat:@"FOB"];
                        //                } else if ([_offerDetailModel.offer_type isEqualToString:@"3"]) {
                        //                    infoString = [NSString stringWithFormat:@"DDP"];
                        //                }
                        //                break;
                        //            }
                        //            case 9:{
                        //                if (![_offerDetailModel.shop_price isEqualToString:@""]&&_offerDetailModel.shop_price) {
                        //                    infoString = [NSString stringWithFormat:@"¥%@/吨",_offerDetailModel.shop_price];
                        //                }
                        //                break;
                        //            }
                        //            case 10:{
                        //                if (![_offerDetailModel.formated_arrive_date isEqualToString:@""]&&_offerDetailModel.formated_arrive_date) {
                        //                    infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.formated_arrive_date];
                        //                }
                        //                break;
                        //            }
                    case 6:{
                        if (![_offerDetailModel.make_date isEqualToString:@""]&&_offerDetailModel.make_date) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.make_date];
                        }
                        break;
                    }
                    case 7:{
                        if (![_offerDetailModel.prepay_name isEqualToString:@""]&&_offerDetailModel.prepay_name) {
                            if ([_offerDetailModel.prepay_type isEqualToString:@"1"]) {
                                infoString = [NSString stringWithFormat:@"¥%@",_offerDetailModel.prepay_num];                                        } else {
                                    infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.prepay_name,@"%"];                    }
                        }
                        break;
                    }
                    case 8:{
                        if (![_offerDetailModel.goods_local isEqualToString:@""]&&_offerDetailModel.goods_local) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.goods_local];
                        }
                        break;
                    }
                    case 9:{
                        if (![_offerDetailModel.last_update isEqualToString:@""]&&_offerDetailModel.last_update) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.last_update];
                        }
                        break;
                    }
                        
                    default:
                        break;
                }
            }
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"5"])//整柜
            {
                switch (i) {
                    case 0:{
                        if (![_offerDetailModel.sku isEqualToString:@""]&&_offerDetailModel.sku) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.sku];
                        }
                        break;
                    }
                    case 1:{
                        if (![_offerDetailModel.region_name isEqualToString:@""]&&_offerDetailModel.region_name) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.region_name];
                        }
                        break;
                    }
                    case 2:{
                        if (![_offerDetailModel.brand_sn isEqualToString:@""]&&_offerDetailModel.brand_sn) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.brand_sn];
                        }
                        break;
                    }
                    
                    case 3:{
                        if (![_offerDetailModel.goods_number isEqualToString:@""]&&_offerDetailModel.goods_number) {
                            if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                                infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_number,NSLocalizedString(@"pc",nil)];
                            }
                            else
                            {
                            infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_number,NSLocalizedString(@"Caninet",nil)];
                            }
                            
                        }
                        break;
                    }
                        
                    case 4:{
                        if (![_offerDetailModel.pack_name isEqualToString:@""]&&_offerDetailModel.pack_name) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.pack_name];
                        }
                        break;
                    }
                        //            case 8:{
                        //                if ([_offerDetailModel.offer_type isEqualToString:@"1"]) {
                        //                    infoString = [NSString stringWithFormat:@"CIF"];
                        //                } else if ([_offerDetailModel.offer_type isEqualToString:@"2"]) {
                        //                    infoString = [NSString stringWithFormat:@"FOB"];
                        //                } else if ([_offerDetailModel.offer_type isEqualToString:@"3"]) {
                        //                    infoString = [NSString stringWithFormat:@"DDP"];
                        //                }
                        //                break;
                        //            }
                        //            case 9:{
                        //                if (![_offerDetailModel.shop_price isEqualToString:@""]&&_offerDetailModel.shop_price) {
                        //                    infoString = [NSString stringWithFormat:@"¥%@/吨",_offerDetailModel.shop_price];
                        //                }
                        //                break;
                        //            }
                        //            case 10:{
                        //                if (![_offerDetailModel.formated_arrive_date isEqualToString:@""]&&_offerDetailModel.formated_arrive_date) {
                        //                    infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.formated_arrive_date];
                        //                }
                        //                break;
                        //            }
                    
                    case 5:{
                        if (![_offerDetailModel.prepay_name isEqualToString:@""]&&_offerDetailModel.prepay_name) {
                            if ([_offerDetailModel.prepay_type isEqualToString:@"1"]) {
                                infoString = [NSString stringWithFormat:@"¥%@",_offerDetailModel.prepay_num];                                        } else {
                                    infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.prepay_name,@"%"];                    }
                        }
                        break;
                    }
                    case 6:{
                        if (![_offerDetailModel.goods_local isEqualToString:@""]&&_offerDetailModel.goods_local) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.goods_local];
                        }
                        break;
                    }
                    case 7:{
                        if (![_offerDetailModel.last_update isEqualToString:@""]&&_offerDetailModel.last_update) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.last_update];
                        }
                        break;
                    }
                        
                    default:
                        break;
                }
            }
        }
        if ([[NSString stringWithFormat:@"%@",_offerDetailModel.goods_type] isEqualToString:@"6"])//期货
        {
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"4"])//零售
            {
                switch (i) {
                    case 0:{
                        if (![_offerDetailModel.sku isEqualToString:@""]&&_offerDetailModel.sku) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.sku];
                        }
                        break;
                    }
                    case 1:{
                        if (![_offerDetailModel.region_name isEqualToString:@""]&&_offerDetailModel.region_name) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.region_name];
                        }
                        break;
                    }
                    case 2:{
                        if (![_offerDetailModel.brand_sn isEqualToString:@""]&&_offerDetailModel.brand_sn) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.brand_sn];
                        }
                        break;
                    }
                    case 3:{
                        if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                            if ((![_offerDetailModel.spec_1 isEqualToString:@""]&&_offerDetailModel.spec_1)||(![_offerDetailModel.spec_2 isEqualToString:@""]&&_offerDetailModel.spec_2)) {
                                infoString = [NSString stringWithFormat:@"%@%@      %@%@",_offerDetailModel.spec_1,_offerDetailModel.spec_1_unit,_offerDetailModel.spec_2,_offerDetailModel.spec_2_unit];
                            }
                        } else {
                            if (![_offerDetailModel.goods_weight isEqualToString:@""]&&_offerDetailModel.goods_weight) {
                                infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_weight,NSLocalizedString(@"MT/Ctn",nil)];
                            }
                        }
                        break;
                    }
                    case 4:{
                        if (![_offerDetailModel.goods_number isEqualToString:@""]&&_offerDetailModel.goods_number) {
                            if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                                infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_number,NSLocalizedString(@"pc",nil)];
                            }
                            else
                            {
                                infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_number,NSLocalizedString(@"Caninet",nil)];
                            }
                            
                        }
                        break;
                    }
                        
                    case 5:{
                        if (![_offerDetailModel.pack_name isEqualToString:@""]&&_offerDetailModel.pack_name) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.pack_name];
                        }
                        break;
                    }
                        //            case 8:{
                        //                if ([_offerDetailModel.offer_type isEqualToString:@"1"]) {
                        //                    infoString = [NSString stringWithFormat:@"CIF"];
                        //                } else if ([_offerDetailModel.offer_type isEqualToString:@"2"]) {
                        //                    infoString = [NSString stringWithFormat:@"FOB"];
                        //                } else if ([_offerDetailModel.offer_type isEqualToString:@"3"]) {
                        //                    infoString = [NSString stringWithFormat:@"DDP"];
                        //                }
                        //                break;
                        //            }
                        //            case 9:{
                        //                if (![_offerDetailModel.shop_price isEqualToString:@""]&&_offerDetailModel.shop_price) {
                        //                    infoString = [NSString stringWithFormat:@"¥%@/吨",_offerDetailModel.shop_price];
                        //                }
                        //                break;
                        //            }
                        //            case 10:{
                        //                if (![_offerDetailModel.formated_arrive_date isEqualToString:@""]&&_offerDetailModel.formated_arrive_date) {
                        //                    infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.formated_arrive_date];
                        //                }
                        //                break;
                        //            }
                    case 6:{
                        if (![_offerDetailModel.make_date isEqualToString:@""]&&_offerDetailModel.make_date) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.make_date];
                        }
                        break;
                    }
                    case 7:{
                        if (![_offerDetailModel.prepay_name isEqualToString:@""]&&_offerDetailModel.prepay_name) {
                            if ([_offerDetailModel.prepay_type isEqualToString:@"1"]) {
                                infoString = [NSString stringWithFormat:@"¥%@",_offerDetailModel.prepay_num];                                        } else {
                                    infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.prepay_name,@"%"];                    }
                        }
                        break;
                    }
                    case 8:{
                        if (![_offerDetailModel.last_update isEqualToString:@""]&&_offerDetailModel.last_update) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.last_update];
                        }
                        break;
                    }
                    case 9:{
                        if (![_offerDetailModel.port_name isEqualToString:@""]&&_offerDetailModel.port_name) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.port_name];
                        }
                        break;
                    }
                    case 10:{
                        if (![_offerDetailModel.formated_arrive_date isEqualToString:@""]&&_offerDetailModel.formated_arrive_date) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.formated_arrive_date];
                        }
                        break;
                    }
                    case 11:{
                        if (![_offerDetailModel.formated_lading_date isEqualToString:@""]&&_offerDetailModel.formated_lading_date) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.formated_lading_date];
                        }
                        break;
                    }
                    case 12:{
                        if (![_offerDetailModel.offer_type isEqualToString:@""]&&_offerDetailModel.offer_type) {
                            if ([_offerDetailModel.offer_type isEqualToString:@"1"]) {
                                infoString = [NSString stringWithFormat:@"CIF"];
                            }
                            if ([_offerDetailModel.offer_type isEqualToString:@"2"]) {
                                    infoString = [NSString stringWithFormat:@"FOB"];
                                }
                            
                            if ([_offerDetailModel.offer_type isEqualToString:@"3"]) {
                                        infoString = [NSString stringWithFormat:@"DDP"];
                                    }
                              if ([_offerDetailModel.offer_type isEqualToString:@"34"]) {
                                            infoString = [NSString stringWithFormat:@"CFR"];
                                        }
                        }
                        break;
                    }
                    default:
                        break;
                }

            }
            if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"5"])//整柜
            {
                switch (i) {
                    case 0:{
                        if (![_offerDetailModel.sku isEqualToString:@""]&&_offerDetailModel.sku) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.sku];
                        }
                        break;
                    }
                    case 1:{
                        if (![_offerDetailModel.region_name isEqualToString:@""]&&_offerDetailModel.region_name) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.region_name];
                        }
                        break;
                    }
                    case 2:{
                        if (![_offerDetailModel.brand_sn isEqualToString:@""]&&_offerDetailModel.brand_sn) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.brand_sn];
                        }
                        break;
                    }
                case 3:{
                    if (![_offerDetailModel.goods_number isEqualToString:@""]&&_offerDetailModel.goods_number) {
                        if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                            infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_number,NSLocalizedString(@"pc",nil)];
                        }
                        else
                        {
                            infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_number,NSLocalizedString(@"Caninet",nil)];
                        }
                        
                    }
                        break;
                    }
                        
                    case 4:{
                        if (![_offerDetailModel.pack_name isEqualToString:@""]&&_offerDetailModel.pack_name) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.pack_name];
                        }
                        break;
                    }

                    case 5:{
                        if (![_offerDetailModel.prepay_name isEqualToString:@""]&&_offerDetailModel.prepay_name) {
                            if ([_offerDetailModel.prepay_type isEqualToString:@"1"]) {
                                infoString = [NSString stringWithFormat:@"¥%@",_offerDetailModel.prepay_num];                                        } else {
                                    infoString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.prepay_name,@"%"];                    }
                        }
                        break;
                    }
                    case 6:{
                        if (![_offerDetailModel.last_update isEqualToString:@""]&&_offerDetailModel.last_update) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.last_update];
                        }
                        break;
                    }
                    case 7:{
                        if (![_offerDetailModel.port_name isEqualToString:@""]&&_offerDetailModel.port_name) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.port_name];
                        }
                        break;
                    }
                    case 8:{
                        if (![_offerDetailModel.formated_arrive_date isEqualToString:@""]&&_offerDetailModel.formated_arrive_date) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.formated_arrive_date];
                        }
                        break;
                    }
                    case 9:{
                        if (![_offerDetailModel.formated_lading_date isEqualToString:@""]&&_offerDetailModel.formated_lading_date) {
                            infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.formated_lading_date];
                        }
                        break;
                    }
                    case 10:{
                        if (![_offerDetailModel.offer_type isEqualToString:@""]&&_offerDetailModel.offer_type) {
                            if ([_offerDetailModel.offer_type isEqualToString:@"1"]) {
                                infoString = [NSString stringWithFormat:@"CIF"];
                            }
                            if ([_offerDetailModel.offer_type isEqualToString:@"2"]) {
                                infoString = [NSString stringWithFormat:@"FOB"];
                            }
                            
                            if ([_offerDetailModel.offer_type isEqualToString:@"3"]) {
                                infoString = [NSString stringWithFormat:@"DDP"];
                            }
                            if ([_offerDetailModel.offer_type isEqualToString:@"34"]) {
                                infoString = [NSString stringWithFormat:@"CFR"];
                            }
                        }
                        break;
                    }
                    default:
                        break;
                }
            }
        }
        
        
        [rightSmallLabel setText:infoString];
        [rightSmallLabel setFont:ThemeFont(CommonFontSize+1)];
        [rightSmallLabel setTextColor:[UIColor blackColor]];
        [rightSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallView);
            make.left.equalTo(leftSmallLabel.mas_right);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
        }];
    }
    
    if ([[NSString stringWithFormat:@"%@",_offerDetailModel.goods_type] isEqualToString:@"7"])//现货
    {
        if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"4"])//零售
        {
            if (!_offerDetailModel.bp_list||_offerDetailModel.bp_list.count==0) {
                if (_offerDetailModel.goods_txt&&![[NSString stringWithFormat:@"%@",_offerDetailModel.goods_txt] isEqualToString:@""]) {
                    [self createSingleDetailUI:middleView];
                }
                else
                {
                    [self creatDianPuUI:middleView];
                    
                }
            }
            else
            {
                [self createHistoryUI:middleView];
            }
        }
        if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"5"]) {
            
                [self createDetailUI:middleView];
            
        }
    }
    
    if ([[NSString stringWithFormat:@"%@",_offerDetailModel.goods_type] isEqualToString:@"6"])//期货
    {
        if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"4"])//零售
        {
            if (!_offerDetailModel.bp_list||_offerDetailModel.bp_list.count==0) {
                if (_offerDetailModel.goods_txt&&![[NSString stringWithFormat:@"%@",_offerDetailModel.goods_txt] isEqualToString:@""]) {
                    [self createSingleDetailUI:middleView];
                }
                else
                {
                    [self creatDianPuUI:middleView];
                    
                }
            }
            else
            {
                [self createHistoryUI:middleView];
            }
        }
        if ([[NSString stringWithFormat:@"%@",_offerDetailModel.sell_type] isEqualToString:@"5"]) {
            
                [self createDetailUI:middleView];
            
        }
    }
}

- (void)createSingleDetailUI:(UIView *)frontView
//报盘说明
{
    
    UIView *DetailView = [UIView new];
    [DetailView setBackgroundColor:[UIColor whiteColor]];
    DetailView.clipsToBounds = YES;
    DetailView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:DetailView];
    float alldetailHeight=0;
   
        if (![_offerDetailModel.goods_txt isEqualToString:@""]&&_offerDetailModel.goods_txt&&_offerDetailModel.goods_txt!=nil)
        {
            alldetailHeight=[self heightForCellWithText:_offerDetailModel.goods_txt andFont:[NSNumber numberWithFloat:14.0] andWidth:[NSNumber numberWithFloat:ScreenWidth-120-20]]+alldetailHeight+20;
        }
    
    
    [DetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(Gap);
        make.top.equalTo(frontView.mas_bottom).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(-Gap);
        make.height.mas_equalTo(alldetailHeight);
    }];
    
    debugLog(@"fjksjdfksdlj:%lf",alldetailHeight);
        UIView *smallView = [UIView new];
        [DetailView addSubview:smallView];
        [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(DetailView.mas_top).with.offset(0);
            make.left.equalTo(DetailView);
            make.right.equalTo(DetailView);
            make.height.mas_equalTo(alldetailHeight);
        }];
        
        UILabel *smallBottomDecorateLabel = [UILabel new];
        [smallBottomDecorateLabel setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
        [smallView addSubview:smallBottomDecorateLabel];
        [smallBottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(smallView.mas_bottom);
            make.left.equalTo(DetailView).with.offset(Gap);
            make.right.equalTo(DetailView).with.offset(-Gap);
            make.height.mas_equalTo(1);
        }];
        UILabel *leftSmallLabel = [UILabel new];
        [smallView addSubview:leftSmallLabel];
        NSString * nameStr = [NSString stringWithFormat:@""];
        nameStr=NSLocalizedString(@"Offer introduction", nil);
        leftSmallLabel.text=nameStr;
        [leftSmallLabel setFont:ThemeFont(CommonFontSize+1)];
        [leftSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(smallView).with.offset(10);
            make.left.equalTo(smallView).with.offset(15);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(30);
        }];
    
    UILabel *redLineLabel3 = [UILabel new];
    [smallView addSubview:redLineLabel3];
    redLineLabel3.backgroundColor=mainColor;
    [redLineLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftSmallLabel.mas_left).with.offset(-5);
        make.centerY.equalTo(leftSmallLabel).with.offset(0);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(20);
    }];
        
        UILabel *rightSmallLabel = [UILabel new];
    rightSmallLabel.numberOfLines=0;
        [smallView addSubview:rightSmallLabel];
        NSString *infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.goods_txt];
        [rightSmallLabel setText:infoString];
        [rightSmallLabel setFont:ThemeFont(14)];
        [rightSmallLabel setTextColor:[UIColor blackColor]];
        [rightSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallView);
            make.left.equalTo(leftSmallLabel.mas_right);
            make.width.mas_equalTo(ScreenWidth-120-20);
            make.height.mas_equalTo(alldetailHeight-20);
        }];
        
        [self creatDianPuUI:DetailView];
   
}


- (void)createDetailUI:(UIView *)frontView {
    
    UIView *DetailView = [UIView new];
    [DetailView setBackgroundColor:[UIColor whiteColor]];
    DetailView.clipsToBounds = YES;
    DetailView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:DetailView];
    NSInteger smallViewHeight = 50;
    
    for (int i =0 ; i<_offerDetailModel.goods_base.count; i++) {
    [DetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(Gap);
        make.top.equalTo(frontView.mas_bottom).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(-Gap);
        make.height.mas_equalTo(smallViewHeight*5*_offerDetailModel.goods_base.count);
    }];
    for (int i =0 ; i<_offerDetailModel.goods_base.count*5; i++) {
        UIView *smallView = [UIView new];
        [DetailView addSubview:smallView];
               [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(DetailView.mas_top).with.offset(smallViewHeight*i);
            make.left.equalTo(DetailView);
            make.right.equalTo(DetailView);
            make.height.mas_equalTo(smallViewHeight);
        }];
        
        UILabel *smallBottomDecorateLabel = [UILabel new];
        [smallBottomDecorateLabel setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
        [smallView addSubview:smallBottomDecorateLabel];
        [smallBottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(smallView.mas_bottom);
            make.left.equalTo(DetailView).with.offset(Gap);
            make.right.equalTo(DetailView).with.offset(-Gap);
            make.height.mas_equalTo(1);
        }];
        UILabel *leftSmallLabel = [UILabel new];
        [smallView addSubview:leftSmallLabel];
        NSString * nameStr = [NSString stringWithFormat:@"暂无"];
        
        NSInteger  index0 = i/5;
        NSInteger  row0 = i%5;
        goodsDetailModel * goodsDetailMD0=_offerDetailModel.goods_base[index0];
        switch (row0) {
            case 0:{
                if (![goodsDetailMD0.goods_names isEqualToString:@""]&&goodsDetailMD0.goods_names) {
                nameStr=goodsDetailMD0.goods_names;
                }
                leftSmallLabel.textColor=[UIColor darkGrayColor];
                break;
            }
            case 1:{
                nameStr=NSLocalizedString(@"Country",nil);
                leftSmallLabel.textColor=[UIColor grayColor];
                break;
            }
            case 2:{
                nameStr=NSLocalizedString(@"Plant No.",nil);
                leftSmallLabel.textColor=[UIColor grayColor];
                break;
            }
            case 3:{
                nameStr=NSLocalizedString(@"Specification",nil);
                leftSmallLabel.textColor=[UIColor grayColor];
                break;
            }
            case 4:{
                nameStr=NSLocalizedString(@"Date of Manufacture",nil);
                leftSmallLabel.textColor=[UIColor grayColor];
                break;
            }
            default:
                break;
        }
        leftSmallLabel.text=nameStr;
        leftSmallLabel.numberOfLines=0;
        leftSmallLabel.lineBreakMode=NSLineBreakByTruncatingHead;
        [leftSmallLabel setFont:ThemeFont(CommonFontSize-1)];
        [leftSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(smallView).with.offset(0);
            make.left.equalTo(smallView).with.offset(30);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(smallViewHeight);
        }];
        
        UILabel *rightSmallLabel = [UILabel new];
        [smallView addSubview:rightSmallLabel];
        NSString *infoString = [NSString stringWithFormat:@"暂无"];
        NSInteger  index = i/5;
        NSInteger  row = i%5;
        goodsDetailModel * goodsDetailMD=_offerDetailModel.goods_base[index];
        switch (row) {
            case 0:{
                
                    infoString = @"";
                
                break;
            }
            case 1:{
                if (![goodsDetailMD.region_name isEqualToString:@""]&&goodsDetailMD.region_name) {
                    infoString = [NSString stringWithFormat:@"%@",goodsDetailMD.region_name];
                }
                break;
            }
            case 2:{
                if (![goodsDetailMD.brand_sn isEqualToString:@""]&&goodsDetailMD.brand_sn) {
                    infoString = [NSString stringWithFormat:@"%@",goodsDetailMD.brand_sn];
                }
                break;
            }
            case 3:{
                if (![goodsDetailMD.specs_3 isEqualToString:@""]&&goodsDetailMD.specs_3) {
                    infoString = [NSString stringWithFormat:@"%@%@",goodsDetailMD.specs_3,goodsDetailMD.specs_3_unit];
                }
                break;
            }
            case 4:{
                if (![goodsDetailMD.make_date isEqualToString:@""]&&goodsDetailMD.make_date) {
                    infoString = [NSString stringWithFormat:@"%@",goodsDetailMD.make_date];
                }
                break;
            }
            default:
                break;
        }
        [rightSmallLabel setText:infoString];
        [rightSmallLabel setFont:ThemeFont(CommonFontSize+1)];
        [rightSmallLabel setTextColor:[UIColor blackColor]];
        [rightSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallView);
            make.left.equalTo(leftSmallLabel.mas_right);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
        }];
        
        
    }
        
        
    
        if (!_offerDetailModel.bp_list||_offerDetailModel.bp_list.count==0) {
            if (_offerDetailModel.goods_txt&&![[NSString stringWithFormat:@"%@",_offerDetailModel.goods_txt] isEqualToString:@""]) {
                [self createSingleDetailUI:DetailView];
            }
            else
            {
                [self creatDianPuUI:DetailView];
                
            }
        }
        else
        {
            [self createHistoryUI:DetailView];
        }

}
}

- (void)createHistoryUI:(UIView *)frontView {
    
    UIView *DetailView = [UIView new];
    [DetailView setBackgroundColor:[UIColor whiteColor]];
    DetailView.clipsToBounds = YES;
    DetailView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:DetailView];
    NSInteger smallViewHeight = 50;
    
    
    [DetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(Gap);
        make.top.equalTo(frontView.mas_bottom).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(-Gap);
        make.height.mas_equalTo(smallViewHeight*(_offerDetailModel.bp_list.count+1));
    }];
    
    for (int i =0 ; i<_offerDetailModel.bp_list.count+1; i++) {
        UIView *smallView = [UIView new];
        [DetailView addSubview:smallView];
        [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(DetailView.mas_top).with.offset(smallViewHeight*i);
            make.left.equalTo(DetailView);
            make.right.equalTo(DetailView);
            make.height.mas_equalTo(smallViewHeight);
        }];
        
        UILabel *smallBottomDecorateLabel = [UILabel new];
        [smallBottomDecorateLabel setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
        [smallView addSubview:smallBottomDecorateLabel];
        [smallBottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(smallView.mas_bottom);
            make.left.equalTo(DetailView).with.offset(Gap);
            make.right.equalTo(DetailView).with.offset(-Gap);
            make.height.mas_equalTo(1);
        }];
        
        OfferHistoryModel * OfferHistoryMD;
        OfferHistoryMD = _offerDetailModel.bp_list[i==0?i:i-1];
        UILabel *leftSmallLabel = [UILabel new];
        [smallView addSubview:leftSmallLabel];
        NSString * nameStr =i==0?NSLocalizedString(@"Transaction history", nil): [NSString stringWithFormat:@"%@",OfferHistoryMD.add_time];
        
        leftSmallLabel.text=nameStr;
        [leftSmallLabel setFont:ThemeFont(CommonFontSize+1)];
        [leftSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(smallView).with.offset(10);
            make.left.equalTo(smallView).with.offset(30);
            make.width.mas_equalTo(ScreenWidth-30);
            make.height.mas_equalTo(30);
        }];
        
        UILabel *redLineLabel3 = [UILabel new];
        [smallView addSubview:redLineLabel3];
        redLineLabel3.backgroundColor=mainColor;
        redLineLabel3.hidden=i==0?NO:YES;
        [redLineLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(leftSmallLabel.mas_left).with.offset(-5);
            make.centerY.equalTo(leftSmallLabel).with.offset(0);
            make.width.mas_equalTo(2);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *rightSmallLabel = [UILabel new];
        [smallView addSubview:rightSmallLabel];
        NSString *infoString = i==0?@"": [NSString stringWithFormat:@"¥%@",OfferHistoryMD.goods_amount];
        [rightSmallLabel setText:infoString];
        rightSmallLabel.textAlignment=NSTextAlignmentRight;
        [rightSmallLabel setFont:ThemeFont(CommonFontSize+1)];
        [rightSmallLabel setTextColor:[UIColor blackColor]];
        [rightSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallView);
            make.right.equalTo(smallView.mas_right).with.offset(-Gap);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo( 30);
        }];
        
        
    }
    if (_offerDetailModel.goods_txt&&![[NSString stringWithFormat:@"%@",_offerDetailModel.goods_txt] isEqualToString:@""]) {
        [self createSingleDetailUI:DetailView];
    }
    else
    {
        [self creatDianPuUI:DetailView];

    }
    
}



-(void)creatDianPuUI:(UIView*)detailView
{
    
     UIView *addedTopView = [UIView new];
    addedTopView.backgroundColor=[UIColor whiteColor];
     [_baseScrollView addSubview:addedTopView];
    [addedTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(0);
        make.top.equalTo(detailView.mas_bottom).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(0);
        make.height.mas_equalTo(40.0+90);
    }];

     UITapGestureRecognizer *addedTopViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addedTopViewTap:)];
     [addedTopView addGestureRecognizer:addedTopViewTap];
    
    
//     UIImage *addedLeftImage = [UIImage imageNamed:@"offer_icon_shop"];
     UIImage *addedRightImage = [UIImage imageNamed:@"offer_icon_next_blue"];
     UIImageView *addedLeftImageView = [[UIImageView alloc] init];
    [addedLeftImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_offerDetailModel.shop_logo]] placeholderImage:nil];
     UIImageView *addedRightImageView = [[UIImageView alloc] initWithImage:addedRightImage];
    addedRightImageView.hidden=YES;
     [addedTopView addSubview:addedLeftImageView];
     [addedTopView addSubview:addedRightImageView];
    
     [addedLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(addedTopView).with.offset(Gap);
     make.top.equalTo(addedTopView).with.offset(16);
     make.width.mas_equalTo(25);
     make.height.mas_equalTo(25);
     }];
     [addedRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.right.equalTo(addedTopView).with.offset(-Gap);
     make.top.equalTo(addedTopView).with.offset(16);
     make.width.mas_equalTo(8);
     make.height.mas_equalTo(8*(addedRightImage.size.height/addedRightImage.size.width));
     }];
     UILabel *addedTopLabel = [UILabel new];
     [addedTopView addSubview:addedTopLabel];
     [addedTopLabel setTextColor:[UIColor grayColor]];
     [addedTopLabel setFont:ThemeFont(16.0)];
     NSString *infoString = [NSString stringWithFormat:@"暂无"];
     if (![_offerDetailModel.shop_name isEqualToString:@""]&&_offerDetailModel.shop_name) {
     infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.shop_name];
     }
     [addedTopLabel setText:infoString];
     [addedTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(addedLeftImageView.mas_right).with.offset(5);
         make.top.equalTo(addedTopView).with.offset(13);

     make.height.mas_equalTo(30);
     }];
     UILabel *topDecorateLabel = [UILabel new];
     [topDecorateLabel setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
     [addedTopView addSubview:topDecorateLabel];
     [topDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
     make.top.equalTo(addedTopLabel.mas_bottom).with.offset(10);
     make.left.equalTo(addedTopView);
     make.right.equalTo(addedTopView);
     make.height.mas_equalTo(1);
     }];
    
    NSInteger banWidth =(ScreenWidth-50)/3;
    for (int i =0; i<3; i++) {
        UIView * banView=[UIView new];
        [addedTopView addSubview:banView];
        [banView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addedTopView).with.offset(25+(ScreenWidth-50)/3*i);
            make.top.equalTo(topDecorateLabel.mas_bottom).with.offset(0);
            make.width.mas_equalTo(banWidth);
            make.height.mas_equalTo(70);
        }];
        
        UILabel *dianpuNumLabel = [UILabel new];
        [banView addSubview:dianpuNumLabel];
        [dianpuNumLabel setTextColor:[UIColor grayColor]];
        
        [dianpuNumLabel setFont:ThemeFont(13.0)];
        NSString * numstr=[NSString stringWithFormat:@"0"];
        switch (i) {
            case 0:
                numstr=_offerDetailModel.shop_goods_num;
                break;
            case 1:
                numstr=_offerDetailModel.shop_order_num;
                break;
            case 2:
                numstr=_offerDetailModel.follow_count;
                break;
            default:
                break;
        }
        [dianpuNumLabel setText:numstr];
        dianpuNumLabel.textAlignment=NSTextAlignmentCenter;
        [dianpuNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(banView.mas_left).with.offset(0);
            make.top.equalTo(banView).with.offset(10);
            make.right.equalTo(banView.mas_right).with.offset(0);
            
            make.height.mas_equalTo(20);
        }];
        
        
        UILabel *n_nameLabel = [UILabel new];
        [banView addSubview:n_nameLabel];
        [n_nameLabel setTextColor:[UIColor grayColor]];
        [n_nameLabel setFont:ThemeFont(13.0)];
        NSString * n_namestr;
        switch (i) {
            case 0:
                n_namestr=NSLocalizedString(@"All products", nil);
                break;
            case 1:
                n_namestr=NSLocalizedString(@"Number of deals", nil);
                break;
            case 2:
                n_namestr=NSLocalizedString(@"Number of reads", nil);
                break;
            default:
                break;
        }
        [n_nameLabel setText:n_namestr];
        n_nameLabel.textAlignment=NSTextAlignmentCenter;
        [n_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(banView.mas_left).with.offset(0);
            make.top.equalTo(dianpuNumLabel.mas_bottom).with.offset(10);
            make.right.equalTo(banView.mas_right).with.offset(0);
            
            make.height.mas_equalTo(20);
        }];
        
    }
    
    [self creatMoreGoods:addedTopView];

}

-(void)creatMoreGoods:(UIView *)dianpuView
{
    UIView *SecondsKillView = [UIView new];
    [SecondsKillView setBackgroundColor:[UIColor whiteColor]];
    
    [_baseScrollView addSubview:SecondsKillView];
    [SecondsKillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(0);
        make.top.equalTo(dianpuView.mas_bottom).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(0);
        make.height.mas_equalTo(40+(ScreenWidth-60)/3-30+85);
    }];
    
    UILabel *SecondsKillLabel = [UILabel new];
    [SecondsKillView addSubview:SecondsKillLabel];
    [SecondsKillLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Number of re-read",nil)]];
    [SecondsKillLabel setFont:ThemeFont(14)];
    SecondsKillLabel.textColor=RGBACOLOR(85, 85, 85, 1);
    [SecondsKillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(-20);
        make.top.equalTo(SecondsKillView).with.offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *redLineLabel3 = [UILabel new];
    [SecondsKillView addSubview:redLineLabel3];
    redLineLabel3.backgroundColor=mainColor;
    [redLineLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(SecondsKillLabel.mas_left).with.offset(-5);
        make.centerY.equalTo(SecondsKillLabel).with.offset(0);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(20);
    }];
    
    
    CGFloat SecondsKillWidth = (ScreenWidth-60)/3.0;
    CGFloat SecondsKillHeight = (ScreenWidth-60)/3.0-30+80;
    CGFloat SecondsKillImageWidth = SecondsKillWidth-30;
    CGFloat SecondsKillLabelWidth = SecondsKillWidth-20;
    CGFloat SecondsKillLabelHeight = 20;
    for (int i = 0; i < _offerDetailModel.goods_base_list.count; i++) {
        goodsBaseModel *miaoShaGoodsMD = _offerDetailModel.goods_base_list[i];
        UIView *SecondsKillsmallFunctionView = [[UIView alloc] initWithFrame:CGRectMake((15+SecondsKillWidth)*(i%3)+15, 35, SecondsKillWidth, SecondsKillHeight)];
        SecondsKillsmallFunctionView.backgroundColor=RGBACOLOR(242, 242, 242, 0.7) ;
        [SecondsKillView addSubview:SecondsKillsmallFunctionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreSecondsKillTapMethod:)];
        [SecondsKillsmallFunctionView addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i;
        UIImageView *SecondsKillsmallFunctionImageView = [UIImageView new];
        [SecondsKillsmallFunctionView addSubview:SecondsKillsmallFunctionImageView];
        //        [SecondsKillsmallFunctionImageView setImage:[UIImage imageNamed:self.functionViewPicArray[i]]];
        [SecondsKillsmallFunctionImageView sd_setImageWithURL:[NSURL URLWithString:miaoShaGoodsMD.goods_thumb] placeholderImage:nil];
        [SecondsKillsmallFunctionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(SecondsKillsmallFunctionView);
            make.top.equalTo(SecondsKillsmallFunctionView).with.offset(20);
            make.width.mas_equalTo(SecondsKillImageWidth);
            make.height.mas_equalTo(SecondsKillImageWidth);
        }];
        UILabel *SecondsKillsmallFunctionLabel = [UILabel new];
        [SecondsKillsmallFunctionView addSubview:SecondsKillsmallFunctionLabel];
        [SecondsKillsmallFunctionLabel setFont:ThemeFont(13)];
        SecondsKillsmallFunctionLabel.textColor=RGBACOLOR(51, 51, 51, 1);
        [SecondsKillsmallFunctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(SecondsKillsmallFunctionView);
            make.top.equalTo(SecondsKillsmallFunctionImageView.mas_bottom).with.offset(Gap);
            make.width.mas_equalTo(SecondsKillLabelWidth);
            make.height.mas_equalTo(SecondsKillLabelHeight);
        }];
        
        [SecondsKillsmallFunctionLabel setText:[NSString stringWithFormat:@"%@",miaoShaGoodsMD.goods_name]];
        [SecondsKillsmallFunctionLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        TTTAttributedLabel *bottomPriceLabel = [TTTAttributedLabel new];
        [SecondsKillsmallFunctionView addSubview:bottomPriceLabel];
        [bottomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(SecondsKillsmallFunctionView.mas_left).with.offset(0);
            make.top.equalTo(SecondsKillsmallFunctionLabel.mas_bottom).with.offset(5);
            make.right.equalTo(SecondsKillsmallFunctionView.mas_right).with.offset(0);
            make.height.mas_equalTo(20);
        }];
        [bottomPriceLabel setTextAlignment:NSTextAlignmentCenter];
        
        [bottomPriceLabel setText:[NSString stringWithFormat:@"%@/%@",miaoShaGoodsMD.shop_price,miaoShaGoodsMD.shop_price_unit] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
         {
             
             //设置可点击文字的范围
             NSRange boldRange = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"%@",miaoShaGoodsMD.shop_price] options:NSCaseInsensitiveSearch];
             //设置可点击文本的颜色
             [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(__bridge id)[mainColor CGColor] range:boldRange];
             
             NSRange boldRange1 = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"/%@",miaoShaGoodsMD.shop_price_unit] options:NSCaseInsensitiveSearch];
             //设置可点击文本的颜色
             [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(__bridge id)[RGBACOLOR(153, 153, 153, 1) CGColor] range:boldRange1];
             
             
             UIFont *boldSystemFont = [UIFont systemFontOfSize:12];
             
             CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
             
             if (font) {
                 
                 [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                 [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange1];
                 
                 CFRelease(font);
                 
             }
             
             return mutableAttributedString;
         }];
        //        [smallFunctionLabel setFont:ThemeFont(CommonFontSize)];
    }
//    [self createBottomUI:SecondsKillView];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(SecondsKillView).with.offset(20);
    }];
    [self createBottomControlUI];
}
- (void)bottomAmountLabelViewTap:(UITapGestureRecognizer *)tap{
    
    TYDP_offerIntroViewController *offerIntroVC=[[TYDP_offerIntroViewController alloc] init];
    [self.navigationController presentViewController:offerIntroVC animated:YES completion:nil];
}

- (void)moreSecondsKillTapMethod:(UITapGestureRecognizer *)tap
{
    TYDP_OfferDetailViewController *offerDetailViewCon = [[TYDP_OfferDetailViewController alloc] init];
    goodsBaseModel *miaoShaGoodsMD = _offerDetailModel.goods_base_list[tap.view.tag];
    offerDetailViewCon.goods_id = miaoShaGoodsMD.goods_id;
     [self.navigationController pushViewController:offerDetailViewCon animated:YES];
}

- (void)createBottomControlUI {
    UIView *bottomView = [UIView new];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(TabbarHeight);
    }];
    _factoryDeatilButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_factoryDeatilButton addTarget:self action:@selector(bottomControlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _factoryDeatilButton.tag = FactoryDetailButtonMessage;
//    [_factoryDeatilButton setImage:[UIImage imageNamed:@"offer_icon_comeshop"] forState:UIControlStateNormal];
    [_factoryDeatilButton setTitle:NSLocalizedString(@"Into store", nil) forState:UIControlStateNormal];
    [_factoryDeatilButton setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
    _factoryDeatilButton.titleLabel.font=[UIFont systemFontOfSize:13.0];

    
    
    _historyOfferButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_historyOfferButton addTarget:self action:@selector(bottomControlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _historyOfferButton.tag = HistoryOfferButtonMessage;
//    [_historyOfferButton setImage:[UIImage imageNamed:@"offer_icon_history"] forState:UIControlStateNormal];
    [_historyOfferButton setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
    [_historyOfferButton setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
    _historyOfferButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    
    _offerModelArray = [NSArray arrayWithArray:_offerDetailModel.huck_list];
    _offerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_offerButton addTarget:self action:@selector(bottomControlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _offerButton.tag = OfferButtonMessage;
    if (![_offerDetailModel.offer isEqualToString:@"11"]) {
        [_offerButton setBackgroundColor:[UIColor lightGrayColor]];
        _offerButton.userInteractionEnabled = NO;
    } else {
        [_offerButton setBackgroundColor:RGBACOLOR(249, 160, 45, 1)];
    }
    [_offerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_offerButton setTitle:NSLocalizedString(@"BARGAIN", nil) forState:UIControlStateNormal];
    [_offerButton.titleLabel setFont:ThemeFont(18)];
    _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_orderButton addTarget:self action:@selector(bottomControlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _orderButton.tag = OrderButtonMessage;
    [_orderButton setBackgroundColor:mainColor];
    [_orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_orderButton setTitle:NSLocalizedString(@"ORDER", nil) forState:UIControlStateNormal];
    [_orderButton.titleLabel setFont:ThemeFont(18)];
    [bottomView addSubview:_factoryDeatilButton];
    [bottomView addSubview:_historyOfferButton];
    [bottomView addSubview:_offerButton];
    [bottomView addSubview:_orderButton];
    CGFloat smallButtonWidth = ScreenWidth*3/14;
    CGFloat bigButtonWidth = ScreenWidth*2/7;
    [_factoryDeatilButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView);
        make.top.equalTo(bottomView);
        make.bottom.equalTo(bottomView);
        make.width.mas_equalTo(smallButtonWidth);
    }];
    [_historyOfferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_factoryDeatilButton.mas_right);
        make.top.equalTo(bottomView);
        make.bottom.equalTo(bottomView);
        make.width.mas_equalTo(smallButtonWidth);
    }];
    [_offerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_historyOfferButton.mas_right);
        make.top.equalTo(bottomView);
        make.bottom.equalTo(bottomView);
        make.width.mas_equalTo(bigButtonWidth);
    }];
    [_orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_offerButton.mas_right);
        make.top.equalTo(bottomView);
        make.bottom.equalTo(bottomView);
        make.width.mas_equalTo(bigButtonWidth);
    }];
}
- (void)leftItemClicked:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)inputShouldNumber:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

- (void)updateOfferUI {
    [_smallScrollView removeFromSuperview];
    [_smallContainerView removeFromSuperview];
    CGFloat smallScrollViewHeight = (ScreenHeight/1.8)*0.44-36;
    CGFloat smallLabelHeight = smallScrollViewHeight/3+12;
    _smallScrollView = [UIScrollView new];
    [_offerShowView addSubview:_smallScrollView];
    [_smallScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_offerShowView);
        make.top.equalTo(_topView.mas_bottom);
        make.right.equalTo(_offerShowView);
        make.height.mas_equalTo(smallScrollViewHeight);
    }];
    _smallContainerView = [UIView new];
    [_smallScrollView addSubview:_smallContainerView];
    [_smallContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_smallScrollView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    CGFloat tmpFontSize;
    if (ScreenHeight == TYDPIphone5sHeight) {
        tmpFontSize = 12;
    } else {
        tmpFontSize = CommonFontSize;
    }
    if (_offerModelArray.count) {
        for (int i = 0; i < _offerModelArray.count; i++) {
            OfferModel *tmpOfferModel = _offerModelArray[i];
            UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, smallLabelHeight*i, ScreenWidth, smallLabelHeight)];
            [_smallScrollView addSubview:smallView];
            UILabel *smallLabel = [UILabel new];
            [smallLabel setBackgroundColor:[UIColor clearColor]];
            [smallLabel setTextAlignment:NSTextAlignmentLeft];
            [smallLabel setTextColor:[UIColor lightGrayColor]];
            [smallLabel setFont:ThemeFont(tmpFontSize)];
            [smallView addSubview:smallLabel];
            [smallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(smallView);
                make.top.equalTo(smallView);
                make.bottom.equalTo(smallView).with.offset(-HomePageBordWidth);
            }];
            UILabel *middleSmallLabel = [UILabel new];
            [middleSmallLabel setBackgroundColor:[UIColor clearColor]];
            [middleSmallLabel setTextAlignment:NSTextAlignmentCenter];
            [middleSmallLabel setTextColor:[UIColor lightGrayColor]];
            [middleSmallLabel setFont:ThemeFont(tmpFontSize)];
            [smallView addSubview:middleSmallLabel];
            [middleSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(smallView);
                make.top.equalTo(smallView);
                make.bottom.equalTo(smallView).with.offset(-HomePageBordWidth);
            }];
            UILabel *rightSmallLabel = [UILabel new];
            [rightSmallLabel setBackgroundColor:[UIColor clearColor]];
            [rightSmallLabel setTextAlignment:NSTextAlignmentCenter];
            [rightSmallLabel setTextColor:[UIColor lightGrayColor]];
            [rightSmallLabel setFont:ThemeFont(tmpFontSize)];
            [smallView addSubview:rightSmallLabel];
            [rightSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(smallView);
                make.top.equalTo(smallView);
                make.bottom.equalTo(smallView).with.offset(-HomePageBordWidth);
            }];
            
            NSString *number =[NSString stringWithFormat:@"%@",tmpOfferModel.user_name];
            debugLog(@"numbernumber:%@",number);
            if ([self inputShouldNumber:number]) {
                NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:nil];
                number = [regularExpression stringByReplacingMatchesInString:number options:0 range:NSMakeRange(3, 4) withTemplate:@"*"];
            }
            debugLog(@"smallLabelsmallLabel:%@",tmpOfferModel.user_name);
            [smallLabel setText:[NSString stringWithFormat:@"  %@",number]];
            [middleSmallLabel setText:[NSString stringWithFormat:@"%@",tmpOfferModel.created_at]];
            [rightSmallLabel setText:[NSString stringWithFormat:@"%@／%@  ", tmpOfferModel.formated_price,tmpOfferModel.unit]];
            UILabel *smallBottomDecorateLabel = [UILabel new];
            [smallBottomDecorateLabel setBackgroundColor:[UIColor lightGrayColor]];
            [smallBottomDecorateLabel setAlpha:0.5];
            [_smallScrollView addSubview:smallBottomDecorateLabel];
            [smallBottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(smallView).with.offset(Gap);
                make.bottom.equalTo(smallView).with.offset(-HomePageBordWidth);
                make.height.mas_equalTo(HomePageBordWidth);
                make.right.equalTo(smallView).with.offset(-Gap);
            }];
            if (i == 0) {
                [smallLabel setTextColor:RGBACOLOR(249, 160, 45, 1)];
                [middleSmallLabel setTextColor:RGBACOLOR(249, 160, 45, 1)];
                [rightSmallLabel setTextColor:RGBACOLOR(249, 160, 45, 1)];
                [middleSmallLabel setText:[NSString stringWithFormat:@"%@",tmpOfferModel.created_at]];
                //                        [smallLabel setText:[NSString stringWithFormat:@"%@            最高%@             %@%@",tmpOfferModel.user_name,tmpOfferModel.created_at, tmpOfferModel.formated_price,tmpOfferModel.unit]];
            }else if (i == _offerModelArray.count-1) {
                [_smallContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(smallView);
                }];
            }
        }
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UIImage* thumbURL =  [UIImage imageNamed:@"shareIcon"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"首农冻品" descr:@"国内领先的一站式冻品交易平台" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"http://test.taiyanggo.com/mobile/share.php?act=goods&id=%@",self.goods_id];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
//        [self alertWithError:error];
    }];
}

- (void)bottomControlButtonClicked:(UIButton *)button {
    POPSpringAnimation *anBasic = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anBasic.springBounciness = 10.0f;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    switch (button.tag) {
        case FactoryDetailButtonMessage:
        {
            NSLog(@"factory");
            NSLog(@"WY:%@",_offerDetailModel.shop_id);
            if (_offerDetailModel.shop_id) {
                
                if ([userDefaults objectForKey:@"user_id"]) {//已登陆
                    TYDP_VendorController *vendorCon = [[TYDP_VendorController alloc] init];
                    vendorCon.shopId = _offerDetailModel.shop_id;
                    [self.navigationController pushViewController:vendorCon animated:YES];
                }
                    else {//尚未登陆状态
                        TYDP_LoginController *loginViewCon = [[TYDP_LoginController alloc] init];
                        [self.navigationController pushViewController:loginViewCon animated:YES];
                    }

               
            }else {
                [_MBHUD setLabelText:@"暂无厂商信息～"];
                [self.view addSubview:_MBHUD];
                [_MBHUD show:YES];
                [_MBHUD hide:YES afterDelay:1.5f];
            }
            break;
        }
        case HistoryOfferButtonMessage:
        {
            NSLog(@"history");
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatFavorite)]];
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作
                [self shareWebPageToPlatformType:platformType];
            }];
//            TYDP_HistoryOfferViewController *historyViewCon = [[TYDP_HistoryOfferViewController alloc] init];
//            historyViewCon.offerDetailModel = _offerDetailModel;
//            [self.navigationController pushViewController:historyViewCon animated:YES];
            
            break;
        }
        case OfferButtonMessage:{
            NSLog(@"offer");
            if ([userDefaults objectForKey:@"user_id"]) {//已登陆
                _offerModelArray =[NSArray arrayWithArray:_offerDetailModel.huck_list] ;
                [_offerTextField resignFirstResponder];
                [_cancelButton removeFromSuperview];
                if (!_blackView) {
                    _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight)];
                    [_blackView setBackgroundColor:[UIColor blackColor]];
                    [_blackView setAlpha:0.5];
                }
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewTapMethod:)];
                [_blackView addGestureRecognizer:tap];
                UIView *tmpView = [tap view];
                tmpView.tag = button.tag + 1;
                [self.view addSubview:_blackView];
                [_offerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(button.superview);
                    make.top.equalTo(button.superview);
                    make.bottom.equalTo(button.superview);
                    make.width.mas_equalTo(ScreenWidth);
                }];
                CGFloat offerShowViewHeight = ScreenHeight/1.8;
                CGFloat smallScrollViewHeight = (ScreenHeight/1.8)*0.44;
                CGFloat smallLabelHeight = smallScrollViewHeight/3;
                if (!_offerShowView) {
                    _offerShowView = [UIView new];
                    [_offerShowView setBackgroundColor:RGBACOLOR(248, 248, 248, 1)];
                    UILabel *topLabel = [UILabel new];
                    [_offerShowView addSubview:topLabel];
                    [topLabel setText:NSLocalizedString(@"Offer a price", nil)];
                    [topLabel setTextAlignment:NSTextAlignmentCenter];
                    [topLabel setFont:ThemeFont(20)];
                    [topLabel setTextColor:RGBACOLOR(255, 92, 9, 1)];
                    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_offerShowView);
                        make.top.equalTo(_offerShowView);
                        make.right.equalTo(_offerShowView);
                        make.height.mas_equalTo(smallLabelHeight);
                    }];
                    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    cancelButton.tag = SmallOfferButtonCancelMessage;
                    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cancelButton setImage:[UIImage imageNamed:@"ico_cancel"] forState:UIControlStateNormal];
                    [_offerShowView addSubview:cancelButton];
                    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(_offerShowView);
                        make.top.equalTo(_offerShowView);
                        make.width.equalTo(cancelButton.mas_height);
                        make.height.mas_equalTo(smallLabelHeight);
                    }];
                    _topView = [UIView new];
                    [_topView setBackgroundColor:[UIColor whiteColor]];
                    [_offerShowView addSubview:_topView];
                    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_offerShowView);
                        make.top.equalTo(topLabel.mas_bottom);
                        make.right.equalTo(_offerShowView);
                        make.height.mas_equalTo(smallLabelHeight);
                    }];
                    UIImage *offerRecordImage = [UIImage imageNamed:@"0ffer_icon_record"];
                    UIImageView *offerRecordImageView = [UIImageView new];
                    [offerRecordImageView setImage:offerRecordImage];
                    [_topView addSubview:offerRecordImageView];
                    [offerRecordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_topView).with.offset(20);
                        make.centerY.equalTo(_topView);
                        make.width.mas_equalTo(ScreenWidth/4);
                        make.height.mas_equalTo((ScreenWidth/4)*(offerRecordImage.size.height/offerRecordImage.size.width));
                    }];
                    UILabel *verticalDecorateLabel = [UILabel new];
                    [_topView addSubview:verticalDecorateLabel];
                    [verticalDecorateLabel setBackgroundColor:[UIColor lightGrayColor]];
                    [verticalDecorateLabel setAlpha:0.5];
                    [verticalDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(offerRecordImageView.mas_right).with.offset(20);
                        make.width.mas_equalTo(1);
                        make.top.equalTo(_topView).with.offset(15);
                        make.bottom.equalTo(_topView).with.offset(-15);
                    }];
                    UILabel *amountLabel = [UILabel new];
                    [amountLabel setTextColor:[UIColor lightGrayColor]];
                    [amountLabel setText:[NSString stringWithFormat:@"¥%@/%@",_offerDetailModel.shop_price,NSLocalizedString(@"MT", nil)]];
                    //适配iphone5s
                    if (ScreenHeight == TYDPIphone5sHeight) {
                        [amountLabel setFont:ThemeFont(CommonFontSize)];
                    } else {
                        [amountLabel setFont:ThemeFont(17)];
                    }
                    [_topView addSubview:amountLabel];
                    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(verticalDecorateLabel).with.offset(20);
                        make.centerY.equalTo(_topView);
                        make.width.mas_equalTo(ScreenWidth/2);
                        make.height.mas_equalTo(35);
                    }];
                    UILabel *bottomDecorateLabel = [UILabel new];
                    [bottomDecorateLabel setBackgroundColor:[UIColor lightGrayColor]];
                    [bottomDecorateLabel setAlpha:0.5];
                    [_topView addSubview:bottomDecorateLabel];
                    [bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_topView);
                        make.bottom.equalTo(_topView).with.offset(-HomePageBordWidth);
                        make.height.mas_equalTo(HomePageBordWidth);
                        make.right.equalTo(_topView);
                    }];
                    
                    
                    [self updateOfferUI];
                    
                    
                    UIView *bottomOfferView = [UIView new];
                    [bottomOfferView setBackgroundColor:[UIColor whiteColor]];
                    [_offerShowView addSubview:bottomOfferView];
                    [bottomOfferView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_offerShowView);
                        make.right.equalTo(_offerShowView);
                        make.bottom.equalTo(_offerShowView.mas_bottom);
                        make.height.mas_equalTo(smallLabelHeight*1.5+40);
                    }];
                    _offerTextField = [UITextField new];
                    _offerTextField.clipsToBounds = YES;
                    _offerTextField.layer.cornerRadius = 5;
                    _offerTextField.layer.borderColor = [RGBACOLOR(216, 216, 216, 1) CGColor];
                    _offerTextField.layer.borderWidth = 1;
                    _offerTextField.delegate = self;
                    _offerTextField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"Offer a bid", nil)];
                    _offerTextField.keyboardType = UIKeyboardTypeNumberPad;
                    _offerTextField.borderStyle = UITextBorderStyleNone;
                    _offerTextField.textAlignment = NSTextAlignmentLeft;
                    _offerTextField.leftViewMode = UITextFieldViewModeAlways;
                    _offerTextField.adjustsFontSizeToFitWidth = YES;
                    UIImage *offerImage = [UIImage imageNamed:@"offer_icon_ren"];
                    UIImageView *offerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (smallLabelHeight*0.8)*(offerImage.size.width/offerImage.size.height), smallLabelHeight*0.8)];
                    [offerImageView setImage:offerImage];
                    _offerTextField.leftView = offerImageView;
                    [bottomOfferView addSubview:_offerTextField];
                    [_offerTextField mas_makeConstraints:^(MASConstraintMaker *make)    {
                        make.centerX.equalTo(bottomOfferView);
                        make.bottom.equalTo(bottomOfferView.mas_bottom).with.offset(-60);
                        make.width.mas_equalTo(ScreenWidth*0.56);
                        make.height.mas_equalTo(smallLabelHeight*0.8);
                    }];
                    
                    
                    _liuyanTextField = [UITextField new];
                    _liuyanTextField.clipsToBounds = YES;
                    _liuyanTextField.layer.cornerRadius = 5;
                    _liuyanTextField.layer.borderColor = [RGBACOLOR(216, 216, 216, 1) CGColor];
                    _liuyanTextField.layer.borderWidth = 1;
                    _liuyanTextField.delegate = self;
                    _liuyanTextField.placeholder = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Leave a mesage", nil)];
                    _liuyanTextField.textAlignment = NSTextAlignmentLeft;
                    _liuyanTextField.leftViewMode = UITextFieldViewModeAlways;
                    _liuyanTextField.adjustsFontSizeToFitWidth = YES;
                    [bottomOfferView addSubview:_liuyanTextField];
                    [_liuyanTextField mas_makeConstraints:^(MASConstraintMaker *make)    {
                        make.centerX.equalTo(bottomOfferView);
                        make.bottom.equalTo(bottomOfferView.mas_bottom).with.offset(-15);
                        make.width.mas_equalTo(ScreenWidth-30);
                        make.height.mas_equalTo(40);
                    }];
                    

                }
                
                
                
                _offerShowView.frame = CGRectMake(0, ScreenHeight-TabbarHeight, ScreenWidth, ScreenHeight/1.8);
                [self.view addSubview:_offerShowView];
                //            [_offerShowView mas_makeConstraints:^(MASConstraintMaker *make) {
                //                make.left.equalTo(self.view);
                //                make.right.equalTo(self.view);
                //                make.top.equalTo(_offerButton.mas_bottom);
                //                make.height.mas_equalTo(ScreenHeight/1.8);
                //            }];
                if (_offerButton.frame.size.width == ScreenWidth) {
                    NSLog(@"TT");
                    _offerShowView.frame = CGRectMake(0, ScreenHeight-TabbarHeight-offerShowViewHeight, ScreenWidth, offerShowViewHeight);
                    [self.view addSubview:_MBHUD];
                    if ([_offerTextField.text intValue] <= 0) {
                        [_MBHUD setLabelText:NSLocalizedString(@"Bid can't be zero", nil)];
                    } else if ([_offerTextField.text intValue] >= [_offerDetailModel.shop_price intValue]) {
                        [_MBHUD setLabelText:NSLocalizedString(@"The bid must be smaller than the manufacturer's offer", nil)];
                    } else {
                        [self updateOfferData];
                    }
                    [_MBHUD show:YES];
                    [_MBHUD hide:YES afterDelay:1.5f];
                    [_offerTextField setText:@""];
                } else {
                    anBasic.toValue = @(_offerShowView.center.y-offerShowViewHeight);
                    anBasic.beginTime = CACurrentMediaTime()+0.1f;
                    [_offerShowView pop_addAnimation:anBasic forKey:@"position"];
                }

            } else {//尚未登陆状态
                TYDP_LoginController *loginViewCon = [[TYDP_LoginController alloc] init];
                [self.navigationController pushViewController:loginViewCon animated:YES];
            }
            break;
        }
        case OrderButtonMessage:{
            if ([userDefaults objectForKey:@"user_id"]) {//已登陆
                [_orderTextField resignFirstResponder];
                [_cancelButton removeFromSuperview];
                NSLog(@"order");
                [_orderButton setTitle:NSLocalizedString(@"Confirm",nil) forState:UIControlStateNormal];
                if (!_blackView) {
                    _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight)];
                    [_blackView setBackgroundColor:[UIColor blackColor]];
                    [_blackView setAlpha:0.5];
                }
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewTapMethod:)];
                [_blackView addGestureRecognizer:tap];
                UIView *tmpView = [tap view];
                tmpView.tag = button.tag + 1;
                [self.view addSubview:_blackView];
                [_orderButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(button.superview);
                    make.top.equalTo(button.superview);
                    make.bottom.equalTo(button.superview);
                    make.width.mas_equalTo(ScreenWidth);
                }];
                CGFloat orderShowViewHeight = ScreenHeight/3;
                CGFloat topLabelHeight = orderShowViewHeight/5;
                if (!_orderShowView) {
                    _orderShowView = [UIView new];
                    [_orderShowView setBackgroundColor:RGBACOLOR(248, 248, 248, 1)];
                    UILabel *topLabel = [UILabel new];
                    [_orderShowView addSubview:topLabel];
                    [topLabel setText:NSLocalizedString(@"ORDER", nil)];
                    [topLabel setTextAlignment:NSTextAlignmentCenter];
                    [topLabel setFont:ThemeFont(20)];
                    [topLabel setTextColor:RGBACOLOR(255, 92, 9, 1)];
                    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_orderShowView);
                        make.top.equalTo(_orderShowView);
                        make.right.equalTo(_orderShowView);
                        make.height.mas_equalTo(topLabelHeight);
                    }];
                    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    cancelButton.tag = SmallOrderButtonCancelMessage;
                    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cancelButton setImage:[UIImage imageNamed:@"ico_cancel"] forState:UIControlStateNormal];
                    [_orderShowView addSubview:cancelButton];
                    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(_orderShowView);
                        make.top.equalTo(_orderShowView);
                        make.width.equalTo(cancelButton.mas_height);
                        make.height.mas_equalTo(topLabelHeight);
                    }];
                    UIView *bottomCellView = [UIView new];
                    [bottomCellView setBackgroundColor:[UIColor whiteColor]];
                    [_orderShowView addSubview:bottomCellView];
                    [bottomCellView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(topLabel.mas_bottom);
                        make.left.equalTo(_orderShowView);
                        make.width.mas_equalTo(ScreenWidth);
                        make.height.mas_equalTo(orderShowViewHeight/2);
                    }];
                    UIImageView *leftBigImageView = [UIImageView new];
                    [bottomCellView addSubview:leftBigImageView];
                    [leftBigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(bottomCellView).with.offset(Gap);
                        make.centerY.equalTo(bottomCellView);
                        make.width.equalTo(leftBigImageView.mas_height);
                        make.height.mas_equalTo(orderShowViewHeight/2-30);
                    }];
                    [leftBigImageView sd_setImageWithURL:[NSURL URLWithString:_offerDetailModel.goods_thumb] placeholderImage:nil];
                    UILabel *middleTopLabel = [UILabel new];
                    [middleTopLabel setText:[NSString stringWithFormat:@"%@",_offerDetailModel.goods_name]];
                    [middleTopLabel setFont:ThemeFont(20)];
                    [bottomCellView addSubview:middleTopLabel];
                    UILabel *middlePriceLabel = [UILabel new];
                    if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                        [middlePriceLabel setText:[NSString stringWithFormat:@"%@/%@  %@%@",_offerDetailModel.formated_shop_price,_offerDetailModel.shop_price_unit,_offerDetailModel.spec_2,NSLocalizedString(@"pc/MT",nil)]];
                    }
                    else  {
                        [middlePriceLabel setText:[NSString stringWithFormat:@"¥%@/%@  %@%@",_offerDetailModel.shop_price,_offerDetailModel.shop_price_unit,_offerDetailModel.goods_weight,NSLocalizedString(@"MT/Ctn",nil)]];
                    }
                    [middlePriceLabel setFont:ThemeFont(18)];
                    //                [middlePriceLabel setBackgroundColor:[UIColor greenColor]];
                    [middlePriceLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
                    [bottomCellView addSubview:middlePriceLabel];
                    [middlePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(leftBigImageView.mas_right).with.offset(20);
                        make.centerY.equalTo(leftBigImageView);
                        //                    make.width.mas_equalTo(120);
                        make.height.mas_equalTo(25);
                    }];
                    [middleTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(leftBigImageView.mas_right).with.offset(20);
                        make.bottom.equalTo(middlePriceLabel.mas_top).with.offset(-5);
                        //                    make.width.mas_equalTo(ScreenWidth/2);
                        make.height.mas_equalTo(CommonHeight);
                    }];
                    
//                    UILabel *middleMeasureLabel = [UILabel new];
//                    [middleMeasureLabel setText:[NSString stringWithFormat:@"/吨"]];
//                    [middleMeasureLabel setFont:ThemeFont(18)];
//                    [middleMeasureLabel setTextColor:[UIColor blackColor]];
//                    [bottomCellView addSubview:middleMeasureLabel];
//                    [middleMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(middlePriceLabel.mas_right);
//                        make.centerY.equalTo(leftBigImageView);
//                        //                    make.width.mas_equalTo(100);
//                        make.height.mas_equalTo(CommonHeight);
//                    }];
                    NSString *tmpMeasureString = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Caninet",nil)];
                    if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                        tmpMeasureString = [NSString stringWithFormat:@"%@",NSLocalizedString(@"pc",nil)];
                    }
                    UILabel *bottomAmountLabel = [UILabel new];
                    [bottomAmountLabel setText:[NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_number,tmpMeasureString]];
                    
                    
                    UILabel *bottomMeasureLabel = [UILabel new];
                    [bottomMeasureLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Stock",nil)]];
                    [bottomMeasureLabel setFont:ThemeFont(CommonFontSize)];
                    [bottomMeasureLabel setTextColor:[UIColor lightGrayColor]];
                    [bottomCellView addSubview:bottomMeasureLabel];
                    [bottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(leftBigImageView.mas_right).with.offset(20);
                        make.top.equalTo(middlePriceLabel.mas_bottom).with.offset(5);
                        make.height.mas_equalTo(CommonHeight);
                    }];
                    [bottomAmountLabel setFont:ThemeFont(CommonFontSize)];
                    [bottomAmountLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
                    [bottomCellView addSubview:bottomAmountLabel];
                    [bottomAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(bottomMeasureLabel.mas_right);
                        make.top.equalTo(bottomMeasureLabel);
                        make.height.mas_equalTo(CommonHeight);
                    }];
                    UILabel *bottomDecorateLabel = [UILabel new];
                    [bottomDecorateLabel setBackgroundColor:[UIColor lightGrayColor]];
                    [bottomDecorateLabel setAlpha:0.5];
                    [bottomCellView addSubview:bottomDecorateLabel];
                    [bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_orderShowView);
                        make.right.equalTo(_orderShowView);
                        make.bottom.equalTo(bottomCellView).with.offset(-1);
                        make.height.mas_equalTo(HomePageBordWidth);
                    }];
//                    UILabel *middleAmountLabel = [UILabel new];
//                    UILabel *middleAmountLastLabel = [UILabel new];
//                    UIView *middleDecoratorView = [UIView new];
//                    middleDecoratorView.layer.cornerRadius = 5;
//                    middleDecoratorView.layer.borderColor = [RGBACOLOR(255, 92, 9, 1) CGColor];
//                    middleDecoratorView.layer.borderWidth = 1;
//                    [bottomCellView addSubview:middleDecoratorView];
//                    [middleAmountLabel setTextColor:RGBACOLOR(255, 92, 9, 1)];
//                    [middleAmountLabel setFont:ThemeFont(CommonFontSize)];
//                    [middleAmountLabel setClipsToBounds:YES];
//                    [bottomCellView addSubview:middleAmountLabel];
//                    [middleAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(middleTopLabel.mas_right).with.offset(MiddleGap);
//                        make.centerY.equalTo(middlePriceLabel);
//                        make.height.mas_equalTo(25);
//                    }];
//                    [middleAmountLastLabel setTextColor:[UIColor grayColor]];
//                    if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
//                        [middleAmountLabel setText:[NSString stringWithFormat:@"%@",_offerDetailModel.spec_2]];
//                        [middleAmountLastLabel setText:[NSString stringWithFormat:@"%@",_offerDetailModel.spec_2_unit]];
//                    } else {
//                        [middleAmountLabel setText:[NSString stringWithFormat:@"%@吨",_offerDetailModel.goods_weight]];
//                        [middleAmountLastLabel setText:[NSString stringWithFormat:@"/柜"]];
//                    }
//                    [middleAmountLastLabel setFont:ThemeFont(CommonFontSize)];
//                    [bottomCellView addSubview:middleAmountLastLabel];
//                    [middleAmountLastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(middleAmountLabel.mas_right);
//                        make.centerY.equalTo(middlePriceLabel);
//                        make.height.mas_equalTo(25);
//                    }];
//                    [middleDecoratorView mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(middleAmountLabel).with.offset(-5);
//                        make.top.equalTo(middleAmountLabel);
//                        make.right.equalTo(middleAmountLastLabel).with.offset(5);
//                        make.bottom.equalTo(middleAmountLabel);
//                    }];
                    UIView *bottomView = [UIView new];
                    [bottomView setBackgroundColor:[UIColor whiteColor]];
                    [_orderShowView addSubview:bottomView];
                    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(bottomCellView);
                        make.top.equalTo(bottomCellView.mas_bottom);
                        make.bottom.equalTo(_orderShowView);
                        make.right.equalTo(bottomCellView);
                    }];
                    [self createBottomSelectAmountUIWithSuperView:bottomView andFlagString:tmpMeasureString];
                }
                //总价初始化
                _orderShowView.frame = CGRectMake(0, ScreenHeight-TabbarHeight, ScreenWidth, ScreenWidth/1.5);
                [self.view addSubview:_orderShowView];
                if (_orderButton.frame.size.width == ScreenWidth) {
                    NSLog(@"TT");
                    [_orderButton setTitle:@"订购" forState:UIControlStateNormal];
                    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
                    [tmpDic setObject:_offerDetailModel.goods_thumb forKey:@"goodsImage"];
                    [tmpDic setObject:_offerDetailModel.goods_name forKey:@"goodsName"];
                    [tmpDic setObject:_offerDetailModel.shop_price forKey:@"goodsPrice"];
                    NSString *frontString = [NSString new];
                    NSString *behindString = [NSString new];
                    if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                        frontString = _offerDetailModel.spec_2;
                        behindString = _offerDetailModel.spec_2_unit;
                    } else {
                        frontString = [NSString stringWithFormat:@"%@%@",_offerDetailModel.goods_weight,NSLocalizedString(@"MT", nil)];
                        behindString = [NSString stringWithFormat:@"/柜"];
                    }
                    [tmpDic setObject:frontString forKey:@"frontNumber"];
                    [tmpDic setObject:behindString forKey:@"behindUnit"];
                    [tmpDic setObject:_orderTextField.text forKey:@"goodsNumber"];
                    NSMutableString *mutableString = [NSMutableString stringWithString:_bottomPriceLabel.text];
                    NSRange range = {0,1};
                    [mutableString deleteCharactersInRange:range];
                    [tmpDic setObject:mutableString forKey:@"orderTotalPrice"];
                    [tmpDic setObject:_offerDetailModel.prepay_name forKey:@"prePayName"];
                    [tmpDic setObject:_offerDetailModel.prepay_type forKey:@"prePayType"];
                    [tmpDic setObject:_offerDetailModel.prepay_num forKey:@"prePayNum"];
                    [tmpDic setObject:_offerDetailModel.goods_id forKey:@"goodsId"];
                    NSString *tmpMeasureString = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Caninet",nil)];
                    if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                        tmpMeasureString = [NSString stringWithFormat:@"%@",NSLocalizedString(@"pc",nil)];
                    }
                    [tmpDic setObject:tmpMeasureString forKey:@"sellMeasureUnit"];
                    [tmpDic setObject:_offerDetailModel.formated_shop_price forKey:@"formated_shop_price"];
                     [tmpDic setObject:_offerDetailModel.shop_price_unit forKey:@"shop_price_unit"];
                     [tmpDic setObject:_offerDetailModel.spec_2 forKey:@"spec_2"];
                     [tmpDic setObject:_offerDetailModel.shop_price forKey:@"shop_price"];
                     [tmpDic setObject:_offerDetailModel.goods_weight forKey:@"goods_weight"];
                     [tmpDic setObject:_offerDetailModel.sell_type forKey:@"sell_type"];
                    
                    
                    TYDP_ConfirmOrderViewController *confirmOrderViewCon = [[TYDP_ConfirmOrderViewController alloc] init];
                    confirmOrderViewCon.orderDic = tmpDic;
                    [self.navigationController pushViewController:confirmOrderViewCon animated:NO];
                    [_blackView removeFromSuperview];
                    [_orderShowView removeFromSuperview];
                    [_orderButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_offerButton.mas_right);
                        make.top.equalTo(_offerButton.superview);
                        make.bottom.equalTo(_offerButton.superview);
                        make.width.mas_equalTo(_offerButton.frame.size.width);
                    }];
                } else {
                    anBasic.toValue = @(_orderShowView.center.y- ScreenWidth/1.5);
                    anBasic.beginTime = CACurrentMediaTime()+0.1f;
                    [_orderShowView pop_addAnimation:anBasic forKey:@"position"];
                }
                if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                    _orderTextField.text = [NSString stringWithFormat:@"%@",_offerDetailModel.spec_2];
                    [_bottomPriceLabel setText:[NSString stringWithFormat:@"¥%.2f",[_offerDetailModel.shop_price floatValue]*([_orderTextField.text floatValue]/[_offerDetailModel.spec_2 intValue])]];
                } else {
                    _orderTextField.text = [NSString stringWithFormat:@"0"];
                    [_bottomPriceLabel setText:[NSString stringWithFormat:@"¥0"]];
                }
                if ([_orderTextField.text intValue] == 0) {
                    [self setBottomButtonUserInteraction:NO];
                } else if ([_orderTextField.text intValue] > [_offerDetailModel.goods_number intValue]&&[_offerDetailModel.sell_type isEqualToString:@"4"]) {//零售时一顿的数量大于库存的时候
                    [self setBottomButtonUserInteraction:NO];
                }
            } else {//尚未登录
                TYDP_LoginController *loginViewCon = [[TYDP_LoginController alloc] init];
                [self.navigationController pushViewController:loginViewCon animated:YES];
            }
            break;
        }
        default:
            break;
    }
}
- (void)updateOfferData {
    _MBHUD = [[MBProgressHUD alloc] init];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    [_MBHUD show:YES];
    [self.view addSubview:_MBHUD];
    if (![_offerDetailModel.user_id isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]) {
        NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"goods",@"save_huck",ConfigNetAppKey];
        NSDictionary *params = @{@"action":@"save_huck",@"sign":[TYDPManager md5:Sign],@"model":@"goods",@"goods_id":_offerDetailModel.goods_id,@"shop_id":_offerDetailModel.shop_id,@"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"price":_offerTextField.text,@"message":_liuyanTextField.text,@"last_price":_offerDetailModel.shop_price};
        NSLog(@"params:%@",params);
        [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
            if (![data[@"error"] intValue]) {
                [_MBHUD setLabelText:@"恭喜您还价成功！"];
                [_MBHUD hide:YES afterDelay:1.5f];
                _offerModelArray = [OfferModel arrayOfModelsFromDictionaries:data[@"content"] error:nil];
                [self updateOfferUI];
            } else {
                [_MBHUD setLabelText:data[@"message"]];
                [_MBHUD hide:YES afterDelay:1.5f];
            }
        } failure:^(TYDPError *error) {
            NSLog(@"%@",error);
        }];
    } else {
        [_MBHUD setLabelText:@"本人不能报价哦。"];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        [_MBHUD hide:YES afterDelay:1.5f];
    }
}
- (void)createBottomSelectAmountUIWithSuperView:(UIView *)superView andFlagString:(NSString *)measureString {
    NSInteger orderTextFieldLength = ScreenWidth/2.76;
    _orderTextField = [[UITextField alloc] initWithFrame:CGRectMake( ScreenWidth - orderTextFieldLength - 20, 20, orderTextFieldLength, 30)];
    [superView addSubview:_orderTextField];
    UILabel *bottomViewLabel = [UILabel new];
    [bottomViewLabel setText:NSLocalizedString(@"purchase amount", nil) ];
    [bottomViewLabel setTextColor:RGBACOLOR(99, 99, 99, 1)];
    [bottomViewLabel setFont:ThemeFont(18)];
    [superView addSubview:bottomViewLabel];
    [bottomViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_orderTextField);
        make.left.equalTo(superView).with.offset(Gap);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(30);
    }];
    _offerTextField.clipsToBounds = YES;
    _offerTextField.layer.cornerRadius = 10;
    _orderTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _orderTextField.layer.borderWidth = 1;
    _orderTextField.delegate = self;
    if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
        _orderTextField.text = [NSString stringWithFormat:@"%@",_offerDetailModel.spec_2];
    } else {
        _orderTextField.text = [NSString stringWithFormat:@"0"];
    }
    _orderTextField.keyboardType = UIKeyboardTypeNumberPad;
    _orderTextField.textAlignment = NSTextAlignmentCenter;
    _orderTextField.adjustsFontSizeToFitWidth = YES;
    _orderPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_orderPlusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _orderPlusButton.frame = CGRectMake(0, 0, 30, 30);
    _orderPlusButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _orderPlusButton.layer.borderWidth = 1;
    _orderPlusButton.tag = OrderPlusButtonMessage;
    [_orderPlusButton addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_orderPlusButton setTitle:@"＋" forState:UIControlStateNormal];
    _orderReduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderReduceButton.frame = CGRectMake(0, 0, 30, 30);
    _orderReduceButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _orderReduceButton.layer.borderWidth = 1;
    _orderReduceButton.tag = OrderReduceButtonMessage;
    [_orderReduceButton addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_orderReduceButton setTitle:@"－" forState:UIControlStateNormal];
    [_orderReduceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _orderTextField.leftView = _orderReduceButton;
    _orderTextField.leftViewMode = UITextFieldViewModeAlways;
    _orderTextField.rightView =  _orderPlusButton;
    _orderTextField.rightViewMode = UITextFieldViewModeAlways;
    //    UILabel *unitLabel = [UILabel new];
    //    [unitLabel setText:[NSString stringWithFormat:@"%@",measureString]];
    //    [unitLabel setTextColor:[UIColor blackColor]];
    //    [unitLabel setFont:ThemeFont(18)];
    //    [superView addSubview:unitLabel];
    //    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(_orderTextField.mas_right).with.offset(5);
    //        make.centerY.equalTo(superView);
    //        make.width.mas_equalTo(25);
    //        make.height.equalTo(unitLabel.mas_width);
    //    }];
    _bottomPriceLabel = [UILabel new];
    [superView addSubview:_bottomPriceLabel];
    [_bottomPriceLabel setText:[NSString stringWithFormat:@"¥0"]];
    [_bottomPriceLabel setFont:ThemeFont(18)];
    [_bottomPriceLabel setTextAlignment:NSTextAlignmentRight];
    [_bottomPriceLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [_bottomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_orderTextField.mas_right);
        make.bottom.equalTo(superView.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    UILabel *bottomDecotrateLabel = [UILabel new];
    [superView addSubview:bottomDecotrateLabel];
    [bottomDecotrateLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Total Price", nil)]];
    [bottomDecotrateLabel setFont:ThemeFont(18)];
    [bottomDecotrateLabel setTextAlignment:NSTextAlignmentRight];
    [bottomDecotrateLabel setTextColor:RGBACOLOR(99, 99, 99, 1)];
    [bottomDecotrateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomPriceLabel.mas_left);
        make.bottom.equalTo(superView.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    NSInteger tmpValue = [_orderTextField.text intValue];
    if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
        if (tmpValue <= [_offerDetailModel.spec_2 intValue]) {
            [_orderReduceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        //零售售卖时的总价
        [_bottomPriceLabel setText:[NSString stringWithFormat:@"¥%.2f",[_offerDetailModel.shop_price floatValue]*([_orderTextField.text floatValue]/[_offerDetailModel.spec_2 intValue])]];
    }
}
- (void)orderButtonClicked:(UIButton *)button {
    NSInteger tmpValue = [_orderTextField.text intValue];
    switch (button.tag) {
        case OrderReduceButtonMessage:{
            if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                if ([_orderTextField.text intValue] <= [_offerDetailModel.spec_2 intValue]) {
                    [_orderReduceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    return;
                } else {
                    if (tmpValue > [_offerDetailModel.spec_2 intValue]) {
                        tmpValue--;
                    }
                }
            } else {
                if (tmpValue > 0 ) {
                    tmpValue--;
                }
            }
            break;
        }
        case OrderPlusButtonMessage:{
            if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
                if (tmpValue < [_offerDetailModel.goods_number intValue]) {
                    tmpValue++;
                }
            } else {
                if (tmpValue < [_offerDetailModel.goods_number intValue]) {
                    tmpValue++;
                }
            }
            break;
        }
        default:
            break;
    }
    [_orderTextField setText:[NSString stringWithFormat:@"%ld",(long)tmpValue]];
    if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
        if ([_orderTextField.text intValue] <= [_offerDetailModel.spec_2 intValue]) {
            [_orderReduceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else if ([_orderTextField.text intValue] > [_offerDetailModel.spec_2 intValue]) {
            [_orderReduceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        //零售售卖时的总价
        [_bottomPriceLabel setText:[NSString stringWithFormat:@"¥%.2f",[_offerDetailModel.shop_price floatValue]*([_orderTextField.text floatValue]/[_offerDetailModel.spec_2 intValue])]];

    } else {
        //整柜售卖时的总价
        [_bottomPriceLabel setText:[NSString stringWithFormat:@"¥%.2f",[_offerDetailModel.shop_price floatValue]*[_orderTextField.text intValue]*[_offerDetailModel.goods_weight floatValue]]];
    }
    if ([_orderTextField.text intValue] >= 1) {
        [self setBottomButtonUserInteraction:YES];
    } else if ([_orderTextField.text intValue] == 0) {
        [self setBottomButtonUserInteraction:NO];
    }
    [self setUserLimit];
}
- (void)setUserLimit{
    if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
        if ([_orderTextField.text intValue] < [_offerDetailModel.spec_2 intValue]) {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"The amount of purchase can not be less than",nil),_offerDetailModel.spec_2,NSLocalizedString(@"pc",nil)]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
            [self setBottomButtonUserInteraction:NO];
        } else if ([_orderTextField.text intValue] > [_offerDetailModel.goods_number intValue]) {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"Purchase quantity cannot be greater than",nil),_offerDetailModel.goods_number,NSLocalizedString(@"pc",nil)]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
            [_orderButton setBackgroundColor:[UIColor grayColor]];
            [self setBottomButtonUserInteraction:NO];
        } else {
            [self setBottomButtonUserInteraction:YES];
        }
    } else {
        if ([_orderTextField.text intValue] > [_offerDetailModel.goods_number intValue]) {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"购买数量不能大于%@%@",NSLocalizedString(@"Purchase quantity cannot be greater than",nil),_offerDetailModel.goods_number,NSLocalizedString(@"Caninet",nil)]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
            [self setBottomButtonUserInteraction:NO];
        } else if ([_orderTextField.text intValue] == 0) {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@0%@",NSLocalizedString(@"The amount of purchase can not be less than",nil),NSLocalizedString(@"pc",nil)]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
            [_orderButton setBackgroundColor:[UIColor grayColor]];
            [self setBottomButtonUserInteraction:NO];
        }else {
            [self setBottomButtonUserInteraction:YES];
        }
    }
}
- (void)setBottomButtonUserInteraction:(BOOL)flag {
    if (flag) {
        [_orderButton setBackgroundColor:mainColor];
    } else {
        [_orderButton setBackgroundColor:[UIColor grayColor]];
    }
    [_orderButton setUserInteractionEnabled:flag];
    if (![_offerDetailModel.offer isEqualToString:@"11"]) {
        [_offerButton setUserInteractionEnabled:NO];
    } else {
        [_offerButton setUserInteractionEnabled:flag];
    }
    [_historyOfferButton setUserInteractionEnabled:flag];
    [_factoryDeatilButton setUserInteractionEnabled:flag];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self regNotification];
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.tag = BigCancelMessage;
        _cancelButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight);
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_cancelButton];
}
- (void)cancelButtonClicked:(UIButton *)button {
    switch (button.tag) {
        case BigCancelMessage:{
            [_offerTextField resignFirstResponder];
            [_orderTextField resignFirstResponder];
            [_cancelButton removeFromSuperview];
            break;
        }
        case SmallOfferButtonCancelMessage:{
            [_blackView removeFromSuperview];
            [_offerShowView removeFromSuperview];
            [_offerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_historyOfferButton.mas_right);
                make.top.equalTo(_offerButton.superview);
                make.bottom.equalTo(_offerButton.superview);
                make.width.mas_equalTo(_orderButton.frame.size.width);
            }];
            break;
        }
        case SmallOrderButtonCancelMessage:{
            [self setBottomButtonUserInteraction:YES];
            [_orderButton setTitle:@"订购" forState:UIControlStateNormal];
            [_blackView removeFromSuperview];
            [_orderShowView removeFromSuperview];
            [_orderButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_offerButton.mas_right);
                make.top.equalTo(_offerButton.superview);
                make.bottom.equalTo(_offerButton.superview);
                make.width.mas_equalTo(_offerButton.frame.size.width);
            }];
            break;
        }
        default:
            break;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [self unRegNotification];
    if (textField == _orderTextField) {
        [self setUserLimit];
    }
    if ([_offerDetailModel.sell_type isEqualToString:@"4"]) {
        //零售售卖时的总价
        [_bottomPriceLabel setText:[NSString stringWithFormat:@"¥%.2f",[_offerDetailModel.shop_price floatValue]*([_orderTextField.text floatValue]/[_offerDetailModel.spec_2 intValue])]];
        
    } else {
        //整柜售卖时的总价
        [_bottomPriceLabel setText:[NSString stringWithFormat:@"¥%.2f",[_offerDetailModel.shop_price floatValue]*[_orderTextField.text intValue]*[_offerDetailModel.goods_weight floatValue]]];
    }
}
#pragma mark register&unregister notification
- (void)regNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)unRegNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark notification handler
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    //    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    CGRect inputFieldRect = self.view.frame;
    inputFieldRect.origin.y += yOffset;
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = inputFieldRect;
    }];
}

- (void)blackViewTapMethod:(UITapGestureRecognizer *)tap{
    [_blackView removeFromSuperview];
    UIView *tmpView = [tap view];
    switch (tmpView.tag-1) {
        case OfferButtonMessage:{
            [_offerShowView removeFromSuperview];
            [_offerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_historyOfferButton.mas_right);
                make.top.equalTo(_offerButton.superview);
                make.bottom.equalTo(_offerButton.superview);
                make.width.mas_equalTo(_orderButton.frame.size.width);
            }];
            break;
        }
        case OrderButtonMessage:{
            [_orderButton setTitle:@"订购" forState:UIControlStateNormal];
            [_orderShowView removeFromSuperview];
            [_orderButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_offerButton.mas_right);
                make.top.equalTo(_offerButton.superview);
                make.bottom.equalTo(_offerButton.superview);
                make.width.mas_equalTo(_offerButton.frame.size.width);
            }];
            break;
        }
        default:
            break;
    }
    [self setBottomButtonUserInteraction:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self setBottomButtonUserInteraction:YES];
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"商品详情界面"];
}
- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self setBottomButtonUserInteraction:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [MobClick endLogPageView:@"商品详情界面"];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
