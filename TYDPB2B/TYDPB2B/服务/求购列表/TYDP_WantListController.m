//
//  TYDP_WantListController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/18.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_WantListController.h"
#import "TYDP_WantListCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface TYDP_WantListController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *_tableVC;
    UIButton *_contentBtn;
    NSMutableArray *_spreadArr;//展开的cell，用于记录展开的cell的标识
}
@end

@implementation TYDP_WantListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)creatUI{
    
    self.navigationItem.title = @"求购列表";
    
    NSString * strModel  = [UIDevice currentDevice].localizedModel;
    NSLog(@"%@",strModel);
    
    _spreadArr = [NSMutableArray new];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _contentBtn = [UIButton copy];
    //创建顶部scroll
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, 40*Height)];
    [self.view addSubview:scroll];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(480*Width, 0);
    NSArray *titleArr = @[@"猪",@"牛",@"羊",@"禽类",@"水产",@"其他"];
    for (int i = 0; i<6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [scroll addSubview:btn];
        
        btn.frame = CGRectMake((80*i+10)*Width, 0, 60*Width, 40*Height);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        [btn setTitleColor:RGBACOLOR(139, 175, 234, 1) forState:UIControlStateNormal];
        if (i == 0) {
            _contentBtn = btn;
            [_contentBtn setBackgroundImage:[UIImage imageNamed:@"line_selected_blue"] forState:UIControlStateNormal];
        }
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _tableVC = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight+40*Height, ScreenWidth, ScreenHeight-NavHeight-40*Height)];
    [self.view addSubview:_tableVC];
    _tableVC.backgroundColor = RGBACOLOR(243, 243, 243, 1);
    _tableVC.delegate = self;
    _tableVC.dataSource = self;
    [_tableVC setSeparatorStyle:UITableViewCellSeparatorStyleNone];//隐藏分割线
    
    [_tableVC registerNib:[UINib nibWithNibName:@"TYDP_WantListCell" bundle:nil] forCellReuseIdentifier:@"TYDP_WantListCell"];
}

- (void)selectBtnClick:(UIButton *)sender{
    [_contentBtn setBackgroundImage:nil forState:UIControlStateNormal];
    _contentBtn = sender;
    [_contentBtn setBackgroundImage:[UIImage imageNamed:@"line_selected_blue"] forState:UIControlStateNormal];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"TYDP_WantListCell";
    TYDP_WantListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[TYDP_WantListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_WantListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell为不能被选中
    [cell.spreadBtn addTarget:self action:@selector(spreadClick:) forControlEvents:UIControlEventTouchUpInside];
    [self configCell:cell withIndexPath:indexPath];
    return cell;
}

-(void)configCell:(TYDP_WantListCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    [cell.spreadBtn setBackgroundImage:[UIImage imageNamed:@"icon_down_nor"] forState:UIControlStateNormal];
    cell.remarksLab.numberOfLines = 1;
    for (NSIndexPath *selectIndexPath in _spreadArr) {
        if (indexPath == selectIndexPath) {
            cell.remarksLab.numberOfLines = 0;
            [cell.spreadBtn setBackgroundImage:[UIImage imageNamed:@"icon_down_pre"] forState:UIControlStateNormal];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_tableVC fd_heightForCellWithIdentifier:@"TYDP_WantListCell" configuration:^(id cell) {
        [self configCell:cell withIndexPath:indexPath];
    }];
}

- (void)spreadClick:(UIButton *)sender {
    NSIndexPath *selectedIndexPath = [_tableVC indexPathForCell:(TYDP_WantListCell *)sender.superview.superview.superview];
    
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

@end
