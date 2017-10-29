//
//  TYDP_HomepageViewController.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/13.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_HomepageViewController.h"
#define blackViewTimeInterval 0.1f
#import "HomePageSliderViewCell.h"
#import "TYDPManager+test.h"
#import <CommonCrypto/CommonDigest.h>
#import "TYDP_ShopListViewController.h"
#import "TYDP_ShopFactoryListViewController.h"
#import "TYDPManager+HomePage.h"
#import "HomePageSlideModel.h"
#import "HomePageMiddlePicModel.h"
#import "BestGoodsModel.h"
#import "HomePageModel.h"
#import "HomePageFilterModel.h"
#import "TYDP_ShopListViewController.h"
#import "TYDP_OfferDetailViewController.h"
#import "TYDP_ServePublicController.h"
#import "TYDP_IssueWantController.h"
#import "TYDP_LoginController.h"
#import "ZYTabBar.h"
#import "TTTAttributedLabel.h"
#import "TYDP_wantBuyViewController.h"
#import "TYDP_wantBuyDetailViewController.h"
#import "AppDelegate.h"
#import "NSBundle+Language.h"
@interface TYDP_HomepageViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UISearchBarDelegate>
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UIView *blackView;
@property(nonatomic, assign)NSInteger viewFlag;
@property(nonatomic, assign)CGRect viewFrame;
@property(nonatomic, strong)UIButton *cancelButton;
@property(nonatomic, strong)NSArray *blackViewArray;
@property(nonatomic, strong)UITableView *sliderTableView;
@property(nonatomic, strong)UIImageView *symbolView;
@property(nonatomic, strong)UIView *searchView;
@property(nonatomic, strong)UIButton *categoryButton;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)UIScrollView *baseScrollView;
@property(nonatomic, strong)UIScrollView *bannerScrollView;
@property(nonatomic, strong)UIPageControl *pageControl;
@property(nonatomic, strong)NSArray *functionViewPicArray;
@property(nonatomic, strong)NSArray *functionViewStringArray;
@property(nonatomic, strong)NSArray *sliderPicArray;
@property(nonatomic, strong)NSArray *sliderSelectedPicArray;
@property(nonatomic, assign)BOOL isOpen;
@property(nonatomic, strong)NSIndexPath* selectedIndex;
@property(nonatomic, strong)MBProgressHUD *MBHUD;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)NSArray *slideModelArray;
@property(nonatomic, strong)NSArray *goodsModelArray;
@property(nonatomic, strong)NSArray *miaoShaModelArray;
@property(nonatomic, strong)NSArray *teJiaArray;
@property(nonatomic, strong)NSArray *qiuGouModelArray;
@property(nonatomic, strong)HomePageMiddlePicModel *middlePicModel;
@property(nonatomic, strong)UIButton *searchTypeButton;
@property(nonatomic, strong)UIButton *offerButton;
@property(nonatomic, assign)BOOL isUnfold;
@property(nonatomic, strong)UIImageView *selectImageView;
@property(nonatomic, assign)BOOL searchTypeState;
@property(nonatomic, strong)NSArray *sliderFilterModelArray;
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)NSMutableArray *tmpArray;
@property(nonatomic,strong)UIButton *searchCancelButton;
@property(nonatomic, strong)UIScrollView *firstLaunchScrollView;

@end
typedef enum {
    CategoryButtonMessage = 1,
    CancelButtonMessage,
    SearchTypeButtonMessage,
    ShopButtonMessage,
    StoreButtonMessage,
    SearchCancelButtonMessage,
    SearchButtonMessage
}BUTTONMESSAGE;

@implementation TYDP_HomepageViewController
-(NSArray *)functionViewPicArray {
    if (!_functionViewPicArray) {
        _functionViewPicArray = [NSArray arrayWithObjects:@"icon_home_full",@"icon_home_future",@"icon_home_accuracy",@"icon_home_spot",@"icon_home_retail",@"home_icon_logistics",@"home_icon_finance",@"home_icon_inquiry", nil];
    }
    return _functionViewPicArray;
}
-(NSArray *)functionViewStringArray {
    if (!_functionViewStringArray) {
        _functionViewStringArray = [NSArray arrayWithObjects:NSLocalizedString(@"Spot", nil),NSLocalizedString(@"Future", nil),NSLocalizedString(@"SpotToBe", nil),NSLocalizedString(@"FCL", nil),NSLocalizedString(@"Retail", nil),@"通关",@"物流",@"金融",@"询盘", nil];
    }
    return _functionViewStringArray;
}
-(NSArray *)blackViewArray{
    if (!_blackViewArray) {
        _blackViewArray = @[@"猪",@"牛",@"羊",@"水产",@"鸡",@"鸭",@"鹅"];
    }
    return _blackViewArray;
}
-(NSArray *)sliderPicArray {
    if (!_sliderPicArray) {
        _sliderPicArray = [NSArray arrayWithObjects:@"leftclassify_icon_pig_n",@"leftclassify_icon_cow_n",@"leftclassify_icon_sheep_n",@"leftclassify_icon_fish_n",@"leftclassify_icon_chicken_n",@"leftclassify_icon_duck_n",@"leftclassify_icon_-goose_n", nil];
    }
    return _sliderPicArray;
}
-(NSArray *)sliderSelectedPicArray {
    if (!_sliderSelectedPicArray) {
        _sliderSelectedPicArray = [NSArray arrayWithObjects:@"leftclassify_icon_pig_s",@"leftclassify_icon_cow_s",@"leftclassify_icon_sheep_s",@"leftclassify_icon_fish_s",@"leftclassify_icon_chicken_s",@"leftclassify_icon_duck_s",@"leftclassify_icon_-goose_s", nil];
    }
    return _sliderSelectedPicArray;
}
- (void)createFirstLaunchScrollView{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        
        self.tabBarController.tabBar.hidden= YES;
        ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
        myBar.plusBtn.hidden=YES;
        
        _firstLaunchScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _firstLaunchScrollView.pagingEnabled = YES;
        [self.view addSubview:_firstLaunchScrollView];
        for (int i = 0; i < 4; i++) {
            CGRect imageRect = CGRectMake(ScreenWidth*i, -20, ScreenWidth, ScreenHeight);
            UIImageView *firstLaunchImageView = [[UIImageView alloc]initWithFrame:imageRect];
            NSString *name = [NSString stringWithFormat:@"引导页%i.jpg",i+1];
            firstLaunchImageView.image = [UIImage imageNamed:name];
            [_firstLaunchScrollView addSubview:firstLaunchImageView];
            _firstLaunchScrollView.showsHorizontalScrollIndicator = NO;
            if (i == 3) {
                UIButton *goMain = [UIButton buttonWithType:UIButtonTypeCustom];
                goMain.frame = CGRectMake(ScreenWidth*3, 0, ScreenWidth, ScreenHeight);
                [goMain addTarget:self action:@selector(fisrtLaunchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_firstLaunchScrollView addSubview:goMain];
            }
        }
        _firstLaunchScrollView.contentSize = CGSizeMake(ScreenWidth*4, 0);
        _firstLaunchScrollView.pagingEnabled = YES;
        [_firstLaunchScrollView setBounces:NO];
        [self.view addSubview:_firstLaunchScrollView];
    }
}
- (void)fisrtLaunchButtonClicked:(UIButton *)button {
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        _firstLaunchScrollView.alpha = 0;
    } completion:^(BOOL finished) {
        [_firstLaunchScrollView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [self setUpNavigationBar];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [self setUpNavigationBar];
    }
}

- (void)getHomepageData {
//    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"other",@"get_index",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"get_index",@"sign":[TYDPManager md5:Sign],@"model":@"other"};
    [TYDPManager GetHomePageInfo:[TYDPManager addCommomParam:params] success:^(HomePageModel *totalHomePageInfo) {
        _slideModelArray = [NSArray arrayWithArray:totalHomePageInfo.app_slide];
        _goodsModelArray = [NSArray arrayWithArray:totalHomePageInfo.best_goods];
        _miaoShaModelArray = [NSArray arrayWithArray:totalHomePageInfo.miaosha_goods];
        _teJiaArray = [NSArray arrayWithArray:totalHomePageInfo.tejia_goods];
        _qiuGouModelArray = [NSArray arrayWithArray:totalHomePageInfo.purchase_list];
        _middlePicModel = totalHomePageInfo.app_index_pic;
        [self configurationUI];
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Check Internet connection",nil)]];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
    }];
}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // 当为根控制器时，手势不执行。
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        
    }
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view addSubview:_searchCancelButton];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchActionMethod];
}

- (BOOL)inputShouldNumber:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

#pragma 配置界面UI
- (void)configurationUI{
    _MBHUD = [[MBProgressHUD alloc] init];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    _sliderFilterModelArray = [NSArray array];
    //默认为选择商品laosiji
    _searchTypeState = YES;
    _isUnfold = YES;
#pragma mark 底层scrollview
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight-TabbarHeight)];
    [self.view addSubview:_baseScrollView];
