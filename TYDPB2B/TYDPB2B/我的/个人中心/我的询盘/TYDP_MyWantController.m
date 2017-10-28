//
//  TYDP_MyWantController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/18.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_MyWantController.h"
#import "TYDP_MyWantCell.h"
#import "TYDP_IssueWantController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "TYDPManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TYDP_MyWantModel.h"

@interface TYDP_MyWantController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableVC;
    NSMutableArray *_spreadArr;//展开的cell
    NSMutableArray *_dataSource;
    MBProgressHUD *_MBHUD;
    int _page;//当前页数
    int _page_count;//一共页数
}
@end

@implementation TYDP_MyWantController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [NSMutableArray new];
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
    [self creatHUD];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSDictionary *param = @{@"model":@"user",@"action":@"get_purchase",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userget_purchase%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:param success:^(id data) {
//        NSLog(@"%@",data);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            [self analyseData:data];
        }else{
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1];
            NSLog(@"---error:%@---/n---message:%@---",data[@"error"],data[@"messagr"]);
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [_MBHUD hide:YES afterDelay:1];
        NSLog(@"---error:%@---",error);
    }];
    [_tableVC.mj_footer endRefreshing];
}

- (void)analyseData:(id)data{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    for (NSDictionary *modelDic in data[@"content"][@"list"]) {
        TYDP_MyWantModel *model = [TYDP_MyWantModel new];
        [model setValuesForKeysWithDictionary:modelDic];
        [_dataSource addObject:model];
    }
    [_tableVC reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self requestData];
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"我的询盘界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick beginLogPageView:@"我的询盘界面"];
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationItem.title = NSLocalizedString(@"My inquiry", nil);
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

    _spreadArr = [[NSMutableArray alloc]init];
    
//    UIButton *addWantBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [self.view addSubview:addWantBtn];
//    [addWantBtn setBackgroundColor:RGBACOLOR(234, 102, 65, 1)];
//    [addWantBtn setTitle:@"添加询盘" forState:UIControlStateNormal];
//    [addWantBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [addWantBtn addTarget:self action:@selector(addNewWant) forControlEvents:UIControlEventTouchUpInside];
//    [addWantBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//        make.height.mas_equalTo(50);
//    }];
    [self.view setBackgroundColor:RGBACOLOR(244, 244, 244, 1)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableVC = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight)];
    [self.view addSubview:_tableVC];
    _tableVC.backgroundColor = RGBACOLOR(244, 244, 244, 1);
    _tableVC.delegate = self;
    _tableVC.dataSource = self;
    [_tableVC setSeparatorStyle:UITableViewCellSeparatorStyleNone];//隐藏分割线
    //取消Tableview上的按钮高亮效果延迟效果（如头视图和脚视图上的Button）
    _tableVC.delaysContentTouches = NO;
    
    //取消Tableviewcell上的按钮高亮效果延迟效果（当需要在cell上添加Button时直接在上一句代码后增加如下代码）
    for (UIView *currentView in _tableVC.subviews) {
        if([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
        }
    }
    [_tableVC registerNib:[UINib nibWithNibName:@"TYDP_MyWantCell" bundle:nil] forCellReuseIdentifier:@"TYDP_MyWantCell"];
    
    //下拉加载
    _page = 1;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TYDP_MyWantCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_MyWantCell" owner:self options:nil] lastObject];
    if (!cell) {
        cell = [[TYDP_MyWantCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_MyWantCell"];
    }
    [cell.spreadButton addTarget:self action:@selector(spreadClick:) forControlEvents:UIControlEventTouchUpInside];
    [self configCell:cell withIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell为不能被选中
    return cell;
}

-(void)configCell:(TYDP_MyWantCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
    //cell加载数据
    TYDP_MyWantModel *model = [TYDP_MyWantModel new];
    model = _dataSource[indexPath.row];
    cell.timeLab.text = model.created;
    cell.remarksLab.text = [NSString stringWithFormat:@"备注：%@",model.memo];
    cell.titleLab.text = model.title;
    cell.priceLab.text = [NSString stringWithFormat:@"%@-%@",model.price_low,model.price_up];
    cell.addressLab.text = model.address;
    cell.Id = model.Id;
    [cell.deleteBtn addTarget:self action:@selector(cellDeleteBtnOrCompileBtnClickWithSender:) forControlEvents:UIControlEventTouchUpInside];
    [cell.compileBtn addTarget:self action:@selector(cellDeleteBtnOrCompileBtnClickWithSender:) forControlEvents:UIControlEventTouchUpInside];
    cell.remarksLab.numberOfLines = 0;
    CGSize size = [cell.remarksLab sizeThatFits:CGSizeMake(100, 20)];
    if (size.height < 20.0) {
        cell.spreadButton.hidden = YES;
    }
    cell.remarksLab.numberOfLines = 1;
    
    //cell设置展开状态与闭合状态
    cell.spreadImg.image = [UIImage imageNamed:@"icon_down_nor"];
    cell.remarksLab.numberOfLines = 1;
    for (NSIndexPath *selectIndexPath in _spreadArr) {
        if (indexPath == selectIndexPath) {
            cell.remarksLab.numberOfLines = 0;
            cell.spreadImg.image = [UIImage imageNamed:@"icon_down_pre"];
        }
    }
}

//删除按钮点击事件
- (void)cellDeleteBtnOrCompileBtnClickWithSender:(UIButton *)sender{
    NSIndexPath *indexPath = [_tableVC indexPathForCell:(TYDP_MyWantCell *)sender.superview.superview];
    TYDP_MyWantModel *model = _dataSource[indexPath.row];
//    NSLog(@"---删除cellId:%@---",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"删除"]) {
        [self deleteCellPostData:model.Id];
    }else{
        [self compileCellPostData:model];
    }
}

//删除询盘发送的请求
- (void)deleteCellPostData:(NSString *)Id{
    [self creatHUD];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"model":@"user",@"action":@"del_purchase",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userdel_purchase%@",ConfigNetAppKey]],@"id":Id,@"token":[userdefaul objectForKey:@"token"],@"user_id":[userdefaul objectForKey:@"user_id"]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_dataSource removeAllObjects];
            _page = 1;
            [self requestData];
        }
    } failure:^(TYDPError *error) {
        NSLog(@"---deleteCellError:%@---",error);
    }];
}

- (void)spreadClick:(UIButton *)sender {
    NSIndexPath *selectedIndexPath = [_tableVC indexPathForCell:(TYDP_MyWantCell *)sender.superview.superview];
    
    //添加或删除展开的cell数组
    if (_spreadArr.count == 0) {
        [_spreadArr addObject:selectedIndexPath];
    }else{
        BOOL isSpread = NO;
        for (NSIndexPath *indexPath in _spreadArr) {
            if (selectedIndexPath == indexPath) {
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
//    [_tableVC scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_tableVC fd_heightForCellWithIdentifier:@"TYDP_MyWantCell" configuration:^(id cell) {
        [self configCell:cell withIndexPath:indexPath];
    }];
}

- (void)compileCellPostData:(TYDP_MyWantModel *)model{
    NSLog(@"编辑");
    [_dataSource removeAllObjects];
    TYDP_IssueWantController *myWantVC = [[TYDP_IssueWantController alloc]init];
    myWantVC.model = model;
    [self.navigationController pushViewController:myWantVC animated:YES];
}

@end
