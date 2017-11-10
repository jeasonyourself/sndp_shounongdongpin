//
//  TYDP_CommitEvidenceViewController.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/28.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_CommitEvidenceViewController.h"
#import "TYDPPhotoPickerManager.h"
#import "TYDP_ConsigneeController.h"
#import "TYDP_AfterServiceController.h"
#import "TYDP_AddCommentController.h"
#import "GetAddressModel.h"
#import "CheckOrderModel.h"
#import "TYDP_OfferDetailViewController.h"
#import "TYDP_IndentController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "APAuthV2Info.h"
typedef enum {
    confirmOrderButtonMessage = 1,
    sellerConsultAddContanctButtonMessage,
    sellerConsultClaimAdjustButtonMessage
}BUTTONMESSAGE;

@interface TYDP_CommitEvidenceViewController ()<UIActionSheetDelegate>
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UIScrollView *baseScrollView;
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)NSArray *testDataArray;
@property(nonatomic, strong)UIButton *confirmOrderButton;
@property(nonatomic, strong)UIButton *qieButton;
@property(nonatomic, strong)UIView *sendView;
@property(nonatomic, strong)NSMutableArray *sendValueArray;
@property(nonatomic, strong)NSArray *sendArray;

@property(nonatomic, strong)NSArray *bottomOrderDetailArray;
@property(nonatomic, strong)NSArray *bankArray;

@property(nonatomic, strong)TYDPPhotoPickerManager *photoPickerManager;
@property(nonatomic, strong)MBProgressHUD *testHUD;
@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UIView *middleView;
@property(nonatomic, strong)UILabel *confirmLabel;
@property(nonatomic, strong)UIView *bottomView;
@property(nonatomic, strong)UIView *bankView;

@property(nonatomic, strong)UIView *contanctView;
@property(nonatomic, strong)NSArray *addContanctArray;
@property(nonatomic, assign)BOOL contanctViewIsHidden;
@property(nonatomic, strong)NSArray *secondOrderDetailArray;

@property(nonatomic, strong)UIButton *sellerConsultAddContanctButton;
@property(nonatomic, strong)UIButton *sellerConsultClaimAdjustButton;
@property(nonatomic, strong)MBProgressHUD *MBHUD;
@property(nonatomic, strong)NSMutableDictionary *checkOrderModel;
@property(nonatomic, strong)NSMutableDictionary *paymentBigModel;
@property(nonatomic, strong)NSMutableDictionary *orderGoodsModel;
//@property(nonatomic, copy)NSString *judgeUIString;
@property(nonatomic, strong)NSMutableArray *orderDetailArray;
@property(nonatomic, strong)NSMutableArray *orderDetailValueArray;
@property(nonatomic, strong)NSMutableArray *addContanctValueArray;
@property(nonatomic, copy)NSString *refreshFlagString;
@property(nonatomic, copy)NSString *addContanctString;
@property(nonatomic, copy)NSString *addEvidenceString;
@property(nonatomic, assign)NSInteger addEvidenceFlag;
@end

@implementation TYDP_CommitEvidenceViewController
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
        _sendArray = [NSArray arrayWithObjects:NSLocalizedString(@"consigner", nil),NSLocalizedString(@"ID number", nil),NSLocalizedString(@"Phone NO.", nil), nil];
    }
    return _sendArray;
}
-(NSArray *)bottomOrderDetailArray {
    if (!_bottomOrderDetailArray) {
        _bottomOrderDetailArray = [NSArray arrayWithObjects:NSLocalizedString(@"Product sum", nil),NSLocalizedString(@"Balance", nil),NSLocalizedString(@"Amount Paid", nil),  nil];
    }
    return _bottomOrderDetailArray;
}

