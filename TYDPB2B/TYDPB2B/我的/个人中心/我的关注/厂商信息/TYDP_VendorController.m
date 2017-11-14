//
//  TYDP_VendorController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/2.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_VendorController.h"
#import "TYDP_VendorCell.h"
#import "TYDPManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TYDP_VendorModel.h"
#import "TYDP_ShopListViewController.h"
#import "TYDP_OfferDetailViewController.h"
#import "TYDP_NewVendorModel.h"
#import <UShareUI/UShareUI.h>
#import "dianpuDetailMsgViewController.h"


@interface TYDP_VendorController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,
UISearchBarDelegate>
{
    UITableView *_tableVC;
//    UIButton *_currentBtn;
    NSInteger _currentBtnIndex;
    NSArray *_btnImgArr;
    NSArray *_btnLabArr;
    NSArray *_currentBtnImgArr;
    MBProgressHUD *_MBHUD;
    UIImageView *_headImg;//厂家logo
    UILabel *_nameLab;//厂家名称
    UILabel *_addressLab;//所在地
    UILabel *_NumLab;//90日成交订单
    UILabel *nintyLab;
    NSMutableArray *_dataSource;
    
    int _goods_type;
    NSString *_user_id;
    int _page;
    int _page_count;
    NSInteger  fo;
}
@property(nonatomic ,strong)NSMutableDictionary * shopDic;

@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic,strong)UIButton *searchCancelButton;
@property(nonatomic, strong)UIButton *cancelButton;
@property(nonatomic, strong)UIView *blackView;
@property(nonatomic, strong)NSArray *topLabelArray;

@property(nonatomic, strong)NSMutableArray * t_btnArray;
@property(nonatomic, strong)NSMutableArray * t_imgArray;
@property(nonatomic, strong)NSMutableArray * t_titleArray;

@property(nonatomic, strong)UIButton *topIndicatorButton;
@property(nonatomic, strong)UILabel *bottomDecorateLabel;

@property(nonatomic, strong)UIButton *other_topIndicatorButton;
@property(nonatomic, strong)UILabel *other_bottomDecorateLabel;


@property(nonatomic, assign)CGFloat tmpMemory;
@property(nonatomic, assign)CGFloat other_tmpMemory;


@property(nonatomic, strong)NSMutableDictionary *tmpDic;
@property(nonatomic, strong)NSMutableDictionary *othertmpDic;

@property(nonatomic, strong)NSString  *followNum;

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

@implementation TYDP_VendorController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shopDic=[[NSMutableDictionary alloc] init];

    // Do any additional setup after loading the view.
    [self creatUI];
}


-(NSArray *)topLabelArray {
    if (!_topLabelArray) {
//        _topLabelArray = [NSArray arrayWithObjects:@"现货",@"期货",@"准现货",@"整柜",@"零售", nil];
        _topLabelArray = [NSArray arrayWithObjects:NSLocalizedString(@"Spot",nil),NSLocalizedString(@"Future",nil),NSLocalizedString(@"SpotToBe",nil),NSLocalizedString(@"FCL",nil),NSLocalizedString(@"Retail",nil), nil];

    }
    return _topLabelArray;
}

