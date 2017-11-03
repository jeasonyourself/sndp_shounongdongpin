//
//  TYDP_ConfirmOrderViewController.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/27.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_ConfirmOrderViewController.h"
#import "TYDP_OrderCommitSuccessViewController.h"
#import "OrderDetailModel.h"
#import "OrderPaymentListModel.h"
#import "OrderDetailPaymentBigModel.h"

@interface TYDP_ConfirmOrderViewController ()<UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITextField *rightNameLable;
}
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UIScrollView *baseScrollView;
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)UILabel *payWayLabel;
@property(nonatomic, strong)UITextView *noteTextView;
@property(nonatomic, strong)UIButton *cancelButton;
@property(nonatomic, strong)UIButton *confirmOrderButton;
@property(nonatomic, strong)UIPickerView *payWayPickerView;
@property(nonatomic, strong)NSArray *payWayArray;
@property(nonatomic, strong)UIImageView *redDotImageView;
@property(nonatomic, assign)NSInteger flag;
@property(nonatomic, strong)NSMutableDictionary *mutableOrderDic;
@property(nonatomic, strong)OrderDetailModel *orderDetailModel;
@property(nonatomic, strong)MBProgressHUD *MBHUD;
@property(nonatomic, strong)UIImageView *firstDotImageView;
@property(nonatomic, strong)UIImageView *secondDotImageView;
@end

@implementation TYDP_ConfirmOrderViewController
-(NSArray *)payWayArray {
    if (!_payWayArray) {
        _payWayArray = [NSArray arrayWithObjects:@"银行转账",@"支付宝", nil];
    }
    return _payWayArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"_orderDic:%@",_orderDic);
    [self createWholeUI];
    // Do any additional setup after loading the view.
}
- (void)createWholeUI{
    _flag = 0;
    [self.view setBackgroundColor:RGBACOLOR(239, 239, 239, 1)];
    [self setUpNavigationBar];
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
    _mutableOrderDic = [NSMutableDictionary dictionary];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    [_mutableOrderDic setObject:[userdefaul objectForKey:@"user_id"] forKey:@"user_id"];
    [_mutableOrderDic setObject:[userdefaul objectForKey:@"token"] forKey:@"token"];
    [_mutableOrderDic setObject:_orderDic[@"goodsId"] forKey:@"goods_id"];
    [_mutableOrderDic setObject:_orderDic[@"goodsNumber"] forKey:@"buy_number"];
    NSLog(@"_noteTextView:%@",_noteTextView.text);
    if ([_noteTextView.text isEqualToString:NSLocalizedString(@"Please input remark info", nil)]||[_noteTextView.text isEqualToString:@""]) {
        [_mutableOrderDic setObject:@"" forKey:@"postscript"];
    } else {
        [_mutableOrderDic setObject:_noteTextView.text forKey:@"postscript"];
    }
    [_mutableOrderDic setObject:@"0" forKey:@"pay_type_id"];
    [_mutableOrderDic setObject:@"2" forKey:@"payment"];
}
- (void)createTopUI {
    UIView *topView = [UIView new];
    [topView setBackgroundColor:[UIColor whiteColor]];
    topView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
    topView.layer.borderWidth = HomePageBordWidth;
    [_baseScrollView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.top.equalTo(_baseScrollView);
        make.right.equalTo(_baseScrollView).with.offset(HomePageBordWidth);
        make.height.mas_equalTo(NavHeight*2);
    }];
//    UILabel *topLabel = [UILabel new];
//    [topView addSubview:topLabel];
//    [topLabel setText:@"201605040324567"];
//    [topLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
//    [topLabel setFont:ThemeFont(18)];
//    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
//        make.top.equalTo(_baseScrollView);
//        make.right.equalTo(_baseScrollView);
//        make.height.mas_equalTo(40);
//    }];
//    UILabel *topDecorateLabel = [UILabel new];
//    [topLabel addSubview:topDecorateLabel];
//    [topDecorateLabel setBackgroundColor:RGBACOLOR(213, 213, 213, 1)];
//    [topDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
//        make.top.equalTo(topLabel.mas_bottom).with.offset(-HomePageBordWidth);
//        make.right.equalTo(_baseScrollView);
//        make.height.mas_equalTo(HomePageBordWidth);
//    }];
    UIImageView *leftImageView = [UIImageView new];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:_orderDic[@"goodsImage"]] placeholderImage:nil];
    [topView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);
