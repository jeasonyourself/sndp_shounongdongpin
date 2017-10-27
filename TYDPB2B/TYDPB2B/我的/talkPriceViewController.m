//
//  talkPriceViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/8.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "talkPriceViewController.h"
#import "talkPriceTableViewCell.h"
#import "talkPriceModel.h"
@interface talkPriceViewController ()
{
    MBProgressHUD *_MBHUD;
    UIView * bgView;
    UIView * TFView;
    UITextField * priceTf;
    NSInteger page;
    NSInteger totalCount;
}
@property(nonatomic, strong)NSMutableArray *goodsModelArray;
@end

@implementation talkPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsModelArray=[[NSMutableArray alloc] init];
    page=1;
    [self getHomepageData];
    [self creatUI];
    
    
    bgView=[UIView new];
    bgView.frame=CGRectMake(0, 0, ScreenWidth, self.view.mj_h);
    bgView.backgroundColor=[UIColor blackColor];
    bgView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTapMethod:)];
    [bgView addGestureRecognizer:tap];
    bgView.alpha=0.7;
    
    TFView=[UIView new];
    TFView.backgroundColor=[UIColor whiteColor];

    priceTf=[UITextField new];
    priceTf.keyboardType=UIKeyboardTypeNumberPad;
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
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller",@"getHucksterList",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"getHucksterList",@"sign":[TYDPManager md5:Sign],@"model":@"seller",@"page":@"1",@"size":[NSString stringWithFormat:@"%ld",page*10],@"user_id":[PSDefaults objectForKey:@"user_id"]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        debugLog(@"yijiaData:%@",data);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            [_goodsModelArray removeAllObjects];

            [_goodsModelArray addObjectsFromArray:[talkPriceModel arrayOfModelsFromDictionaries:data[@"content"][@"list"] error:nil]];
            debugLog(@"_goodsModelArray_goodsModelArray:%ld",_goodsModelArray.count);
            totalCount=[data[@"content"][@"total"][@"page_count"] integerValue];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
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


- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"议价列表";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.tableView.backgroundColor = RGBACOLOR(244, 244, 244, 1);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //取消Tableview上的按钮高亮效果延迟效果（如头视图和脚视图上的Button）
    self.tableView.delaysContentTouches = NO;
    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        page++;
        if (page>totalCount) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self getHomepageData];
        }
    }];
    //取消Tableviewcell上的按钮高亮效果延迟效果（当需要在cell上添加Button时直接在上一句代码后增加如下代码）
    for (UIView *currentView in self.tableView.subviews) {
        if([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
        }
    }
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
return 90.0/375.0*ScreenWidth;
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    
    CGFloat sectionHeaderHeight =120;
    
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset=UIEdgeInsetsMake(-scrollView.contentOffset.y,0,0,0);
        
    }else if(scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset=UIEdgeInsetsMake(-sectionHeaderHeight,0,0,0);
        
    }
    
}

#pragma mark 商品详情
- (void)bottomCellTapMethod:(UITapGestureRecognizer *)tap
{
    
}

