
//
//  seller_orderDetailViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/13.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "seller_orderDetailViewController.h"
#import "TYDPPhotoPickerManager.h"
#import "TYDP_ConsigneeController.h"
#import "TYDP_AfterServiceController.h"
#import "TYDP_AddCommentController.h"
#import "GetAddressModel.h"
#import "sellerOrderDetailModel.h"
#import "TYDP_OfferDetailViewController.h"
#import "sellerCenterOrderListViewController.h"

typedef enum {
    confirmOrderButtonMessage = 1,
    sellerConsultAddContanctButtonMessage,
    sellerConsultClaimAdjustButtonMessage
}BUTTONMESSAGE;

@interface seller_orderDetailViewController ()
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UIScrollView *baseScrollView;
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)NSArray *testDataArray;
@property(nonatomic, strong)UITextField *specField;

@property(nonatomic, strong)UIButton *confirmOrderButton;
@property(nonatomic, strong)UIButton *refuseOrderButton;

@property(nonatomic, strong)NSArray *bottomOrderDetailArray;
@property(nonatomic, strong)TYDPPhotoPickerManager *photoPickerManager;
@property(nonatomic, strong)MBProgressHUD *testHUD;
@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UIView *middleView;
@property(nonatomic, strong)UILabel *confirmLabel;
@property(nonatomic, strong)UIView *bottomView;
@property(nonatomic, strong)UIView *contanctView;
@property(nonatomic, strong)UIView *sendView;

@property(nonatomic, strong)NSArray *addContanctArray;
@property(nonatomic, strong)NSArray *sendArray;

@property(nonatomic, assign)BOOL contanctViewIsHidden;
@property(nonatomic, strong)NSArray *secondOrderDetailArray;
@property(nonatomic, strong)UIButton *sellerConsultAddContanctButton;
@property(nonatomic, strong)UIButton *sellerConsultClaimAdjustButton;
@property(nonatomic, strong)MBProgressHUD *MBHUD;
@property(nonatomic, strong)NSMutableDictionary *checkOrderModel;
@property(nonatomic, strong)NSMutableDictionary *paymentBigModel;
@property(nonatomic, strong)NSMutableDictionary *orderGoodsModel;
@property(nonatomic, copy)NSString *judgeUIString;
@property(nonatomic, strong)NSMutableArray *orderDetailArray;
@property(nonatomic, strong)NSMutableArray *orderDetailValueArray;
@property(nonatomic, strong)NSMutableArray *addContanctValueArray;
@property(nonatomic, strong)NSMutableArray *sendValueArray;

@property(nonatomic, copy)NSString *refreshFlagString;
@property(nonatomic, copy)NSString *addContanctString;
@property(nonatomic, copy)NSString *addEvidenceString;
@property(nonatomic, assign)NSInteger addEvidenceFlag;

@end

@implementation seller_orderDetailViewController

-(NSArray *)secondOrderDetailArray {
    if (!_secondOrderDetailArray) {
        _secondOrderDetailArray = [NSArray arrayWithObjects:NSLocalizedString(@"Order NO.", nil),NSLocalizedString(@"Order status", nil),NSLocalizedString(@"Payment Method", nil),NSLocalizedString(@"Name of seller", nil),NSLocalizedString(@"Seller's phone NO.", nil), nil];
    }
    return _secondOrderDetailArray;
}
-(NSArray *)testDataArray {
    if (!_testDataArray) {
        _testDataArray = [NSArray arrayWithObjects:@"20160702712345",@"待付款",@"银行转账",@"北京市泰洋国际科技公司",@"中国民生银行北京支行",@"1508019950377",@"中国农业银行",@"王晔",@"622123456789034",@"北京市朝阳区支行", nil];
    }
    return _testDataArray;
}
-(NSArray *)addContanctArray {
    if (!_addContanctArray) {
        _addContanctArray = [NSArray arrayWithObjects:NSLocalizedString(@"Consignee", nil),NSLocalizedString(@"ID number", nil),NSLocalizedString(@"Phone NO.", nil), nil];
    }
    return _addContanctArray;
}
-(NSArray *)sendArray {
    if (!_sendArray) {
        _sendArray = [NSArray arrayWithObjects:NSLocalizedString(@"consogner", nil),NSLocalizedString(@"ID number", nil),NSLocalizedString(@"Phone NO.", nil), nil];
    }
    return _sendArray;
}