//        make.top.equalTo(topLabel.mas_bottom).with.offset(Gap);
        make.centerY.equalTo(topView);
        make.width.equalTo(leftImageView.mas_height);
        make.height.mas_equalTo(90);
    }];
    UILabel *rightTopLabel = [UILabel new];
    [topView addSubview:rightTopLabel];
    [rightTopLabel setText:_orderDic[@"goodsName"]];
    [rightTopLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [rightTopLabel setFont:ThemeFont(OrderFontSize)];
    [rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).with.offset(Gap);
        make.top.equalTo(leftImageView.mas_top);
        make.height.mas_equalTo(45);
    }];
    
    debugLog(@"sureeee_orderDic:%@",_orderDic);
    UILabel *rightBottomLabel = [UILabel new];
    [topView addSubview:rightBottomLabel];
    //    [rightBottomLabel setBackgroundColor:[UIColor greenColor]];
    if ([[NSString stringWithFormat:@"%@",_orderDic[@"sell_type"]] isEqualToString:@"4"]) {
        rightBottomLabel.text=[NSString stringWithFormat:@"%@/%@  %@%@",[NSString stringWithFormat:@"%@",_orderDic[@"formated_shop_price"]],[NSString stringWithFormat:@"%@",_orderDic[@"shop_price_unit"]],[NSString stringWithFormat:@"%@",_orderDic[@"spec_2"]],NSLocalizedString(@"ctn/MT",nil)];
        
    }
    else  {
        rightBottomLabel.text=[NSString stringWithFormat:@"¥%@/%@  %@%@",[NSString stringWithFormat:@"%@",_orderDic[@"shop_price"]],[NSString stringWithFormat:@"%@",_orderDic[@"shop_price_unit"]],[NSString stringWithFormat:@"%@",_orderDic[@"goods_weight"]],NSLocalizedString(@"MT/FCL",nil)];
    }
   
    [rightBottomLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [rightBottomLabel setFont:ThemeFont(OrderFontSize)];
    [rightBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).with.offset(Gap);
        make.top.equalTo(rightTopLabel.mas_bottom);
//        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(45);
    }];
    [self createMiddleUIWithFrontView:topView];
}
- (void)dotImageViewTapMethod:(UITapGestureRecognizer *)tap {
    UIView *tmpView = [tap view];
    [self setRedDotImageViewPositionWith:tmpView];
}
- (void)setRedDotImageViewPositionWith:(UIView *)tmpView {
    NSLog(@"tmpViewTag:%lu",tmpView.tag);
    if (tmpView.tag == 1) {
        tmpView = _firstDotImageView;
    } else {
        tmpView = _secondDotImageView;
    }
    [tmpView addSubview:_redDotImageView];
    [_redDotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tmpView);
    }];
    switch (tmpView.tag) {
        case 1:
        {
            [_mutableOrderDic setObject:@"1" forKey:@"pay_type_id"];
            [_mutableOrderDic setObject:@"0" forKey:@"payment"];
            break;
        }
        case 2:
        {
            [_mutableOrderDic setObject:@"0" forKey:@"pay_type_id"];
            [_mutableOrderDic setObject:@"2" forKey:@"payment"];
            break;
        }
        default:
            break;
    }
}
- (void)createMiddleUIWithFrontView:(UIView *)frontView {
//    UIView *middleTopView = [UIView new];
//    [_baseScrollView addSubview:middleTopView];
//    [middleTopView setBackgroundColor:[UIColor whiteColor]];
//    middleTopView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
//    middleTopView.layer.borderWidth = HomePageBordWidth;
//    [middleTopView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
//        make.top.equalTo(frontView.mas_bottom).with.offset(MiddleGap);
//        make.right.equalTo(_baseScrollView.mas_right).with.offset(HomePageBordWidth);
//        make.height.mas_equalTo(40*2+40);
//    }];
//    UILabel *leftLabel = [UILabel new];
//    [middleTopView addSubview:leftLabel];
//    [leftLabel setText:@"支付方式："];
//    [leftLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
//    [leftLabel setFont:ThemeFont(OrderFontSize)];
//    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_baseScrollView).with.offset(Gap);
//        make.top.equalTo(middleTopView.mas_top).with.offset(Gap);
//        make.height.mas_equalTo(30);
//    }];
//    _firstDotImageView = [UIImageView new];
//    [_firstDotImageView setImage:[UIImage  imageNamed:@"order_icon_choose_n"]];
//    _secondDotImageView = [UIImageView new];
//    [_secondDotImageView setImage:[UIImage  imageNamed:@"order_icon_choose_n"]];
//    _firstDotImageView.userInteractionEnabled = YES;
//    _secondDotImageView.userInteractionEnabled = YES;
//    [middleTopView addSubview:_firstDotImageView];
//    [middleTopView addSubview:_secondDotImageView];
//    [_firstDotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(leftLabel);
//        make.top.equalTo(leftLabel.mas_bottom).with.offset(10);
//        make.width.mas_equalTo(_firstDotImageView.mas_height);
//        make.width.mas_equalTo(20);
//    }];
//    [_secondDotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(leftLabel);
//        make.top.equalTo(_firstDotImageView.mas_bottom).with.offset(20);
//        make.width.mas_equalTo(_secondDotImageView.mas_height);
//        make.width.mas_equalTo(20);
//    }];
//    _redDotImageView = [UIImageView new];
//    [_redDotImageView setImage:[UIImage imageNamed:@"order_icon_choose_s"]];
//    [_secondDotImageView addSubview:_redDotImageView];
//    [_redDotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_secondDotImageView);
//    }];
//    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotImageViewTapMethod:)];
//    [_firstDotImageView addGestureRecognizer:firstTap];
//    UIView *firstView = [firstTap view];
//    firstView.tag = 1;
//    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotImageViewTapMethod:)];
//    [_secondDotImageView addGestureRecognizer:secondTap];
//    UIView *secondView = [secondTap view];
//    secondView.tag = 2;
//    UILabel *firstLabel = [UILabel new];
//    firstLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *firstLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotImageViewTapMethod:)];
//    [firstLabel addGestureRecognizer:firstLabelTap];
//    UIView *firsLabelView = [firstLabelTap view];
//    firsLabelView.tag = 1;
//    UILabel *firstIndicatorLabel = [UILabel new];
//    firstIndicatorLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *firstIndicatorLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotImageViewTapMethod:)];
//    [firstIndicatorLabel addGestureRecognizer:firstIndicatorLabelTap];
//    UIView *firsIndicatorLabelView = [firstIndicatorLabelTap view];
//    firsIndicatorLabelView.tag = 1;
//    UILabel *secondLabel = [UILabel new];
//    secondLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *secondLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotImageViewTapMethod:)];
//    UIView *secondLabelView = [secondLabelTap view];
//    secondLabelView.tag = 2;
//    [secondLabel addGestureRecognizer:secondLabelTap];
//    UILabel *secondIndicatorLabel = [UILabel new];
//    secondIndicatorLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *secondIndicatorLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotImageViewTapMethod:)];
//    [secondIndicatorLabel addGestureRecognizer:secondIndicatorLabelTap];
//    UIView *secondIndicatorLabelView = [secondIndicatorLabelTap view];
//    secondIndicatorLabelView.tag = 2;
//    [middleTopView addSubview:firstLabel];
//    [middleTopView addSubview:firstIndicatorLabel];
//    [middleTopView addSubview:secondLabel];
//    [middleTopView addSubview:secondIndicatorLabel];
//    [firstLabel setText:@"与卖家直接交易"];
//    [firstLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
//    [firstLabel setFont:ThemeFont(OrderFontSize)];
//    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_firstDotImageView.mas_right).with.offset(Gap);
//        make.centerY.equalTo(_firstDotImageView);
//        make.height.mas_equalTo(40);
//    }];
//    [firstIndicatorLabel setText:@"(装车付款，注意风险)"];
//    [firstIndicatorLabel setTextColor:RGBACOLOR(255, 92, 9, 1)];
//    [firstIndicatorLabel setFont:ThemeFont(OrderFontSize)];
//    [firstIndicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(firstLabel.mas_right);
//        make.centerY.equalTo(_firstDotImageView);
//        make.height.mas_equalTo(40);
//    }];
//    [secondLabel setText:@"付款到平台"];
//    [secondLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
//    [secondLabel setFont:ThemeFont(OrderFontSize)];
//    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_secondDotImageView.mas_right).with.offset(Gap);
//        make.centerY.equalTo(_secondDotImageView);
//        make.height.mas_equalTo(40);
//    }];
//    [secondIndicatorLabel setText:@"(担保交易，随时退款)"];
//    [secondIndicatorLabel setTextColor:RGBACOLOR(255, 92, 9, 1)];
//    [secondIndicatorLabel setFont:ThemeFont(OrderFontSize)];
//    [secondIndicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(secondLabel.mas_right);
//        make.centerY.equalTo(_secondDotImageView);
//        make.height.mas_equalTo(40);
//    }];
//    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [middleTopView addSubview:selectButton];
//    UIImage *selectButtonImage = [UIImage imageNamed:@"icon_next_nor"];
//    [selectButton setImage:selectButtonImage forState:UIControlStateNormal];
//    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(middleTopView).with.offset(-MiddleGap);
//        make.centerY.equalTo(middleTopView);
//        make.width.mas_equalTo(MiddleGap);
//        make.height.mas_equalTo(MiddleGap*(selectButtonImage.size.height/selectButtonImage.size.width));
//    }];
//    if (!_payWayLabel) {
//        _payWayLabel = [UILabel new];
//        [middleTopView addSubview:_payWayLabel];
//        [_payWayLabel setText:@"银行转账"];
//        [_payWayLabel setTextAlignment:NSTextAlignmentRight];
//        [_payWayLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
//        [_payWayLabel setFont:ThemeFont(18)];
//        [_payWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(selectButton.mas_left).with.offset(-Gap);
//            make.centerY.equalTo(middleTopView);
//            make.width.mas_equalTo(ScreenWidth/2);
//            make.height.mas_equalTo(TabbarHeight+5);
//        }];
//        _payWayLabel.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payWayLabelTapMethod:)];
//        [_payWayLabel addGestureRecognizer:tap];
//    }
    UIView *middleBottomView = [UIView new];
    [_baseScrollView addSubview:middleBottomView];
    [middleBottomView setBackgroundColor:[UIColor whiteColor]];
    middleBottomView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
    middleBottomView.layer.borderWidth = HomePageBordWidth;
    [middleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.top.equalTo(frontView.mas_bottom).with.offset(MiddleGap);
        make.right.equalTo(_baseScrollView.mas_right).with.offset(HomePageBordWidth);
        make.height.mas_equalTo(TabbarHeight*3);
    }];
    UILabel *bottomViewLeftLabel = [UILabel new];
    [middleBottomView addSubview:bottomViewLeftLabel];
    [bottomViewLeftLabel setText:NSLocalizedString(@"Note", nil)];
    //    [bottomViewLeftLabel setBackgroundColor:[UIColor greenColor]];
    [bottomViewLeftLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [bottomViewLeftLabel setFont:ThemeFont(OrderFontSize)];
    [bottomViewLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);
        make.top.equalTo(middleBottomView).with.offset(Gap);
        make.height.mas_equalTo(30);
    }];
    if (!_noteTextView) {
        _noteTextView = [UITextView new];
        _noteTextView.clipsToBounds = YES;
        _noteTextView.layer.cornerRadius = 5;
        _noteTextView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
        _noteTextView.layer.borderWidth = 1;
        _noteTextView.delegate = self;
        _noteTextView.text = [NSString stringWithFormat:NSLocalizedString(@"Please input remark info", nil)];
        _noteTextView.textColor = [UIColor lightGrayColor];
        _noteTextView.font = ThemeFont(CommonFontSize);
        [middleBottomView addSubview:_noteTextView];
        [_noteTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(middleBottomView).with.offset(-MiddleGap);
            make.top.equalTo(bottomViewLeftLabel.mas_bottom);
            make.bottom.equalTo(middleBottomView).with.offset(-MiddleGap);
            make.left.equalTo(middleBottomView).with.offset(MiddleGap);;
        }];
    }
    [self createBottomViewWithFrontView:middleBottomView];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _flag++;
    if (_flag == 1) {
        _noteTextView.text = @"";
    }
    _noteTextView.textColor = [UIColor blackColor];
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight);
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_cancelButton];
}
- (void)payWayLabelTapMethod:(UITapGestureRecognizer *)tap{
    _payWayPickerView = [UIPickerView new];
    [_payWayPickerView setBackgroundColor:[UIColor whiteColor]];
    _payWayPickerView.dataSource = self;
    _payWayPickerView.delegate = self;
    [self.view addSubview:_payWayPickerView];
    [_payWayPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(pickerViewCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(ScreenHeight-216);
    }];
}
- (void)pickerViewCancelButtonClicked:(UIButton *)button {
    [button removeFromSuperview];
    [_payWayPickerView removeFromSuperview];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.payWayArray count];
}
//每行的title
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.payWayArray[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [_payWayLabel setText:self.payWayArray[row]];
}
- (void)createBottomViewWithFrontView:(UIView *)frontView {
    UIView *bottomView = [UIView new];
    [_baseScrollView addSubview:bottomView];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    bottomView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
    bottomView.layer.borderWidth = HomePageBordWidth;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.top.equalTo(frontView.mas_bottom).with.offset(MiddleGap);
        make.right.equalTo(_baseScrollView.mas_right).with.offset(HomePageBordWidth);
        make.height.mas_equalTo(55*5);
    }];
    UILabel *newTopLeftLabel = [UILabel new];
    [bottomView addSubview:newTopLeftLabel];
    [newTopLeftLabel setText:NSLocalizedString(@"Order amount", nil)];
    [newTopLeftLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [newTopLeftLabel setFont:ThemeFont(OrderFontSize)];
    [newTopLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);
        make.top.equalTo(bottomView);
        make.height.mas_equalTo(55);
    }];
    UILabel *newTopRightLabel = [UILabel new];
    [bottomView addSubview:newTopRightLabel];
    [newTopRightLabel setTextAlignment:NSTextAlignmentRight];
    [newTopRightLabel setText:[NSString stringWithFormat:@"%@%@",_orderDic[@"goodsNumber"],_orderDic[@"sellMeasureUnit"]]];
    [newTopRightLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [newTopRightLabel setFont:ThemeFont(OrderFontSize)];
    [newTopRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_baseScrollView).with.offset(-MiddleGap);
        make.top.equalTo(bottomView);
        make.height.mas_equalTo(55);
    }];
    
    UILabel *middleDecorateLabel = [UILabel new];
    [bottomView addSubview:middleDecorateLabel];
    [middleDecorateLabel setBackgroundColor:RGBACOLOR(213, 213, 213, 1)];
    [middleDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.right.equalTo(_baseScrollView);
        make.height.mas_equalTo(HomePageBordWidth);
        make.bottom.equalTo(newTopLeftLabel).with.offset(-HomePageBordWidth);
    }];
    
    UILabel *TopLeftLabel = [UILabel new];
    [bottomView addSubview:TopLeftLabel];
    [TopLeftLabel setText:NSLocalizedString(@"Total price", nil)];
    [TopLeftLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [TopLeftLabel setFont:ThemeFont(OrderFontSize)];
    [TopLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);
        make.top.equalTo(newTopLeftLabel.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    UILabel *TopRightLabel = [UILabel new];
    [bottomView addSubview:TopRightLabel];
    [TopRightLabel setTextAlignment:NSTextAlignmentRight];
    [TopRightLabel setText:[NSString stringWithFormat:@"¥%@",_orderDic[@"orderTotalPrice"]]];
    [TopRightLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [TopRightLabel setFont:ThemeFont(OrderFontSize)];
    [TopRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_baseScrollView).with.offset(-MiddleGap);
        make.top.equalTo(newTopLeftLabel.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    UILabel *DownLeftLabel = [UILabel new];
    [bottomView addSubview:DownLeftLabel];
    [DownLeftLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [DownLeftLabel setFont:ThemeFont(OrderFontSize)];
    [DownLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);
        make.top.equalTo(TopLeftLabel.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    UILabel *DownRightLabel = [UILabel new];
    [bottomView addSubview:DownRightLabel];
    [DownRightLabel setTextAlignment:NSTextAlignmentRight];
    if ([_orderDic[@"prePayType"] isEqualToString:@"1"]) {
        [DownLeftLabel setText:NSLocalizedString(@"Prepayment", nil)];
        [DownRightLabel setText:[NSString stringWithFormat:@"¥%@",_orderDic[@"prePayNum"]]];
    } else {
        [DownLeftLabel setText:[NSString stringWithFormat:@"%@（%@%%）",NSLocalizedString(@"Prepayment", nil),_orderDic[@"prePayName"]]];
        [DownRightLabel setText:[NSString stringWithFormat:@"¥%.2f",([_orderDic[@"prePayName"] floatValue]/100.0)*([_orderDic[@"orderTotalPrice"] floatValue])]];
    }
    [DownRightLabel setTextColor:RGBACOLOR(244, 88, 48, 1)];
    [DownRightLabel setFont:ThemeFont(OrderFontSize)];
    [DownRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_baseScrollView).with.offset(-MiddleGap);
        make.top.equalTo(TopRightLabel.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    
    UILabel *middleDecorateLabel1 = [UILabel new];
    [bottomView addSubview:middleDecorateLabel1];
    [middleDecorateLabel1 setBackgroundColor:RGBACOLOR(213, 213, 213, 1)];
    [middleDecorateLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.right.equalTo(_baseScrollView);
        make.height.mas_equalTo(HomePageBordWidth);
        make.bottom.equalTo(DownLeftLabel).with.offset(-HomePageBordWidth);
    }];
    
    UILabel *nameLable = [UILabel new];
    [bottomView addSubview:nameLable];
    [nameLable setText:NSLocalizedString(@"Legal name", nil)];
    [nameLable setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [nameLable setFont:ThemeFont(OrderFontSize)];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);
        make.top.equalTo(DownLeftLabel.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    
    rightNameLable = [UITextField new];
    [bottomView addSubview:rightNameLable];
    rightNameLable.placeholder=NSLocalizedString(@"Legal name", nil);
    [rightNameLable setTextAlignment:NSTextAlignmentRight];
    [rightNameLable setText:[NSString stringWithFormat:@"%@",[PSDefaults objectForKey:@"alias"]]];
    if (![PSDefaults objectForKey:@"alias"]||[[PSDefaults objectForKey:@"alias"] isEqualToString:@""])
    {
        rightNameLable.userInteractionEnabled=YES;
    }
    else
    {
        rightNameLable.userInteractionEnabled=NO;

    }

       [rightNameLable setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [rightNameLable setFont:ThemeFont(OrderFontSize)];
    [rightNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_baseScrollView).with.offset(-MiddleGap);
        make.top.equalTo(DownRightLabel.mas_bottom);
        make.height.mas_equalTo(55);
    }];

    UILabel *middleDecorateLabel2 = [UILabel new];
    [bottomView addSubview:middleDecorateLabel2];
    [middleDecorateLabel2 setBackgroundColor:RGBACOLOR(213, 213, 213, 1)];
    [middleDecorateLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.right.equalTo(_baseScrollView);
        make.height.mas_equalTo(HomePageBordWidth);
        make.bottom.equalTo(nameLable).with.offset(-HomePageBordWidth);
    }];
    
    UILabel *phoneLable = [UILabel new];
    [bottomView addSubview:phoneLable];
    [phoneLable setText:NSLocalizedString(@"Phone No.", nil)];
    [phoneLable setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [phoneLable setFont:ThemeFont(OrderFontSize)];
    [phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);
        make.top.equalTo(nameLable.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    UILabel *rightphoneLable = [UILabel new];
    [bottomView addSubview:rightphoneLable];
    [rightphoneLable setTextAlignment:NSTextAlignmentRight];
    [rightphoneLable setText:[NSString stringWithFormat:@"%@",[PSDefaults objectForKey:@"mobile_phone"]]];
    [rightphoneLable setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [rightphoneLable setFont:ThemeFont(OrderFontSize)];
    [rightphoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_baseScrollView).with.offset(-MiddleGap);
        make.top.equalTo(rightNameLable.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    
    

    
    UILabel *secondMiddleDecorateLabel = [UILabel new];
    [bottomView addSubview:secondMiddleDecorateLabel];
    [secondMiddleDecorateLabel setBackgroundColor:RGBACOLOR(213, 213, 213, 1)];
    [secondMiddleDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.right.equalTo(_baseScrollView);
        make.height.mas_equalTo(HomePageBordWidth);
        make.bottom.equalTo(TopLeftLabel).with.offset(-HomePageBordWidth);
    }];
    if (!_confirmOrderButton) {
        _confirmOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_confirmOrderButton];
        [_confirmOrderButton addTarget:self action:@selector(bottomControlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmOrderButton setBackgroundColor:mainColor];
        [_confirmOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmOrderButton setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
        [_confirmOrderButton.titleLabel setFont:ThemeFont(18)];
        [_confirmOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(TabbarHeight);
        }];
    }
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView).with.offset(Gap*3);
    }];
}
- (void)bottomControlButtonClicked:(UIButton *)button {
    [self getOrderData];
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
    [navigationLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Confirm order", nil)]];
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
    [MobClick beginLogPageView:@"确认订单界面"];
}
- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"确认订单界面"];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
}
- (void)cancelButtonClicked:(UIButton *)button {
    [_noteTextView resignFirstResponder];
    [_cancelButton removeFromSuperview];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self unRegNotification];
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
    inputFieldRect.origin.y += yOffset/2;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = inputFieldRect;
    }];
}
- (void)getOrderData {
    if ([rightNameLable.text isEqualToString:@""]) {
        [self.view Message:NSLocalizedString(@"Legal name", nil) HiddenAfterDelay:1.0];
        return;

    }
    
    _MBHUD = [[MBProgressHUD alloc] init];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [self.view addSubview:_MBHUD];
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    [_MBHUD show:YES];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"order",@"save_order",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"save_order",@"sign":[TYDPManager md5:Sign],@"model":@"order"};
    [_mutableOrderDic addEntriesFromDictionary:params];
    NSLog(@"params:%@",_mutableOrderDic[@"goods_id"]);
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:_mutableOrderDic success:^(id data) {
        if (![data[@"error"] intValue]) {
            [_MBHUD hide:YES];
            _orderDetailModel = [[OrderDetailModel alloc] initWithDictionary:data[@"content"] error:nil];
            TYDP_OrderCommitSuccessViewController *orderCommitSuccessViewCon = [[TYDP_OrderCommitSuccessViewController alloc] init];
            orderCommitSuccessViewCon.orderDetailModel = _orderDetailModel;
            
            if (![PSDefaults objectForKey:@"alias"]||[[PSDefaults objectForKey:@"alias"] isEqualToString:@""])
            {
                [PSDefaults setObject:rightNameLable.text forKey:@"alias"];
            }
            
            [self.navigationController pushViewController:orderCommitSuccessViewCon animated:YES];
        } else {
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        NSLog(@"%@",error);
    }];
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
