//
//  TYDP_AfterServiceController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/21.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_AfterServiceController.h"
#import "TYDP_AfterServiceCell.h"
#import "TYDP_AddCommentController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "TYDPManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TYDP_AfterServeModel.h"

@interface TYDP_AfterServiceController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableVC;
    UIButton *_contentBtn;
    NSMutableArray *_spreadArr;
    NSMutableArray *_dataSource;
    int _msg_type;
    MBProgressHUD *_MBHUD;
    int _currentPage;//当前页数
    int _totalPage;//全部页数
    
    UIScrollView *scroll;
}
@end

@implementation TYDP_AfterServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)requestData{
//    NSLog(@"----------%d",_msg_type);
    [self creatHUD];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:@{@"model":@"user",@"action":@"message_list",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"usermessage_list%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"msg_type":[NSString stringWithFormat:@"%d",_msg_type-1],@"page":[NSString stringWithFormat:@"%d",_currentPage],@"size":@"10"}];
    if (_msg_type == 0) {
        [param setObject:@"" forKey:@"msg_type"];
    }
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:param success:^(id data) {
//        NSLog(@"%@",data);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            _totalPage = [data[@"content"][@"total"][@"page_count"] intValue];
            [self analyseData:data];
        }else{
            [_MBHUD setMode:MBProgressHUDModeText];
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1.5];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setMode:MBProgressHUDModeText];
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [_MBHUD hide:YES afterDelay:1.5];
        NSLog(@"---error:%@---",error);
    }];
    [_tableVC.mj_footer endRefreshing];
}

- (void)analyseData:(id)data{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    for (NSDictionary *modelDict in data[@"content"][@"list"]) {
        TYDP_AfterServeModel *model = [TYDP_AfterServeModel new];
        [model setValuesForKeysWithDictionary:modelDict];
        [_dataSource addObject:model];
    }
    [_tableVC reloadData];
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
    
    self.navigationItem.title = NSLocalizedString(@"After sale service", nil);
    
    _spreadArr = [NSMutableArray new];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //创建scroll
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, 40)];
    [self.view addSubview:scroll];
    scroll.delaysContentTouches = NO;
    scroll.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr = @[NSLocalizedString(@"All", nil),NSLocalizedString(@"Comment", nil),NSLocalizedString(@"Complain", nil),NSLocalizedString(@"Customer service", nil)];
    scroll.contentSize = CGSizeMake(ScreenWidth, 0);
    for (int i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [scroll addSubview:btn];
        btn.tag = 100+i;
        btn.frame = CGRectMake(i*ScreenWidth/4+10, 0, ScreenWidth/4-20, 40);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [btn addTarget:self action:@selector(selectContentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            _contentBtn = btn;
            [_contentBtn setBackgroundImage:[UIImage imageNamed:@"line_selected_blue"] forState:UIControlStateNormal];
            [_contentBtn setTitleColor:mainColor forState:UIControlStateNormal];
        }
    }
    
    //创建tableview
    _tableVC = [[UITableView alloc]initWithFrame:CGRectMake(0, 40+NavHeight, ScreenWidth, ScreenHeight-NavHeight-84)];
    [self.view addSubview:_tableVC];
    _tableVC.delegate = self;
    _tableVC.dataSource = self;
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
    
    [_tableVC registerNib:[UINib nibWithNibName:@"TYDP_AfterServiceCell" bundle:nil] forCellReuseIdentifier:@"TYDP_AfterServiceCell"];
    
    //下拉加载
    _tableVC.mj_footer.automaticallyHidden = YES;
    _tableVC.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        //根据后台返回来的page总数限制刷新次数
        if (_currentPage < _totalPage) {
            _currentPage++;
            [self requestData];
        } else {
            MBProgressHUD *tmpHud = [[MBProgressHUD alloc] init];
            [tmpHud setAnimationType:MBProgressHUDAnimationFade];
            [tmpHud setMode:MBProgressHUDModeText];
            [tmpHud setLabelText:NSLocalizedString(@"No more", nil)];
            [self.view addSubview:tmpHud];
            [tmpHud show:YES];
            [tmpHud hide:YES afterDelay:1.5f];
            [_tableVC.mj_footer endRefreshingWithNoMoreData];
        }
    }];

    //发表留言
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(0, ScreenHeight-44, ScreenWidth, 44);
    [btn setBackgroundColor:mainColor];
    [btn setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];

    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn addTarget:self action:@selector(addCommentClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectContentBtnClick:(UIButton *)sender{
    [_contentBtn setBackgroundImage:nil forState:UIControlStateNormal];
    _contentBtn = sender;
    [_contentBtn setBackgroundImage:[UIImage imageNamed:@"line_selected_blue"] forState:UIControlStateNormal];
    for (UIView *sview in scroll.subviews) {
        if ([sview isKindOfClass:[UIButton class]]) {
            [(UIButton*)sview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }

    [_contentBtn setTitleColor:mainColor forState:UIControlStateNormal];
    
       _msg_type = (int)sender.tag-100;
    [_dataSource removeAllObjects];
    _currentPage = 1;
    [self requestData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDP_AfterServiceCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_AfterServiceCell" owner:self options:nil]lastObject];
    if (!cell) {
        cell = [[TYDP_AfterServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_AfterServiceCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.spreadBtn addTarget:self action:@selector(spreadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self configCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)spreadBtnClick:(UIButton *)sender{
    NSIndexPath *selectedIndexPath = [_tableVC indexPathForCell:(TYDP_AfterServiceCell *)sender.superview.superview.superview];
    if (_spreadArr.count == 0) {
        [_spreadArr addObject:selectedIndexPath];
    }else{
        BOOL isSpread = NO;
        for (NSIndexPath *indexPath in _spreadArr) {
            if (indexPath == selectedIndexPath) {
                isSpread = YES;
            }
        }
        if (isSpread == YES) {
            [_spreadArr removeObject:selectedIndexPath];
        }else{
            [_spreadArr addObject:selectedIndexPath];
        }
    }
    [_tableVC reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)configCell:(TYDP_AfterServiceCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    TYDP_AfterServeModel *model = [TYDP_AfterServeModel new];
    model = _dataSource[indexPath.row];
    cell.timeLab.text = model.msg_time;
    cell.titleLab.text = model.msg_title;
    cell.subTitleLab.text = model.msg_content;
    
    cell.subTitleLab.numberOfLines = 0;
    CGSize size = [cell.subTitleLab sizeThatFits:CGSizeMake(100, 20)];
    if (size.height < 20.0) {
        cell.spreadBtn.hidden = YES;
        cell.spreadImg.hidden = YES;
    }
    cell.subTitleLab.numberOfLines = 1;
    
    cell.spreadImg.image = [UIImage imageNamed:@"icon_down_nor"];
    cell.subTitleLab.numberOfLines = 1;
    for (NSIndexPath *selectIndexPath in _spreadArr) {
        if (indexPath == selectIndexPath) {
            cell.subTitleLab.numberOfLines = 0;
            [cell.spreadImg setImage:[UIImage imageNamed:@"icon_down_pre"]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_tableVC fd_heightForCellWithIdentifier:@"TYDP_AfterServiceCell" configuration:^(id cell) {
        [self configCell:cell withIndexPath:indexPath];
    }];
}

- (void)addCommentClick{
    TYDP_AddCommentController *addVC = [[TYDP_AddCommentController alloc]init];
    addVC.pushType = 0;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    _currentPage = 1;
    [self requestData];
    [MobClick beginLogPageView:@"售后服务界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"售后服务界面"];
}

@end