- (void)topLabelTapMethod:(UITapGestureRecognizer *)tap {
    UIView *tmpView = [tap view];
    [self setTopIndicatorButtonVisible:tmpView];
}
- (void)setTopIndicatorButtonVisible:(UIView *)superView {
//    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
//    [self.view addSubview:_MBHUD];
//    [_MBHUD show:YES];
//    _tmpPage = 1;
    _page=1;
    _dataSource=nil;
    if (superView.tag<4) {
   
    if (!_topIndicatorButton) {
        _topIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topIndicatorButton setBackgroundColor:[UIColor whiteColor]];
        [_topIndicatorButton.titleLabel setFont:ThemeFont(CommonFontSize)];
       
        _bottomDecorateLabel = [UILabel new];
        
        _tmpMemory = (NSInteger)ScreenWidth/10;
    }
        [_topIndicatorButton setTitleColor:RGBACOLOR(251, 91, 50, 1) forState:UIControlStateNormal];
        [_bottomDecorateLabel setBackgroundColor:RGBACOLOR(251, 91, 50, 1)];
    _topIndicatorButton.frame = CGRectMake(0, 0,superView.frame.size.width,superView.frame.size.height);
    _bottomDecorateLabel.frame = CGRectMake(0, superView.frame.size.height - 1.5,superView.frame.size.width,1.5);
    [superView addSubview:_topIndicatorButton];
    [superView addSubview:_bottomDecorateLabel];
       [_topIndicatorButton setTitle:self.topLabelArray[superView.tag-1] forState:UIControlStateNormal];
        _topIndicatorButton.titleLabel.numberOfLines=0;
        _topIndicatorButton.titleLabel.lineBreakMode=NSLineBreakByTruncatingHead;
        _topIndicatorButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    _tmpDic = [NSMutableDictionary dictionary];
    switch (superView.tag) {
        
        case 1:{
            [_tmpDic setObject:@"7" forKey:@"goods_type"];
            break;
        }
        case 2:{
            [_tmpDic setObject:@"6" forKey:@"goods_type"];
            break;
        }
        case 3:{
            [_tmpDic setObject:@"8" forKey:@"goods_type"];
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
        [self requestGoodsList];
    }];
    }
    else
    {
        
        if (!_other_topIndicatorButton) {
            _other_topIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_other_topIndicatorButton setBackgroundColor:[UIColor whiteColor]];
            [_other_topIndicatorButton.titleLabel setFont:ThemeFont(CommonFontSize)];
          
            _other_bottomDecorateLabel = [UILabel new];
           
            _other_tmpMemory = (NSInteger)ScreenWidth/10;
        }
        [_other_topIndicatorButton setTitleColor:RGBACOLOR(251, 91, 50, 1) forState:UIControlStateNormal];
        [_other_bottomDecorateLabel setBackgroundColor:RGBACOLOR(251, 91, 50, 1)];
        _other_topIndicatorButton.frame = CGRectMake(0, 0,superView.frame.size.width,superView.frame.size.height);
        _other_bottomDecorateLabel.frame = CGRectMake(0, superView.frame.size.height - 1.5,superView.frame.size.width,1.5);
        [superView addSubview:_other_topIndicatorButton];
        [superView addSubview:_other_bottomDecorateLabel];
        [_other_topIndicatorButton setTitle:self.topLabelArray[superView.tag-1] forState:UIControlStateNormal];
        _othertmpDic = [NSMutableDictionary dictionary];
        switch (superView.tag) {
            case 4:{

                [_othertmpDic setObject:@"5" forKey:@"sell_type"];                break;
            }
            case 5:{
                
                [_othertmpDic setObject:@"4" forKey:@"sell_type"];
                break;
            }
                       default:
                break;
        }
        //设置对象动画属性
        POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        anBasic.fromValue = @(_other_tmpMemory);
        anBasic.toValue = @(_other_topIndicatorButton.center.x);
        anBasic.beginTime = CACurrentMediaTime();
        [_other_bottomDecorateLabel pop_addAnimation:anBasic forKey:@"positionX"];
        _other_tmpMemory = _other_topIndicatorButton.center.x;
        [anBasic setAnimationDidStartBlock:^(POPAnimation *ani) {
            [self requestGoodsList];
        }];
    }
//    [anBasic setCompletionBlock:^(POPAnimation * ani, BOOL fin) {
//        if(fin) {
//            [self createMiddleFilterUI];
//        }
//    }];
}

- (void)leftItemClicked:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UIImage* thumbURL =  [UIImage imageNamed:@"shareIcon"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shopDic[@"shop_name"] descr:@"首农冻品店铺分享" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"http://www.taiyanggo.com/mobile/share.php?act=shop&id=%@",self.shopId];
    
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
-(void)rightItemClicked:(UIButton*)btn{
[UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatFavorite)]];
[UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
    // 根据获取的platformType确定所选平台进行下一步操作
    [self shareWebPageToPlatformType:platformType];
}];
}

#pragma mark 设置导航栏
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    _navigationBarView.backgroundColor=mainColor;
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
    
     UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shareButtonImage = [UIImage imageNamed:@"icon_offer_b_share"];
    [shareButton setImage:shareButtonImage forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_navigationBarView).with.offset(-10);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];