//    _baseScrollView.backgroundColor=RGBACOLOR(252, 252, 252, 1.0);

    _baseScrollView.backgroundColor=RGBACOLOR(252, 252, 252, 1.0);

    UIView *bottomView = [UIView new];
    [_baseScrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_baseScrollView);
        make.width.equalTo(_baseScrollView);
    }];
#pragma mark 设置顶部滚动视图
    _bannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2.0)];
    _bannerScrollView.delegate = self;
    _bannerScrollView.contentSize = CGSizeMake(ScreenWidth*_slideModelArray.count,0);
    _bannerScrollView.showsHorizontalScrollIndicator = YES;
    _bannerScrollView.pagingEnabled = YES;
    [_baseScrollView addSubview:_bannerScrollView];
    //使图片滑动的时候过渡更自然
    HomePageSlideModel *firstSlideModel = [_slideModelArray lastObject];
    HomePageSlideModel *lastSlideModel = [_slideModelArray firstObject];
    UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-ScreenWidth, 0, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
    [firstImageView sd_setImageWithURL:[NSURL URLWithString:firstSlideModel.pic] placeholderImage:nil];
    [_bannerScrollView addSubview:firstImageView];
    UIImageView *lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*_slideModelArray.count, 0, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
    [lastImageView sd_setImageWithURL:[NSURL URLWithString:lastSlideModel.pic] placeholderImage:nil];
    [_bannerScrollView addSubview:lastImageView];
    
    for (int i = 0 ; i < _slideModelArray.count; i++) {
        HomePageSlideModel *tmpModel = _slideModelArray[i];
        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
        [tmpImageView sd_setImageWithURL:[NSURL URLWithString:tmpModel.pic] placeholderImage:nil];
        [_bannerScrollView addSubview:tmpImageView];
    }
     [self addTimer];
     
//    for (int i = 0 ; i < 1; i++) {
//        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
//        [tmpImageView setImage:[UIImage imageNamed:@"banner_home_ch"]];
//        [_bannerScrollView addSubview:tmpImageView];
//    }
  

    

#pragma mark 设置八个功能视图
    UIView *functionView = [UIView new];
    [functionView setBackgroundColor:[UIColor whiteColor]];
    functionView.layer.borderColor = [RGBACOLOR(222, 222, 222, 0.7) CGColor];
    functionView.layer.borderWidth = HomePageBordWidth;
    functionView.clipsToBounds = YES;
    functionView.layer.cornerRadius = 10;
    [_baseScrollView addSubview:functionView];
    [functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(10);
        make.top.equalTo(_bannerScrollView.mas_bottom).with.offset(-(ScreenWidth-40)/8);
        make.right.equalTo(_baseScrollView).with.offset(-10);
        make.height.mas_equalTo((ScreenWidth-20)/4);
    }];
    CGFloat functionWidth = (ScreenWidth-20)/5.0;
    CGFloat functionHeight = (ScreenWidth-20)/5.0;
    CGFloat smallFunctionImageWidth = functionWidth/1.5;
    CGFloat smallFunctionLabelWidth = functionWidth;
    CGFloat smallFunctionLabelHeight = functionWidth/5;
    for (int i = 0; i < 5; i++) {
        UIView *smallFunctionView = [[UIView alloc] initWithFrame:CGRectMake(0.5+(functionWidth)*(i%5), functionHeight*(i/5), functionWidth, functionHeight)];
        [functionView addSubview:smallFunctionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
        [smallFunctionView addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i + 1;
        UIImageView *smallFunctionImageView = [UIImageView new];
        [smallFunctionView addSubview:smallFunctionImageView];
        [smallFunctionImageView setImage:[UIImage imageNamed:self.functionViewPicArray[i]]];
        [smallFunctionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(smallFunctionView);
            make.top.equalTo(smallFunctionView).with.offset(10);
            make.width.mas_equalTo(smallFunctionImageWidth);
            make.height.mas_equalTo(smallFunctionImageWidth);
        }];
        UILabel *smallFunctionLabel = [UILabel new];
        [smallFunctionView addSubview:smallFunctionLabel];
        [smallFunctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(smallFunctionView);
            make.top.equalTo(smallFunctionImageView.mas_bottom).with.offset(0);
            make.width.mas_equalTo(smallFunctionLabelWidth);
            make.height.mas_equalTo(20);
        }];
        [smallFunctionLabel setText:[NSString stringWithFormat:@"%@",self.functionViewStringArray[i]]];
        [smallFunctionLabel setFont:ThemeFont(13)];
        smallFunctionLabel.textColor=RGBACOLOR(102, 102, 102, 1);
        [smallFunctionLabel setTextAlignment:NSTextAlignmentCenter];
        //        [smallFunctionLabel setFont:ThemeFont(CommonFontSize)];
    }
#pragma mark 设置秒杀

    UILabel *SecondsKillLabel = [UILabel new];
    [_baseScrollView addSubview:SecondsKillLabel];
    [SecondsKillLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Time limit", nil)]];
    [SecondsKillLabel setFont:ThemeFont(14)];
    SecondsKillLabel.textColor=RGBACOLOR(85, 85, 85, 1);
    [SecondsKillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(-20);
        make.top.equalTo(functionView.mas_bottom).with.offset(MiddleGap);
        make.height.mas_equalTo(CommonHeight);
    }];
    
    UILabel *moreSecondsKillLabel = [UILabel new];
    [_baseScrollView addSubview:moreSecondsKillLabel];
    [moreSecondsKillLabel setText:[NSString stringWithFormat:@"%@>",NSLocalizedString(@"more", nil)]];
    [moreSecondsKillLabel setTextAlignment:NSTextAlignmentRight];
    
    moreSecondsKillLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreSecondsKillTapMethod:)];
    [moreSecondsKillLabel addGestureRecognizer:tap];
    [moreSecondsKillLabel setFont:ThemeFont(14)];
    moreSecondsKillLabel.textColor=RGBACOLOR(153, 153, 153, 1);
    [moreSecondsKillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_baseScrollView).with.offset(-15);
        make.top.equalTo(functionView.mas_bottom).with.offset(MiddleGap);
        make.height.mas_equalTo(CommonHeight);
        make.width.mas_equalTo(60);
    }];
    
    
    UIView *SecondsKillView = [UIView new];
    [SecondsKillView setBackgroundColor:[UIColor whiteColor]];
    
    [_baseScrollView addSubview:SecondsKillView];
    [SecondsKillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(0);
        make.top.equalTo(SecondsKillLabel.mas_bottom).with.offset(10);
        make.right.equalTo(_baseScrollView).with.offset(0);
        make.height.mas_equalTo((ScreenWidth-60)/3-30+120);
    }];
    
    CGFloat SecondsKillWidth = (ScreenWidth-60)/3.0;
    CGFloat SecondsKillHeight = (ScreenWidth-60)/3.0-30+100;
    CGFloat SecondsKillImageWidth = SecondsKillWidth-30;
    CGFloat SecondsKillLabelWidth = SecondsKillWidth-20;
    CGFloat SecondsKillLabelHeight = 20;
    for (int i = 0; i < _miaoShaModelArray.count; i++) {
        BestGoodsModel *miaoShaGoodsMD = _miaoShaModelArray[i];
        UIView *SecondsKillsmallFunctionView = [[UIView alloc] initWithFrame:CGRectMake((15+SecondsKillWidth)*(i%3)+15, SecondsKillHeight*(i/3), SecondsKillWidth, SecondsKillHeight)];
        SecondsKillsmallFunctionView.backgroundColor=RGBACOLOR(242, 242, 242, 0.7) ;
        [SecondsKillView addSubview:SecondsKillsmallFunctionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SecondsKilltapMethod:)];
        [SecondsKillsmallFunctionView addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i + 1;
        UIImageView *SecondsKillsmallFunctionImageView = [UIImageView new];
        [SecondsKillsmallFunctionView addSubview:SecondsKillsmallFunctionImageView];
//        [SecondsKillsmallFunctionImageView setImage:[UIImage imageNamed:self.functionViewPicArray[i]]];
        [SecondsKillsmallFunctionImageView sd_setImageWithURL:[NSURL URLWithString:miaoShaGoodsMD.goods_thumb] placeholderImage:nil];
        [SecondsKillsmallFunctionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(SecondsKillsmallFunctionView);
            make.top.equalTo(SecondsKillsmallFunctionView).with.offset(Gap);
            make.width.mas_equalTo(SecondsKillImageWidth);
            make.height.mas_equalTo(SecondsKillImageWidth);
        }];
        UILabel *SecondsKillsmallFunctionLabel = [UILabel new];
        [SecondsKillView addSubview:SecondsKillsmallFunctionLabel];
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
//        [bottomPriceLabel setText:[NSString stringWithFormat:@"%@/%@",miaoShaGoodsMD.shop_price_fake,miaoShaGoodsMD.unit_name]];
//        [bottomPriceLabel setFont:ThemeFont(13)];
//        [bottomPriceLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
        [SecondsKillsmallFunctionView addSubview:bottomPriceLabel];
        [bottomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(SecondsKillsmallFunctionView.mas_left).with.offset(0);
            make.top.equalTo(SecondsKillsmallFunctionLabel.mas_bottom).with.offset(5);
            make.right.equalTo(SecondsKillsmallFunctionView.mas_right).with.offset(0);
            make.height.mas_equalTo(20);
        }];
         [bottomPriceLabel setTextAlignment:NSTextAlignmentCenter];
        
        [bottomPriceLabel setText:[NSString stringWithFormat:@"%@/%@",miaoShaGoodsMD.shop_price,miaoShaGoodsMD.unit_name] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
         {
             
             //设置可点击文字的范围
             NSRange boldRange = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"%@",miaoShaGoodsMD.shop_price] options:NSCaseInsensitiveSearch];
             //设置可点击文本的颜色
             [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(__bridge id)[mainColor CGColor] range:boldRange];
             
             NSRange boldRange1 = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"/%@",miaoShaGoodsMD.unit_name] options:NSCaseInsensitiveSearch];
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
//        bottomPriceLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        /*
        UILabel *bottomMeasureLabel = [UILabel new];
        [bottomMeasureLabel setFont:ThemeFont(13)];
         bottomMeasureLabel.textColor=RGBACOLOR(153, 153, 153, 1);
        [bottomMeasureLabel setText:[NSString stringWithFormat:@"/%@",miaoShaGoodsMD.unit_name]];
        [SecondsKillsmallFunctionView addSubview:bottomMeasureLabel];
        [bottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomPriceLabel.mas_right);
            make.top.equalTo(SecondsKillsmallFunctionLabel.mas_bottom).with.offset(5);
            //            make.width.mas_equalTo(bottomCellHeight/2);
            make.height.mas_equalTo(CommonHeight);
        }];
        [bottomMeasureLabel setTextAlignment:NSTextAlignmentLeft];
         
         */

        
        UILabel *oldBottomPriceLabel = [UILabel new];
        
        NSString *textStr = [NSString stringWithFormat:@"%@/%@",miaoShaGoodsMD.shop_price_fake,miaoShaGoodsMD.unit_name];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
        [oldBottomPriceLabel setFont:ThemeFont(11)];
        [oldBottomPriceLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
        [oldBottomPriceLabel setAttributedText:attribtStr];

        [SecondsKillsmallFunctionView addSubview:oldBottomPriceLabel];
        [oldBottomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(SecondsKillsmallFunctionView.mas_right).with.offset(0);
            make.top.equalTo(bottomPriceLabel.mas_bottom).with.offset(5);
            make.left.equalTo(SecondsKillsmallFunctionView.mas_left).with.offset(0);
            //            make.width.mas_equalTo(bottomCellHeight);
            make.height.mas_equalTo(20);
        }];
        [oldBottomPriceLabel setTextAlignment:NSTextAlignmentCenter];