-(NSArray *)bankArray {
    if (!_bankArray) {
        _bankArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Payee", nil),NSLocalizedString(@"Bank Card No.", nil),NSLocalizedString(@"Opening Bank", nil),  nil];
    }
    return _bankArray;
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
        [_orderDetailValueArray addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"In stock",nil)]];
        
    }
    else if ([_checkOrderModel[@"stock_status"] isEqualToString:@"2"]) {
        [_orderDetailValueArray addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Out of stock",nil)]];
        
    }
    else
    {
    [_orderDetailValueArray addObject:[NSString stringWithFormat:@""]];
    }
//    [_orderDetailValueArray addObject:[NSString stringWithFormat:@"%@",_checkOrderModel[@"stock_status_tag"]]];

    [self createTopUI];
}

#pragma mark viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AliPay) name:AlipayNotificationName object:nil];

    _confirmOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmOrderButton.tag = confirmOrderButtonMessage;
    [self.view addSubview:_confirmOrderButton];
    [_confirmOrderButton setBackgroundColor:mainColor];
    [_confirmOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmOrderButton.hidden=YES;
    [_confirmOrderButton.titleLabel setFont:ThemeFont(18)];
    
    _qieButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //            _qieButton.tag = confirmOrderButtonMessage;
    [self.view addSubview:_qieButton];
    [_qieButton setBackgroundColor:mainColor];
    [_qieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _qieButton.hidden=YES;
    [_qieButton.titleLabel setFont:ThemeFont(18)];
    

    
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
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"order",@"order_info",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"order_info",@"sign":[TYDPManager md5:Sign],@"model":@"order",@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"order_id":_orderId};
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"ooorderdata:%@",data);
        if (![data[@"error"] intValue]) {
            [_MBHUD hide:YES];
            _checkOrderModel = [[NSMutableDictionary alloc] initWithDictionary:data[@"content"] ];
            
            debugLog(@"order_status_name:%@",_checkOrderModel[@"order_status_name"]);
            _paymentBigModel = [[NSMutableDictionary alloc] initWithDictionary:_checkOrderModel[@"user_info"]];
            _orderGoodsModel = [[NSMutableDictionary alloc] initWithDictionary:_checkOrderModel[@"goods_info"]];
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
//    if ([_orderSourceString isEqualToString:@"personalCenter"]) {
        [self addReFresh];
//    } else{
//        [self getOrderData];
//    }
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
    [navigationLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Order details", nil)]];
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
    _addContanctValueArray = [NSMutableArray array];

    _sendValueArray = [NSMutableArray array];

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
    [topLabel setText:NSLocalizedString(@"Product information", nil)];
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
    [rightTopLabel setText:[NSString stringWithFormat:@"%@  %@",_orderGoodsModel[@"goods_name"],_orderGoodsModel[@"brand_sn"]]];
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
    [rightBottomLabel setText:[NSString stringWithFormat:@"%@/%@",_orderGoodsModel[@"goods_price"],NSLocalizedString(@"MT", nil)]];
    [rightBottomLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [rightBottomLabel setFont:ThemeFont(14)];
    [rightBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).with.offset(Gap);
        make.top.equalTo(rightTopLabel.mas_bottom);
        //        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(34);
    }];
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
        [self createMiddleUIWithFrontViewWithJudgeString:@""];

}
-(void)manageRefresh {
    [_contanctView removeFromSuperview];
    [_topView removeFromSuperview];
    [_middleView removeFromSuperview];
    [_bottomView removeFromSuperview];
    
    [self getOrderData];
    
//    if (!_addEvidenceFlag){
//        _confirmOrderButton.hidden = NO;
//    }
}
- (void)addReFresh {
    [self manageRefresh];
//    _baseScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self manageRefresh];
//        _addEvidenceString = 0;
//    }];
}
- (void)createMiddleUIWithFrontViewWithJudgeString:(NSString *)judgeString {
    _middleView = [UIView new];
    _middleView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
    _middleView.layer.borderWidth = HomePageBordWidth;
    [_middleView setBackgroundColor:[UIColor whiteColor]];
    [_baseScrollView addSubview:_middleView];
    CGFloat middleViewWidth = ScreenHeight/2+MiddleGap;
    CGFloat smallViewHeight = 40;
    middleViewWidth = middleViewWidth - smallViewHeight*4;
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
        if (![[NSString stringWithFormat:@"%@",_checkOrderModel[@"user_info"][@"name"]] isEqualToString:@""]&&![[NSString stringWithFormat:@"%@",_checkOrderModel[@"stock_status"]] isEqualToString:@"0"]) {//订单不是待确认
            [_orderDetailArray addObject:NSLocalizedString(@"Name of seller", nil)];
            [_orderDetailArray addObject:NSLocalizedString(@"Seller's phone NO.", nil)];
                [_orderDetailValueArray addObject:_paymentBigModel[@"name"]];
                [_orderDetailValueArray addObject:_paymentBigModel[@"mobile"]];
           
//            [self createMiddleOrderUIWithArray:_orderDetailArray WithJudgeString:judgeString];
        }
//        else {//付款到平台UI
//            [self createMiddleOrderUIWithArray:_orderDetailArray WithJudgeString:judgeString];
//        }
    
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
                make.width.mas_equalTo(150);
                make.bottom.equalTo(smallView);
            }];
            UILabel *rightLabel = [UILabel new];
            [smallView addSubview:rightLabel];
            rightLabel.numberOfLines = 0;
            [rightLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
            [rightLabel setFont: ThemeFont(16)];
            [rightLabel setText:_orderDetailValueArray[i]];
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLabel.mas_right);
                make.top.equalTo(smallView);
                make.width.mas_equalTo(ScreenWidth);
                make.bottom.equalTo(smallView);
            }];
            if (i == 1) {
                _confirmLabel = [UILabel new];
                [smallView addSubview:_confirmLabel];
                [_confirmLabel setFont: ThemeFont(16)];
                [_confirmLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
                [_confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(rightLabel).with.offset(55);
                    make.top.equalTo(smallView);
                    make.bottom.equalTo(smallView);
                }];
                if ([[NSString stringWithFormat:@"%@",_checkOrderModel[@"pay_check"]] isEqualToString:@"1"]) {
                    [_confirmLabel setText:[NSString stringWithFormat:@"【%@】",NSLocalizedString(@"Confirmation", nil)]];
                } else{
                    [_confirmLabel setText:@""];
                }
            }
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
    }}

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
    [topLabel setText:NSLocalizedString(@"Information of consigner", nil)];
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
- (void)createBottomViewWithFrontView:(UIView *)frontView {
    CGFloat tmpGap = 0;
    if (_contanctViewIsHidden) {
        tmpGap = MiddleGap;
    } else {
        tmpGap = MiddleGap;
    }
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
            [rightLabel setText:[NSString stringWithFormat:@"%@",_checkOrderModel[@"goods_amount"]]];
        } else if (i == 1) {
            [rightLabel setText:[NSString stringWithFormat:@"%@",_checkOrderModel[@"order_amount"]]];
        }else
        {
            [rightLabel setText:[NSString stringWithFormat:@"%@",_checkOrderModel[@"money_paid"]]];
        }
        //
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
    
    if (_checkOrderModel[@"bank"][@"account"]&&![[NSString stringWithFormat:@"%@",_checkOrderModel[@"bank"][@"account"]] isEqualToString:@""]&&[[NSString stringWithFormat:@"%@",_checkOrderModel[@"stock_status"]] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",_checkOrderModel[@"pay_id"]] isEqualToString:@"2"]) {
        [self BBankViewWithFrontView:_bottomView];
    }
    else
    {
    [self creatBottomBtnUI];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_bottomView);
        }];
    }
   
}