-(NSArray *)bottomOrderDetailArray {
    if (!_bottomOrderDetailArray) {
        _bottomOrderDetailArray = [NSArray arrayWithObjects:NSLocalizedString(@"Product summation", nil),NSLocalizedString(@"Amount payable", nil),NSLocalizedString(@"Amount Paid", nil),  nil];
    }
    return _bottomOrderDetailArray;
}
- (void)manageOrderData{
    _orderDetailArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Order NO.", nil),NSLocalizedString(@"Order status", nil),NSLocalizedString(@"Payment Method", nil),NSLocalizedString(@"Inventory status", nil), nil];
    _orderDetailValueArray = [NSMutableArray array];
    [_orderDetailValueArray addObject:[NSString stringWithFormat:@"%@",_checkOrderModel[@"order_sn"]]];
    [_orderDetailValueArray addObject:[NSString stringWithFormat:@"%@",_checkOrderModel[@"order_status_name"]]];
    [_orderDetailValueArray addObject:[NSString stringWithFormat:@"%@",_checkOrderModel[@"pay_name"]]];
    
    if ([_checkOrderModel[@"stock_status"] isEqualToString:@"0"]) {
        [_orderDetailValueArray addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"To be confirmed",nil)]];
        
    }
    else if ([_checkOrderModel[@"stock_status"] isEqualToString:@"1"]) {
        [_orderDetailValueArray addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Confirm shipment",nil)]];
        
    }
    else if ([_checkOrderModel[@"stock_status"] isEqualToString:@"2"]) {
        [_orderDetailValueArray addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Confirm no goods",nil)]];
        
    }
    else
    {
        [_orderDetailValueArray addObject:[NSString stringWithFormat:@""]];
    }

    [self createTopUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createWholeUI];
}
- (void)getOrderData {
    _MBHUD = [[MBProgressHUD alloc] init];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [self.view addSubview:_MBHUD];
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    [_MBHUD show:YES];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller",@"order_info",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"order_info",@"sign":[TYDPManager md5:Sign],@"model":@"seller",@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"order_id":_orderId};
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"ooorderdata:%@",data);
        if (![data[@"error"] intValue]) {
            [_MBHUD hide:YES];
            _checkOrderModel = [[NSMutableDictionary alloc] initWithDictionary:data[@"content"] ];
            debugLog(@"order_status_name:%@",_checkOrderModel[@"order_status_name"]);
            _paymentBigModel = [[NSMutableDictionary alloc] initWithDictionary:_checkOrderModel[@"user_info"]];
            _orderGoodsModel = [[NSMutableDictionary alloc] initWithDictionary:_checkOrderModel[@"goods_info"]];
            [_baseScrollView.mj_header endRefreshing];
            [self manageOrderData];
            
        } else {
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)createWholeUI{
    _addContanctValueArray = [NSMutableArray array];
    _sendValueArray = [NSMutableArray array];

    [self.view setBackgroundColor:RGBACOLOR(239, 239, 239, 1)];
    [self setUpNavigationBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight)];
    
    [self.view addSubview:_baseScrollView];
    _containerView = [UIView new];
    [_baseScrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_baseScrollView);
        make.width.equalTo(_baseScrollView);
    }];
        [self addReFresh];
   
}
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    _navigationBarView.backgroundColor=mainColor;
    [self.view addSubview:_navigationBarView];
    
    
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
    [navigationLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Order detail", nil)]];
    [navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(ScreenWidth/3);
        make.height.mas_equalTo(25);
    }];
}
- (void)topViewTapMethod:(UITapGestureRecognizer *)tap {
    TYDP_OfferDetailViewController *offerDetailViewCon = [[TYDP_OfferDetailViewController alloc] init];
    offerDetailViewCon.goods_id =[NSString stringWithFormat:@"%@", _orderGoodsModel[@"goods_id"]];
    [self.navigationController pushViewController:offerDetailViewCon animated:YES];
}
- (void)createTopUI {
    _contanctViewIsHidden = YES;
    _topView = [UIView new];
    [_topView setBackgroundColor:[UIColor whiteColor]];
    _topView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
    _topView.layer.borderWidth = HomePageBordWidth;
    [_baseScrollView addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.top.equalTo(_baseScrollView);
        make.right.equalTo(_baseScrollView).with.offset(HomePageBordWidth);
        make.height.mas_equalTo(NavHeight*2);
    }];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewTapMethod:)];
