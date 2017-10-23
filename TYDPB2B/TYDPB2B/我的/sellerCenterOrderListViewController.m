//
//  sellerCenterOrderListViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/9.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "sellerCenterOrderListViewController.h"
#import "sellerOrderListTableViewCell.h"
#import "TYDPManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TYDP_NoIndentController.h"
#import "seller_orderDetailViewController.h"

@interface sellerCenterOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableVC;
    UIButton *_contentBtn;
    NSMutableArray *_dataSource;
    MBProgressHUD *_MBHUD;
    UIScrollView *_scroll;//顶部scroll
    int _page;//当前页数
    int _page_count;//全部页数
}


@end

@implementation sellerCenterOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"全部订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建scroll
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, 40)];
    [self.view addSubview:_scroll];
    _scroll.delaysContentTouches = NO;
    _scroll.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr = @[@"全部",@"未收款",@"已收款",@"已预付",@"已完成"];
    _scroll.contentSize = CGSizeMake(ScreenWidth, 0);
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_scroll addSubview:btn];
        btn.tag = 100+i;
        btn.frame = CGRectMake(i*ScreenWidth/5+10, 0, ScreenWidth/5-20, 40);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        if (i != 0) {
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        [btn addTarget:self action:@selector(selectContentBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == self.listType) {
            _contentBtn = btn;
            [_contentBtn setBackgroundImage:[UIImage imageNamed:@"line_selected_blue"] forState:UIControlStateNormal];
            [_contentBtn setTitleColor:mainColor forState:UIControlStateNormal];

        }
    }
    
    //创建tableview
    _tableVC = [[UITableView alloc]initWithFrame:CGRectMake(0, 40+NavHeight, ScreenWidth, ScreenHeight-NavHeight-40)];
    [self.view addSubview:_tableVC];
    _tableVC.delegate = self;
    _tableVC.dataSource = self;
    _tableVC.rowHeight = 172;
    _tableVC.backgroundColor = RGBACOLOR(238, 238, 238, 1);
    _tableVC.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //取消Tableview上的按钮高亮效果延迟效果（如头视图和脚视图上的Button）
    _tableVC.delaysContentTouches = NO;
    
    //取消Tableviewcell上的按钮高亮效果延迟效果（当需要在cell上添加Button时直接在上一句代码后增加如下代码）
    for (UIView *currentView in _tableVC.subviews) {
        if([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
        }
    }
    
    _page = 1;
    //下拉加载
    _tableVC.mj_footer.automaticallyHidden = YES;
    _tableVC.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
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
            [_tableVC.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)selectContentBtn:(UIButton *)sender{
    [_contentBtn setBackgroundImage:nil forState:UIControlStateNormal];
    _contentBtn = sender;
    [_contentBtn setBackgroundImage:[UIImage imageNamed:@"line_selected_blue"] forState:UIControlStateNormal];
    for (UIView * subBtn in _scroll.subviews) {
        if ([subBtn isKindOfClass:[UIButton class]]) {
             [(UIButton *)subBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
       
    }
    [_contentBtn setTitleColor:mainColor forState:UIControlStateNormal];

    self.listType = (int)sender.tag-100;
    [_dataSource removeAllObjects];
    _page = 1;
    [self requestData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    sellerOrderListTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"sellerOrderListTableViewCell" owner:self options:nil]lastObject];
    if (!cell) {
        cell = [[sellerOrderListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sellerOrderListTableViewCell"];
    }
    //    if (self.listType == 0) {
    //
    //    }else if (self.listType == 1){
    //        [cell.typeBtn setTitle:@"去发货" forState:UIControlStateNormal];
    //    }else if (self.listType == 2){
    //
    //    }else{
    //
    //    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [self configCell:cell WithindexPath:indexPath];
    return cell;
}

- (void)configCell:(sellerOrderListTableViewCell *)cell WithindexPath:(NSIndexPath *)indexPath{
    NSDictionary *cellData = _dataSource[indexPath.row];
    cell.titleLab.text = cellData[@"goods"][@"goods_name"];
    cell.numberLab.text = cellData[@"order_sn"];
    cell.timeLab.text = cellData[@"add_time"];
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:cellData[@"goods"][@"goods_thumb"]]];
    cell.priceLab.text = [NSString stringWithFormat:@"¥%@/吨",cellData[@"goods"][@"goods_price"]];
    cell.changNumLable.text = [NSString stringWithFormat:@"厂号   %@",cellData[@"goods"][@"brand_sn"]];
    cell.regionNameLable.text = [NSString stringWithFormat:@"%@",cellData[@"goods"][@"region_name"]];
    if ([[NSString stringWithFormat:@"%@",cellData[@"goods"][@"is_retail"]] isEqualToString:@"1"]) {
         cell.howMuchLable.text = [NSString stringWithFormat:@"%@%@  %@%@",cellData[@"goods"][@"part_number"],cellData[@"goods"][@"part_unit"] ,cellData[@"goods"][@"goods_number"],cellData[@"goods"][@"measure_unit"]];
    }
    else
    {
         cell.howMuchLable.text = [NSString stringWithFormat:@"%@%@  %@%@",cellData[@"goods"][@"part_weight"],cellData[@"goods"][@"part_unit"] ,cellData[@"goods"][@"goods_number"],cellData[@"goods"][@"measure_unit"]];
    }
    
   
//    cell.goodsNumLab.text = [NSString stringWithFormat:@"x%件",cellData[@"goods"][@"total_weight"]];
    cell.typeLab.text = cellData[@"order_status_format"];
//    cell.howMuchLable.text = cellData[@"order_status_format"];

    if (_listType==2||_listType==3||_listType==4) {
        [cell.typeBtn setTitle:@"详细信息" forState:UIControlStateNormal];
    }else{
        [cell.typeBtn setTitle:@"确认库存" forState:UIControlStateNormal];
    }
    cell.typeBtn.hidden=YES;
    [cell.typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellData = _dataSource[indexPath.row];
    seller_orderDetailViewController *CommitEvidenceVC = [seller_orderDetailViewController new];
    CommitEvidenceVC.orderId = cellData[@"order_id"];
    [self.navigationController pushViewController:CommitEvidenceVC animated:YES];
}

//跳转到订单详情页面
- (void)typeBtnClick:(UIButton*)sender{
    NSIndexPath *indexPath = [_tableVC indexPathForCell:(sellerOrderListTableViewCell*)sender.superview.superview.superview];
    NSDictionary *cellData = _dataSource[indexPath.row];
    seller_orderDetailViewController *CommitEvidenceVC = [seller_orderDetailViewController new];
    CommitEvidenceVC.orderId = cellData[@"order_id"];
    [self.navigationController pushViewController:CommitEvidenceVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"全部订单界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"全部订单界面"];
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

- (void)requestData{
    [self creatHUD];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":[NSNumber numberWithInt:_page],@"model":@"seller",@"action":@"order_list",@"user_id":[userdefaul objectForKey:@"user_id"],@"sign":[TYDPManager md5:[NSString stringWithFormat:@"sellerorder_list%@",ConfigNetAppKey]]}];
    if (self.listType != 0) {
        NSArray *listTypeArr = @[@"",@0,@1,@2,@99];
        [params setObject:[NSString stringWithFormat:@"%d",[listTypeArr[self.listType] intValue]] forKey:@"status"];
    }
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
                debugLog(@"1121221212:%@",data);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            [self configUIWithData:data[@"content"][@"list"]];
            _page_count = [data[@"content"][@"total"][@"page_count"] intValue];
            [_tableVC.mj_footer endRefreshing];
        }else{
            [_MBHUD hide:data[@"message"] afterDelay:1];
            NSLog(@"%@",data[@"message"]);
        }
    } failure:^(TYDPError *error) {
        NSLog(@"---error:%@---",error);
    }];
}

- (void)configUIWithData:(NSArray *)list{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    for (NSDictionary *indent in list) {
        [_dataSource addObject:indent];
    }
    [_tableVC reloadData];
    if (_dataSource.count == 0) {
        TYDP_NoIndentController *NoIndengVC = [TYDP_NoIndentController new];
        [self addChildViewController:NoIndengVC];
        NoIndengVC.view.frame = self.view.frame;
        [self.view addSubview:NoIndengVC.view];
        [self.view bringSubviewToFront:_scroll];
    }else{
        for (UIViewController *subControllers in self.childViewControllers) {
            if ([subControllers isMemberOfClass:[TYDP_NoIndentController class]]) {
                [subControllers.view removeFromSuperview];
                [subControllers removeFromParentViewController];
            }
        }
    }
}

@end