#pragma mark 设置搜索框
    
    
    
    _searchBar = [[UISearchBar alloc] init];
    [_navigationBarView addSubview:_searchBar];
    _searchBar.returnKeyType=UIReturnKeySearch;
    _searchBar.delegate = self;
    [_searchBar setSearchBarStyle:UISearchBarStyleDefault];
    _searchBar.placeholder = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Search the Product",nil)];
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    _searchBar.showsCancelButton = NO;
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton).with.offset(60);
        make.bottom.equalTo(_navigationBarView.mas_bottom).with.offset(-8);
        make.height.mas_equalTo(CommonSearchViewHeight);
        make.right.equalTo(shareButton.mas_left).with.offset(-20);
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
                [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Search the Product",nil)
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
//    [self getHomepageData];
}

-(void)buttonClicked:(UIButton *)button {
    POPSpringAnimation *anBasic = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anBasic.springBounciness = 10.0f;
    switch (button.tag) {
        case CancelButtonMessage:
        {
            _cancelButton.hidden = YES;
            anBasic.toValue = @(_blackView.center.x-ScreenWidth*3/4);
            anBasic.beginTime = CACurrentMediaTime();
            [_blackView pop_addAnimation:anBasic forKey:@"position"];
            break;
        }
        case SearchCancelButtonMessage:
        {
            [_searchBar resignFirstResponder];
            [_searchCancelButton removeFromSuperview];
            break;
        }
        case SearchButtonMessage:{
//            [self searchActionMethod];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatHUD{
    if (!_MBHUD) {
        _MBHUD = [[MBProgressHUD alloc] init];
        [self.view addSubview:_MBHUD];
    }
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [_MBHUD show:YES];
}

- (void)requestShopDetail{
    [self creatHUD];
    if (self.shopId) {
        NSDictionary *params = @{@"model":@"user",@"action":@"get_shop",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userget_shop%@",ConfigNetAppKey]],@"shop_id":self.shopId,@"user_id":[PSDefaults objectForKey:@"user_id"]};
        [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
            NSLog(@"shopdetailData:%@",data[@"content"]);
            if (![data[@"error"] intValue]) {
                _goods_type = 0;
                _shopDic=data[@"content"];
                [self configShopDetailUI:data[@"content"]];
                _user_id = [NSString stringWithFormat:@"%@",data[@"content"][@"user_id"]];
                [_MBHUD hide:YES afterDelay:1.5f];
                [self requestGoodsList];
            } else {
                [_MBHUD setLabelText:data[@"message"]];
                [_MBHUD hide:YES afterDelay:1.5f];
            }
        } failure:^(TYDPError *error) {
            NSLog(@"---ShopDetailError:%@---",error);
             [_MBHUD hide:YES afterDelay:1.5f];
        }];
    }
}

- (void)configShopDetailUI:(NSDictionary *)ShopData{
        [_headImg sd_setImageWithURL:[NSURL URLWithString:ShopData[@"user_face"]] placeholderImage:[UIImage imageNamed:@"person_head_default"]];
        _nameLab.text =[NSString stringWithFormat:@"%@",ShopData[@"shop_name"]];
    if ([[NSString stringWithFormat:@"%@",ShopData[@"is_follow"]] isEqualToString:@"1"]) {
        nintyLab.text=NSLocalizedString(@"Following",nil);
        nintyLab.backgroundColor=[UIColor grayColor];
    }
    else
    {
    nintyLab.text=NSLocalizedString(@"Follow",nil);
        nintyLab.backgroundColor=mainColor;
    }
    _followNum=ShopData[@"follow_count"];
    fo= [_followNum integerValue];

    _NumLab.text = [NSString stringWithFormat:@"%@%@",ShopData[@"follow_count"],NSLocalizedString(@"Following",nil)];
//        _NumLab.text = [NSString stringWithFormat:@"%@",ShopData[@"order_num"]];
//        _addressLab.text = [NSString stringWithFormat:@"所在地:%@ %@",ShopData[@"province"],ShopData[@"city"]];
}

- (void)requestGoodsList{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"model":@"goods",@"action":@"get_list",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"goodsget_list%@",ConfigNetAppKey]],@"user_id":_user_id,@"page":[NSNumber numberWithInt:_page],@"keywords":_searchBar.text}];
//    if (_goods_type == 6||_goods_type == 7) {
//        [params setObject:[NSString stringWithFormat:@"%d",_goods_type] forKey:@"goods_type"];
//    }else{
//        [params removeObjectForKey:@"goods_type"];
//    }
        [params addEntriesFromDictionary:_tmpDic];

    [params addEntriesFromDictionary:_othertmpDic];
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        NSLog(@"dianpu_goodsListData:%@",data);
        if ([data[@"error"] isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            if (data[@"content"][@"list"]) {
                _page_count = [data[@"content"][@"total"][@"page_count"] intValue];
                [_tableVC.mj_footer endRefreshing];
                [self analyseGoodsListData:data[@"content"][@"list"]];
                [_MBHUD hide:YES afterDelay:1];
            }
        }else{
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
         [_MBHUD hide:YES afterDelay:1.5f];
        NSLog(@"---GoodsListError:%@---",error);
    }];
}

