//
//  manageGoodsViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/9.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "manageGoodsViewController.h"
#import "talkPriceTableViewCell.h"
#import "goodsBaseModel.h"
#import "LMContainsLMComboxScrollView.h"
#import "TYDP_pubOfferViewController.h"
#import "TYDP_OfferDetailViewController.h"
#define kDropDownListTag 1000

@interface manageGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *_MBHUD;
    
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
    NSString *selectedCity;
    NSString *selectedArea;
    
    NSInteger page;
    NSInteger totalCount;

}
@property(nonatomic, strong)NSMutableArray *goodsModelArray;
@property(nonatomic, strong)UITableView *myTableView;

@end

@implementation manageGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsModelArray=[[NSMutableArray alloc] init];
    
    province=[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Future", nil)],[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Spot", nil)], nil];
    city=[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Retail", nil)],[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"FCL", nil)], nil];
    district=[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"On Shelf", nil)],[NSString stringWithFormat:@"%@↓",NSLocalizedString(@"Off Shelf", nil)],nil];
    
    selectedProvince=[NSString stringWithFormat:@"6"];
    selectedCity=[NSString stringWithFormat:@"4"];
    selectedArea=[NSString stringWithFormat:@"1"];
page=1;
    [self getHomepageData];
    [self creatUI];
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


- (void)getHomepageData {
    [self creatHUD];
    
    //    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"offer_list",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"offer_list",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"page":@"1",@"size":[NSString stringWithFormat:@"%ld",page*10],@"user_id":[PSDefaults objectForKey:@"user_id"],@"goods_type":selectedProvince,@"sell_type":selectedCity,@"is_on_sale":selectedArea};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        debugLog(@"baopanguanliData:%@",data);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            [_goodsModelArray removeAllObjects];
            [_goodsModelArray addObjectsFromArray:[goodsBaseModel arrayOfModelsFromDictionaries:data[@"content"][@"list"] error:nil]];
            [_myTableView reloadData];
        }else{
           [_MBHUD hide:YES];
            debugLog(@"%@",data[@"message"]);
        }
    } failure:^(TYDPError *error) {

        [_MBHUD hide:YES];
        debugLog(@"error:%@",error);
    }];
    
}


- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = NSLocalizedString(@"Offer", nil);
    
    
    for(NSInteger i=0;i<3;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(ScreenWidth/3*i, 0, ScreenWidth/3, 40)];
        NSMutableArray *itemsArray;
        if (i==0) {
            itemsArray = [NSMutableArray arrayWithArray:province];
        }
        if(i==1) {
            itemsArray = [NSMutableArray arrayWithArray:city];
            }
        if(i==2) {
            itemsArray = [NSMutableArray arrayWithArray:district];
        }
        debugLog(@"aaaaarr:%@",itemsArray);
        comBox.titlesList = itemsArray;
        comBox.delegate = self;
        comBox.supView = self.view;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        [self.view addSubview:comBox];
    }

    UILabel *bottomMeasureLabel = [UILabel new];
    [bottomMeasureLabel setText:[NSString stringWithFormat:NSLocalizedString(@"For sell", nil)]];
    [bottomMeasureLabel setFont:ThemeFont(14)];
    [bottomMeasureLabel setTextColor:[UIColor whiteColor]];
    [bottomMeasureLabel setBackgroundColor:mainColor];
    bottomMeasureLabel.textAlignment=NSTextAlignmentCenter;
    bottomMeasureLabel.layer.cornerRadius = 0;//设置那个圆角的有多圆
    bottomMeasureLabel.layer.borderWidth =0;//设置边框的宽度，当然可以不要
    bottomMeasureLabel.layer.borderColor =nil;//设置边框的颜色
    bottomMeasureLabel.layer.masksToBounds = YES;//设为NO去试试
    [self.view addSubview:bottomMeasureLabel];
    [bottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(40);
    }];
    
    bottomMeasureLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTapMethod:)];
    [bottomMeasureLabel addGestureRecognizer:tap1];
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    _myTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.mj_w, self.view.mj_h-NavHeight-40-40) style:UITableViewStylePlain];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    [self.view addSubview:_myTableView];
    _myTableView.backgroundColor = RGBACOLOR(244, 244, 244, 1);
    [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //取消Tableview上的按钮高亮效果延迟效果（如头视图和脚视图上的Button）
    self.myTableView.delaysContentTouches = NO;
    self.myTableView.mj_footer.automaticallyHidden = YES;
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        page++;
        if (page>totalCount) {
            [self.myTableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self getHomepageData];
        }
    }];

    //取消Tableviewcell上的按钮高亮效果延迟效果（当需要在cell上添加Button时直接在上一句代码后增加如下代码）
    for (UIView *currentView in self.myTableView.subviews) {
        if([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
        }
    }
}