- (void)BBankViewWithFrontView:(UIView *)frontView {
    CGFloat tmpGap = 0;
    if (_contanctViewIsHidden) {
        tmpGap = MiddleGap;
    } else {
        tmpGap = MiddleGap;
    }
    _bankView = [UIView new];
    [_baseScrollView addSubview:_bankView];
    [_bankView setBackgroundColor:[UIColor whiteColor]];
    _bankView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
    _bankView.layer.borderWidth = HomePageBordWidth;
    int count =3;
       [_bankView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.top.equalTo(frontView.mas_bottom).with.offset(tmpGap);
        make.right.equalTo(_baseScrollView.mas_right).with.offset(HomePageBordWidth);
        make.height.mas_equalTo(40*(count+1));
    }];
    UILabel *topLabel = [UILabel new];
    [_bankView addSubview:topLabel];
    [topLabel setText:NSLocalizedString(@"Opening Bank", nil)];
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
        [_bankView addSubview:smallView];
        UILabel *leftLabel = [UILabel new];
        [smallView addSubview:leftLabel];
        [leftLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [leftLabel setFont: ThemeFont(16)];
        [leftLabel setText:self.bankArray[i]];
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
            [rightLabel setText:[NSString stringWithFormat:@"%@",_checkOrderModel[@"bank"][@"username"]]];
        } else if (i == 1) {
            [rightLabel setText:[NSString stringWithFormat:@"%@",_checkOrderModel[@"bank"][@"account"]]];
        }else
        {
            [rightLabel setText:[NSString stringWithFormat:@"%@",_checkOrderModel[@"bank"][@"deposit_bank"]]];
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
    
    
    [self creatBottomBtnUI];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bankView);
    }];
}



