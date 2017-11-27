//
//  TYDP_ServrController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/14.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_ServrController.h"
#import "TYDP_WantListController.h"
#import "TYDP_ServePublicController.h"
#import "TYDP_IssueWantController.h"
#import "TYDP_LoginController.h"
#import "ZYTabBar.h"
#import "TYDP_NewsController.h"
@interface TYDP_ServrController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableVC;
    NSArray *_imgArr;//图片
    NSArray *_titleArr;//上边文字
    NSArray *_subTitleArr;//下边文字
}
@end

@implementation TYDP_ServrController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Service", nil);
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)creatUI{
    
    _imgArr = @[@"icon_serve_cash",@"icon_serve_entrepot",@"icon_serve_money",@"icon_serve_ask",@"icon_serve_news"];
    _titleArr = @[NSLocalizedString(@"Inland Logistics", nil),NSLocalizedString(@"Warehouse Service", nil),NSLocalizedString(@"Mortgage loaning", nil),NSLocalizedString(@"Enquiry service", nil),NSLocalizedString(@"Industry information", nil)];
    _subTitleArr = @[@"",@"",@"",@"",@""];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableVC = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight-TabbarHeight)];
    [self.view addSubview:_tableVC];
    _tableVC.showsVerticalScrollIndicator = NO;
    _tableVC.delegate = self;
    _tableVC.dataSource = self;
    
    //创建头视图
    _tableVC.tableHeaderView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 262*Height)];

    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 250*Height)];
    headImg.image = [UIImage imageNamed:NSLocalizedString(@"banner_serve_en", nil)];
    headImg.userInteractionEnabled=YES;
    [_tableVC.tableHeaderView addSubview:headImg];
    
    UIView * bgView =[UIView new];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    bgView.layer.borderWidth = HomePageBordWidth;
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [headImg addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg).with.offset(20);
        make.bottom.equalTo(headImg.mas_bottom).with.offset(-15);
        make.right.equalTo(headImg).with.offset(-20);
        make.height.mas_equalTo(120);
    }];
    
    for (int i =0; i<2; i++) {
        UIImageView * imageView =[UIImageView new];
        imageView.image=[UIImage imageNamed:_imgArr[i+3]];
        [bgView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).with.offset(i==0?(ScreenWidth-40)/4-25:(ScreenWidth-40)*3/4-25);
            make.top.equalTo(bgView.mas_top).with.offset(25);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        
        UILabel * titleLable =[UILabel new];
        titleLable.text=[NSString stringWithFormat:@"%@", _titleArr[i+3]];
        titleLable.textAlignment=NSTextAlignmentCenter;
        titleLable.textColor=[UIColor blackColor];
        titleLable.font=[UIFont boldSystemFontOfSize:13.0];
        [bgView addSubview:titleLable];
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).with.offset(i==0?0:(ScreenWidth-40)/2);
            make.top.equalTo(imageView.mas_bottom).with.offset(10);
            make.width.mas_equalTo((ScreenWidth-40)/2);
            make.height.mas_equalTo(20);
        }];
        
        UILabel * subtitleLable =[UILabel new];
        subtitleLable.text=[NSString stringWithFormat:@"%@", _subTitleArr[i+3]];
        subtitleLable.textAlignment=NSTextAlignmentCenter;

        subtitleLable.textColor=[UIColor lightGrayColor];
        subtitleLable.font=[UIFont boldSystemFontOfSize:12.0];
        [bgView addSubview:subtitleLable];
        [subtitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).with.offset(i==0?0:(ScreenWidth-40)/2);
            make.top.equalTo(titleLable.mas_bottom).with.offset(0);
            make.width.mas_equalTo((ScreenWidth-40)/2);
            make.height.mas_equalTo(20);
        }];
        
        UIButton * subBtn=[UIButton new];
        [bgView addSubview:subBtn];
        subBtn.tag=i;
        [subBtn addTarget:self action:@selector(subBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).with.offset(i==0?0:(ScreenWidth-40)/2);
            make.top.equalTo(bgView).with.offset(0);
            make.width.mas_equalTo((ScreenWidth-40)/2);
            make.height.mas_equalTo(60);
        }];

        
    }

    
    UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, 250*Height, ScreenWidth, 17*Height)];
    grayLine.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    [_tableVC.tableHeaderView addSubview:grayLine];
    
    //去掉多余的cell分割线
    _tableVC.tableFooterView = [[UIView alloc]init];
}


-(void)subBtnHandler:(UIButton*)btn
{
    if (btn.tag==0) {
        TYDP_IssueWantController *IssueWantVC = [TYDP_IssueWantController new];
        [self.navigationController pushViewController:IssueWantVC animated:YES];
    }
    else
    {
        TYDP_NewsController*  TYDP_NewsVC = [TYDP_NewsController new];
        [self.navigationController pushViewController:TYDP_NewsVC  animated:YES];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"TYDP_ServrControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    _tableVC.rowHeight = 70;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imgArr[indexPath.row]]];
    
    CGSize size = CGSizeMake(40, 40);
    UIImage *image = [UIImage imageNamed:_imgArr[indexPath.row]];
    cell.imageView.image = image;
    //调整image的大小
    UIGraphicsBeginImageContextWithOptions(size, NO,0.0);
    CGRect imageRect=CGRectMake(0.0, 0.0, size.width, size.height);
    [image drawInRect:imageRect];
    cell.imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_titleArr[indexPath.row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_subTitleArr[indexPath.row]];
    cell.detailTextLabel.textColor = RGBACOLOR(153, 153, 153, 1);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSLog(@"代理报关");
        TYDP_ServePublicController *serveVC = [[TYDP_ServePublicController alloc]init];
        serveVC.sendType = 0;
        [self.navigationController pushViewController:serveVC animated:YES];
    }
    else if (indexPath.row == 1){
        NSLog(@"仓储服务");
        TYDP_ServePublicController *serveVC = [[TYDP_ServePublicController alloc]init];
        serveVC.sendType = 1;
        [self.navigationController pushViewController:serveVC animated:YES];
    }else if (indexPath.row == 2){
        NSLog(@"货押贷款");
        TYDP_ServePublicController *serveVC = [[TYDP_ServePublicController alloc]init];
        serveVC.sendType = 2;
        [self.navigationController pushViewController:serveVC animated:YES];
    }else {
        NSLog(@"市场价格");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    if (![userdefaul objectForKey:@"token"]) {
        TYDP_LoginController *loginVC = [TYDP_LoginController new];
        [self.navigationController pushViewController:loginVC animated:NO];
    }
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
    [MobClick beginLogPageView:@"服务一级界面"];
}
- (void)viewDidAppear:(BOOL)animated {
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=YES;
    self.tabBarController.tabBar.hidden = YES;

    [MobClick endLogPageView:@"服务一级界面"];
}

@end
