//
//  TYDP_IndentController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/20.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_IndentController.h"
#import "TYDP_IndentCell.h"
#import "TYDPManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TYDP_NoIndentController.h"
#import "TYDP_CommitEvidenceViewController.h"

@interface TYDP_IndentController ()<UITableViewDelegate,UITableViewDataSource>
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

@implementation TYDP_IndentController

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
    
    self.navigationItem.title = NSLocalizedString(@"Order list", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建scroll
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, 40)];
    [self.view addSubview:_scroll];
    _scroll.delaysContentTouches = NO;
    _scroll.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr = @[NSLocalizedString(@"All", nil),NSLocalizedString(@"Obligation", nil),NSLocalizedString(@"Paid", nil),NSLocalizedString(@"Prepaid", nil),NSLocalizedString(@"Finished", nil)];
    _scroll.contentSize = CGSizeMake(ScreenWidth, 0);
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_scroll addSubview:btn];
        btn.tag = 100+i;
        btn.frame = CGRectMake(i*ScreenWidth/5+10, 0, ScreenWidth/5-20, 40);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        if (i != 0) {
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            if (i==1) {
                btn.titleLabel.font = [UIFont systemFontOfSize:11];
            }
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
    _tableVC.rowHeight = 136;
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
    TYDP_IndentCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_IndentCell" owner:self options:nil]lastObject];
    if (!cell) {
        cell = [[TYDP_IndentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_IndentCell"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *cellData = _dataSource[indexPath.row];
    TYDP_CommitEvidenceViewController *CommitEvidenceVC = [TYDP_CommitEvidenceViewController new];
    CommitEvidenceVC.orderId = cellData[@"order_id"];
    CommitEvidenceVC.order_status = [NSString stringWithFormat:@"%@",cellData[@"show_pay"]];
    CommitEvidenceVC.popMore=NO;

    CommitEvidenceVC.orderSourceString = [NSString stringWithFormat:@"personalCenter"];
    [self.navigationController pushViewController:CommitEvidenceVC animated:YES];
}

- (void)configCell:(TYDP_IndentCell *)cell WithindexPath:(NSIndexPath *)indexPath{
    NSDictionary *cellData = _dataSource[indexPath.row];
    cell.titleLab.text =[NSString stringWithFormat:@"%@  %@",cellData[@"goods"][@"goods_name"],cellData[@"goods"][@"brand_sn"]]; ;
    cell.numberLab.text = cellData[@"order_sn"];
    cell.timeLab.text = cellData[@"add_time"];
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:cellData[@"goods"][@"goods_thumb"]]];
    cell.priceLab.text = [NSString stringWithFormat:@"￥%@/%@",cellData[@"goods"][@"goods_price"],NSLocalizedString(@"MT", nil)];
    if ([[NSString stringWithFormat:@"%@",cellData[@"goods"][@"is_retail"]] isEqualToString:@"1"]) {
        cell.goodsNumLab.text = [NSString stringWithFormat:@"%@%@  %@%@",cellData[@"goods"][@"part_number"],cellData[@"goods"][@"part_unit"] ,cellData[@"goods"][@"goods_number"],cellData[@"goods"][@"measure_unit"]];
    }
    else
    {
        cell.goodsNumLab.text = [NSString stringWithFormat:@"%@%@  %@%@",cellData[@"goods"][@"part_weight"],cellData[@"goods"][@"part_unit"] ,cellData[@"goods"][@"goods_number"],cellData[@"goods"][@"measure_unit"]];
    }
    

//    cell.goodsNumLab.text = [NSString stringWithFormat:@"x%@柜",cellData[@"goods"][@"total_weight"]];
    cell.typeLab.text = cellData[@"order_status_format"];
    if ([cellData[@"show_pay"] intValue]==1) {
        [cell.typeBtn setTitle:@"去付款" forState:UIControlStateNormal];
    }else{
        [cell.typeBtn setTitle:@"详情" forState:UIControlStateNormal];
    }
    cell.typeBtn.hidden=YES;
    cell.typeBtn.tag=indexPath.row;
    [cell.typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

//跳转到订单详情页面
- (void)typeBtnClick:(UIButton*)sender{
    NSIndexPath *indexPath = [_tableVC indexPathForCell:(TYDP_IndentCell*)sender.superview.superview.superview];
    NSDictionary *cellData = _dataSource[indexPath.row];
    TYDP_CommitEvidenceViewController *CommitEvidenceVC = [TYDP_CommitEvidenceViewController new];
    CommitEvidenceVC.orderId = cellData[@"order_id"];
    CommitEvidenceVC.order_status = [NSString stringWithFormat:@"%@",cellData[@"show_pay"]];
    CommitEvidenceVC.popMore=NO;

    CommitEvidenceVC.orderSourceString = [NSString stringWithFormat:@"personalCenter"];
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
    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Wait a moment",nil)]];
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [_MBHUD show:YES];
}

- (void)requestData{
    [self creatHUD];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":[NSNumber numberWithInt:_page],@"model":@"order",@"action":@"order_list",@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"sign":[TYDPManager md5:[NSString stringWithFormat:@"orderorder_list%@",ConfigNetAppKey]]}];
    if (self.listType != 0) {
        NSArray *listTypeArr = @[@"",@0,@1,@2,@99];
        [params setObject:[NSString stringWithFormat:@"%d",[listTypeArr[self.listType] intValue]] forKey:@"status"];
    }
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        debugLog(@"lissssstdata:%@",data);
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