//        oldBottomPriceLabel.adjustsFontSizeToFitWidth=YES;
        
        /*
        UILabel *oldBottomMeasureLabel = [UILabel new];
        [oldBottomMeasureLabel setFont:ThemeFont(11)];
        [oldBottomMeasureLabel setText:[NSString stringWithFormat:@"/%@",miaoShaGoodsMD.unit_name]];
        [oldBottomMeasureLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
        [SecondsKillsmallFunctionView addSubview:oldBottomMeasureLabel];
        [oldBottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(oldBottomPriceLabel.mas_right);
            make.top.equalTo(bottomPriceLabel.mas_bottom).with.offset(5);
            //            make.width.mas_equalTo(bottomCellHeight/2);
            make.height.mas_equalTo(CommonHeight);
        }];
         [oldBottomMeasureLabel setTextAlignment:NSTextAlignmentLeft];
        
        
        UILabel *bottomDecorateLabel = [UILabel new];
        [bottomDecorateLabel setFont:ThemeFont(13)];
        [bottomDecorateLabel setBackgroundColor:RGBACOLOR(122, 122, 122, 0.7)];
        [SecondsKillsmallFunctionView addSubview:bottomDecorateLabel];
        [bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(oldBottomPriceLabel);
            make.right.equalTo(oldBottomMeasureLabel);
            make.centerY.equalTo(oldBottomPriceLabel);
            make.height.mas_equalTo(HomePageBordWidth);
        }];
        */
        
        //        [smallFunctionLabel setFont:ThemeFont(CommonFontSize)];
    }

#pragma mark 设置今日特价
    
    UIView *titleSalePriceView = [UIView new];
    [titleSalePriceView setBackgroundColor:[UIColor whiteColor]];
    
    [_baseScrollView addSubview:titleSalePriceView];
    [titleSalePriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(0);
        make.top.equalTo(SecondsKillView.mas_bottom).with.offset(15);
        make.right.equalTo(_baseScrollView).with.offset(0);
        make.height.mas_equalTo(40);
    }];

    
    UILabel *salePriceLabel = [UILabel new];
    [titleSalePriceView addSubview:salePriceLabel];
    [salePriceLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Today\'s deal", nil)]];
    [salePriceLabel setFont:ThemeFont(14)];
    salePriceLabel.textColor=RGBACOLOR(85, 85, 85, 1);
    [salePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(-20);
        make.top.equalTo(titleSalePriceView.mas_top).with.offset(Gap);
        make.height.mas_equalTo(CommonHeight);
    }];
    
    UILabel *moresalePriceLabel = [UILabel new];
    [titleSalePriceView addSubview:moresalePriceLabel];
    [moresalePriceLabel setText:[NSString stringWithFormat:@"%@>",NSLocalizedString(@"more", nil)]];
    [moresalePriceLabel setTextAlignment:NSTextAlignmentRight];

    [moresalePriceLabel setFont:ThemeFont(14)];
    moresalePriceLabel.textColor=RGBACOLOR(153, 153, 153, 1);
    moresalePriceLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moresalePriceTapMethod:)];
    [moresalePriceLabel addGestureRecognizer:tap1];
    [moresalePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_baseScrollView).with.offset(-15);
        make.top.equalTo(titleSalePriceView.mas_top).with.offset(Gap);
        make.height.mas_equalTo(CommonHeight);
        make.width.mas_equalTo(60);
    }];
    
    
    UIView *salePriceView = [UIView new];
    [salePriceView setBackgroundColor:RGBACOLOR(252, 252, 252, 1.0)];
    
    [_baseScrollView addSubview:salePriceView];
    [salePriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(0);
        make.top.equalTo(titleSalePriceView.mas_bottom).with.offset(1);
        make.right.equalTo(_baseScrollView).with.offset(0);
        make.height.mas_equalTo(80);
    }];
    CGFloat salePriceWidth = ScreenWidth/2.0;
    CGFloat salePriceHeight = 80;
    CGFloat salePriceImageWidth = 60;
    CGFloat salePriceLabelWidth = (ScreenWidth-40)/2.0-salePriceImageWidth;
    CGFloat salePriceLabelHeight = salePriceImageWidth/3;
    for (int i = 0; i < _teJiaArray.count; i++) {
        BestGoodsModel *teJiaGoodsMD = _teJiaArray[i];
        UIView *salePricesmallFunctionView = [[UIView alloc] initWithFrame:CGRectMake((salePriceWidth)*(i%2)+i, salePriceHeight*(i/2), salePriceWidth, salePriceHeight)];
        salePricesmallFunctionView.backgroundColor=[UIColor whiteColor] ;
        [salePriceView addSubview:salePricesmallFunctionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(salePricetapMethod:)];
        [salePricesmallFunctionView addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i + 1;
        UIImageView *salePricesmallFunctionImageView = [UIImageView new];
        [salePricesmallFunctionView addSubview:salePricesmallFunctionImageView];
         [salePricesmallFunctionImageView sd_setImageWithURL:[NSURL URLWithString:teJiaGoodsMD.goods_thumb] placeholderImage:nil];
        [salePricesmallFunctionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(salePricesmallFunctionView.mas_left).with.offset(20);
            make.top.equalTo(salePricesmallFunctionView).with.offset(10);
            make.width.mas_equalTo(salePriceImageWidth);
            make.height.mas_equalTo(salePriceImageWidth);
        }];
        
        UILabel *salePricesmallFunctionLabel = [UILabel new];
        [salePricesmallFunctionView addSubview:salePricesmallFunctionLabel];
        [salePricesmallFunctionLabel setFont:ThemeFont(13)];
        salePricesmallFunctionLabel.textColor=RGBACOLOR(51, 51, 51, 1);
        [salePricesmallFunctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(salePricesmallFunctionImageView.mas_right).with.offset(10);
            make.top.equalTo(salePricesmallFunctionImageView.mas_top).with.offset(0);
            make.width.mas_equalTo(salePriceLabelWidth);
            make.height.mas_equalTo(salePriceLabelHeight);
        }];
        [salePricesmallFunctionLabel setText:[NSString stringWithFormat:@"%@",teJiaGoodsMD.goods_name]];
        [salePricesmallFunctionLabel setTextAlignment:NSTextAlignmentLeft];