-(void)creatBottomBtnUI
{
#pragma mark 底部按钮
    if ([[NSString stringWithFormat:@"%@",_checkOrderModel[@"stock_status"]] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",_checkOrderModel[@"apply_pay"]] isEqualToString:@"1"])//对方已确认有货，可以上传凭证了
    {
        
        [_confirmOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmOrderButton setTitle:NSLocalizedString(@"Upload payment receipt", nil) forState:UIControlStateNormal];
        [_confirmOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(TabbarHeight);
        }];
        
        _confirmOrderButton.tag=100;
        [_confirmOrderButton addTarget:self action:@selector(changeorder:) forControlEvents:UIControlEventTouchUpInside];
        _confirmOrderButton.hidden = NO;
        
        if ([[NSString stringWithFormat:@"%@",_checkOrderModel[@"order_status"]] isEqualToString:@"0"]) {
            [_qieButton addTarget:self action:@selector(qieButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            _qieButton.tag=200;
            [_qieButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_confirmOrderButton.mas_top).with.offset(-1);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.height.mas_equalTo(TabbarHeight);
            }];
            [_qieButton setTitle:NSLocalizedString(@"Choose payment method", nil) forState:UIControlStateNormal];
            _qieButton.hidden = NO;
             _baseScrollView.frame= CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight-TabbarHeight*2-1);
        }
        else
        {
            _qieButton.hidden = YES;
            _baseScrollView.frame= CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight-TabbarHeight);
        }
        
        
       
    }
    
    if ([[NSString stringWithFormat:@"%@",_checkOrderModel[@"buyer_seller_edit"]] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",_checkOrderModel[@"stock_status"]] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",_checkOrderModel[@"get_address"][@"name"]] isEqualToString:@""])//可以填写收货地址了
    {
        
        [_confirmOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmOrderButton setTitle:NSLocalizedString(@"Add consignee information", nil) forState:UIControlStateNormal];
        _confirmOrderButton.tag=101;
        [_confirmOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(TabbarHeight);
        }];
        
        [_confirmOrderButton addTarget:self action:@selector(changeorder:) forControlEvents:UIControlEventTouchUpInside];
        _confirmOrderButton.hidden = NO;
        
        _baseScrollView.frame= CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight-TabbarHeight);
        
        if ([[NSString stringWithFormat:@"%@",_checkOrderModel[@"order_status"]] isEqualToString:@"99"])//可以理赔
        {
            [_qieButton addTarget:self action:@selector(qieButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_qieButton setTitle:NSLocalizedString(@"Claims", nil) forState:UIControlStateNormal];
            _qieButton.hidden = NO;
            _qieButton.tag=201;
            [_qieButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_confirmOrderButton.mas_top).with.offset(-1);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.height.mas_equalTo(TabbarHeight);
            }];
            _baseScrollView.frame= CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight-TabbarHeight*2-1);
            
        }
    }
    else
    {
        if (![[NSString stringWithFormat:@"%@",_checkOrderModel[@"stock_status"]] isEqualToString:@"2"]&&[[NSString stringWithFormat:@"%@",_checkOrderModel[@"order_status"]] isEqualToString:@"99"])//不是无货订单，可以理赔
        {
            [_qieButton addTarget:self action:@selector(qieButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_qieButton setTitle:NSLocalizedString(@"Claims", nil) forState:UIControlStateNormal];
            _qieButton.hidden = NO;
            _qieButton.tag=201;
            [_qieButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.height.mas_equalTo(TabbarHeight);
            }];
            _baseScrollView.frame= CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight-TabbarHeight);
            
        }
        
    }

}