//    [_topView addGestureRecognizer:tap];
    UILabel *topLabel = [UILabel new];
    [_topView addSubview:topLabel];
    [topLabel setText:NSLocalizedString(@"Order information", nil)];
    [topLabel setTextColor:[UIColor lightGrayColor]];
    [topLabel setFont:ThemeFont(16)];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.top.equalTo(_baseScrollView);
        make.right.equalTo(_baseScrollView);
        make.height.mas_equalTo(40);
    }];
    UILabel *topDecorateLabel = [UILabel new];
    [topLabel addSubview:topDecorateLabel];
    [topDecorateLabel setBackgroundColor:RGBACOLOR(213, 213, 213, 1)];
    [topDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.top.equalTo(topLabel.mas_bottom).with.offset(-HomePageBordWidth);
        make.right.equalTo(_baseScrollView);
        make.height.mas_equalTo(HomePageBordWidth);
    }];
    UIImageView *leftImageView = [UIImageView new];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_orderGoodsModel[@"goods_thumb"]]] placeholderImage:nil];
    [_topView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);
        make.top.equalTo(topLabel.mas_bottom).with.offset(Gap);
        make.width.equalTo(leftImageView.mas_height);
        make.height.mas_equalTo(68);
    }];
    UILabel *rightTopLabel = [UILabel new];
    [_topView addSubview:rightTopLabel];
    [rightTopLabel setText:[NSString stringWithFormat:@"%@ %@",_orderGoodsModel[@"goods_name"],_orderGoodsModel[@"brand_sn"]]];
    [rightTopLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [rightTopLabel setFont:ThemeFont(18)];
    [rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).with.offset(Gap);
        make.top.equalTo(topLabel.mas_bottom).with.offset(Gap);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(34);
    }];
    UILabel *rightBottomLabel = [UILabel new];
    [_topView addSubview:rightBottomLabel];
    //    [rightBottomLabel setBackgroundColor:[UIColor greenColor]];
    [rightBottomLabel setText:[NSString stringWithFormat:@"¥%@/%@",_orderGoodsModel[@"goods_price"],NSLocalizedString(@"Ton", nil)]];
    [rightBottomLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [rightBottomLabel setFont:ThemeFont(14)];
    [rightBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).with.offset(Gap);
        make.top.equalTo(rightTopLabel.mas_bottom);
        //        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(34);
    }];
