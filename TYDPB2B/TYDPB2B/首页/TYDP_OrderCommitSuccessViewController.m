//
//  TYDP_OrderCommitSuccessViewController.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/27.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_OrderCommitSuccessViewController.h"
#import "TYDP_CommitEvidenceViewController.h"

@interface TYDP_OrderCommitSuccessViewController ()
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UIScrollView *baseScrollView;
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)NSMutableArray *orderDetailArray;
@property(nonatomic, strong)NSArray *testDataArray;
@property(nonatomic, strong)UIButton *checkOrderButton;
@property(nonatomic, strong)NSMutableArray *orderDetailValueArray;
@end

@implementation TYDP_OrderCommitSuccessViewController
-(NSArray *)testDataArray {
    if (!_testDataArray) {
        _testDataArray = [NSArray arrayWithObjects:@"20160702712345",@"待付款",@"银行转账",@"北京市泰洋国际科技公司",@"中国民生银行北京支行",@"1508019950377",@"中国农业银行",@"王晔",@"622123456789034",@"北京市朝阳区支行",@"", nil];
    }
    return _testDataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self manageOrderData];
    // Do any additional setup after loading the view.
}
- (void)createWholeUI{
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
    [self createTopUI];
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
    [navigationLabel setText:NSLocalizedString(@"Order submission successful", nil)];
    [navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(25);
    }];
}
- (void)leftItemClicked:(UIBarButtonItem *)item{
    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
    [self.navigationController.viewControllers objectAtIndex:index-2];
}
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"订单提交成功提示界面"];
}
- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"订单提交成功提示界面"];
}
- (void)createTopUI{
    UIImage *topImage = [UIImage imageNamed:@"ico_order_succeed"];
    UIImageView *topImageView = [UIImageView new];
    [topImageView setImage:topImage];
    [_baseScrollView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_baseScrollView);
        make.top.equalTo(_baseScrollView).with.offset(30);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30*(topImage.size.height/topImage.size.width));
    }];
    UILabel *topLabel = [UILabel new];
    [topLabel setText:NSLocalizedString(@"Order submission successful", nil)];
    [topLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [topLabel setTextAlignment:NSTextAlignmentCenter];
    [topLabel setFont:ThemeFont(20)];
    [_baseScrollView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_baseScrollView);
        make.top.equalTo(topImageView).with.offset(30);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(50);
    }];
    [self createMiddleUIWithFrontView:topLabel];
}
- (void)manageOrderData{
    OrderDetailPaymentBigModel *orderDetailPaymentBigModel = _orderDetailModel.payment_desc;
     _orderDetailArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Order NO.", nil),NSLocalizedString(@"Order status", nil),NSLocalizedString(@"Payment Method", nil), nil];
    _orderDetailValueArray = [NSMutableArray array];
    [_orderDetailValueArray addObject:_orderDetailModel.order_sn];
    [_orderDetailValueArray addObject:NSLocalizedString(@"Obligation", nil)];
    [_orderDetailValueArray addObject:NSLocalizedString(@"To be confirmed", nil)];
    //只有list里有数据的时候才处理
//    if (orderDetailPaymentBigModel.payment_list.count) {
//        NSMutableArray *orderDetailListModelArray = [NSMutableArray array];
//        //把除key为heng的字段加入数组
//        for (OrderPaymentListModel *model in orderDetailPaymentBigModel.payment_list) {
//            NSLog(@"model.name:%@",model.name);
//            if (![model.name isEqualToString:@"heng"]) {
//                NSMutableString *tmpString = [NSMutableString stringWithFormat:@"%@：",model.name];
//                if ([tmpString length] == 3) {
//                    [tmpString insertString:@"       " atIndex:1];
//                } else if([tmpString length] == 4) {
//                    [tmpString insertString:@"  " atIndex:1];
//                    [tmpString insertString:@"  " atIndex:4];
//                }
//                [orderDetailListModelArray addObject:tmpString];
//            }
//        }
//        [_orderDetailArray addObjectsFromArray:orderDetailListModelArray];
//        for (OrderPaymentListModel *model in orderDetailPaymentBigModel.payment_list) {
//            if (![model.name isEqualToString:@"heng"]) {
//                [_orderDetailValueArray addObject:model.value];
//            }
//        }
//    }
    [self createWholeUI];
}