#pragma mark 自定价
- (void)zidingjiaTapMethod:(UITapGestureRecognizer *)tap
{
    UIView * sview=[tap view];
    
    bgView.tag=sview.tag;
    TFView.tag=sview.tag;
    priceTf.tag=sview.tag;
    self.tableView.scrollEnabled=NO;
    [self.view addSubview:bgView];
    [self.view addSubview:TFView];
    [TFView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(40);
        make.centerY.equalTo(bgView).with.offset(-100);
        make.right.equalTo(bgView).with.offset(-40);
        make.height.mas_equalTo(120);
    }];
    
    UILabel *titleLable = [UILabel new];
    [titleLable setText:[NSString stringWithFormat:@"请输入自定价(¥/%@)",NSLocalizedString(@"Ton", nil)]];
    [titleLable setFont:ThemeFont(CommonFontSize)];
    [titleLable setTextColor:[UIColor blackColor]];
    [TFView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(TFView).with.offset(-10);
        make.top.equalTo(TFView).with.offset(10);
        make.left.equalTo(TFView).with.offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [priceTf setFont:ThemeFont(CommonFontSize-2)];
    [TFView addSubview:priceTf];
    
    [priceTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(TFView).with.offset(-10);
        make.top.equalTo(titleLable.mas_bottom).with.offset(15);
        make.left.equalTo(TFView).with.offset(10);
        make.height.mas_equalTo(20);
    }];
    [priceTf becomeFirstResponder];
    
    UILabel *sureLable = [UILabel new];
    [sureLable setText:NSLocalizedString(@"Sure",nil)];
    [sureLable setFont:ThemeFont(CommonFontSize-2)];
    [sureLable setTextColor:mainColor];
    sureLable.textAlignment=NSTextAlignmentCenter;
    [TFView addSubview:sureLable];

    [sureLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(TFView).with.offset(-20);
        make.bottom.equalTo(TFView).with.offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    sureLable.tag=sview.tag;
    sureLable.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sureAndremoveTapMethod:)];
    [sureLable addGestureRecognizer:tap1];

    
}
- (void)sureAndremoveTapMethod:(UITapGestureRecognizer *)tap
{
    
    talkPriceModel *tmpGoodsModel = _goodsModelArray[priceTf.tag];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller",@"saveHuckster",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"saveHuckster",@"sign":[TYDPManager md5:Sign],@"model":@"seller",@"user_id":[PSDefaults objectForKey:@"user_id"],@"goods_id":tmpGoodsModel.goods_id,@"price":priceTf.text};
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        NSLog(@"zidingjiaData:%@",data);
        if (![data[@"error"] intValue]) {
            [self getHomepageData];
        }
    } failure:^(TYDPError *error) {
        NSLog(@"%@",error);
    }];
    
    [priceTf removeFromSuperview];
    [TFView removeFromSuperview];
    [bgView removeFromSuperview];
    self.tableView.scrollEnabled=YES;

}