//    UILabel *rightBottomMeasureLabel = [UILabel new];
//    [_topView addSubview:rightBottomMeasureLabel];
//    //    [rightBottomMeasureLabel setBackgroundColor:[UIColor redColor]];
//    [rightBottomMeasureLabel setText:@"/吨"];
//    [rightBottomMeasureLabel setTextColor:RGBACOLOR(136, 136, 136, 1)];
//    [rightBottomMeasureLabel setFont:ThemeFont(CommonFontSize)];
//    [rightBottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(rightBottomLabel.mas_right);
//        make.top.equalTo(rightTopLabel.mas_bottom);
//        make.height.mas_equalTo(34);
//    }];
    UILabel *rightBottomSecondLabel = [UILabel new];
    [_topView addSubview:rightBottomSecondLabel];
    //    [rightBottomLabel setBackgroundColor:[UIColor greenColor]];
    
    if ([[NSString stringWithFormat:@"%@",_orderGoodsModel[@"is_retail"]] isEqualToString:@"1"]) {
        [rightBottomSecondLabel setText:[NSString stringWithFormat:@"%@",_orderGoodsModel[@"part_number"]]];
    }
    else
    {
        [rightBottomSecondLabel setText:[NSString stringWithFormat:@"%@",_orderGoodsModel[@"part_weight"]]];
    }

    [rightBottomSecondLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [rightBottomSecondLabel setFont:ThemeFont(14)];
    [rightBottomSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightBottomLabel.mas_right).with.offset(MiddleGap);
        make.top.equalTo(rightTopLabel.mas_bottom);
        //        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(34);
    }];
    UILabel *rightBottomMeasureSecondLabel = [UILabel new];
    [_topView addSubview:rightBottomMeasureSecondLabel];
    //    [rightBottomMeasureLabel setBackgroundColor:[UIColor redColor]];
    [rightBottomMeasureSecondLabel setText:[NSString stringWithFormat:@"%@",_orderGoodsModel[@"part_unit"]]];
    [rightBottomMeasureSecondLabel setTextColor:RGBACOLOR(136, 136, 136, 1)];
    [rightBottomMeasureSecondLabel setFont:ThemeFont(CommonFontSize)];
    [rightBottomMeasureSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightBottomSecondLabel.mas_right);
        make.top.equalTo(rightTopLabel.mas_bottom);
        make.height.mas_equalTo(34);
    }];
    UILabel *rightBottomThirdLabel = [UILabel new];
    [_topView addSubview:rightBottomThirdLabel];
    //    [rightBottomLabel setBackgroundColor:[UIColor greenColor]];
    [rightBottomThirdLabel setText:[NSString stringWithFormat:@"%@",_orderGoodsModel[@"goods_number"]]];
    [rightBottomThirdLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [rightBottomThirdLabel setFont:ThemeFont(18)];
    [rightBottomThirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightBottomMeasureSecondLabel.mas_right).with.offset(MiddleGap);
        make.top.equalTo(rightTopLabel.mas_bottom);
        //        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(34);
    }];
    UILabel *rightBottomMeasureThirdLabel = [UILabel new];
    [_topView addSubview:rightBottomMeasureThirdLabel];
    //    [rightBottomMeasureLabel setBackgroundColor:[UIColor redColor]];
    [rightBottomMeasureThirdLabel setText:[NSString stringWithFormat:@"%@",_orderGoodsModel[@"measure_unit"]]];
    [rightBottomMeasureThirdLabel setTextColor:RGBACOLOR(136, 136, 136, 1)];
    [rightBottomMeasureThirdLabel setFont:ThemeFont(CommonFontSize)];
    [rightBottomMeasureThirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightBottomThirdLabel.mas_right);
        make.top.equalTo(rightTopLabel.mas_bottom);
        make.height.mas_equalTo(34);
    }];
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topView addSubview:selectButton];
    UIImage *selectButtonImage = [UIImage imageNamed:@"icon_next_nor"];
    [selectButton setImage:selectButtonImage forState:UIControlStateNormal];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topView).with.offset(-MiddleGap);
        make.centerY.equalTo(leftImageView);
        make.width.mas_equalTo(MiddleGap);
        make.height.mas_equalTo(MiddleGap*(selectButtonImage.size.height/selectButtonImage.size.width));
    }];
    
        [self createMiddleUIWithFrontViewWithJudgeString:nil];
    
}
-(void)manageRefresh {
    [_contanctView removeFromSuperview];
    [_topView removeFromSuperview];
    [_middleView removeFromSuperview];
    [_bottomView removeFromSuperview];
    _refreshFlagString =[NSString stringWithFormat:@"refreshFlagString"];
    [self getOrderData];
}
- (void)addReFresh {
        [self manageRefresh];
    
}
- (void)createMiddleOrderUIWithArray:(NSArray *)tmpArray WithJudgeString:(NSString *)judgeString{
    CGFloat smallViewHeight = 40;
    [_middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.top.equalTo(_topView.mas_bottom).with.offset(MiddleGap);
        make.right.equalTo(_baseScrollView).with.offset(HomePageBordWidth);
        make.height.mas_equalTo(40*(_orderDetailArray.count+1));
    }];
    for (int i = 0; i < _orderDetailArray.count; i++) {
        UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+smallViewHeight*i, ScreenWidth, smallViewHeight)];
        [_middleView addSubview:smallView];
        UIImageView *dotSmallImageView = [UIImageView new];
        [dotSmallImageView setImage:[UIImage imageNamed:@"ico_filledcircle"]];
        [smallView addSubview:dotSmallImageView];
        [dotSmallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(smallView).with.offset(MiddleGap);
            make.centerY.equalTo(smallView);
            make.width.equalTo(dotSmallImageView.mas_height);
            make.height.mas_equalTo(7);
        }];
        UILabel *leftLabel = [UILabel new];
        [smallView addSubview:leftLabel];
        [leftLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [leftLabel setFont: ThemeFont(16)];
        [leftLabel setText:tmpArray[i]];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dotSmallImageView.mas_right).with.offset(Gap);
            make.top.equalTo(smallView);
            make.width.mas_equalTo(150);
            make.bottom.equalTo(smallView);
        }];
        UILabel *rightLabel = [UILabel new];
        [smallView addSubview:rightLabel];
        [rightLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [rightLabel setFont: ThemeFont(16)];
        [rightLabel setText:_orderDetailValueArray[i]];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.mas_right);
            make.top.equalTo(smallView);
            make.width.mas_equalTo(ScreenWidth);
            make.bottom.equalTo(smallView);
        }];
        if (i == 5) {
            UILabel *decorateBottomLabel = [UILabel new];
            [decorateBottomLabel setText:@"------------------------------------------------------"];
            [decorateBottomLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
            [smallView addSubview:decorateBottomLabel];
            [decorateBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_baseScrollView).with.offset(MiddleGap);
                make.right.equalTo(_baseScrollView);
                make.bottom.equalTo(smallView);
                make.height.mas_equalTo(3);
            }];
        }
    }
}
- (void)createMiddleUIWithFrontViewWithJudgeString:(NSString *)judgeString {
    _middleView = [UIView new];
    _middleView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
    _middleView.layer.borderWidth = HomePageBordWidth;
    [_middleView setBackgroundColor:[UIColor whiteColor]];
    [_baseScrollView addSubview:_middleView];
    CGFloat middleViewWidth = ScreenHeight/2+MiddleGap;
    CGFloat smallViewHeight = 40;
    UILabel *topLabel = [UILabel new];
    [_middleView addSubview:topLabel];
    [topLabel setText:NSLocalizedString(@"Order information", nil)];
    [topLabel setTextColor:[UIColor lightGrayColor]];
    [topLabel setFont:ThemeFont(16)];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.top.equalTo(_topView.mas_bottom).with.offset(MiddleGap);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    UILabel *topDecorateLabel = [UILabel new];
    [topLabel addSubview:topDecorateLabel];
    [topDecorateLabel setBackgroundColor:RGBACOLOR(213, 213, 213, 1)];
    [topDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.top.equalTo(topLabel.mas_bottom).with.offset(-HomePageBordWidth);
        make.right.equalTo(_baseScrollView);
        make.height.mas_equalTo(HomePageBordWidth);
    }];
    
    [_orderDetailArray addObject:NSLocalizedString(@"Name of seller", nil)];
    [_orderDetailArray addObject:NSLocalizedString(@"Seller's phone NO.", nil)];
                [_orderDetailValueArray addObject:_paymentBigModel[@"name"]];
                [_orderDetailValueArray addObject:_paymentBigModel[@"mobile"]];
    debugLog(@"_orderDetailValueArraylll:%@",_orderDetailValueArray);
        [_middleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
            make.top.equalTo(_topView.mas_bottom).with.offset(MiddleGap);
            make.right.equalTo(_baseScrollView).with.offset(HomePageBordWidth);
            make.height.mas_equalTo(40*(_orderDetailArray.count+1));
        }];
        for (int i = 0; i < _orderDetailArray.count; i++) {
            UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+smallViewHeight*i, ScreenWidth, smallViewHeight)];
            [_middleView addSubview:smallView];
            UILabel *leftLabel = [UILabel new];
            [smallView addSubview:leftLabel];
            [leftLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
            [leftLabel setFont: ThemeFont(16)];
            [leftLabel setText:_orderDetailArray[i]];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(smallView).with.offset(MiddleGap);
                make.top.equalTo(smallView);
                make.width.mas_equalTo(200);
                make.bottom.equalTo(smallView);
            }];
            UILabel *rightLabel = [UILabel new];
            [smallView addSubview:rightLabel];
            rightLabel.numberOfLines = 0;
            [rightLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
            [rightLabel setFont: ThemeFont(16)];[rightLabel setText:_orderDetailValueArray[i]];
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLabel.mas_right);
                make.top.equalTo(smallView);
                make.width.mas_equalTo(ScreenWidth);
                make.bottom.equalTo(smallView);
            }];

        }
    
    //jeasoncode
    if (![[NSString stringWithFormat:@"%@",_checkOrderModel[@"get_address"][@"name"]] isEqualToString:@""]) {
        [self createAddContanctViewWithFrontView:_middleView];
    }
    else if (![[NSString stringWithFormat:@"%@",_checkOrderModel[@"send_address"][@"name"]] isEqualToString:@""]) {
        [self SendCreateAddContanctViewWithFrontView:_middleView];
    }
    else{
        [self createBottomViewWithFrontView:_middleView];
    }
    
}
- (void)createAddContanctViewWithFrontView:(UIView *)frontView {
    _contanctView = [UIView new];
    [_baseScrollView addSubview:_contanctView];
    [_contanctView setBackgroundColor:[UIColor whiteColor]];
    _contanctView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
    _contanctView.layer.borderWidth = HomePageBordWidth;
    CGFloat tmpHeight = 0.00;
    if (_checkOrderModel[@"get_address"]) {
        _contanctViewIsHidden = NO;
        [_addContanctValueArray addObject:[NSString stringWithFormat:@"%@",_checkOrderModel[@"get_address"][@"name"]]];
        [_addContanctValueArray addObject:[NSString stringWithFormat:@"%@",_checkOrderModel[@"get_address"][@"id_number"]]];
        [_addContanctValueArray addObject:[NSString stringWithFormat:@"%@",_checkOrderModel[@"get_address"][@"mobile"]]];
    } else {
        [_addContanctValueArray addObject:@"暂无"];
        [_addContanctValueArray addObject:@"暂无"];
        [_addContanctValueArray addObject:@"暂无"];
    }
    if (!_contanctViewIsHidden) {
        tmpHeight = 40*4;
    }
    [_contanctView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.top.equalTo(frontView.mas_bottom).with.offset(MiddleGap);
        make.right.equalTo(_baseScrollView.mas_right).with.offset(HomePageBordWidth);
        make.height.mas_equalTo(tmpHeight);
    }];
    UILabel *topLabel = [UILabel new];
    [_contanctView addSubview:topLabel];
    [topLabel setText:NSLocalizedString(@"Information of consignee", nil)];
    [topLabel setTextColor:[UIColor lightGrayColor]];
    [topLabel setFont:ThemeFont(16)];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.top.equalTo(frontView.mas_bottom).with.offset(MiddleGap);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    UILabel *topDecorateLabel = [UILabel new];
    [topLabel addSubview:topDecorateLabel];
    [topDecorateLabel setBackgroundColor:RGBACOLOR(213, 213, 213, 1)];
    [topDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.top.equalTo(topLabel.mas_bottom).with.offset(-HomePageBordWidth);
        make.right.equalTo(_baseScrollView);
        make.height.mas_equalTo(HomePageBordWidth);
    }];
    CGFloat smallViewHeight = 40;
    for (int i = 0; i < 3; i++) {
        UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+smallViewHeight*i, ScreenWidth, smallViewHeight)];
        [_contanctView addSubview:smallView];
        UILabel *leftLabel = [UILabel new];
        [smallView addSubview:leftLabel];
        [leftLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [leftLabel setFont: ThemeFont(16)];
        [leftLabel setText:self.addContanctArray[i]];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(smallView).with.offset(MiddleGap);
            make.top.equalTo(smallView);
            make.bottom.equalTo(smallView);
        }];
        UILabel *rightLabel = [UILabel new];
        [smallView addSubview:rightLabel];
        [rightLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [rightLabel setFont: ThemeFont(16)];
        [rightLabel setText:_addContanctValueArray[i]];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.mas_right);
            make.top.equalTo(smallView);
            make.bottom.equalTo(smallView);
        }];
    }
    if (![[NSString stringWithFormat:@"%@",_checkOrderModel[@"send_address"][@"name"]] isEqualToString:@""]) {
        [self SendCreateAddContanctViewWithFrontView:_contanctView];
    }
    else{
        [self createBottomViewWithFrontView:_contanctView];
    }
}