-(void)changeorder:(UIButton *)button {
    if (button.tag==100)//上传凭证
    {
        _photoPickerManager = [TYDPPhotoPickerManager shared];
        [_photoPickerManager showActionSheetInView:nil fromController:self completion:^(UIImage *image) {
            NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
            NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"order",@"upPayImg",ConfigNetAppKey];
            NSDictionary *params = @{@"action":@"upPayImg",@"sign":[TYDPManager md5:Sign],@"model":@"order",@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"order_id":_orderId};
            NSLog(@"params:%@",params);

            [TYDPManager upLoadPic:params withImage:image withName:@"pay_img" withView:self.view];
            //跳转去新的页面
            TYDP_CommitEvidenceViewController *CommitEvidenceVC = [TYDP_CommitEvidenceViewController new];
            CommitEvidenceVC.orderId = self.orderId;
            CommitEvidenceVC.order_status =self.order_status;
            CommitEvidenceVC.popMore =YES;
            
            CommitEvidenceVC.orderSourceString = self.orderSourceString;
            [self.navigationController pushViewController:CommitEvidenceVC animated:YES];

        } cancelBlock:^{
            
        }];

    }
    if (button.tag==101)//添加取货人信息
    {
        //添加联系人
        [self addContanctMethod];

    }
}


-(void)qieButtonClicked:(UIButton *)button {
    if (button.tag==200)//选择支付方式
    {
    
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Alipay", nil),NSLocalizedString(@"Offline transaction", nil),NSLocalizedString(@"Bank card transfer", nil), nil];
    [choiceSheet showInView:self.view];

    }
    
    if (button.tag==201)//理赔
    {
        TYDP_AddCommentController *addVC = [[TYDP_AddCommentController alloc]init];
        addVC.pushType = 1;
        addVC.titleStr = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"Order No.", nil),[NSString stringWithFormat:@"%@",_checkOrderModel[@"order_sn"]]];
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

-(void)AliPay
{
    
    //跳转
    TYDP_CommitEvidenceViewController *CommitEvidenceVC = [TYDP_CommitEvidenceViewController new];
    CommitEvidenceVC.orderId = self.orderId;
    CommitEvidenceVC.order_status =self.order_status;
    CommitEvidenceVC.popMore =YES;
    
    CommitEvidenceVC.orderSourceString = self.orderSourceString;
    [self.navigationController pushViewController:CommitEvidenceVC animated:YES];
}


