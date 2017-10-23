//
//  TYDP_MyMessageController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/15.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_MyMessageController.h"
#import "TYDP_MyMessageCell.h"

@interface TYDP_MyMessageController ()

@end

@implementation TYDP_MyMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"我的消息";
    
    //对tableview的设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = RGBACOLOR(234, 234, 234, 1);
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TYDP_MyMessageCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_MyMessageCell" owner:self options:nil]lastObject];
    if (!cell) {
        cell = [[TYDP_MyMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_MyMessageCell"];
    }
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"我的消息界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"我的消息界面"];
}

@end