- (void)SendCreateAddContanctViewWithFrontView:(UIView *)frontView {
    _sendView = [UIView new];
    [_baseScrollView addSubview:_sendView];
    [_sendView setBackgroundColor:[UIColor whiteColor]];
    _sendView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
    _sendView.layer.borderWidth = HomePageBordWidth;
    CGFloat tmpHeight = 0.00;
    if (_checkOrderModel[@"send_address"]) {
        [_sendValueArray addObject:[NSString stringWithFormat:@"%@",_checkOrderModel[@"send_address"][@"name"]]];
        [_sendValueArray addObject:[NSString stringWithFormat:@"%@",_checkOrderModel[@"send_address"][@"id_number"]]];
        [_sendValueArray addObject:[NSString stringWithFormat:@"%@",_checkOrderModel[@"send_address"][@"mobile"]]];
    } else {
        [_sendValueArray addObject:@"暂无"];
        [_sendValueArray addObject:@"暂无"];
        [_sendValueArray addObject:@"暂无"];
    }
        tmpHeight = 40*4;
    
    [_sendView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.top.equalTo(frontView.mas_bottom).with.offset(MiddleGap);
        make.right.equalTo(_baseScrollView.mas_right).with.offset(HomePageBordWidth);
        make.height.mas_equalTo(tmpHeight);
    }];
    UILabel *topLabel = [UILabel new];
    [_sendView addSubview:topLabel];
    [topLabel setText:NSLocalizedString(@"Information of consogner", nil)];
    [topLabel setTextColor:[UIColor lightGrayColor]];
    [topLabel setFont:ThemeFont(16)];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.top.equalTo(frontView.mas_bottom).with.offset(MiddleGap);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    UILabel *topDecorateLabel = [UILabel new];
    [topLabel addSubview:topDecorateLabel];
    [topDecorateLabel setBackgroundColor:RGBACOLOR(213, 213, 213, 1)];
    [topDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.top.equalTo(topLabel.mas_bottom).with.offset(-HomePageBordWidth);
        make.right.equalTo(_baseScrollView);
        make.height.mas_equalTo(HomePageBordWidth);
    }];
    CGFloat smallViewHeight = 40;
    for (int i = 0; i < 3; i++) {
        UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+smallViewHeight*i, ScreenWidth, smallViewHeight)];
        [_sendView addSubview:smallView];
        UILabel *leftLabel = [UILabel new];
        [smallView addSubview:leftLabel];
        [leftLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [leftLabel setFont: ThemeFont(16)];
        [leftLabel setText:self.sendArray[i]];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(smallView).with.offset(MiddleGap);
            make.top.equalTo(smallView);
            make.bottom.equalTo(smallView);
        }];
        UILabel *rightLabel = [UILabel new];
        [smallView addSubview:rightLabel];
        [rightLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [rightLabel setFont: ThemeFont(16)];
        [rightLabel setText:self.sendValueArray[i]];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.mas_right);
            make.top.equalTo(smallView);
            make.bottom.equalTo(smallView);
        }];
    }
    [self createBottomViewWithFrontView:_sendView];
}