#pragma mark 支付
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        switch (alertView.tag) {
            case 0:
            {
                NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
                NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"order",@"order_edit_payment",ConfigNetAppKey];
                NSDictionary *params = @{@"action":@"order_edit_payment",@"sign":[TYDPManager md5:Sign],@"model":@"order",@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"order_id":_orderId,@"pay_id":@"3"};
                debugLog(@"params:%@",params);
                [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
                    if (![data[@"error"] intValue]) {
                        
                        TYDP_CommitEvidenceViewController *CommitEvidenceVC = [TYDP_CommitEvidenceViewController new];
                        CommitEvidenceVC.orderId = self.orderId;
                        CommitEvidenceVC.order_status =self.order_status;
                        CommitEvidenceVC.popMore =YES;
                        
                        CommitEvidenceVC.orderSourceString = self.orderSourceString;
                        [self.navigationController pushViewController:CommitEvidenceVC animated:YES];
                        
                        NSString *appScheme = @"alisdksndp";
                        
                        // NOTE: 调用支付结果开始支付
                        [[AlipaySDK defaultService] payOrder:_checkOrderModel[@"pay_online"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            
                            debugLog(@"reslut = %@",resultDic);
                            //                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                            //                    [window Message:NSLocalizedString(@"Pay success!", nil) HiddenAfterDelay:1.0];
                        }];

                    }else {
                        [self.view Message:NSLocalizedString(@"Operation fail", nil) HiddenAfterDelay:1.0];
                    }
                    
                }
               failure:^(TYDPError *error) {
                    NSLog(@"%@",error);
                                                }
                 ];
                
            }
                break;
            case 1:
            {
                NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
                NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"order",@"order_edit_payment",ConfigNetAppKey];
                NSDictionary *params = @{@"action":@"order_edit_payment",@"sign":[TYDPManager md5:Sign],@"model":@"order",@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"order_id":_orderId,@"pay_id":@"-1"};
                debugLog(@"params:%@",params);
                [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
                    if (![data[@"error"] intValue]) {
                        [self.view Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.0];
                        
                        //跳转去新的订单详情页面
                        TYDP_CommitEvidenceViewController *CommitEvidenceVC = [TYDP_CommitEvidenceViewController new];
                        CommitEvidenceVC.orderId = self.orderId;
                        CommitEvidenceVC.order_status =self.order_status;
                        CommitEvidenceVC.popMore =YES;
                        
                        CommitEvidenceVC.orderSourceString = self.orderSourceString;
                        [self.navigationController pushViewController:CommitEvidenceVC animated:YES];
                    }else {
                        [self.view Message:NSLocalizedString(@"Operation fail", nil) HiddenAfterDelay:1.0];
                    }
                    
                }
                                                failure:^(TYDPError *error) {
                                                    NSLog(@"%@",error);
                                                }];
                
            }
                break;
            case 2:
            {
                NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
                NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"order",@"order_edit_payment",ConfigNetAppKey];
                NSDictionary *params = @{@"action":@"order_edit_payment",@"sign":[TYDPManager md5:Sign],@"model":@"order",@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"order_id":_orderId,@"pay_id":@"2"};
                debugLog(@"params:%@",params);
                [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
                    if (![data[@"error"] intValue]) {
                        [self.view Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.0];
                        
                        //跳转去新的订单详情页面
                        TYDP_CommitEvidenceViewController *CommitEvidenceVC = [TYDP_CommitEvidenceViewController new];
                        CommitEvidenceVC.orderId = self.orderId;
                        CommitEvidenceVC.order_status =self.order_status;
                        CommitEvidenceVC.popMore =YES;
                        
                        CommitEvidenceVC.orderSourceString = self.orderSourceString;
                        [self.navigationController pushViewController:CommitEvidenceVC animated:YES];
                    }else {
                        [self.view Message:NSLocalizedString(@"Operation fail", nil) HiddenAfterDelay:1.0];
                    }
                    
                }
                                                failure:^(TYDPError *error) {
                                                    NSLog(@"%@",error);
                                                }];
                
            }

                break;
            default:
                
                break;
        }

    }
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString * msg = [NSString stringWithFormat:@""];
    switch (buttonIndex) {
        case 0:
        {
            msg=NSLocalizedString(@"Switch to Alipay", nil);
        }
            break;
        case 1:
        {
            msg=NSLocalizedString(@"Switch to Offline transaction", nil);
        }
            break;
        case 2:
        {
            msg=NSLocalizedString(@"Switch to Bank transfer", nil);
        }
            
            break;
        default:
            return;
            break;
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm information", nil)
                          
                                                    message:msg
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"Confirm",nil),nil];
    alert.tag=buttonIndex;
    [alert show];

    }