#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    NSInteger tag = _combox.tag - kDropDownListTag;
    switch (tag) {
        case 0:
        {
            selectedProvince =  index==0?@"6":@"7";
            
            
        }
            break;
        case 1:
        {
            selectedCity =  index==0?@"4":@"5";
            
            
        }
            break;
        case 2:
        {
            selectedArea =  index==0?@"1":@"0";
            
            
        }
            break;
            default:
            
            break;
    }
    debugLog(@"ssssggg:%@-%@—%@",selectedProvince,selectedCity,selectedArea);
    
    [self getHomepageData];
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    
    CGFloat sectionHeaderHeight =160;
    
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset=UIEdgeInsetsMake(-scrollView.contentOffset.y,0,0,0);
        
    }else if(scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset=UIEdgeInsetsMake(-sectionHeaderHeight,0,0,0);
        
    }
    
}

#pragma mark 商品详情
- (void)bottomCellTapMethod:(UITapGestureRecognizer *)tap
{    UIView * sview=[tap view];

    goodsBaseModel *tmpGoodsModel = _goodsModelArray[sview.tag];
    TYDP_OfferDetailViewController *offerDetailViewCon = [[TYDP_OfferDetailViewController alloc] init];
    offerDetailViewCon.goods_id = tmpGoodsModel.goods_id;
    [self.navigationController pushViewController:offerDetailViewCon animated:YES];
}