- (void)createBottomViewWithFrontView:(UIView *)frontView {        CGFloat tmpGap = MiddleGap;
    _bottomView = [UIView new];
    [_baseScrollView addSubview:_bottomView];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    _bottomView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
    _bottomView.layer.borderWidth = HomePageBordWidth;
    int count =2;
    if ([[NSString stringWithFormat:@"%@",_checkOrderModel[@"order_status"]] isEqualToString:@"1"]) {
        count=3;
    }
    [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.top.equalTo(frontView.mas_bottom).with.offset(tmpGap);
        make.right.equalTo(_baseScrollView.mas_right).with.offset(HomePageBordWidth);
        make.height.mas_equalTo(40*(count+1));
    }];
    UILabel *topLabel = [UILabel new];
    [_bottomView addSubview:topLabel];
    [topLabel setText:NSLocalizedString(@"Details of charges", nil)];
    [topLabel setTextColor:[UIColor lightGrayColor]];
    [topLabel setFont:ThemeFont(16)];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.top.equalTo(frontView.mas_bottom).with.offset(tmpGap);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    UILabel *topDecorateLabel = [UILabel new];
    [topLabel addSubview:topDecorateLabel];
    [topDecorateLabel setBackgroundColor:RGBACOLOR(213, 213, 213, 1)];
    [topDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.top.equalTo(topLabel.mas_bottom).with.offset(-HomePageBordWidth);
        make.right.equalTo(_baseScrollView);
        make.height.mas_equalTo(HomePageBordWidth);
    }];
    CGFloat smallViewHeight = 40;
   
    for (int i = 0; i < count; i++) {
        UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+smallViewHeight*i, ScreenWidth, smallViewHeight)];
        [_bottomView addSubview:smallView];
        UILabel *leftLabel = [UILabel new];
        [smallView addSubview:leftLabel];
        [leftLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [leftLabel setFont: ThemeFont(16)];
        [leftLabel setText:self.bottomOrderDetailArray[i]];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(smallView).with.offset(MiddleGap);
            make.top.equalTo(smallView);
            make.bottom.equalTo(smallView);
        }];
        UILabel *rightLabel = [UILabel new];
        [smallView addSubview:rightLabel];
        [rightLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [rightLabel setFont: ThemeFont(16)];
        if (i == 0) {
            [rightLabel setText:[NSString stringWithFormat:@"¥%@",_checkOrderModel[@"goods_amount"]]];
        } else if (i == 1) {
            [rightLabel setText:[NSString stringWithFormat:@"¥%@",_checkOrderModel[@"order_amount"]]];
        }else
        {
        [rightLabel setText:[NSString stringWithFormat:@"%@",_checkOrderModel[@"money_paid"]]];
        }
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(smallView).with.offset(-MiddleGap);
            make.top.equalTo(smallView);
            make.bottom.equalTo(smallView);
        }];
        if (i == 1) {
            [rightLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
        }
        if (i == 2) {
            [rightLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
        }
    }
    //创建底部按钮
    if ([[NSString stringWithFormat:@"%@",_checkOrderModel[@"stock_status"]] isEqualToString:@"0"])
    {
        
        if (!_specField) {
            _specField = [UITextField new];
            [self.view addSubview:_specField];
            _specField.backgroundColor=[UIColor whiteColor];
            _specField.placeholder=NSLocalizedString(@"Please input memo information", nil);
            [_specField setFont:ThemeFont(15)];
            [_specField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).with.offset(-TabbarHeight);
                make.width.mas_equalTo(ScreenWidth);
                make.right.equalTo(self.view);
                make.height.mas_equalTo(TabbarHeight);
            }];
        }
    if (!_confirmOrderButton) {
        
            _addEvidenceFlag = 0;
            _confirmOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _confirmOrderButton.tag = 1;
            [self.view addSubview:_confirmOrderButton];
            [_confirmOrderButton addTarget:self action:@selector(bottomControlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_confirmOrderButton setBackgroundColor:mainColor];
            [_confirmOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _refuseOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _refuseOrderButton.tag = 2;
        [self.view addSubview:_refuseOrderButton];
        [_refuseOrderButton addTarget:self action:@selector(refuseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_refuseOrderButton setBackgroundColor:[UIColor grayColor]];
        [_refuseOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
                [_confirmOrderButton setTitle:NSLocalizedString(@"Confirm shipment", nil) forState:UIControlStateNormal];
                [_refuseOrderButton setTitle:NSLocalizedString(@"Confirm no goods", nil) forState:UIControlStateNormal];
        
            
            [_confirmOrderButton.titleLabel setFont:ThemeFont(15)];
            [_confirmOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
                make.width.mas_equalTo(ScreenWidth/2);
                make.right.equalTo(self.view);
                make.height.mas_equalTo(TabbarHeight);
            }];
        
        [_refuseOrderButton.titleLabel setFont:ThemeFont(15)];
        [_refuseOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.mas_equalTo(ScreenWidth/2);
            make.height.mas_equalTo(TabbarHeight);
        }];

        _baseScrollView.frame = CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight-TabbarHeight*2-1);

    }
    }
    
    if ([[NSString stringWithFormat:@"%@",_checkOrderModel[@"buyer_seller_edit"]] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",_checkOrderModel[@"stock_status"]] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",_checkOrderModel[@"send_address"][@"name"]] isEqualToString:@""])
    {
        
        if (!_confirmOrderButton) {
            
            _addEvidenceFlag = 0;
            _confirmOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _confirmOrderButton.tag = 1;
            [self.view addSubview:_confirmOrderButton];
            [_confirmOrderButton addTarget:self action:@selector(bottomControlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_confirmOrderButton setBackgroundColor:mainColor];
            [_confirmOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [_confirmOrderButton setTitle:NSLocalizedString(@"Add consogner information", nil) forState:UIControlStateNormal];
            
            [_confirmOrderButton.titleLabel setFont:ThemeFont(15)];
            [_confirmOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
                make.width.mas_equalTo(ScreenWidth);
                make.right.equalTo(self.view);
                make.height.mas_equalTo(TabbarHeight);
            }];
            
            
            //            if ([_checkOrderModel.buyer_seller_edit isEqualToString:@"1"]) {
            //                [_confirmOrderButton setTitle:@"＋添加取货人信息" forState:UIControlStateNormal];
            //                _confirmOrderButton.hidden = NO;
            //            } else if(_addEvidenceFlag == 0) {
            //                _confirmOrderButton.hidden = NO;
            //            }
            //            else {
            //                _confirmOrderButton.hidden = YES;
            //            }
            //            //如果值为非空 则添加过联系人 下面的button改变状态
            //            if (_checkOrderModel.get_address||[_addContanctString isEqualToString:@"added"]) {
            //                _confirmOrderButton.hidden = NO;
            //                [_confirmOrderButton setTitle:@"理赔" forState:UIControlStateNormal];
            //            }
            
            
        }
        _baseScrollView.frame = CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight-TabbarHeight);
    }
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomView);
    }];
}