- (void)bottomControlButtonClicked:(UIButton *)button {
    switch (button.tag) {
        case confirmOrderButtonMessage:{
            if ([_confirmOrderButton.titleLabel.text isEqualToString:NSLocalizedString(@"Upload payment receipt", nil)]) {
                _photoPickerManager = [TYDPPhotoPickerManager shared];
                [_photoPickerManager showActionSheetInView:nil fromController:self completion:^(UIImage *image) {
                    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
                    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"order",@"upPayImg",ConfigNetAppKey];
                    NSDictionary *params = @{@"action":@"upPayImg",@"sign":[TYDPManager md5:Sign],@"model":@"order",@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"order_id":_orderId};
                    NSLog(@"params:%@",params);
//                    [self getOrderData];
                    [TYDPManager upLoadPic:params withImage:image withName:@"pay_img" withView:self.view];
//                    跳转去新的页面
                    TYDP_CommitEvidenceViewController *CommitEvidenceVC = [TYDP_CommitEvidenceViewController new];
                    CommitEvidenceVC.orderId = self.orderId;
                    CommitEvidenceVC.order_status =self.order_status;
                    CommitEvidenceVC.popMore =YES;

                    CommitEvidenceVC.orderSourceString = self.orderSourceString;
                    [self.navigationController pushViewController:CommitEvidenceVC animated:YES];

                    
                } cancelBlock:^{
                    
                }];
            } else if ([_confirmOrderButton.titleLabel.text isEqualToString:NSLocalizedString(@"Claims", nil)]) {
                TYDP_AddCommentController *addVC = [[TYDP_AddCommentController alloc]init];
                addVC.pushType = 1;
                addVC.titleStr = [NSString stringWithFormat:@"%@：%@",[NSString stringWithFormat:@"%@",NSLocalizedString(@"Order No.", nil),_checkOrderModel[@"order_sn"]]];
                [self.navigationController pushViewController:addVC animated:YES];
            }
            else {
                //添加联系人
                [self addContanctMethod];
//                _confirmOrderButton.hidden = YES;
            }
                break;
        }
        case sellerConsultClaimAdjustButtonMessage:{
            NSLog(@"理赔");
            TYDP_AddCommentController *addVC = [[TYDP_AddCommentController alloc]init];
            addVC.pushType = 1;
            addVC.titleStr = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"Order No.", nil),[NSString stringWithFormat:@"%@",_checkOrderModel[@"order_sn"]]];
            [self.navigationController pushViewController:addVC animated:YES];
            break;
        }
        case sellerConsultAddContanctButtonMessage:{
            NSLog(@"添加联系人");
            [self addContanctMethod];
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
        NSLog(@"didfsdfrrc:%@", dic);
        [self uploadContanctInfoWithAddressId:dic[@"address_id"] andTransferState:dic[@"yunfei"]];
        
        
    };
    [self.navigationController pushViewController:consigneeCon animated:YES];
}
- (void)uploadContanctInfoWithAddressId:(NSString *)addressId andTransferState:(NSString *)transferWay{
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"order",@"save_order_address",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"save_order_address",@"sign":[TYDPManager md5:Sign],@"model":@"order",@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"order_id":_orderId,@"address_id":addressId,@"yunfei":transferWay};
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        NSLog(@"data:%@",data[@"message"]);
        if (![data[@"error"] intValue]) {
            //跳转
            TYDP_CommitEvidenceViewController *CommitEvidenceVC = [TYDP_CommitEvidenceViewController new];
            CommitEvidenceVC.orderId = self.orderId;
            CommitEvidenceVC.order_status =self.order_status;
            CommitEvidenceVC.popMore =YES;
            
            CommitEvidenceVC.orderSourceString = self.orderSourceString;
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
    if ([_orderSourceString isEqualToString:@"personalCenter"]) {
        
        if (_popMore) {
//            NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
            
            for (UIViewController * vc in self.navigationController.viewControllers) {
                
                if ([vc isKindOfClass:[TYDP_IndentController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            
            return;
            
        }
        [self.navigationController popViewControllerAnimated:YES];
      
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AlipayNotificationName object:nil];
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