//        [salePricesmallFunctionLabel setFont:ThemeFont(CommonFontSize)];
        
        UILabel *bottomPriceLabel = [UILabel new];
        [bottomPriceLabel setText:[NSString stringWithFormat:@"%@",teJiaGoodsMD.shop_price]];
        [bottomPriceLabel setFont:ThemeFont(13)];
        [bottomPriceLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
        [salePricesmallFunctionView addSubview:bottomPriceLabel];
        [bottomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(salePricesmallFunctionImageView.mas_right).with.offset(10);
            make.top.equalTo(salePricesmallFunctionLabel.mas_bottom).with.offset(0);
            make.height.mas_equalTo(CommonHeight);
        }];
        
        [bottomPriceLabel setTextAlignment:NSTextAlignmentLeft];
        
        
        UILabel *bottomMeasureLabel = [UILabel new];
        
        [bottomMeasureLabel setText:[NSString stringWithFormat:@"/%@",teJiaGoodsMD.unit_name]];
        [bottomMeasureLabel setFont:ThemeFont(13)];
        [bottomMeasureLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];

        [salePricesmallFunctionView addSubview:bottomMeasureLabel];
        [bottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomPriceLabel.mas_right);
            make.top.equalTo(salePricesmallFunctionLabel.mas_bottom).with.offset(0);
            //            make.width.mas_equalTo(bottomCellHeight/2);
            make.height.mas_equalTo(CommonHeight);
        }];
        [bottomMeasureLabel setTextAlignment:NSTextAlignmentLeft];
        
        
        
        UILabel *oldBottomPriceLabel = [UILabel new];
        [oldBottomPriceLabel setText:[NSString stringWithFormat:@"%@",teJiaGoodsMD.shop_price_fake]];
        [oldBottomPriceLabel setFont:ThemeFont(11)];
        [oldBottomPriceLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
        [salePricesmallFunctionView addSubview:oldBottomPriceLabel];
        [oldBottomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(salePricesmallFunctionImageView.mas_right).with.offset(10);
            make.top.equalTo(bottomPriceLabel.mas_bottom).with.offset(0);
            make.height.mas_equalTo(CommonHeight);
        }];
        [oldBottomPriceLabel setTextAlignment:NSTextAlignmentLeft];
        oldBottomPriceLabel.adjustsFontSizeToFitWidth=YES;
        
        UILabel *oldBottomMeasureLabel = [UILabel new];
        [oldBottomMeasureLabel setText:[NSString stringWithFormat:@"/%@",teJiaGoodsMD.unit_name]];
        [oldBottomMeasureLabel setFont:ThemeFont(11)];

        [oldBottomMeasureLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
        [salePricesmallFunctionView addSubview:oldBottomMeasureLabel];
        [oldBottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(oldBottomPriceLabel.mas_right);
            make.top.equalTo(bottomPriceLabel.mas_bottom).with.offset(0);
            //            make.width.mas_equalTo(bottomCellHeight/2);
            make.height.mas_equalTo(CommonHeight);
        }];
        [oldBottomMeasureLabel setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *bottomDecorateLabel = [UILabel new];
        [bottomDecorateLabel setFont:ThemeFont(13)];
        [bottomDecorateLabel setBackgroundColor:RGBACOLOR(122, 122, 122, 0.7)];
        [salePricesmallFunctionView addSubview:bottomDecorateLabel];
        [bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(oldBottomPriceLabel);
            make.right.equalTo(oldBottomMeasureLabel);
            make.centerY.equalTo(oldBottomPriceLabel);
            make.height.mas_equalTo(HomePageBordWidth);
        }];

    }
    
#pragma mark 设置求购信息
    
    UIView *titleDemandView = [UIView new];
    [titleDemandView setBackgroundColor:[UIColor whiteColor]];
    
    [_baseScrollView addSubview:titleDemandView];
    [titleDemandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(0);
        make.top.equalTo(salePriceView.mas_bottom).with.offset(15);
        make.right.equalTo(_baseScrollView).with.offset(0);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *demandLabel = [UILabel new];
    [titleDemandView addSubview:demandLabel];
    [demandLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"List wanted", nil)]];
    [demandLabel setFont:ThemeFont(14)];
    demandLabel.textColor=RGBACOLOR(85, 85, 85, 1);
    [demandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(-20);
        make.top.equalTo(titleDemandView.mas_top).with.offset(Gap);
        make.height.mas_equalTo(CommonHeight);
    }];
    
    UILabel *moreDemandLabel = [UILabel new];
    [titleDemandView addSubview:moreDemandLabel];
    [moreDemandLabel setText:[NSString stringWithFormat:@"%@>",NSLocalizedString(@"more", nil)]];
    [moreDemandLabel setTextAlignment:NSTextAlignmentRight];
    
    [moreDemandLabel setFont:ThemeFont(14)];
    moreDemandLabel.textColor=RGBACOLOR(153, 153, 153, 1);
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreDemandTapMethod:)];
    moreDemandLabel.userInteractionEnabled=YES;
    [moreDemandLabel addGestureRecognizer:tap2];
    
    [moreDemandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_baseScrollView).with.offset(-15);
        make.top.equalTo(titleDemandView.mas_top).with.offset(Gap);
        make.height.mas_equalTo(CommonHeight);
        make.width.mas_equalTo(60);
    }];

#pragma mark 搭建求购信息cell
    CGFloat demandCellHeight = ScreenWidth/5;
    CGFloat demandCellImageWidth = (ScreenWidth/5 - 2*10-10)/2;
    
    UIView * lastdemandCellView = [UIView new];

    for (int i = 0; i < _qiuGouModelArray.count; i++) {
        purchaseListModel *purchaseListMD = _qiuGouModelArray[i];
//        BestGoodsModel *tmpGoodsModel = _goodsModelArray[i];
        UIView *demandCellView = [UIView new];
        [_baseScrollView addSubview:demandCellView];
        demandCellView.backgroundColor=[UIColor whiteColor];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(demandCellViewTapMethod:)];
        [demandCellView addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i + 1;
        [demandCellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleDemandView.mas_bottom).with.offset((demandCellHeight+1)*i+1);
            make.left.equalTo(_baseScrollView);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(demandCellHeight);
        }];
        
        if (i == _qiuGouModelArray.count-1) {
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
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[purchaseListMD.user_face isEqualToString:@""]?@"http://test.taiyanggo.com/images/no_picture.gif":purchaseListMD.user_face] placeholderImage:nil];
        
        
        UILabel *nameLabel = [UILabel new];
        NSString *number =[NSString stringWithFormat:@"%@",purchaseListMD.user_name];
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
        [addressLabel setText:[NSString stringWithFormat:@"%@",purchaseListMD.address]];
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
        
        UIImageView *localImageView = [UIImageView new];
       [localImageView setImage:[UIImage imageNamed:@"home_addressLocal"]];
        [demandCellView addSubview:localImageView];
        [localImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(addressLabel.mas_left).with.offset(0);
            make.top.equalTo(nameLabel);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
        
        UILabel *needLabel = [UILabel new];
        [needLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Need", nil)]];
        [needLabel setFont:ThemeFont(12)];
        [needLabel setTextAlignment:NSTextAlignmentCenter];
        [needLabel setBackgroundColor:RGBACOLOR(153, 153, 153, 1)];
        [needLabel setTextColor:[UIColor whiteColor]];
        [demandCellView addSubview:needLabel];
        [needLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImageView.mas_left).with.offset(0);
            make.top.equalTo(headImageView.mas_bottom).with.offset(10);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(CommonHeight);
        }];
        
        UILabel *detailDemandLabel = [UILabel new];
        [detailDemandLabel setText:[NSString stringWithFormat:@"%@  %@%@  %@-%@%@",purchaseListMD.goods_name,NSLocalizedString(@"Ton", nil),purchaseListMD.goods_num,purchaseListMD.price_low,purchaseListMD.price_up,NSLocalizedString(@"yuan/ton", nil)]];
        [detailDemandLabel setFont:ThemeFont(13)];
        [detailDemandLabel setTextColor:RGBACOLOR(51, 51, 51, 1)];

        [detailDemandLabel setTextAlignment:NSTextAlignmentLeft];
