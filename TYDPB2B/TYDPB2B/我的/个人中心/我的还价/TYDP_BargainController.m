//
//  TYDP_BargainController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/19.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_BargainController.h"
#import "TYDP_BargainCell.h"
#import "TYDP_BargainCellB.h"
#import "TYDP_BargainModel.h"
#import "TYDP_OfferDetailViewController.h"
#import "TYDP_NoBargainController.h"

@interface TYDP_BargainController ()
{
    NSArray *_subImgS;//货物属性
    NSArray *_typeImgS;//还价状态
    NSMutableArray *_dataSource;
    MBProgressHUD *_MBHUD;
    int _page;//当前页数
    int _page_count;//一共页数
}
@end

@implementation TYDP_BargainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)requestData{
    [self creatHUD];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"model":@"user",@"action":@"get_myhuck",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userget_myhuck%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        debugLog(@"haijiadataaa:%@",data);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            _page_count = [data[@"content"][@"total"][@"page_count"] intValue];
            [self analyseData:data];
        }else{
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1];
            NSLog(@"%@",data[@"message"]);
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [_MBHUD hide:YES afterDelay:1];
        NSLog(@"%@",error);
    }];
    [self.tableView.mj_footer endRefreshing];
}

- (void)analyseData:(id)data{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    [_dataSource removeAllObjects];
    for (NSDictionary *modelDic in data[@"content"][@"list"]) {
        TYDP_BargainModel *model = [TYDP_BargainModel new];
        [model setValuesForKeysWithDictionary:modelDic];
        [_dataSource addObject:model];
    }
    [self.tableView reloadData];
    if (_dataSource.count == 0) {
        TYDP_NoBargainController *NoBargainVC = [TYDP_NoBargainController new];
        [self addChildViewController:NoBargainVC];
        [self.view addSubview:NoBargainVC.view];
    }else{
        for (UIViewController *childVC in self.childViewControllers) {
            if ([childVC isKindOfClass:[TYDP_NoBargainController class] ]) {
                [childVC.view removeFromSuperview];
                [childVC removeFromParentViewController];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self requestData];
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"我的还价界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"我的还价界面"];
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatHUD{
    if (!_MBHUD) {
        _MBHUD = [[MBProgressHUD alloc] init];
        [self.view addSubview:_MBHUD];
    }
    [_MBHUD setLabelText:@"稍等片刻。。。"];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [_MBHUD show:YES];
}

- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"我的还价";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    //取消Tableview上的按钮高亮效果延迟效果（如头视图和脚视图上的Button）
    self.tableView.delaysContentTouches = NO;
    
    //取消Tableviewcell上的按钮高亮效果延迟效果（当需要在cell上添加Button时直接在上一句代码后增加如下代码）
    for (UIView *currentView in self.tableView.subviews) {
        if([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
        }
    }

    //拼，期，现，整，零，还
    _subImgS = @[@[@"",@"pic_lcl"],@[@"pic_futures",@"pic_cash"],@[@"pic_retail",@"pic_fcl"]];//@[@[拼，空],@[期，现],@[零，整]]
    
    //还价成功，等待回复，还价失败
    _typeImgS = @[@"pic_wait",@"pic_failure",@"pic_succed"];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = RGBACOLOR(237, 243, 254, 1);
    
    //下拉加载
    _page = 1;
    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        //根据后台返回来的page总数限制刷新次数
        if (_page < _page_count) {
            _page++;
            [self requestData];
        } else {
            MBProgressHUD *tmpHud = [[MBProgressHUD alloc] init];
            [tmpHud setAnimationType:MBProgressHUDAnimationFade];
            [tmpHud setMode:MBProgressHUDModeText];
            [tmpHud setLabelText:@"没有更多了"];
            [self.view addSubview:tmpHud];
            [tmpHud show:YES];
            [tmpHud hide:YES afterDelay:1.5f];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (ScreenWidth <= 375) {
        TYDP_BargainCellB *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_BargainCellB" owner:self options:nil] lastObject];
        if (!cell) {
            cell = [[TYDP_BargainCellB alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_BargainCellB"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TYDP_BargainModel *model = [TYDP_BargainModel new];
        model = _dataSource[indexPath.row];
        self.tableView.rowHeight = 195+[self heightForCellWithText:model.message andFont:[NSNumber numberWithFloat:14.0] andWidth:[NSNumber numberWithFloat:ScreenWidth-20]];
        [self configCellB:cell WithIndexPath:indexPath];
        return cell;
    }else{
        TYDP_BargainCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_BargainCell" owner:self options:nil] lastObject];
        if (!cell) {
            cell = [[TYDP_BargainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_BargainCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TYDP_BargainModel *model = [TYDP_BargainModel new];
        model = _dataSource[indexPath.row];
        self.tableView.rowHeight = 195+[self heightForCellWithText:model.message andFont:[NSNumber numberWithFloat:14.0] andWidth:[NSNumber numberWithFloat:ScreenWidth-20]];

        [self configCell:cell WithIndexPath:indexPath];
        return cell;
    }
}

//iphone6P屏幕的cell
- (void)configCell:(TYDP_BargainCell *)cell WithIndexPath:(NSIndexPath *)indexPath{
    TYDP_BargainModel *model = [TYDP_BargainModel new];
    model = _dataSource[indexPath.row];
    cell.titleLab.text = model.goods_name;
    
    cell.priceAgo.text = model.last_price;
    cell.priceNow.text = model.last_price;

    cell.priceMine.text = model.price;

    cell.numLab.text = model.brand_sn;
    [cell.buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mainImg sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
//    [cell.stateImg sd_setImageWithURL:[NSURL URLWithString:model]];
    cell.subImg1.image = [UIImage imageNamed:@"pic_bargaining"];//还
    cell.subImg2.image = [UIImage imageNamed:_subImgS[1][[model.goods_type intValue]-6]];//现，期
    cell.subImg3.image = [UIImage imageNamed:_subImgS[2][[model.sell_type intValue]-4]];//零，整
    cell.subImg4.image = [UIImage imageNamed:_subImgS[0][[model.is_pin intValue]]];
    cell.typeImg.image = [UIImage imageNamed:_typeImgS[[model.status intValue]]];
    cell.timeLable.text=[NSString stringWithFormat:@"还价时间:%@",model.created_at];
    cell.spec_textLable.text=[NSString stringWithFormat:@"还价内容:%@",model.message];

    if ([model.status isEqualToString:@"0"]) {
        cell.bargainBtn.backgroundColor = [UIColor grayColor];
        cell.bargainBtn.userInteractionEnabled = NO;
    } else {
        [cell.bargainBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//iphone4，5，6屏幕的cell
- (void)configCellB:(UITableViewCell *)cell WithIndexPath:(NSIndexPath *)indexPath{
    TYDP_BargainModel *model = [TYDP_BargainModel new];
    model = _dataSource[indexPath.row];
    
    ((TYDP_BargainCellB *)cell).titleLab.text = model.goods_name;
    ((TYDP_BargainCellB *)cell).priceAgo.text = model.last_price;
    ((TYDP_BargainCellB *)cell).priceMine.text = model.price;
    ((TYDP_BargainCellB *)cell).priceNow.text = model.last_price;
    ((TYDP_BargainCellB *)cell).numLab.text = model.brand_sn;
    ((TYDP_BargainCellB *)cell).timeLable.text=[NSString stringWithFormat:@"还价时间:%@",model.created_at];
    ((TYDP_BargainCellB *)cell).spec_textLable.text=[NSString stringWithFormat:@"还价内容:%@",model.message];
    [((TYDP_BargainCellB *)cell).buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [((TYDP_BargainCellB *)cell).bargainBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [((TYDP_BargainCellB *)cell).mainImg sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    ((TYDP_BargainCellB *)cell).subImg1.image = [UIImage imageNamed:@"pic_bargaining"];//还
    ((TYDP_BargainCellB *)cell).subImg2.image = [UIImage imageNamed:_subImgS[1][[model.goods_type intValue]-6]];//现，期
    ((TYDP_BargainCellB *)cell).subImg3.image = [UIImage imageNamed:_subImgS[2][[model.sell_type intValue]-4]];//零，整
    ((TYDP_BargainCellB *)cell).subImg4.image = [UIImage imageNamed:_subImgS[0][[model.is_pin intValue]]];
    ((TYDP_BargainCellB *)cell).typeImg.image = [UIImage imageNamed:_typeImgS[[model.status intValue]]];
    if ([model.status isEqualToString:@"0"]) {
        ((TYDP_BargainCellB *)cell).bargainBtn.backgroundColor = [UIColor grayColor];
        ((TYDP_BargainCellB *)cell).bargainBtn.userInteractionEnabled = NO;
    }
}

- (void)buyBtnClick:(UIButton *)sender{
    TYDP_BargainModel *model = [TYDP_BargainModel new];
    
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    model = _dataSource[indexPath.row];
    TYDP_OfferDetailViewController *detailVC = [TYDP_OfferDetailViewController new];
    detailVC.goods_id = model.goods_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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



@end