- (void)refuseButtonClicked:(UIButton *)button {
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller",@"stock_status",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"stock_status",@"sign":[TYDPManager md5:Sign],@"model":@"seller",@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"order_id":_orderId,@"stock_remark":_specField.text,@"stock_status":[NSString stringWithFormat:@"%ld",(long)button.tag]};
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        NSLog(@"sureorderdata:%@",data);
        if (![data[@"error"] intValue]) {
            _MBHUD.labelText = [NSString stringWithFormat:@"%@",data[@"message"]];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
//            [ self.navigationController popViewControllerAnimated:YES];
            
            //跳转新的页面
            seller_orderDetailViewController *CommitEvidenceVC = [seller_orderDetailViewController new];
            CommitEvidenceVC.orderId = self.orderId;
            CommitEvidenceVC.popMore=YES;
            [self.navigationController pushViewController:CommitEvidenceVC animated:YES];
        } else {
            _MBHUD.labelText = [NSString stringWithFormat:@"%@",data[@"message"]];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)bottomControlButtonClicked:(UIButton *)button {
    switch (button.tag) {
        case 1:{
            if ([_confirmOrderButton.titleLabel.text isEqualToString:NSLocalizedString(@"Confirm shipment", nil)]) {
                [self refuseButtonClicked:button];
            }
           
            else {
                //添加联系人
                [self addContanctMethod];
//                _confirmOrderButton.hidden = YES;
            }
            break;
        }
        
        default:
            break;
    }
}
- (void)addContanctMethod {
    TYDP_ConsigneeController *consigneeCon = [[TYDP_ConsigneeController alloc] init];
    consigneeCon.pushType = 0;
    consigneeCon.type=[[PSDefaults objectForKey:@"userType"] isEqualToString:@"0"]?0:1;
    consigneeCon.addAddressInfoBlock = ^(NSDictionary *dic) {
        NSLog(@"dic:%@", dic);
        [self uploadContanctInfoWithAddressId:dic[@"address_id"] andTransferState:dic[@"yunfei"]];
       
//        _confirmOrderButton.hidden = YES;
    };
   
    [self.navigationController pushViewController:consigneeCon animated:YES];
}
- (void)uploadContanctInfoWithAddressId:(NSString *)addressId andTransferState:(NSString *)transferWay{
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"order",@"save_order_address",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"save_order_address",@"sign":[TYDPManager md5:Sign],@"model":@"order",@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"order_id":_orderId,@"address_id":addressId,@"type":@"1"};
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        NSLog(@"data:%@",data[@"message"]);
        if (![data[@"error"] intValue]) {
            //跳转新的页面
            seller_orderDetailViewController *CommitEvidenceVC = [seller_orderDetailViewController new];
            CommitEvidenceVC.orderId = self.orderId;
            CommitEvidenceVC.popMore=YES;
            [self.navigationController pushViewController:CommitEvidenceVC animated:YES];
        } else {
            _MBHUD.labelText = [NSString stringWithFormat:@"%@",data[@"message"]];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)leftItemClicked:(UIBarButtonItem *)item{
    if (_popMore) {
        for (UIViewController * vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[sellerCenterOrderListViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }

        return;

    }
            [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"订单详情界面"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [MobClick endLogPageView:@"订单详情界面"];
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