#pragma mark 下架
- (void)downTapMethod:(UITapGestureRecognizer *)tap
{
     [self creatHUD];
    UIView * sview=[tap view];
    goodsBaseModel *tmpGoodsModel = _goodsModelArray[sview.tag];

    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"offer_edit_on_sale",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"offer_edit_on_sale",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"goods_id":tmpGoodsModel.goods_id,@"is_on_sale":[selectedArea isEqualToString:@"1"]?@"0":@"1",@"user_id":[PSDefaults objectForKey:@"user_id"]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        debugLog(@"xiajiaData:%@",data);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            [self getHomepageData];
        }else{
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1];
            NSLog(@"%@",data[@"message"]);
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [_MBHUD hide:YES afterDelay:1];
        NSLog(@"error:%@",error);
    }];

}
#pragma mark 复制
- (void)copyTapMethod:(UITapGestureRecognizer *)tap
{
    UIView *tmpView = [tap view];
    goodsBaseModel *tmpGoodsModel = _goodsModelArray[tmpView.tag];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"seller_Storyboard" bundle:nil];
    TYDP_pubOfferViewController*  pubOfferVC = [story instantiateViewControllerWithIdentifier:@"pubOfferVC"];
    pubOfferVC.if_addOrEditOrCopy=@"3";
    pubOfferVC.goods_id=[NSString stringWithFormat:@"%@",tmpGoodsModel.goods_id];
    //         pubOfferVC.dismissOrPop=YES;
    [self.navigationController pushViewController:pubOfferVC animated:YES];
}
#pragma mark 编辑
- (void)editTapMethod:(UITapGestureRecognizer *)tap
{
    UIView *tmpView = [tap view];
    goodsBaseModel *tmpGoodsModel = _goodsModelArray[tmpView.tag];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"seller_Storyboard" bundle:nil];
    TYDP_pubOfferViewController*  pubOfferVC = [story instantiateViewControllerWithIdentifier:@"pubOfferVC"];
    pubOfferVC.if_addOrEditOrCopy=@"2";
    pubOfferVC.goods_id=[NSString stringWithFormat:@"%@",tmpGoodsModel.goods_id];
    //         pubOfferVC.dismissOrPop=YES;
    [self.navigationController pushViewController:pubOfferVC animated:YES];
}
#pragma mark 新增
- (void)addTapMethod:(UITapGestureRecognizer *)tap
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"seller_Storyboard" bundle:nil];
    TYDP_pubOfferViewController*  pubOfferVC = [story instantiateViewControllerWithIdentifier:@"pubOfferVC"];
    pubOfferVC.if_addOrEditOrCopy=@"1";
    [self.navigationController pushViewController:pubOfferVC animated:YES];

}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    goodsBaseModel *tmpGoodsModel = _goodsModelArray[section];
    
    CGFloat bottomCellHeight = ScreenWidth/4;
    
    UIView *bottomCellView = [UIView new];
    bottomCellView.backgroundColor=[UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomCellTapMethod:)];
    [bottomCellView addGestureRecognizer:tap];
    UIView *tmpView = [tap view];
    tmpView.tag = section ;
    bottomCellView.frame=CGRectMake(0, 0, ScreenWidth, 160);
    
    UILabel *numberLabel = [UILabel new];
    [numberLabel setText:[NSString stringWithFormat:@"%@",tmpGoodsModel.sku]];
    [numberLabel setFont:ThemeFont(12)];
    [numberLabel setTextColor:RGBACOLOR(102, 102, 102, 1)];
    numberLabel.alpha=0.7;
    //        [middleTopLabel setTextColor:[UIColor grayColor]];
    [bottomCellView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomCellView).with.offset(10);
        make.left.equalTo(bottomCellView).with.offset(Gap);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(20);
    }];

    UILabel *passLale = [UILabel new];
    [passLale setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Audit through", nil)]];
    [passLale setFont:ThemeFont(12)];
    [passLale setTextColor:RGBACOLOR(102, 102, 102, 1)];
    passLale.textAlignment=NSTextAlignmentRight;
    passLale.alpha=0.7;
    //        [middleTopLabel setTextColor:[UIColor grayColor]];
    [bottomCellView addSubview:passLale];
    [passLale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomCellView).with.offset(10);
        make.right.equalTo(bottomCellView).with.offset(-Gap);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(20);
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
    
    
    UILabel *smallLocalLabel = [UILabel new];
    [smallLocalLabel setText:[NSString stringWithFormat:@"%@",tmpGoodsModel.region_name]];
    [smallLocalLabel setFont:ThemeFont(9)];
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
    [middleMiddleLabel setText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Plat NO.", nil),tmpGoodsModel.brand_sn]];
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
//    原价:
    [bottomPriceLabel setText:[NSString stringWithFormat:@"%@/%@",tmpGoodsModel.shop_price,tmpGoodsModel.unit_name]];
    [bottomPriceLabel setFont:ThemeFont(14)];
    [bottomPriceLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [bottomCellView addSubview:bottomPriceLabel];
    [bottomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBigImageView.mas_right).with.offset(Gap);
        make.top.equalTo(middleMiddleLabel.mas_bottom).with.offset(0);
        //            make.width.mas_equalTo(bottomCellHeight);
        make.height.mas_equalTo((bottomCellHeight - 2*Gap)/3);
    }];
    
    UILabel *guigeLabel = [UILabel new];
    if ([[NSString stringWithFormat:@"%@",tmpGoodsModel.sell_type] isEqualToString:@"4"]) {
        [guigeLabel setText:[NSString stringWithFormat:@"%@%@  %@%@",tmpGoodsModel.spec_2,tmpGoodsModel.spec_2_unit,tmpGoodsModel.goods_number,tmpGoodsModel.measure_unit]];

    }
    else
    {
     [guigeLabel setText:[NSString stringWithFormat:@"%@%@  %@%@",tmpGoodsModel.goods_weight,tmpGoodsModel.spec_1_unit,tmpGoodsModel.goods_number,tmpGoodsModel.measure_unit]];
    }
    [guigeLabel setFont:ThemeFont(14)];
    [guigeLabel setTextColor:RGBACOLOR(252, 91, 49, 1)];
    [bottomCellView addSubview:guigeLabel];
    [guigeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomPriceLabel.mas_right).with.offset(Gap);
        make.top.equalTo(middleMiddleLabel.mas_bottom).with.offset(0);
        //            make.width.mas_equalTo(bottomCellHeight);
        make.height.mas_equalTo((bottomCellHeight - 2*Gap)/3);
    }];
    
    
    UILabel *timeLable = [UILabel new];
    [timeLable setText:[NSString stringWithFormat:@"%@",tmpGoodsModel.last_update_time]];
    [timeLable setFont:ThemeFont(14)];
    [timeLable setTextColor:RGBACOLOR(102, 102, 102, 1)];
    [bottomCellView addSubview:timeLable];
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomCellView.mas_left).with.offset(Gap);
        make.bottom.equalTo(bottomCellView.mas_bottom).with.offset(-8);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(25);
    }];
    
    
    UILabel *bottomMeasureLabel = [UILabel new];
    [bottomMeasureLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Copy", nil)]];
    [bottomMeasureLabel setFont:ThemeFont(14)];
    [bottomMeasureLabel setTextColor:[UIColor whiteColor]];
    [bottomMeasureLabel setBackgroundColor:mainColor];
    bottomMeasureLabel.textAlignment=NSTextAlignmentCenter;
    bottomMeasureLabel.layer.cornerRadius = 5;//设置那个圆角的有多圆
    bottomMeasureLabel.layer.borderWidth =0;//设置边框的宽度，当然可以不要
    bottomMeasureLabel.layer.borderColor =nil;//设置边框的颜色
    bottomMeasureLabel.layer.masksToBounds = YES;//设为NO去试试
    [bottomCellView addSubview:bottomMeasureLabel];
    [bottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomCellView.mas_right).with.offset(-Gap);
        make.bottom.equalTo(bottomCellView.mas_bottom).with.offset(-8);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    bottomMeasureLabel.tag=section;

    bottomMeasureLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyTapMethod:)];
    [bottomMeasureLabel addGestureRecognizer:tap1];
    
    UILabel *bottomEditLabel = [UILabel new];
    [bottomEditLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Edit", nil)]];
    [bottomEditLabel setFont:ThemeFont(14)];
    [bottomEditLabel setTextColor:[UIColor whiteColor]];
    [bottomEditLabel setBackgroundColor:mainColor];
    bottomEditLabel.textAlignment=NSTextAlignmentCenter;
    bottomEditLabel.layer.cornerRadius = 5;//设置那个圆角的有多圆
    bottomEditLabel.layer.borderWidth =0;//设置边框的宽度，当然可以不要
    bottomEditLabel.layer.borderColor =nil;//设置边框的颜色
    bottomEditLabel.layer.masksToBounds = YES;//设为NO去试试
    [bottomCellView addSubview:bottomEditLabel];
    [bottomEditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomMeasureLabel.mas_left).with.offset(-5);
        make.bottom.equalTo(bottomCellView.mas_bottom).with.offset(-8);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    bottomEditLabel.tag=section;

    bottomEditLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapMethod:)];
    [bottomEditLabel addGestureRecognizer:tap2];
    
    
    UILabel *downLabel = [UILabel new];
    [downLabel setText:[NSString stringWithString:[selectedArea isEqualToString:@"1"]?NSLocalizedString(@"Off Shelf", nil):NSLocalizedString(@"On Shelf", nil)]];
    [downLabel setFont:ThemeFont(14)];
    [downLabel setTextColor:[UIColor whiteColor]];
    [downLabel setBackgroundColor:mainColor];
    downLabel.textAlignment=NSTextAlignmentCenter;
    downLabel.layer.cornerRadius = 5;//设置那个圆角的有多圆
    downLabel.layer.borderWidth =0;//设置边框的宽度，当然可以不要
    downLabel.layer.borderColor =nil;//设置边框的颜色
    downLabel.layer.masksToBounds = YES;//设为NO去试试
    [bottomCellView addSubview:downLabel];
    [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomEditLabel.mas_left).with.offset(-5);
        make.bottom.equalTo(bottomCellView.mas_bottom).with.offset(-8);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(25);
    }];
    downLabel.userInteractionEnabled=YES;
    downLabel.tag=section;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downTapMethod:)];
    [downLabel addGestureRecognizer:tap3];
    
    //        UILabel *bottomAmountLabel = [UILabel new];
    //        //        [bottomAmountLabel setText:[NSString stringWithFormat:@"%@%@",tmpGoodsModel.spec_1,tmpGoodsModel.spec_1_unit]];
    //        [bottomAmountLabel setFont:ThemeFont(14)];
    //        [bottomAmountLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
    //        [bottomCellView addSubview:bottomAmountLabel];
    //
    //
    //        UILabel *bottomOriginLabel = [UILabel new];
    //        [bottomOriginLabel setText:[NSString stringWithFormat:@"%@",tmpGoodsModel.region_name]];
    //        [bottomOriginLabel setTextAlignment:NSTextAlignmentRight];
    //        [bottomOriginLabel setFont:ThemeFont(13)];
    //        [bottomOriginLabel setTextColor:RGBACOLOR(153, 153, 153, 1)];
    //        [bottomCellView addSubview:bottomOriginLabel];
    //        [bottomOriginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(bottomMeasureLabel.mas_right);
    //            make.bottom.equalTo(leftBigImageView);
    //            make.right.equalTo(bottomCellView).with.offset(-Gap);
    //            make.height.mas_equalTo(CommonHeight);
    //        }];
    //        [bottomAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(bottomMeasureLabel.mas_right).with.offset(Gap);
    //            make.bottom.equalTo(leftBigImageView);
    //            //            make.width.mas_equalTo(bottomCellHeight/1.5);
    //            make.height.mas_equalTo(CommonHeight);
    //        }];
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
        //            if ([tmpGoodsModel.is_pin isEqualToString:@"1"]) {
        //                [smallRightFouthImageView setImage:[UIImage imageNamed:NSLocalizedString(@"pic_lcl_en",nil)]];
        //            }
        //        } else {
        //            if ([tmpGoodsModel.is_pin isEqualToString:@"1"]) {
        //                [smallRightThirdImageView setImage:[UIImage imageNamed:NSLocalizedString(@"pic_lcl_en",nil)]];
        //            }
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
    return bottomCellView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _goodsModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    talkPriceTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"talkPriceTableViewCell" owner:self options:nil] lastObject];
    if (!cell) {
        cell = [[talkPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"talkPriceTableViewCell"];
    }
    
//    talkPriceModel *tmpGoodsModel = _goodsModelArray[indexPath.section];
//    NSDictionary * dic =[tmpGoodsModel.huck_list objectAtIndex:indexPath.row];
//    cell.priceLable.text=dic[@"last_price"];
//    cell.timeLable.text=dic[@"created_at"];
//    cell.liuyanLable.text=[NSString stringWithFormat:@"留言:%@",dic[@"message"]];
//    cell.okBtn.layer.cornerRadius = cell.okBtn.mj_h/2;//设置那个圆角的有多圆
//    cell.okBtn.layer.borderWidth =0;//设置边框的宽度，当然可以不要
//    cell.okBtn.layer.borderColor =nil;//设置边框的颜色
//    cell.okBtn.layer.masksToBounds = YES;//设为NO去试试
//    cell.okBtn.tag=indexPath.section*1000+indexPath.row;
//    [cell.okBtn addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.myTableView.rowHeight = 0.1;
    return cell;
}


-(void)okButtonClick:(UIButton *)btn
{
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
