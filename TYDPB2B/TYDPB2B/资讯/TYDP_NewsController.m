//
//  TYDP_NewsController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/15.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_NewsController.h"
#import "TYDP_NewsCell.h"
#import "TYDPManager.h"
#import "TYDP_NewsModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TYDP_NewsDetailController.h"

@interface TYDP_NewsController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableVC;
    UISegmentedControl *_segment;
    NSMutableArray *_dataArr;
    NSString *_selectId;
    NSArray *_segmentCatArr;
    MBProgressHUD *_MBHUD;
}
@end

@implementation TYDP_NewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self requestDataWithId:_selectId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)retBtnClick
{
    if (_dismissOrPop) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
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

- (void)requestDataWithId:(NSString *)Id{
    [self creatHUD];
    NSDictionary *params = @{@"model":@"other",@"action":@"get_article",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"otherget_article%@",ConfigNetAppKey]],@"id":Id};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
                debugLog(@"NewsData:%@",data);
        if ([Id isEqualToString:@"0"]) {
            [self configSegmentWithCategory:data[@"content"][@"category"]];
        }
        [self configTableviewWithList:data[@"content"][@"list"]];
        [_MBHUD hide:YES];
    } failure:^(TYDPError *error) {
        NSLog(@"---error:%@---",error);
    }];
}

- (void)configTableviewWithList:(NSArray *)list{
    [_dataArr removeAllObjects];
    for (NSDictionary *dict in list) {
        TYDP_NewsModel *model = [TYDP_NewsModel new];
        [model setValuesForKeysWithDictionary:dict];
        [_dataArr addObject:model];
    }
    [_tableVC reloadData];
}

- (void)configSegmentWithCategory:(NSArray *)category{
    _segmentCatArr = category;
    [_segment removeAllSegments];
    for (NSDictionary *dict in category) {
        //        dict[@"cat_id"];
        //        dict[@"cat_name"];
        [_segment insertSegmentWithTitle:dict[@"cat_name"] atIndex:0 animated:NO];
    }
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(segmentClick) forControlEvents:UIControlEventValueChanged];
}

- (void)creatUI{
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationController.navigationBarHidden = NO;
    
    
    _selectId = @"0";
    _dataArr = [NSMutableArray new];

    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, 60*Height)];
    [self.view addSubview:topV];
    topV.backgroundColor = [UIColor whiteColor];
    //选择框
    _segment = [[UISegmentedControl alloc]initWithFrame:CGRectMake(42.5*Width, 13*Height, ScreenWidth-85*Width, 32*Height)];
    [topV addSubview:_segment];
    _segment.tintColor = RGBACOLOR(236, 163, 72, 1);
    //    [_segment insertSegmentWithTitle:@"泰阳冻品" atIndex:0 animated:NO];
    
    //初始化列表
    if (_dismissOrPop) {
        _tableVC = [[UITableView alloc]initWithFrame:CGRectMake(0, 60*Height+NavHeight, ScreenWidth, ScreenHeight-NavHeight-TabbarHeight-60*Height)];
    }else
    {
    _tableVC = [[UITableView alloc]initWithFrame:CGRectMake(0, 60*Height+NavHeight, ScreenWidth, ScreenHeight-NavHeight-TabbarHeight)];
    }
    [self.view addSubview:_tableVC];
    [_tableVC setSeparatorStyle:UITableViewCellSeparatorStyleNone];//隐藏分割线
    _tableVC.delegate = self;
    _tableVC.dataSource = self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld行cell",indexPath.row);
    [_tableVC deselectRowAtIndexPath:indexPath animated:YES];
    TYDP_NewsDetailController *detailVC = [TYDP_NewsDetailController new];
    TYDP_NewsModel *model = [TYDP_NewsModel new];
    model = _dataArr[indexPath.row];
    detailVC.requestURL = model.url;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDP_NewsCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_NewsCell" owner:self options:nil] lastObject];
    if (!cell) {
        cell = [[TYDP_NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_NewsCell"];
    }
    [self configCell:cell WithIndexPath:indexPath];
    return cell;
}

- (void)configCell:(TYDP_NewsCell *)cell WithIndexPath:(NSIndexPath *)indexPath{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TYDP_NewsModel *model = [TYDP_NewsModel new];
    model = _dataArr[indexPath.row];
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.arc_img] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    cell.titleLab.text = model.title;
    cell.timeLab.text = model.add_time;
    cell.subTitleLab.text = model.short_title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (void)segmentClick{
    _selectId = _segmentCatArr[_segment.selectedSegmentIndex][@"cat_id"];
    NSLog(@"%@",_selectId);
    [self requestDataWithId:_selectId];
}
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;

    [MobClick beginLogPageView:@"新闻资讯界面"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [MobClick endLogPageView:@"新闻资讯界面"];
}

@end