- (void)removeTapMethod:(UITapGestureRecognizer *)tap
{
    
    
    [priceTf removeFromSuperview];
    [TFView removeFromSuperview];
    [bgView removeFromSuperview];
    self.tableView.scrollEnabled=YES;

    
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    talkPriceModel *tmpGoodsModel = _goodsModelArray[section];
    
    CGFloat bottomCellHeight = ScreenWidth/4;

    UIView *bottomCellView = [UIView new];
    bottomCellView.backgroundColor=[UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomCellTapMethod:)];
    [bottomCellView addGestureRecognizer:tap];
    UIView *tmpView = [tap view];
    tmpView.tag = section + 1;
    bottomCellView.frame=CGRectMake(0, 0, ScreenWidth, 90.0/375.0*ScreenWidth);

    UIImageView *leftBigImageView = [UIImageView new];
        [bottomCellView addSubview:leftBigImageView];
        [leftBigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomCellView).with.offset(Gap);
            make.centerY.equalTo(bottomCellView);
            make.height.mas_equalTo(bottomCellHeight - 20);
            make.width.equalTo(leftBigImageView.mas_height);
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
        [middleMiddleLabel setText:[NSString stringWithFormat:@"厂号：%@",tmpGoodsModel.brand_sn]];
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
        [bottomPriceLabel setText:[NSString stringWithFormat:@"原价:%@/%@",tmpGoodsModel.shop_price,NSLocalizedString(@"Ton", nil)]];
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
        [bottomMeasureLabel setText:[NSString stringWithFormat:@"自定价"]];
        [bottomMeasureLabel setFont:ThemeFont(14)];
        [bottomMeasureLabel setTextColor:[UIColor whiteColor]];
        [bottomMeasureLabel setBackgroundColor:mainColor];
    bottomMeasureLabel.textAlignment=NSTextAlignmentCenter;
    bottomMeasureLabel.layer.cornerRadius = (bottomCellHeight - 2*Gap)/6;//设置那个圆角的有多圆
    bottomMeasureLabel.layer.borderWidth =0;//设置边框的宽度，当然可以不要
    bottomMeasureLabel.layer.borderColor =nil;//设置边框的颜色
    bottomMeasureLabel.layer.masksToBounds = YES;//设为NO去试试
        [bottomCellView addSubview:bottomMeasureLabel];
        [bottomMeasureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomCellView.mas_right).with.offset(-Gap);
            make.top.equalTo(middleMiddleLabel.mas_bottom).with.offset(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo((bottomCellHeight - 2*Gap)/3);
        }];
    bottomMeasureLabel.tag=section;
    bottomMeasureLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zidingjiaTapMethod:)];
    [bottomMeasureLabel addGestureRecognizer:tap1];
    
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
                firstImageViewString = [NSString stringWithFormat:@"pic_cash"];
                break;
            }
            case 6:{
                firstImageViewString = [NSString stringWithFormat:@"pic_futures"];
                break;
            }
            default:
                break;
        }
        NSString *secondImageViewString;
        switch ([tmpGoodsModel.sell_type intValue]) {
            case 4:{
                secondImageViewString = [NSString stringWithFormat:@"pic_zero"];
                break;
            }
            case 5:{
                secondImageViewString = [NSString stringWithFormat:@"pic_fcl"];
                break;
            }
            default:
                break;
        }
        [smallRightFirstImageView setImage:[UIImage imageNamed:firstImageViewString]];
        [smallRightSecondImageView setImage:[UIImage imageNamed:secondImageViewString]];
        if ([tmpGoodsModel.offer isEqualToString:@"11"]) {
            [smallRightThirdImageView setImage:[UIImage imageNamed:@"pic_bargaining"]];
//            if ([tmpGoodsModel.is_pin isEqualToString:@"1"]) {
//                [smallRightFouthImageView setImage:[UIImage imageNamed:@"pic_lcl"]];
//            }
//        } else {
//            if ([tmpGoodsModel.is_pin isEqualToString:@"1"]) {
//                [smallRightThirdImageView setImage:[UIImage imageNamed:@"pic_lcl"]];
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
    talkPriceModel *tmpGoodsModel = _goodsModelArray[section];

    return tmpGoodsModel.huck_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    talkPriceTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"talkPriceTableViewCell" owner:self options:nil] lastObject];
    if (!cell) {
        cell = [[talkPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"talkPriceTableViewCell"];
    }
    
    talkPriceModel *tmpGoodsModel = _goodsModelArray[indexPath.section];
    NSDictionary * dic =[tmpGoodsModel.huck_list objectAtIndex:indexPath.row];
    cell.priceLable.text=dic[@"price"];
    cell.timeLable.text=dic[@"created_at"];
    cell.liuyanLable.text=[NSString stringWithFormat:@"留言:%@",dic[@"message"]];
    if ([tmpGoodsModel.huckster isEqualToString:@"2"]) {
        if (indexPath.row==0) {
            [cell.okBtn setTitle:@"已采用" forState:UIControlStateNormal];
            cell.okBtn.userInteractionEnabled=NO;
        }
        else
        {
            [cell.okBtn setTitle:@"采用" forState:UIControlStateNormal];
            cell.okBtn.userInteractionEnabled=YES;
        }
        
    }
    else
    {
        [cell.okBtn setTitle:@"采用" forState:UIControlStateNormal];
        cell.okBtn.userInteractionEnabled=YES;

    }
    cell.okBtn.layer.cornerRadius = cell.okBtn.mj_h/2;//设置那个圆角的有多圆
    cell.okBtn.layer.borderWidth =0;//设置边框的宽度，当然可以不要
    cell.okBtn.layer.borderColor =nil;//设置边框的颜色
    cell.okBtn.layer.masksToBounds = YES;//设为NO去试试
    cell.okBtn.tag=indexPath.section*1000+indexPath.row;
    [cell.okBtn addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    self.tableView.rowHeight = 101;
    return cell;
}

-(void)okButtonClick:(UIButton *)btn
{
    NSInteger secion = btn.tag/1000;
    NSInteger row = btn.tag%1000;
talkPriceModel *tmpGoodsModel = _goodsModelArray[secion];
    NSDictionary * dic = [tmpGoodsModel.huck_list objectAtIndex:row];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller",@"saveHuckster",ConfigNetAppKey];
    NSDictionary *params = @{@"action":@"saveHuckster",@"sign":[TYDPManager md5:Sign],@"model":@"seller",@"user_id":[PSDefaults objectForKey:@"user_id"],@"goods_id":tmpGoodsModel.goods_id,@"huck_id":dic[@"id"],};
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        NSLog(@"sureData:%@",data);
        if (![data[@"error"] intValue]) {

            [self getHomepageData];
        }
    } failure:^(TYDPError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


@end