- (void)analyseGoodsListData:(NSArray *)list{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    for (NSDictionary *goodsData in list) {
        TYDP_VendorModel *model = [TYDP_VendorModel new];
        [model setValuesForKeysWithDictionary:goodsData];
        [_dataSource addObject:model];
    }
//    _dataSource = [TYDP_NewVendorModel arrayOfModelsFromDictionaries:list error:nil];
//    for (TYDP_NewVendorModel *tempModel in _dataSource) {
//        NSLog(@"tempModel:%@",tempModel);
//    }
    [_tableVC reloadData];
}

- (void)creatUI{
    [self setUpNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建tableview
    _tableVC = [UITableView new];
    [self.view addSubview:_tableVC];
    _tableVC.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableVC.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    _tableVC.delegate = self;
    _tableVC.dataSource = self;
    [_tableVC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
    }];
    _tableVC.sectionHeaderHeight = 124;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 193+64+40)];
    _tableVC.tableHeaderView = headView;
    _page = 1;
    //下拉加载
    _tableVC.mj_footer.automaticallyHidden = YES;
    _tableVC.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        NSLog(@"page:%d,%d",_page,_page_count);
        //根据后台返回来的page总数限制刷新次数
        if (_page < _page_count) {
            _page++;
            [self requestGoodsList];
        } else {
            MBProgressHUD *tmpHud = [[MBProgressHUD alloc] init];
            [tmpHud setAnimationType:MBProgressHUDAnimationFade];
            [tmpHud setMode:MBProgressHUDModeText];
            [tmpHud setLabelText:NSLocalizedString(@"No more",nil)];
            [self.view addSubview:tmpHud];
            [tmpHud show:YES];
            [tmpHud hide:YES afterDelay:1.5f];
            [_tableVC.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    //顶部背景图
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 193)];
    [headView addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    imgView.image = [UIImage imageNamed:@"firm_bgcompany"];
    
    //厂家logo
    _headImg = [UIImageView new];
    [imgView addSubview:_headImg];
//    _headImg.image = [UIImage imageNamed:@"firm_logo"];
    _headImg.layer.cornerRadius = 32.5;
    _headImg.layer.masksToBounds = YES;
    [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView);
        make.bottom.equalTo(imgView).with.offset(-5);
        make.width.equalTo(_headImg.mas_height);
        make.width.mas_equalTo(65);
    }];
     //厂家名称
    _nameLab = [UILabel new];
    [imgView addSubview:_nameLab];
    _nameLab.text = @"";
    _nameLab.textColor = [UIColor whiteColor];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImg.mas_right).with.offset(10);
        make.centerY.equalTo(_headImg.mas_centerY).with.offset(0);
        make.height.mas_equalTo(20);
    }];
    
    //关注
    UIView *blackView = [UIView new];
    [imgView addSubview:blackView];
    blackView.layer.cornerRadius = 5;
    blackView.layer.masksToBounds = YES;
    blackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgView).with.offset(-5);
        make.bottom.equalTo(imgView).with.offset(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    nintyLab = [UILabel new];
    [blackView addSubview:nintyLab];
    nintyLab.text =NSLocalizedString(@"Follow",nil);
    nintyLab.userInteractionEnabled=YES;
    UITapGestureRecognizer *addednintyLabViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addednintyLabViewTap:)];
    [nintyLab addGestureRecognizer:addednintyLabViewTap];
    nintyLab.textAlignment=NSTextAlignmentCenter;
    nintyLab.backgroundColor=mainColor;
    nintyLab.font = [UIFont systemFontOfSize:13];
    nintyLab.textColor = [UIColor whiteColor];
    [nintyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(blackView).with.offset(0);
        make.left.equalTo(blackView).with.offset(0);
        make.top.equalTo(blackView).with.offset(0);
        make.right.equalTo(blackView).with.offset(0);
    }];
    
    _NumLab = [UILabel new];
    [imgView addSubview:_NumLab];
    _NumLab.text = [NSString stringWithFormat:@"%@N",NSLocalizedString(@"No. of reads",nil)];
    _NumLab.font = [UIFont systemFontOfSize:13];
    _NumLab.textColor = [UIColor whiteColor];
    [_NumLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_nameLab.mas_right).offset(0);
        make.right.equalTo(nintyLab.mas_left).offset(-10);
        make.bottom.equalTo(nintyLab.mas_bottom).offset(0);
        make.top.equalTo(nintyLab).offset(2);
    }];
    
    
    _btnImgArr = @[@"firm_icon_all_n",@"firm_icon_cash_n",@"firm_icon_futures_n"];
    _btnLabArr = @[NSLocalizedString(@"All",nil),NSLocalizedString(@"New",nil),NSLocalizedString(@"On Sale",nil)];
    _currentBtnImgArr = @[@"firm_icon_all_s",@"firm_icon_cash_s",@"firm_icon_futures_s"];
    if (!_t_btnArray) {
        _t_btnArray=[NSMutableArray new];
    }
    if (!_t_imgArray) {
        _t_imgArray=[NSMutableArray new];
    }
    if (!_t_titleArray) {
        _t_titleArray=[NSMutableArray new];
    }
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [headView addSubview:btn];
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(ScreenWidth/3*i, 0, ScreenWidth/3, 64);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom);
            make.left.mas_equalTo(ScreenWidth/3*i);
            make.width.mas_equalTo(ScreenWidth/3);
            make.height.mas_equalTo(64);
        }];
        
        [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *titleImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_btnImgArr[i]]];
        [btn addSubview:titleImg];
        titleImg.tag = 200+i;
        titleImg.image = [UIImage imageNamed:_btnImgArr[i]];
        [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(13);
            make.left.mas_equalTo(53*Width);
            make.right.mas_equalTo(-53*Width);
            make.height.equalTo(titleImg.mas_width);
        }];
        UILabel *titleLab = [UILabel new];
        [btn addSubview:titleLab];
        titleLab.tag = 300+i;
        titleLab.text = _btnLabArr[i];
        titleLab.textColor = RGBACOLOR(155, 155, 155, 1);
        titleLab.textAlignment = NSTextAlignmentCenter;
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleImg.mas_bottom);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [_t_btnArray addObject:btn];
        [_t_imgArray addObject:titleImg];
        [_t_titleArray addObject:titleLab];
        
        if (!_currentBtnIndex) {
            _currentBtnIndex = 0;
        }
        if (i == _currentBtnIndex) {
            [btn setBackgroundImage:[UIImage imageNamed:@"firm_line_orange"] forState:UIControlStateNormal];
            titleImg.image = [UIImage imageNamed:_currentBtnImgArr[i]];
            titleLab.textColor = RGBACOLOR(221, 92, 55, 1);
        }

    }
    
    
    NSInteger smallTopWidth = (NSInteger)ScreenWidth/5;
    NSInteger smallTopHeight = 40;
    for (int i = 0; i <5; i++) {
        UILabel *topSmallLabel = [[UILabel alloc] initWithFrame:CGRectMake(smallTopWidth*i, imgView.mj_size.height+imgView.mj_y+64, smallTopWidth, smallTopHeight)];
        [headView addSubview:topSmallLabel];
        [topSmallLabel setBackgroundColor:[UIColor whiteColor]];
        [topSmallLabel setText:self.topLabelArray[i]];
        [topSmallLabel setTextAlignment:NSTextAlignmentCenter];
        [topSmallLabel setFont:ThemeFont(CommonFontSize)];
        topSmallLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topLabelTapMethod:)];
        [topSmallLabel addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = i + 1;
        //默认设置不从首页进入的标志
        NSInteger tmpInteger = 6;
        switch (_HomePageFlag) {
            case 1:{
                tmpInteger = 1;
                break;
            }
            case 2:{
                tmpInteger = 2;
                break;
            }
            case 3:{
                tmpInteger = 3;
                break;
            }
            case 4:{
                tmpInteger = 4;
                break;
            }
            case 5:{
                tmpInteger = 5;
                break;
            }
            default:
                break;
        }
        if (i == tmpInteger) {
            [self setTopIndicatorButtonVisible:topSmallLabel];
        } else {
//            if ([[_filterDic allKeys] count]) {
//                //搜索商品
//                //                [self getShopListDataWithNewDic:_filterDic];
//                [self createMiddleFilterUI];
//                
//            }
        }
    }
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(60);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bottomView addSubview:btn];
    btn.backgroundColor = mainColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedString(@"Stall detail",nil) forState:UIControlStateNormal];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).with.offset(10);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo((ScreenWidth-80)/2);
        make.height.mas_equalTo(40);
    }];
    [btn addTarget:self action:@selector(dianPuDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bottomView addSubview:btn1];
    btn1.backgroundColor = mainColor;
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitle:NSLocalizedString(@"Contact",nil) forState:UIControlStateNormal];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).with.offset(10);
        make.left.mas_equalTo((ScreenWidth-80)/2+60);
        make.width.mas_equalTo((ScreenWidth-80)/2);
        make.height.mas_equalTo(40);
    }];
    [btn1 addTarget:self action:@selector(dianPuTelephoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self requestShopDetail];
}
- (void)addednintyLabViewTap:(UITapGestureRecognizer *)tap {
    UILabel * lableView=(UILabel *)tap.view;
    if ([lableView.text isEqualToString:NSLocalizedString(@"Following",nil)]) {
        NSDictionary *params = @{@"model":@"user",@"action":@"unfollow_store",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userunfollow_store%@",ConfigNetAppKey]],@"shop_id":self.shopId,@"user_id":[PSDefaults objectForKey:@"user_id"]};
        [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
            debugLog(@"ifFollowData:%@",data[@"content"]);
            if (![data[@"error"] intValue]) {
                
                nintyLab.text=NSLocalizedString(@"Follow",nil);
                nintyLab.backgroundColor=mainColor;
                fo--;
                _NumLab.text = [NSString stringWithFormat:@"%@%ld",NSLocalizedString(@"Following", nil),fo];
            } else {
                [_MBHUD setLabelText:data[@"message"]];
                [_MBHUD hide:YES afterDelay:1.5f];
            }
        } failure:^(TYDPError *error) {
            NSLog(@"---ShopDetailError:%@---",error);
        }];
    }
    else
    {
        NSDictionary *params = @{@"model":@"user",@"action":@"follow_store",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userfollow_store%@",ConfigNetAppKey]],@"shop_id":self.shopId,@"user_id":[PSDefaults objectForKey:@"user_id"]};
        [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
            debugLog(@"ifFollowData:%@",data[@"content"]);
            if (![data[@"error"] intValue]) {
                
                nintyLab.text=NSLocalizedString(@"Following",nil);
                nintyLab.backgroundColor=[UIColor grayColor];
                fo++;
                _NumLab.text = [NSString stringWithFormat:@"%ld%@",fo,NSLocalizedString(@"Following",nil)];
            } else {
                [_MBHUD setLabelText:data[@"message"]];
                [_MBHUD hide:YES afterDelay:1.5f];
            }
        } failure:^(TYDPError *error) {
            NSLog(@"---ShopDetailError:%@---",error);
        }];

    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    debugLog(@"搜索");
    _page=1;
    [_dataSource removeAllObjects];
    [self requestGoodsList];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"搜索");
    TYDP_ShopListViewController *ShopListVC = [TYDP_ShopListViewController new];
    ShopListVC.sign_MSandTJ = NO;

    ShopListVC.filterDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"user_id":_user_id,@"keywords":textField.text}];
    [self.navigationController pushViewController:ShopListVC animated:YES];
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDP_VendorCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_VendorCell" owner:self options:nil]lastObject];
    if (!cell) {
        cell = [[TYDP_VendorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_VendorCell"];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [self configCell:cell WithIndexPath:indexPath];
    return cell;
}
- (void)configCell:(TYDP_VendorCell *)cell WithIndexPath:(NSIndexPath *)indexPath{
    TYDP_VendorModel *model = [TYDP_VendorModel new];
    model = _dataSource[indexPath.row];
    cell.titleLab.text = model.goods_name;
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    cell.priceLab.text = model.shop_price;
    cell.numLab.text = model.brand_sn;
    cell.addressLab.text = model.goods_local;
    cell.regionNameLbale.text = model.region_name_ch;
    cell.unitNameLable.text = [NSString stringWithFormat:@"/%@",model.unit_name];

    [cell.regin_icon sd_setImageWithURL:[NSURL URLWithString:model.region_icon]];
    NSArray *subimgArr = @[@[NSLocalizedString(@"pic_futures_en",nil),NSLocalizedString(@"pic_cash_en",nil)],@[NSLocalizedString(@"pic_retail_en",nil),NSLocalizedString(@"pic_fcl_en",nil)],@[@"",NSLocalizedString(@"pic_lcl_en",nil)],@[@"",NSLocalizedString(@"pic_bargaining_en",nil)]];//@[期，现],@[零，整]]@[否，拼],@[正，还]
    cell.subImg1.image = [UIImage imageNamed:subimgArr[0][[model.goods_type intValue]-6]];
    cell.subImg2.image = [UIImage imageNamed:subimgArr[1][[model.sell_type intValue]-4]];
    if ([model.offer isEqualToString:@"10"]) {
        cell.subImg3.image = [UIImage imageNamed:subimgArr[2][[model.is_pin intValue]]];
    }else{
        cell.subImg3.image = [UIImage imageNamed:subimgArr[3][1]];
        cell.subImg4.image = [UIImage imageNamed:subimgArr[2][[model.is_pin intValue]]];
    }
    //库存为0或者为负时不能点击
        BOOL JudgeStoreNumber = YES;
        NSString *tmpString = [NSString stringWithFormat:@"%@",model.goods_number];
        if ([tmpString length] >= 1) {
            if ([[tmpString substringToIndex:1] isEqualToString:@"-"]) {
                JudgeStoreNumber = NO;
            }
        }
        if ([model.goods_number intValue] == 0||JudgeStoreNumber == NO) {
            cell.userInteractionEnabled = NO;
            UIImageView *backGroundImageView = [UIImageView new];
//            backGroundImageView.image = [UIImage imageNamed:@"home_icon_sell"];
            backGroundImageView.backgroundColor = [UIColor whiteColor];
            backGroundImageView.alpha = 0.7;
            [cell addSubview:backGroundImageView];
            [backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            
            UIImageView *cycImg = [UIImageView new];
            cycImg.image = [UIImage imageNamed:NSLocalizedString(@"icon_sellout_en", nil)];
            [backGroundImageView addSubview:cycImg];
            [cycImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(backGroundImageView.mas_right).with.offset(-60);
                make.bottom.equalTo(backGroundImageView.mas_bottom).with.offset(-10);
                make.width.mas_equalTo(1.175*110);
                make.height.mas_equalTo(110);
            }];

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableVC deselectRowAtIndexPath:indexPath animated:YES];
    TYDP_OfferDetailViewController *OfferDetailVC = [TYDP_OfferDetailViewController new];
    TYDP_VendorModel *model = [TYDP_VendorModel new];
    model = _dataSource[indexPath.row];
    OfferDetailVC.goods_id = model.goods_id;
    [self.navigationController pushViewController:OfferDetailVC animated:YES];
}

- (void)dianPuDetailBtnClick:(UIButton *)sender{
    dianpuDetailMsgViewController * dianpuDetailMsgVC = [[dianpuDetailMsgViewController alloc] init];
    dianpuDetailMsgVC.shop_id=_shopId;
    [self.navigationController pushViewController:dianpuDetailMsgVC animated:YES];
}
- (void)dianPuTelephoneBtnClick:(UIButton *)sender
{
    
    if(!_shopDic[@"service_hotline"]||[_shopDic[@"service_hotline"] isEqualToString:@""])
    {
        [self.view Message:NSLocalizedString(@"He/she didn't reserve the phone number", nil) HiddenAfterDelay:1.5];
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_shopDic[@"service_hotline"]];
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@",str]];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    [self.view addSubview:callWebview];
    
}

- (void)selectBtnClick:(UIButton *)sender{
    //褪色
    [_topIndicatorButton removeFromSuperview];
    [_other_topIndicatorButton removeFromSuperview];
    
    [_topIndicatorButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_bottomDecorateLabel setBackgroundColor:[UIColor clearColor]];
    
    
    [_other_topIndicatorButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_other_bottomDecorateLabel setBackgroundColor:[UIColor clearColor]];
    
    if (_currentBtnIndex == sender.tag-100) {
        return;
    }
    _currentBtnIndex = sender.tag-100;
    _page=1;
    _dataSource=nil;
    UIButton * btn0 = [_t_btnArray objectAtIndex:0];
    UIImageView * titleImg0 = [_t_imgArray objectAtIndex:0];
    UILabel * titleLab0 = [_t_titleArray objectAtIndex:0];

    
    UIButton * btn1 = [_t_btnArray objectAtIndex:1];
    UIImageView * titleImg1 = [_t_imgArray objectAtIndex:1];
    UILabel * titleLab1 = [_t_titleArray objectAtIndex:1];

    UIButton * btn2 = [_t_btnArray objectAtIndex:2];
    UIImageView * titleImg2 = [_t_imgArray objectAtIndex:2];
    UILabel * titleLab2 = [_t_titleArray objectAtIndex:2];
    
    if (sender.tag == 100) {
        [btn0 setBackgroundImage:[UIImage imageNamed:@"firm_line_orange"] forState:UIControlStateNormal];
        titleImg0.image = [UIImage imageNamed:_currentBtnImgArr[0]];
        titleLab0.textColor = RGBACOLOR(221, 92, 55, 1);
        
        [btn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        titleImg1.image = [UIImage imageNamed:_btnImgArr[1]];
        titleLab1.textColor = RGBACOLOR(155, 155, 155, 1);
        
        [btn2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        titleImg2.image = [UIImage imageNamed:_btnImgArr[2]];
        titleLab2.textColor = RGBACOLOR(155, 155, 155, 1);
        [_tmpDic removeObjectForKey:@"promote"];
        [_tmpDic removeObjectForKey:@"goods_types"];
        [_othertmpDic removeObjectForKey:@"sell_type"];
    }else if (sender.tag == 101) {
        [btn1 setBackgroundImage:[UIImage imageNamed:@"firm_line_orange"] forState:UIControlStateNormal];
        titleImg1.image = [UIImage imageNamed:_currentBtnImgArr[1]];
        titleLab1.textColor = RGBACOLOR(221, 92, 55, 1);
        
        [btn0 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        titleImg0.image = [UIImage imageNamed:_btnImgArr[0]];
        titleLab0.textColor = RGBACOLOR(155, 155, 155, 1);
        
        [btn2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        titleImg2.image = [UIImage imageNamed:_btnImgArr[2]];
        titleLab2.textColor = RGBACOLOR(155, 155, 155, 1);
         [_tmpDic removeObjectForKey:@"promote"];
        [_tmpDic removeObjectForKey:@"goods_types"];
        [_othertmpDic removeObjectForKey:@"sell_type"];
    }
    else
    {
        [btn2 setBackgroundImage:[UIImage imageNamed:@"firm_line_orange"] forState:UIControlStateNormal];
        titleImg2.image = [UIImage imageNamed:_currentBtnImgArr[2]];
        titleLab2.textColor = RGBACOLOR(221, 92, 55, 1);
        
        [btn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        titleImg1.image = [UIImage imageNamed:_btnImgArr[1]];
        titleLab1.textColor = RGBACOLOR(155, 155, 155, 1);
        
        [btn0 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        titleImg0.image = [UIImage imageNamed:_btnImgArr[0]];
        titleLab0.textColor = RGBACOLOR(155, 155, 155, 1);
        _tmpDic[@"promote"]=@"8";
        [_tmpDic removeObjectForKey:@"goods_types"];
        [_othertmpDic removeObjectForKey:@"sell_type"];
        
    }
    
    [_dataSource removeAllObjects];
    [self requestGoodsList];
}

- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtnClick{
    NSLog(@"分享");
    /*
    [UMSocialData defaultData].extConfig.title = @"远洋冻品";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://tydpb2b.bizsoho.com/";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"57aa879467e58e4370003259"
                                      shareText:@"远洋冻品欢迎您！"
                                     shareImage:[UIImage imageNamed:@"edit_icon_portrait"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:self];
     */
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"厂商信息界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"厂商信息界面"];
}

@end