- (void)createMiddleUIWithFrontView:(UIView *)frontView {
    UIView *middleView = [UIView new];
    middleView.layer.borderColor = [RGBACOLOR(213, 213, 213, 1) CGColor];
    middleView.layer.borderWidth = HomePageBordWidth;
    [middleView setBackgroundColor:[UIColor whiteColor]];
    [_baseScrollView addSubview:middleView];
    NSLog(@"_orderDetailArray:%lu\n_orderDetailValueArray:%lu",_orderDetailArray.count, _orderDetailValueArray.count);
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.top.equalTo(frontView.mas_bottom).with.offset(MiddleGap);
        make.right.equalTo(_baseScrollView).with.offset(HomePageBordWidth);
        make.height.mas_equalTo(55+40*(_orderDetailArray.count));
    }];
    UILabel *topLabel = [UILabel new];
    [middleView addSubview:topLabel];
    [topLabel setText:NSLocalizedString(@"Amount Paid", nil)];
    [topLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [topLabel setFont:ThemeFont(17)];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(MiddleGap);;
        make.top.equalTo(frontView.mas_bottom).with.offset(MiddleGap);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(55);
    }];
    UILabel *topRightLabel = [UILabel new];
    [middleView addSubview:topRightLabel];
    [topRightLabel setText:_orderDetailModel.formated_order_amount];
    [topRightLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [topRightLabel setFont:ThemeFont(17)];
    [topRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLabel.mas_right);
        make.top.equalTo(frontView.mas_bottom).with.offset(MiddleGap);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(55);
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
    for (int i = 0; i < _orderDetailArray.count; i++) {
        UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 55+smallViewHeight*i, ScreenWidth, smallViewHeight)];
        [middleView addSubview:smallView];
//        [smallView setBackgroundColor:[UIColor yellowColor]];
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
        [leftLabel setText:_orderDetailArray[i]];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dotSmallImageView.mas_right).with.offset(Gap);
            make.top.equalTo(smallView);
            make.width.mas_equalTo(130);
            make.bottom.equalTo(smallView);
        }];
        UILabel *rightLabel = [UILabel new];
        [smallView addSubview:rightLabel];
        [rightLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [rightLabel setFont: ThemeFont(16)];
        [rightLabel setText:_orderDetailValueArray[i]];
        rightLabel.numberOfLines = 0;
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.mas_right);
            make.right.equalTo(smallView);
            make.top.equalTo(smallView);
            make.bottom.equalTo(smallView);
        }];
        if (i == 5) {
            UILabel *decorateBottomLabel = [UILabel new];
            [decorateBottomLabel setText:@"------------------------------------------------------"];
            [decorateBottomLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
            [_baseScrollView addSubview:decorateBottomLabel];
            [decorateBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_baseScrollView).with.offset(MiddleGap);
                make.right.equalTo(_baseScrollView);
                make.bottom.equalTo(smallView);
                make.height.mas_equalTo(3);
            }];
        }
    }
    if (!_checkOrderButton) {
        _checkOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkOrderButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _checkOrderButton.clipsToBounds = YES;
        _checkOrderButton.layer.cornerRadius = 5;
        _checkOrderButton.layer.borderColor = [RGBACOLOR(252, 91, 49, 1) CGColor];
        _checkOrderButton.layer.borderWidth = 1;
        [_checkOrderButton setTitle:NSLocalizedString(@"View order", nil) forState:UIControlStateNormal];
        [_checkOrderButton setTitleColor:RGBACOLOR(252, 91, 49, 1) forState:UIControlStateNormal];
        [_baseScrollView addSubview:_checkOrderButton];
        [_checkOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_baseScrollView);
            make.top.equalTo(middleView.mas_bottom).with.offset(30);
            make.width.mas_equalTo(ScreenWidth*0.55);
            make.height.mas_equalTo(45);
        }];
    }
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_checkOrderButton).with.offset(30);
    }];
}
- (void)checkButtonClicked:(UIButton *)button {
    TYDP_CommitEvidenceViewController *commitEvidenceViewCon = [[TYDP_CommitEvidenceViewController alloc] init];
    commitEvidenceViewCon.orderId = _orderDetailModel.order_id;
    [self.navigationController pushViewController:commitEvidenceViewCon animated:YES];
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