//        [detailDemandLabel setBackgroundColor:[UIColor grayColor]];
        [demandCellView addSubview:detailDemandLabel];
        [detailDemandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(needLabel.mas_right).with.offset(15);
            make.top.equalTo(headImageView.mas_bottom).with.offset(10);
            make.width.mas_equalTo(ScreenWidth-100);
            make.height.mas_equalTo(CommonHeight);
        }];
        
//        UILabel *bottomDecorateLabel = [UILabel new];
//        [bottomDecorateLabel setBackgroundColor:RGBACOLOR(222, 222, 222, 0.7)];
//        [demandCellView addSubview:bottomDecorateLabel];
//        [bottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_baseScrollView);
//            make.right.equalTo(_baseScrollView);
//            make.top.equalTo(needLabel.mas_bottom).with.offset(Gap);
//            make.height.mas_equalTo(HomePageBordWidth);
//        }];
}
    
    
#pragma mark 设置推荐商品
    UILabel *middleAdvertLabel = [UILabel new];
    [_baseScrollView addSubview:middleAdvertLabel];
    [middleAdvertLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Recommended products", nil)]];
    [middleAdvertLabel setFont:ThemeFont(14)];
    [middleAdvertLabel setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [middleAdvertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bannerScrollView).with.offset(Gap);
        make.right.equalTo(_bannerScrollView).with.offset(-Gap);
        make.top.equalTo(lastdemandCellView.mas_bottom).with.offset(MiddleGap);
        make.height.mas_equalTo(CommonHeight);
    }];
    
    
    UILabel *moreAdvertPriceLabel = [UILabel new];
    [_baseScrollView addSubview:moreAdvertPriceLabel];
    [moreAdvertPriceLabel setText:[NSString stringWithFormat:@"%@>",NSLocalizedString(@"more", nil)]];
    [moreAdvertPriceLabel setTextAlignment:NSTextAlignmentRight];
    moreAdvertPriceLabel.userInteractionEnabled=YES;
    [moreAdvertPriceLabel setFont:ThemeFont(14)];
    moreAdvertPriceLabel.textColor=RGBACOLOR(153, 153, 153, 1);
    moreAdvertPriceLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreRecommendTapMethod:)];
    [moreAdvertPriceLabel addGestureRecognizer:tap3];
    [moreAdvertPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_baseScrollView).with.offset(-15);
        make.top.equalTo(middleAdvertLabel.mas_top).with.offset(0);
        make.height.mas_equalTo(CommonHeight);
        make.width.mas_equalTo(60);
    }];

    
   #pragma mark 搭建底部cell
    CGFloat bottomCellHeight = ScreenWidth/4;
    CGFloat smallBottomCellImageWidth = (ScreenWidth/4 - 2*Gap)/3;
    for (int i = 0; i < _goodsModelArray.count; i++) {
        BestGoodsModel *tmpGoodsModel = _goodsModelArray[i];
        UIView *bottomCellView = [UIView new];
        [_baseScrollView addSubview:bottomCellView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomCellTapMethod:)];
        [bottomCellView addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i + 1;
        [bottomCellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(middleAdvertLabel.mas_bottom).with.offset((bottomCellHeight+1)*i+MiddleGap-Gap);
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
        [leftBigImageView sd_setImageWithURL:[NSURL URLWithString:tmpGoodsModel.goods_thumb] placeholderImage:nil];
        
//        UIImageView *smallTopImageView = [UIImageView new];
//        [smallTopImageView sd_setImageWithURL:[NSURL URLWithString:tmpGoodsModel.region_icon] placeholderImage:nil];
//        [leftBigImageView addSubview:smallTopImageView];
//        [smallTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(leftBigImageView);
//            make.left.equalTo(leftBigImageView);
//            make.width.equalTo(smallTopImageView.mas_height);
//            make.height.mas_equalTo(smallBottomCellImageWidth);
//        }];
        
        UILabel *smallLocalLabel = [UILabel new];
        [smallLocalLabel setText:[NSString stringWithFormat:@"%@",tmpGoodsModel.region_name]];
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
        
        
        
        UILabel *middleTopLabel = [UILabel new];
        [middleTopLabel setText:[NSString stringWithFormat:@"%@",tmpGoodsModel.goods_name]];
        [middleTopLabel setFont:ThemeFont(14)];
        [middleTopLabel setTextColor:RGBACOLOR(51, 51, 51, 1)];
        //        [middleTopLabel setTextColor:[UIColor grayColor]];
        [bottomCellView addSubview:middleTopLabel];
        [middleTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBigImageView.mas_right).with.offset(Gap);
            make.top.equalTo(leftBigImageView);
            //            make.width.mas_equalTo(bottomCellHeight);
            make.height.mas_equalTo((bottomCellHeight - 2*Gap)/3);
        }];
        
        UILabel *middleMiddleLabel = [UILabel new];
        [middleMiddleLabel setText:[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"Plat No.",nil) ,tmpGoodsModel.brand_sn]];
        [middleMiddleLabel setFont:ThemeFont(13)];
        [middleMiddleLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
        [bottomCellView addSubview:middleMiddleLabel];
        [middleMiddleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBigImageView.mas_right).with.offset(Gap);
            make.top.equalTo(middleTopLabel.mas_bottom).with.offset(0);
            //            make.width.mas_equalTo(ScreenWidth/2);
            make.height.mas_equalTo((bottomCellHeight - 2*Gap)/3);
        }];
        
        UILabel *bottomPriceLabel = [UILabel new];
        [bottomPriceLabel setText:[NSString stringWithFormat:@"%@",tmpGoodsModel.shop_price]];
        [bottomPriceLabel setFont:ThemeFont(14)];
        [bottomPriceLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
        [bottomCellView addSubview:bottomPriceLabel];
        [bottomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBigImageView.mas_right).with.offset(Gap);
             make.top.equalTo(middleMiddleLabel.mas_bottom).with.offset(0);
//            make.width.mas_equalTo(bottomCellHeight);
            make.height.mas_equalTo((bottomCellHeight - 2*Gap)/3);
        }];
        UILabel *bottomMeasureLabel = [UILabel new];
        [bottomMeasureLabel setText:[NSString stringWithFormat:@"/%@",tmpGoodsModel.unit_name]];
        [bottomMeasureLabel setFont:ThemeFont(14)];
        [bottomMeasureLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
        [bottomCellView addSubview:bottomMeasureLabel];
        [bottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomPriceLabel.mas_right);
            make.top.equalTo(middleMiddleLabel.mas_bottom).with.offset(0);
            //            make.width.mas_equalTo(bottomCellHeight/2);
            make.height.mas_equalTo((bottomCellHeight - 2*Gap)/3);
        }];
        UILabel *bottomAmountLabel = [UILabel new];
        //        [bottomAmountLabel setText:[NSString stringWithFormat:@"%@%@",tmpGoodsModel.spec_1,tmpGoodsModel.spec_1_unit]];
        [bottomAmountLabel setFont:ThemeFont(14)];
        [bottomAmountLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
        [bottomCellView addSubview:bottomAmountLabel];
        
        
        UILabel *bottomOriginLabel = [UILabel new];
        [bottomOriginLabel setText:[NSString stringWithFormat:@"%@",tmpGoodsModel.goods_local]];
        [bottomOriginLabel setTextAlignment:NSTextAlignmentRight];
        [bottomOriginLabel setFont:ThemeFont(13)];
        [bottomOriginLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
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
        if ([tmpGoodsModel.goods_number length] >= 1) {
            if ([[tmpGoodsModel.goods_number substringToIndex:1] isEqualToString:@"-"]) {
                JudgeStoreNumber = NO;
            }
        }
        if ([tmpGoodsModel.goods_number intValue] == 0||JudgeStoreNumber == NO) {
            bottomCellView.userInteractionEnabled = NO;
            UIImageView *backGroundImageView = [UIImageView new];
            backGroundImageView.image = [UIImage imageNamed:@"home_icon_sell"];
            backGroundImageView.backgroundColor = [UIColor blackColor];
            backGroundImageView.alpha = 0.3;
            [bottomCellView addSubview:backGroundImageView];
            [backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bottomCellView).with.insets(UIEdgeInsetsMake(0, 0, Gap, 0));            }];
        }
        if (i == _goodsModelArray.count-1) {
            [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(bottomCellView);
            }];
        }
    }
    [self getSliderFilterData];
}
- (void)searchSelectButtonClicked:(UIButton *)button {
//    UIImage *searchButtonImage = [UIImage new];
    switch (button.tag) {
        case ShopButtonMessage:{
            
            [_searchTypeButton setTitle:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Product",nil)] forState:UIControlStateNormal];
            _searchBar.placeholder = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Factory number / Product name / Origin", nil)];
            _searchTypeState = YES;
            break;
        }
        case StoreButtonMessage:{
             [_searchTypeButton setTitle:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Shop",nil)] forState:UIControlStateNormal];
            _searchBar.placeholder = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Shop name",nil)];
            _searchTypeState = NO;
            break;
        }
        default:
            break;
    }
    _selectImageView.hidden = YES;
    _isUnfold = YES;
}
- (void)searchTypeButtonClicked:(UIButton *) button {
    if (!_selectImageView) {
        _selectImageView = [UIImageView new];
        _selectImageView.hidden = YES;
        _selectImageView.userInteractionEnabled = YES;
        UIImage *selectImage = [UIImage imageNamed:@"home_search_dropdown"];
        [_selectImageView setImage:selectImage];
        [_baseScrollView addSubview:_selectImageView];
        [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_searchTypeButton);
            make.top.equalTo(_searchTypeButton.mas_bottom);
            make.width.mas_equalTo(ScreenWidth/5);
            make.height.mas_equalTo((ScreenWidth/5)*(selectImage.size.height/selectImage.size.width));
        }];
        UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [shopButton setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Product", nil)] forState:UIControlStateNormal];
        [shopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        shopButton.tag = ShopButtonMessage;
        [shopButton addTarget:self action:@selector(searchSelectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *storeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [storeButton setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Shop", nil)] forState:UIControlStateNormal];
        storeButton.tag = StoreButtonMessage;
        [storeButton addTarget:self action:@selector(searchSelectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [storeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectImageView addSubview:shopButton];
        [_selectImageView addSubview:storeButton];
        [shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_selectImageView);
            make.top.equalTo(_selectImageView).with.offset(Gap);
            make.width.equalTo(_selectImageView);
            make.height.equalTo(storeButton);
        }];
        [storeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_selectImageView);
            make.top.equalTo(shopButton.mas_bottom);
            make.width.equalTo(_selectImageView);
            make.height.equalTo(shopButton);
            make.bottom.equalTo(_selectImageView);
        }];
    }
    if (_isUnfold) {
        if (_searchTypeState) {
            [_searchTypeButton setTitle:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Product",nil)] forState:UIControlStateNormal];
        } else {
           [_searchTypeButton setTitle:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Shop",nil)] forState:UIControlStateNormal];
        }
        _selectImageView.hidden = NO;
    } else {
        if (_searchTypeState) {
            [_searchTypeButton setTitle:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Product",nil)] forState:UIControlStateNormal];
        } else {
            [_searchTypeButton setTitle:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Shop",nil)] forState:UIControlStateNormal];
        }
        _selectImageView.hidden = YES;
    }
    _isUnfold = !_isUnfold;
}
- (void)bottomCellTapMethod:(UITapGestureRecognizer *)tap {
    UIView *tmpView = [tap view];
    BestGoodsModel *tmpGoodsModel = _goodsModelArray[tmpView.tag-1];
    NSLog(@"goods_id:%@",tmpGoodsModel.goods_id);
    TYDP_OfferDetailViewController *offerDetailViewCon = [[TYDP_OfferDetailViewController alloc] init];
    offerDetailViewCon.goods_id = tmpGoodsModel.goods_id;
    [self.navigationController pushViewController:offerDetailViewCon animated:YES];
    self.tabBarController.tabBar.hidden = YES;

}

#pragma mark 更多秒杀
- (void)moreSecondsKillTapMethod:(UITapGestureRecognizer *)tap
{
    TYDP_ShopListViewController *shopListViewCon = [[TYDP_ShopListViewController alloc] init];
    shopListViewCon.sign_MSandTJ = YES;
    shopListViewCon.more_type = [NSMutableString stringWithFormat:@"hot"];
    [self.navigationController pushViewController:shopListViewCon animated:YES];
    self.tabBarController.tabBar.hidden = YES;

}

#pragma mark 秒杀详情
- (void)SecondsKilltapMethod:(UITapGestureRecognizer *)tap
{
    BestGoodsModel *teJiaGoodsMD = _miaoShaModelArray[tap.view.tag-1];
    NSLog(@"goods_id:%@",teJiaGoodsMD.goods_id);
    TYDP_OfferDetailViewController *offerDetailViewCon = [[TYDP_OfferDetailViewController alloc] init];
    offerDetailViewCon.goods_id = teJiaGoodsMD.goods_id;
    [self.navigationController pushViewController:offerDetailViewCon animated:YES];
}
#pragma mark 更多特价
- (void)moresalePriceTapMethod:(UITapGestureRecognizer *)tap
{
    
    TYDP_ShopListViewController *shopListViewCon = [[TYDP_ShopListViewController alloc] init];
    shopListViewCon.sign_MSandTJ = YES;
    shopListViewCon.more_type = [NSMutableString stringWithFormat:@"promote"];
    [self.navigationController pushViewController:shopListViewCon animated:YES];
    self.tabBarController.tabBar.hidden = YES;

}

#pragma mark 特价详情
- (void)salePricetapMethod:(UITapGestureRecognizer *)tap
{
    
    BestGoodsModel *teJiaGoodsMD = _teJiaArray[tap.view.tag-1];
    NSLog(@"goods_id:%@",teJiaGoodsMD.goods_id);
    TYDP_OfferDetailViewController *offerDetailViewCon = [[TYDP_OfferDetailViewController alloc] init];
    offerDetailViewCon.goods_id = teJiaGoodsMD.goods_id;
    [self.navigationController pushViewController:offerDetailViewCon animated:YES];
}

#pragma mark 更多求购
- (void)moreDemandTapMethod:(UITapGestureRecognizer *)tap
{
    TYDP_wantBuyViewController * TYDP_wantBuyVC=[[TYDP_wantBuyViewController alloc] init];
     TYDP_wantBuyVC.HomePageFlag =0;
    [self.navigationController pushViewController:TYDP_wantBuyVC animated:YES];
}
#pragma mark 求购详情
- (void)demandCellViewTapMethod:(UITapGestureRecognizer *)tap
{
    purchaseListModel * purchaseListMD=_qiuGouModelArray[tap.view.tag-1];
    TYDP_wantBuyDetailViewController * TYDP_wantBuyDetailVC =[[TYDP_wantBuyDetailViewController alloc] init];
    TYDP_wantBuyDetailVC.qiugou_id=purchaseListMD.id;
    [self.navigationController pushViewController:TYDP_wantBuyDetailVC animated:YES];
}

#pragma mark 更多推荐
- (void)moreRecommendTapMethod:(UITapGestureRecognizer *)tap
{
    TYDP_ShopListViewController *shopListViewCon = [[TYDP_ShopListViewController alloc] init];
    shopListViewCon.sign_MSandTJ = YES;
    shopListViewCon.more_type = [NSMutableString stringWithFormat:@"best"];
    [self.navigationController pushViewController:shopListViewCon animated:YES];
    self.tabBarController.tabBar.hidden = YES;

}

#pragma mark 点击5功能按钮
- (void)tapMethod:(UITapGestureRecognizer *)tap {
    UIView *tmpView = [tap view];
    if (tmpView.tag < 6) {
        TYDP_ShopListViewController *shopListViewCon = [[TYDP_ShopListViewController alloc] init];
        shopListViewCon.HomePageFlag = tmpView.tag;
        shopListViewCon.sign_MSandTJ = NO;

        [self.navigationController pushViewController:shopListViewCon animated:YES];
        self.tabBarController.tabBar.hidden = YES;

    }
    else {
        NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
        if ([userDefualts objectForKey:@"user_id"]) {
            switch (tmpView.tag) {
                case 5:{
                    NSLog(@"代理报关");
                    TYDP_ServePublicController *servePublicVC = [TYDP_ServePublicController new];
                    servePublicVC.sendType = 0;
                    [self.navigationController pushViewController:servePublicVC animated:YES];
                    self.tabBarController.tabBar.hidden = YES;

                    break;
                }
                case 6:{
                    NSLog(@"物流找车");
                    break;
                }
                case 7:{
                    NSLog(@"货押贷款");
                    TYDP_ServePublicController *servePublicVC = [TYDP_ServePublicController new];
                    servePublicVC.sendType = 2;
                    [self.navigationController pushViewController:servePublicVC animated:YES];
                    self.tabBarController.tabBar.hidden = YES;

                    break;
                }
                case 8:{
                    NSLog(@"询盘服务");
                    TYDP_IssueWantController *IssueWantVC = [TYDP_IssueWantController new];
                    [self.navigationController pushViewController:IssueWantVC animated:YES];
                    self.tabBarController.tabBar.hidden = YES;

                    break;
                }
                default:
                    break;
            }
        } else {
            TYDP_LoginController *loginViewCon = [[TYDP_LoginController alloc] init];
            [self.navigationController pushViewController:loginViewCon animated:YES];
            self.tabBarController.tabBar.hidden = YES;

        }
    }
}

#pragma mark 设置导航栏
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    _navigationBarView.backgroundColor=mainColor;
    [self.view addSubview:_navigationBarView];
    #pragma mark 设置搜索框
    
    _searchTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_searchTypeButton setTitle:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Product",nil)] forState:UIControlStateNormal];
    _searchTypeButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
//    [_searchTypeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_navigationBarView addSubview:_searchTypeButton];
    [_searchTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navigationBarView).with.offset(0);
        make.top.equalTo(_navigationBarView).with.offset(20);
        make.bottom.equalTo(_navigationBarView);
        make.width.mas_equalTo(60.0);
    }];
    _searchTypeButton.tag = SearchTypeButtonMessage;
    [_searchTypeButton addTarget:self action:@selector(searchTypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    _searchView = [UIView new];
//    [_searchView setBackgroundColor:[UIColor whiteColor]];
//    [_navigationBarView addSubview:_searchView];
//    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_searchTypeButton).with.offset(60);
//        make.bottom.equalTo(_navigationBarView.mas_bottom).with.offset(-8);
//        make.height.mas_equalTo(CommonSearchViewHeight);
//        make.right.equalTo(_navigationBarView).with.offset(-20);
//    }];
//    _searchView.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
//    _searchView.layer.borderWidth = 0.7;
//    _searchView.clipsToBounds = YES;
//    _searchView.layer.cornerRadius = CommonSearchViewHeight/2;
    
    _searchBar = [[UISearchBar alloc] init];
    [_navigationBarView addSubview:_searchBar];
    _searchBar.returnKeyType=UIReturnKeySearch;
    _searchBar.delegate = self;
    [_searchBar setSearchBarStyle:UISearchBarStyleDefault];
    _searchBar.placeholder = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Factory number / Product name / Origin", nil)];
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    _searchBar.showsCancelButton = NO;
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_searchTypeButton).with.offset(60);
        make.bottom.equalTo(_navigationBarView.mas_bottom).with.offset(-8);
        make.height.mas_equalTo(CommonSearchViewHeight);
        make.right.equalTo(_navigationBarView).with.offset(-105);
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
    
    
    
    _searchCancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _searchCancelButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [_searchCancelButton setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    _searchCancelButton.alpha = 0.3;
    _searchCancelButton.tag = SearchCancelButtonMessage;
    [_searchCancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
#pragma mark 设置取消侧滑视图的全屏取消按钮
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [_cancelButton setBackgroundColor:[UIColor blackColor]];
    [_cancelButton setAlpha:0.5];
    _cancelButton.tag = CancelButtonMessage;
    [_cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _offerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_offerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_offerButton setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Switch language",nil)] forState:UIControlStateNormal];
    [_offerButton addTarget:self action:@selector(offerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _offerButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    //    [_searchTypeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_navigationBarView addSubview:_offerButton];
    [_offerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_navigationBarView).with.offset(0);
        make.top.equalTo(_navigationBarView).with.offset(20);
        make.bottom.equalTo(_navigationBarView);
        make.width.mas_equalTo(100.0);
    }];

    
    [self getHomepageData];
}
-(void)offerButtonClicked:(UIButton *)Btn
{
    // 切换语言前
    NSArray *langArr1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *language1 = langArr1.firstObject;
    debugLog(@"模拟器语言切换之前：%@",language1);
    
    NSArray *lans;
    if ([language1 isEqualToString:@"zh-Hans"]) {
        lans = @[@"en"];
    }
    else
    {
        lans = @[@"zh-Hans"];
    }
    // 切换语言
    
    [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
    
    // 切换语言后
    NSArray *langArr2 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *language2 = langArr2.firstObject;
    debugLog(@"语言切换之后：%@",language2);
    //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
    
    [NSBundle setLanguage:language2];
    
    // 然后将设置好的语言存储好，下次进来直接加载
    [[NSUserDefaults standardUserDefaults] setObject:language2 forKey:@"myLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [PSDefaults setObject:@"0" forKey:@"needCenterBtn"];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TYDPTabBarController*  rootVC = story.instantiateInitialViewController;
    AppDelegate* appDele=(AppDelegate* )[UIApplication sharedApplication].delegate;
    appDele.window.rootViewController=rootVC;
}
#pragma mark 侧滑按钮的触发方法
-(void)buttonClicked:(UIButton *)button {
    POPSpringAnimation *anBasic = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anBasic.springBounciness = 10.0f;
    switch (button.tag) {
        case CategoryButtonMessage:
        {
            if (_sliderFilterModelArray.count) {
                _blackView = [[UIView alloc] initWithFrame:CGRectMake(-ScreenWidth*3/4, 0, ScreenWidth*3/4, ScreenHeight)];
                [_blackView setBackgroundColor:RGBACOLOR(255, 255, 255, 1)];
                [[UIApplication sharedApplication].keyWindow addSubview:_cancelButton];
                [[UIApplication sharedApplication].keyWindow addSubview:_blackView];
                [self createSliderTableView];
                _viewFlag = 0;
                if (!_viewFlag) {
                    _cancelButton.hidden = NO;
                    anBasic.toValue = @(_blackView.center.x+ScreenWidth*3/4);
                    anBasic.beginTime = CACurrentMediaTime();
                    [_blackView pop_addAnimation:anBasic forKey:@"position"];
                    _viewFlag = 1;
                } else {
                    //                [_cancelButton removeFromSuperview];
                    _cancelButton.hidden = YES;
                    anBasic.toValue = @(_blackView.center.x-ScreenWidth*3/4);
                    anBasic.beginTime = CACurrentMediaTime();
                    [_blackView pop_addAnimation:anBasic forKey:@"position"];
                    _viewFlag = 0;
                    [_blackView removeFromSuperview];
                }
            } else {
                [self getSliderFilterData];
            }
            break;
        }
        case CancelButtonMessage:
        {
            _cancelButton.hidden = YES;
            anBasic.toValue = @(_blackView.center.x-ScreenWidth*3/4);
            anBasic.beginTime = CACurrentMediaTime();
            [_blackView pop_addAnimation:anBasic forKey:@"position"];
            _viewFlag = 0;
            break;
        }
        case SearchCancelButtonMessage:
        {
            [_searchBar resignFirstResponder];
            [_searchCancelButton removeFromSuperview];
            break;
        }
        case SearchButtonMessage:{
            [self searchActionMethod];
        }
        default:
            break;
    }
    _cancelButton.userInteractionEnabled = NO;
    [anBasic setCompletionBlock:^(POPAnimation *ani, BOOL fin) {
        if (fin) {
            button.userInteractionEnabled = YES;
            _cancelButton.userInteractionEnabled = YES;
        }
    }];
}
- (void)searchActionMethod {
    NSMutableDictionary *filterDic = [NSMutableDictionary dictionary];
    [filterDic setObject:_searchBar.text forKey:@"keywords"];
    if (_searchTypeState) {//商品搜索
        if ([_searchBar.text isEqualToString:@""]||_searchBar.text == nil) {
            [_MBHUD setLabelText:NSLocalizedString(@"No keyword", nil)];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.0f];
        } else {
            TYDP_ShopListViewController *shopListViewCon = [[TYDP_ShopListViewController alloc] init];
            shopListViewCon.sign_MSandTJ = NO;

            shopListViewCon.filterDic = [NSMutableDictionary dictionaryWithDictionary:filterDic];
            [self.navigationController pushViewController:shopListViewCon animated:YES];
            _searchBar.text = @"";
            self.tabBarController.tabBar.hidden = YES;

        }
    } else {//店铺搜索
        if ([_searchBar.text isEqualToString:@""]||_searchBar.text == nil) {
            [_MBHUD setLabelText:NSLocalizedString(@"No keyword", nil)];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.0f];
        } else {
            TYDP_ShopFactoryListViewController *shopFactoryListViewCon = [[TYDP_ShopFactoryListViewController alloc] init];
            shopFactoryListViewCon.keywords = [NSString stringWithFormat:@"%@",_searchBar.text];
            [self.navigationController pushViewController:shopFactoryListViewCon animated:YES];
            _searchBar.text = @"";
            self.tabBarController.tabBar.hidden = YES;

        }
    }
    [_searchBar resignFirstResponder];
    [_searchCancelButton removeFromSuperview];
}
- (void)getSliderFilterData {
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"other",@"get_menu",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"get_menu",@"sign":[TYDPManager md5:Sign],@"model":@"other"};
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        if (![data[@"error"] intValue]) {
            _sliderFilterModelArray = [HomePageFilterModel arrayOfModelsFromDictionaries:data[@"content"] error:nil];
        }
    } failure:^(TYDPError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark 设置侧滑视图里的表视图
-(void)createSliderTableView{
    NSUserDefaults *userdefauls = [NSUserDefaults standardUserDefaults];
    _sliderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*3/4, ScreenHeight-TabbarHeight) style:UITableViewStylePlain];
    [_blackView addSubview:_sliderTableView];
    _sliderTableView.dataSource = self;
    _sliderTableView.delegate = self;
    _sliderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _sliderTableView.tableFooterView = [UIView new];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*3/4, NavHeight*2+Gap)];;
    [topView setBackgroundColor:RGBACOLOR(0, 78, 145, 1)];
    UIImageView *topImageView = [UIImageView new];
    NSLog(@"imageUrl:%@",[userdefauls objectForKey:@"user_face"]);
    [topView addSubview:topImageView];
    topImageView.clipsToBounds = YES;
    topImageView.layer.cornerRadius = NavHeight/2;
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).with.offset(30);
        make.width.mas_equalTo(NavHeight);
        make.height.equalTo(topImageView.mas_width);
    }];
    UILabel *memberNameLabel = [UILabel new];
    [topView addSubview:memberNameLabel];
    [memberNameLabel setTextColor:[UIColor whiteColor]];
    [memberNameLabel setFont:ThemeFont(CommonFontSize)];
    [memberNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImageView.mas_right).with.offset(MiddleGap);
        make.top.equalTo(topImageView).with.offset(Gap);
        make.height.mas_equalTo(CommonHeight);
    }];
    UILabel *GreetingLabel = [UILabel new];
    [topView addSubview:GreetingLabel];
    [GreetingLabel setFont:ThemeFont(CommonFontSize)];
    [GreetingLabel setTextColor:[UIColor whiteColor]];
    [GreetingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImageView.mas_right).with.offset(MiddleGap);
        make.bottom.equalTo(topImageView).with.offset(-Gap);
        make.height.mas_equalTo(CommonHeight);
    }];
    UIImage *bottomImage = [UIImage imageNamed:@"leftclasify_icon_contact"];
    UIImageView *bottomImageView = [UIImageView new];
    [bottomImageView setImage:bottomImage];
    [_blackView addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tabBarController.tabBar);
        make.width.mas_equalTo(ScreenWidth/4);
        make.height.mas_equalTo(((ScreenWidth/4)/bottomImage.size.width)*bottomImage.size.height);
        make.centerX.equalTo(_blackView);
    }];
    bottomImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contanctServicerTapMethod:)];
    [bottomImageView addGestureRecognizer:tap];
    _sliderTableView.tableHeaderView = topView;
    if ([userdefauls objectForKey:@"user_id"]) {
        [topImageView sd_setImageWithURL:[NSURL URLWithString:    [userdefauls objectForKey:@"user_face"]] placeholderImage:[UIImage imageNamed:@"person_head_default"]];
        [memberNameLabel setText:[NSString stringWithFormat:@"会员%@",[userdefauls objectForKey:@"alias"]]];
        [GreetingLabel setText:[NSString stringWithFormat:@"欢迎您！"]];
        bottomImageView.hidden = NO;
    } else {
        [topImageView setImage:[UIImage imageNamed:@"person_head_default"]];
        [memberNameLabel setText:[NSString stringWithFormat:@"尚未登陆"]];
        [GreetingLabel setText:[NSString stringWithFormat:@"请到个人中心登陆！"]];
        bottomImageView.hidden = YES;
    }
}
- (void)contanctServicerTapMethod:(UITapGestureRecognizer *)tap {
    [_cancelButton removeFromSuperview];
    [_blackView removeFromSuperview];
    NSString *telephoneString = [NSString stringWithFormat:@"tel://18501995377"];
    NSString *reminderString = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Make sure to call？",nil)];
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Remind",nil) message:reminderString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:nil];
    [alertCon addAction:firstAction];
    UIAlertAction *Secondaction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sure",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneString]];
    }];
    [alertCon addAction:Secondaction];
    [self.navigationController presentViewController:alertCon animated:YES completion:nil];
}
#pragma _sliderTableViewDelegate
#pragma mark myTableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.blackViewArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageSliderViewCell *cell = [HomePageSliderViewCell cellWithTableView:tableView];
    [cell.mainImageView setImage:[UIImage imageNamed:self.sliderPicArray[indexPath.row]]];
    HomePageFilterModel *filterModel = _sliderFilterModelArray[indexPath.row];
    [cell.nameLabel setText:[NSString stringWithFormat:@"%@",filterModel.cat_name]];
    [cell.nameLabel setTextColor:[UIColor blackColor]];
    [cell.indicateImageView setImage:[UIImage imageNamed:@"leftclassify_icon_down"]];
    if (indexPath.row == _selectedIndex.row) {
        if (_isOpen == YES) {
            NSLog(@"WY:展开");
            [cell.mainImageView setImage:[UIImage imageNamed:self.sliderSelectedPicArray[indexPath.row]]];
            [cell.nameLabel setTextColor:RGBACOLOR(68, 138, 230, 1)];
            [cell.indicateImageView setImage:[UIImage imageNamed:@"leftclassify_icon_up"]];
            cell.containerView.hidden = NO;
            _containerView = [UIView new];
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
    return cell;
}
- (void)createSmallButtonWithNumbers:(NSInteger)numbers {
    CGFloat smallButtonWidth = ScreenWidth*3/4 ;
    CGFloat smallButtonHeight = 60;
    for (int i = 0; i < numbers; i++) {
        HomePageFilterSmallModel *model = _tmpArray[i];
        UIButton *smallButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [smallButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,ScreenWidth/3)];
        smallButton.tag = i+1;
        [_containerView addSubview:smallButton];
        smallButton.frame = CGRectMake(0, smallButtonHeight*i, smallButtonWidth, smallButtonHeight);
        [smallButton setBackgroundColor:[UIColor clearColor]];
        [smallButton setTitle:[NSString stringWithFormat:@"%@",model.cat_name] forState:UIControlStateNormal];
        [smallButton.titleLabel setFont:ThemeFont(16)];
        [smallButton addTarget:self action:@selector(smallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [smallButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
- (void)smallButtonClicked:(UIButton *)button {
    POPSpringAnimation *anBasic = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anBasic.springBounciness = 10.0f;
    _cancelButton.hidden = YES;
    anBasic.toValue = @(_blackView.center.x-ScreenWidth*3/4);
    anBasic.beginTime = CACurrentMediaTime();
    [_blackView pop_addAnimation:anBasic forKey:@"position"];
    _viewFlag = 0;
    HomePageFilterSmallModel *model = _tmpArray[button.tag - 1];
    NSMutableDictionary *filterDic = [NSMutableDictionary dictionary];
    [filterDic setObject:model.cat_id forKey:@"cat_id"];
    TYDP_ShopListViewController *shopListViewCon = [[TYDP_ShopListViewController alloc] init];
    shopListViewCon.sign_MSandTJ = NO;

    shopListViewCon.filterDic = [NSMutableDictionary dictionaryWithDictionary:filterDic];
    [self.navigationController pushViewController:shopListViewCon animated:YES];
    self.tabBarController.tabBar.hidden = YES;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomePageFilterModel *filterModel = _sliderFilterModelArray[indexPath.row];
    NSArray *tmpFilterSmallModelArray = filterModel.son;
    _tmpArray = [NSMutableArray arrayWithArray:tmpFilterSmallModelArray];
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
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == _selectedIndex) {
        if (indexPath.row == _selectedIndex.row && _selectedIndex != nil) {
            if (_isOpen == YES) {
                //调整伸展后cell的高度
                return 60*( _tmpArray.count+1);
            } else {
                return 60;
            }
        } else {
        }
    } else {
        return 60;
    }
    return 60;
}
- (void)addTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoScroll:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)autoScroll:(NSTimer *)timer {
    [_bannerScrollView setContentOffset:CGPointMake(_bannerScrollView.contentOffset.x+ScreenWidth,0) animated:YES];
    CGPoint temp = _bannerScrollView.contentOffset;
    temp.x = -ScreenWidth;
    NSInteger tmpNumber = _slideModelArray.count-1;
    if (_bannerScrollView.contentOffset.x >= (ScreenWidth*tmpNumber)) {
        _bannerScrollView.contentOffset = temp;
    }
    
}
#pragma  scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _bannerScrollView) {
        CGRect rect = [[UIScreen mainScreen] bounds];
        int page = (int)scrollView.contentOffset.x/(int)rect.size.width;
        _pageControl.currentPage = page;
    }
}
/**
 *  重写navigationBar所以把原生的隐藏
 *
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=NO;
    [self createFirstLaunchScrollView];

    [MobClick beginLogPageView:@"首页界面"];
}
- (void)viewDidAppear:(BOOL)animated {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        self.tabBarController.tabBar.hidden= YES;
        ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
        myBar.plusBtn.hidden=YES;
        return;
    }
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;

    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=YES;
    self.tabBarController.tabBar.hidden = YES;

    [MobClick endLogPageView:@"首页界面"];
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
