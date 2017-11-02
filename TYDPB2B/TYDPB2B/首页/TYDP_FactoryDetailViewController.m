//
//  TYDP_FactoryDetailViewController.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/21.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_FactoryDetailViewController.h"

@interface TYDP_FactoryDetailViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UIScrollView *baseScrollView;
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)UIScrollView *bannerScrollView;
@property(nonatomic, strong)UIPageControl *pageControl;
@property(nonatomic, strong)UIView *middleContainerView;
@property(nonatomic, assign)CGFloat originalHeight;
@property(nonatomic, strong)UIButton *moreIndicatorButton;
@property(nonatomic, strong)UILabel *moreIndicatorLabel;
@property(nonatomic, assign)BOOL isOpen;
@property(nonatomic, strong)UIView *bottomContainerView;
@end

@implementation TYDP_FactoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWholeUI];
    // Do any additional setup after loading the view.
}
- (void)createWholeUI{
    [self.view setBackgroundColor:RGBACOLOR(248, 248, 248, 1)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
    [self.view addSubview:_baseScrollView];
    _containerView = [UIView new];
    [_baseScrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_baseScrollView);
        make.width.equalTo(_baseScrollView);
    }];
#pragma mark 设置顶部滚动视图
    _bannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/1.6)];
    _bannerScrollView.delegate = self;
    _bannerScrollView.contentSize = CGSizeMake(ScreenWidth*3,0);
    _bannerScrollView.showsHorizontalScrollIndicator = YES;
    _bannerScrollView.pagingEnabled = YES;
    [_baseScrollView addSubview:_bannerScrollView];
    for (int i = 0 ; i < 5; i++) {
        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*(-1+i), 0, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
        tmpImageView.image = [UIImage imageNamed:@"home_banner"];
        [_bannerScrollView addSubview:tmpImageView];
    }
    UIView *blackView = [UIView new];
    [_baseScrollView addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bannerScrollView.mas_left);
        make.right.equalTo(_bannerScrollView.mas_right);
        make.bottom.equalTo(_bannerScrollView.mas_bottom);
        make.height.mas_equalTo(CommonHeight);
    }];
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 4;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [_baseScrollView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bannerScrollView.mas_bottom);
        make.centerX.equalTo(_baseScrollView.mas_centerX);
        make.width.mas_equalTo(blackView);
        make.height.mas_equalTo(CommonHeight);
    }];
    UIView *topView = [UIView new];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [_baseScrollView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView);
        make.top.equalTo(_bannerScrollView.mas_bottom);
        make.right.equalTo(_bannerScrollView);
        make.height.mas_equalTo(TabbarHeight+Gap);
    }];
    UILabel *topLeftLabel = [UILabel new];
    [topView addSubview:topLeftLabel];
    [topLeftLabel setText:@"厂号：3000014"];
    [topLeftLabel setFont:ThemeFont(18)];
    [topLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(Gap);
        make.top.equalTo(_bannerScrollView.mas_bottom);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(TabbarHeight+Gap);
    }];
    UILabel *topRightLabel = [UILabel new];
    topRightLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:topRightLabel];
    [topRightLabel setText:@"美国"];
    [topRightLabel setFont:ThemeFont(CommonFontSize)];
    [topRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_baseScrollView).with.offset(-Gap);
        make.top.equalTo(_bannerScrollView.mas_bottom);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(TabbarHeight+Gap);
    }];
    UIImageView *topRightImageView = [UIImageView new];
    [topRightImageView setImage:[UIImage imageNamed:@"manufacturer_icon_country"]];
    [topView addSubview:topRightImageView];
    [topRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topRightLabel.mas_left);
        make.centerY.equalTo(topView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    UIView *factoryIntroduceView = [UIView new];
    factoryIntroduceView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    factoryIntroduceView.layer.borderWidth = HomePageBordWidth;
    [_baseScrollView addSubview:factoryIntroduceView];
    [factoryIntroduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
        make.top.equalTo(topView.mas_bottom);
        make.right.equalTo(_bannerScrollView).with.offset(HomePageBordWidth);
        make.height.mas_equalTo(TabbarHeight);
    }];
    UILabel *factoryIntroduceLabel = [UILabel new];
    [factoryIntroduceView addSubview:factoryIntroduceLabel];
    [factoryIntroduceLabel setText:@"厂商介绍"];
    [factoryIntroduceLabel setFont:ThemeFont(16)];
    [factoryIntroduceLabel setTextColor:[UIColor grayColor]];
    [factoryIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(Gap);
        make.top.equalTo(factoryIntroduceView);
        make.bottom.equalTo(factoryIntroduceView);
        make.width.equalTo(factoryIntroduceView);
    }];
    _originalHeight = _bannerScrollView.frame.size.height/2.0;
    _isOpen = YES;
    [self createMiddleContainerViewWithHeight:0.0];
    [self setUpNavigationBar];
}
- (void)createMiddleContainerViewWithHeight:(CGFloat)height{
    if (!_middleContainerView) {
        _middleContainerView = [UIView new];
        [_middleContainerView setBackgroundColor:[UIColor whiteColor]];
        [_baseScrollView addSubview:_middleContainerView];
        UILabel *topLabel = [UILabel new];
        [_middleContainerView addSubview:topLabel];
        [topLabel setText:@"0001 美国加州厂"];
        [topLabel setFont:ThemeFont(18)];
        [topLabel setTextColor:[UIColor redColor]];
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_middleContainerView).with.offset(Gap);
            make.top.equalTo(_middleContainerView);
            make.right.equalTo(_middleContainerView);
            make.height.mas_equalTo(TabbarHeight-Gap);
        }];
    }
    //height不为0时将值赋给视图
    if (!height) {
        [_middleContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_baseScrollView);
            make.top.equalTo(_bannerScrollView.mas_bottom).with.offset(TabbarHeight*2+Gap);;
            make.right.equalTo(_bannerScrollView);
            make.height.mas_equalTo(_originalHeight);
        }];
    } else {
        [_middleContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_baseScrollView);
            make.top.equalTo(_bannerScrollView.mas_bottom).with.offset(TabbarHeight*2+Gap);;
            make.right.equalTo(_bannerScrollView);
            make.height.mas_equalTo(height);
        }];
    }
    if (!_moreIndicatorButton) {
        _moreIndicatorButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_middleContainerView addSubview:_moreIndicatorButton];
        [_moreIndicatorButton setBackgroundImage:[UIImage imageNamed:@"manufacturer_btn_detail_n"] forState:UIControlStateNormal];
        [_moreIndicatorButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIImage *tmpImage = [UIImage imageNamed:@"manufacturer_btn_detail_n"];
    [_moreIndicatorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_middleContainerView);
        make.bottom.equalTo(_middleContainerView).with.offset(-Gap);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(65*(tmpImage.size.height/tmpImage.size.width));
    }];
    if (!_moreIndicatorLabel) {
        _moreIndicatorLabel = [UILabel new];
        [_middleContainerView addSubview:_moreIndicatorLabel];
        [_moreIndicatorLabel setTextColor:[UIColor grayColor]];
        [_moreIndicatorLabel setNumberOfLines:0];
        [_moreIndicatorLabel sizeToFit];
        [_moreIndicatorLabel setFont:ThemeFont(CommonFontSize)];
        [_moreIndicatorLabel setText:@"    泰洋集团从事冻品交易及相关服务已有25年以上的历史。集团主要经营冷冻食品的进口和分销，以中国市场为基础，构建了强大的冻品销售网络。泰洋集团通过收购、租赁等多重方式，优先支持自营品牌的工厂化生产，同时与欧洲、美加等10余个国家和地区的实力肉类生产及贸易企业建立了持久稳定的合作关系。目前，贸易月进口量可达2.7万吨以上，主流猪副产品占中国总进口量的10%以上。"];
        [_moreIndicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_middleContainerView).with.offset(TabbarHeight-Gap);
            make.left.equalTo(_middleContainerView).with.offset(Gap);
            make.right.equalTo(_middleContainerView).with.offset(-Gap);
            make.bottom.equalTo(_moreIndicatorButton.mas_top).with.offset(-Gap);
        }];
    }
    [self createBottomView];
}
- (void)moreButtonClicked:(UIButton *)button {
    if (_isOpen) {
        [_moreIndicatorButton setBackgroundImage:[UIImage imageNamed:@"manufacturer_btn_detail_s"] forState:UIControlStateNormal];
        [self createMiddleContainerViewWithHeight:220];
    } else {
        [_moreIndicatorButton setBackgroundImage:[UIImage imageNamed:@"manufacturer_btn_detail_n"] forState:UIControlStateNormal];
        [self createMiddleContainerViewWithHeight:0];
    }
    [self createBottomView];
    _isOpen = !_isOpen;
}
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    [_baseScrollView addSubview:_navigationBarView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationBarView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"manufacturer_icon_return"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navigationBarView).with.offset(Gap);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationBarView addSubview:rightButton];
    [rightButton setImage:[UIImage imageNamed:@"manufacturer_icon_share"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_navigationBarView).with.offset(-Gap);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
}
- (void)createBottomView {
    if (!_bottomContainerView) {
        _bottomContainerView = [UIView new];
        NSInteger bottomCellHeight = (NSInteger)ScreenWidth/3;
        [_baseScrollView addSubview:_bottomContainerView];
        [_bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_middleContainerView.mas_bottom);
            make.left.equalTo(_baseScrollView);
            make.right.equalTo(_baseScrollView);
            make.height.mas_equalTo(bottomCellHeight*5+TabbarHeight);
        }];
        UIView *productIntroduceView = [UIView new];
        productIntroduceView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        productIntroduceView.layer.borderWidth = HomePageBordWidth;
        [_bottomContainerView addSubview:productIntroduceView];
        [productIntroduceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_baseScrollView).with.offset(-HomePageBordWidth);
            make.top.equalTo(_bottomContainerView);
            make.right.equalTo(_bannerScrollView).with.offset(HomePageBordWidth);
            make.height.mas_equalTo(TabbarHeight);
        }];
        UILabel *productIntroduceLabel = [UILabel new];
        [productIntroduceView addSubview:productIntroduceLabel];
        [productIntroduceLabel setText:@"相关产品"];
        [productIntroduceLabel setFont:ThemeFont(16)];
        [productIntroduceLabel setTextColor:[UIColor grayColor]];
        [productIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_baseScrollView).with.offset(Gap);
            make.top.equalTo(productIntroduceView);
            make.bottom.equalTo(productIntroduceView);
            make.width.equalTo(productIntroduceView);
        }];

    }
    [self createBottomCell];
}
- (void)createBottomCell {
#pragma mark 搭建底部cell
    CGFloat bottomCellHeight = ScreenWidth/3;
    CGFloat smallBottomCellImageWidth = (ScreenWidth/3 - 2*Gap)/3;
    for (int i = 0; i < 5; i++) {
        UIView *bottomCellView = [UIView new];
        [bottomCellView setBackgroundColor:[UIColor whiteColor]];
        [_bottomContainerView addSubview:bottomCellView];
        [bottomCellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomContainerView).with.offset((bottomCellHeight+1)*i+TabbarHeight);
            make.left.equalTo(_baseScrollView);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(bottomCellHeight);
        }];
        UIImageView *leftBigImageView = [UIImageView new];
        [bottomCellView addSubview:leftBigImageView];
        [leftBigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomCellView).with.offset(Gap);
            make.centerY.equalTo(bottomCellView);
            make.width.equalTo(leftBigImageView.mas_height);
            make.height.mas_equalTo(bottomCellHeight - 2*Gap);
        }];
        [leftBigImageView setImage:[UIImage imageNamed:@"home_img1"]];
        UIImageView *smallTopImageView = [UIImageView new];
        [smallTopImageView setImage:[UIImage imageNamed:@"home_img_country"]];
        [leftBigImageView addSubview:smallTopImageView];
        [smallTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftBigImageView);
            make.left.equalTo(leftBigImageView);
            make.width.equalTo(smallTopImageView.mas_height);
            make.height.mas_equalTo(smallBottomCellImageWidth);
        }];
        UILabel *middleTopLabel = [UILabel new];
        [middleTopLabel setText:[NSString stringWithFormat:@"猪前肘／猪手"]];
        [middleTopLabel setFont:ThemeFont(16)];
        //        [middleTopLabel setTextColor:[UIColor grayColor]];
        [bottomCellView addSubview:middleTopLabel];
        [middleTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBigImageView.mas_right).with.offset(Gap);
            make.top.equalTo(leftBigImageView);
            make.width.mas_equalTo(bottomCellHeight);
            make.height.mas_equalTo(CommonHeight);
        }];
        UILabel *middleMiddleLabel = [UILabel new];
        [middleMiddleLabel setText:[NSString stringWithFormat:@"厂号：00001543"]];
        //        [middleMiddleLabel setTextColor:[UIColor grayColor]];
        [middleMiddleLabel setFont:ThemeFont(16)];
        [bottomCellView addSubview:middleMiddleLabel];
        [middleMiddleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBigImageView.mas_right).with.offset(Gap);
            make.top.equalTo(middleTopLabel.mas_bottom).with.offset(Gap);
            make.width.mas_equalTo(ScreenWidth/2);
            make.height.mas_equalTo(CommonHeight);
        }];
        UILabel *bottomPriceLabel = [UILabel new];
        [bottomPriceLabel setText:[NSString stringWithFormat:@"15000"]];
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
        [bottomMeasureLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"yuan/MT", nil)]];
        [bottomMeasureLabel setFont:ThemeFont(CommonFontSize)];
        [bottomMeasureLabel setTextColor:[UIColor blackColor]];
        [bottomCellView addSubview:bottomMeasureLabel];
        [bottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomPriceLabel.mas_right);
            make.bottom.equalTo(leftBigImageView);
            make.width.mas_equalTo(bottomCellHeight/2);
            make.height.mas_equalTo(CommonHeight);
        }];
        UILabel *bottomAmountLabel = [UILabel new];
        [bottomAmountLabel setText:[NSString stringWithFormat:@"500%@",NSLocalizedString(@"pc/MT",nil)]];
        [bottomAmountLabel setFont:ThemeFont(CommonFontSize)];
        [bottomAmountLabel setTextColor:[UIColor blackColor]];
        [bottomCellView addSubview:bottomAmountLabel];
        UILabel *bottomOriginLabel = [UILabel new];
        [bottomOriginLabel setText:[NSString stringWithFormat:@"上海"]];
        [bottomOriginLabel setTextAlignment:NSTextAlignmentRight];
        [bottomOriginLabel setFont:ThemeFont(CommonFontSize)];
        [bottomOriginLabel setTextColor:[UIColor blackColor]];
        [bottomCellView addSubview:bottomOriginLabel];
        [bottomOriginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.left.equalTo(bottomAmountLabel.mas_right);
            make.bottom.equalTo(leftBigImageView);
            make.right.equalTo(bottomCellView).with.offset(-Gap);
            make.height.mas_equalTo(CommonHeight);
            make.width.mas_equalTo(30);
        }];
        [bottomAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomOriginLabel.mas_left);
            make.bottom.equalTo(leftBigImageView);
            make.width.mas_equalTo(bottomCellHeight/1.5);
            make.height.mas_equalTo(CommonHeight);
        }];
        
        UIImageView *smallRightFirstImageView = [UIImageView new];
        UIImageView *smallRightSecondImageView = [UIImageView new];
        UIImageView *smallRightThirdImageView = [UIImageView new];
        [smallRightFirstImageView setImage:[UIImage imageNamed:NSLocalizedString(@"pic_bargaining_en",nil)]];
        [smallRightSecondImageView setImage:[UIImage imageNamed:NSLocalizedString(@"pic_fcl_en",nil)]];
        [smallRightThirdImageView setImage:[UIImage imageNamed:NSLocalizedString(@"pic_cash_en",nil)]];
        [bottomCellView addSubview:smallRightFirstImageView];
        [bottomCellView addSubview:smallRightSecondImageView];
        [bottomCellView addSubview:smallRightThirdImageView];
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
        UILabel *bottomDecorateLabel = [UILabel new];
        [bottomDecorateLabel setBackgroundColor:[UIColor lightGrayColor]];
        [bottomCellView addSubview:bottomDecorateLabel];
        [bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_baseScrollView);
            make.right.equalTo(_baseScrollView);
            make.top.equalTo(leftBigImageView.mas_bottom).with.offset(Gap);
            make.height.mas_equalTo(HomePageBordWidth);
        }];
        if (i == 4) {
            [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(bottomCellView);
            }];
        }

    }
}
- (void)rightItemClicked:(UIButton*)button{

}
- (void)leftItemClicked:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
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
