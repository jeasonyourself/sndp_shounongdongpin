//
//  TYDP_ConsigneeController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/27.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_ConsigneeController.h"
#import "TYDP_ConsigneeCell.h"
#import "TYDP_AddConsigneeController.h"
#import "TYDP_ConsigneeModel.h"
#import "TYDP_NoConsigneeController.h"
#import "addSenderAddressViewController.h"
@interface TYDP_ConsigneeController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableVC;
    NSIndexPath *_currentIndex;//被选中的indexpath
    UIImageView *_selectBtnImg;//买家找车（运费自付）前面的按钮
    BOOL _isSelectCar;
    NSMutableArray *_dataSource;
//    BOOL _isSelectAddress;
    MBProgressHUD *_MBHUD;
}
@property(nonatomic, copy)NSString *addressIdString;
@property(nonatomic, copy)NSString *addressName;
@property(nonatomic, copy)NSString *addressMobile;
@property(nonatomic, copy)NSString *addressUserId;
@end

@implementation TYDP_ConsigneeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSDictionary *params = @{@"model":@"user",@"action":@"get_address_list",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userget_address_list%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"],@"type":[NSString stringWithFormat:@"%d",_type],@"token":[userdefaul objectForKey:@"token"]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
//        NSLog(@"%@",data);
        if ([data[@"error"] isEqualToString:@"0"]) {
            [self analyseData:data[@"content"]];
            [_MBHUD hide:YES];
        }else{
            [_MBHUD setMode:MBProgressHUDModeText];
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [_MBHUD hide:YES afterDelay:1];
        NSLog(@"---error:%@---",error);
    }];
}

- (void)analyseData:(NSArray *)listArr{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }else{
        [_dataSource removeAllObjects];
    }
    for (NSDictionary *dataDict in listArr) {
        TYDP_ConsigneeModel *model = [TYDP_ConsigneeModel new];
        [model setValuesForKeysWithDictionary:dataDict];
        [_dataSource addObject:model];
    }
    [_tableVC reloadData];
    if (_dataSource.count == 0) {
        TYDP_NoConsigneeController *NoConsigneeVC = [TYDP_NoConsigneeController new];
        [self addChildViewController:NoConsigneeVC];
        NoConsigneeVC.view.frame = self.view.frame;
        [self.view addSubview:NoConsigneeVC.view];
        UIButton *addbtn = (UIButton *)[self.view viewWithTag:100];
        [self.view insertSubview:NoConsigneeVC.view belowSubview:addbtn];
    }else{
        for (UIViewController *subController in self.childViewControllers) {
            if ([subController isKindOfClass:[TYDP_NoConsigneeController class]]) {
                [subController.view removeFromSuperview];
                [subController removeFromParentViewController];
            }
        }
    }
}

- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.title=NSLocalizedString(@"Address infomation", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建tableview
    _tableVC = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight-TabbarHeight-NavHeight)];
    [self.view addSubview:_tableVC];
    _tableVC.delegate = self;
    _tableVC.dataSource = self;
    _tableVC.backgroundColor = RGBACOLOR(234, 234, 234, 1);
    [_tableVC setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //取消Tableview上的按钮高亮效果延迟效果（如头视图和脚视图上的Button）
    _tableVC.delaysContentTouches = NO;
    
    //取消Tableviewcell上的按钮高亮效果延迟效果（当需要在cell上添加Button时直接在上一句代码后增加如下代码）
    for (UIView *currentView in _tableVC.subviews) {
        if([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
        }
    }
    
    [_tableVC registerNib:[UINib nibWithNibName:@"TYDP_ConsigneeCell" bundle:nil] forCellReuseIdentifier:@"TYDP_ConsigneeCell"];
    
    
    if (self.pushType == 0) {//从订单页面push过来的
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;

//        //头视图
//        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 105)];
//        _tableVC.tableHeaderView = headView;
//        
//        UIView *view = [UIView new];
//        [headView addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(headView);
//            make.top.mas_equalTo(27);
//            make.width.mas_equalTo(260);
//            make.height.mas_equalTo(23);
//        }];
//        
//        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_icon_Pickup"]];
//        [view addSubview:img];
//        [img mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(view);
//            make.left.equalTo(view);
//            make.bottom.equalTo(view);
//            make.width.mas_equalTo(23);
//        }];
//        
//        UILabel *lab1 = [UILabel new];
//        [view addSubview:lab1];
//        lab1.text = @"支付完成，请填写取货人信息";
//        lab1.textColor = RGBACOLOR(218, 50, 0, 1);
//        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(30);
//            make.right.mas_equalTo(view);
//            make.top.mas_equalTo(view);
//            make.bottom.mas_equalTo(view);
//        }];
//        
//        UILabel *lab2 = [UILabel new];
//        [headView addSubview:lab2];
//        lab2.text = @"订单号：00202";
//        lab2.font = [UIFont systemFontOfSize:15];
//        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(view);
//            make.height.mas_equalTo(23);
//            make.top.mas_equalTo(65);
//            make.width.mas_equalTo(200);
//        }];
        
        //脚视图
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        _tableVC.tableFooterView = footView;
        
        UILabel *footLabel = [UILabel new];
        [footView addSubview:footLabel];
        [footLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(-10);
            make.width.mas_equalTo(160);
        }];
        footLabel.text = @"买家找车（运费自付）";
        footLabel.font = [UIFont systemFontOfSize:16];
        footLabel.hidden=YES;
        _selectBtnImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_icon_car_n"]];
        [footView addSubview:_selectBtnImg];
        [_selectBtnImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(footLabel.mas_left).with.offset(-5);
            make.centerY.equalTo(footLabel);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(15);
        }];
        _selectBtnImg.hidden=YES;
        
        _isSelectCar = NO;
        
        //透明的button，使_btnImg实现选择框效果
        UIButton *selectCarBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [footView addSubview:selectCarBtn];
//        [selectCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(0);
//            make.bottom.mas_equalTo(0);
//            make.width.mas_equalTo(200);
//        }];
        [selectCarBtn addTarget:self action:@selector(selectCarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }

    //添加联系人按钮
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:addbtn];
    addbtn.frame = CGRectMake(0, ScreenHeight-TabbarHeight, ScreenWidth, TabbarHeight);
    [addbtn setBackgroundColor:mainColor];
    [addbtn setTitle:self.type==0? NSLocalizedString(@"Add consignee", nil):NSLocalizedString(@"Add consogner", nil) forState:UIControlStateNormal];
    [addbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addbtn setBackgroundColor:mainColor];
    [addbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addbtn.titleLabel setFont:ThemeFont(18)];
    [addbtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addbtn.tag = 100;
}

//买家找车选择按钮
- (void)selectCarBtnClick{
    if (_isSelectCar == NO) {
        _selectBtnImg.image = [UIImage imageNamed:@"order_icon_car_s"];
    }else{
        _selectBtnImg.image = [UIImage imageNamed:@"order_icon_car_n"];
    }
    _isSelectCar = !_isSelectCar;
}

//选择按钮
- (void)selectBtnClick:(UIButton *)sender{
    NSIndexPath *indexPath = [_tableVC indexPathForCell:(TYDP_ConsigneeCell *)sender.superview.superview.superview];
    if (_currentIndex) {
        if (_currentIndex == indexPath) {
            [sender setBackgroundImage:[UIImage imageNamed:@"selected_b1"] forState:UIControlStateNormal];
            _currentIndex = nil;
        }else{
            TYDP_ConsigneeCell*cell = (TYDP_ConsigneeCell *)[_tableVC cellForRowAtIndexPath:_currentIndex];
            [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"selected_b1"] forState:UIControlStateNormal];
            [sender setBackgroundImage:[UIImage imageNamed:@"selected_b0"] forState:UIControlStateNormal];
            _currentIndex = indexPath;
        }
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"selected_b0"] forState:UIControlStateNormal];
        _currentIndex = indexPath;
    }
    TYDP_ConsigneeModel *model = _dataSource[_currentIndex.row];
    NSLog(@"TYDP_ConsigneeModel:%@",model.Id);
    _addressIdString = [NSString stringWithFormat:@"%@",model.Id];
    _addressMobile = [NSString stringWithFormat:@"%@",model.mobile];
    _addressName = [NSString stringWithFormat:@"%@",model.name];
    _addressUserId = [NSString stringWithFormat:@"%@",model.id_number];
    [self changeBottomBtn];
}

//改变底部按钮（确定，添加取货人）
- (void)changeBottomBtn{
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    [btn setBackgroundColor:mainColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:ThemeFont(18)];
    if (_currentIndex) {
        [btn setTitle:NSLocalizedString(@"Confirm",nil) forState:UIControlStateNormal];
        [btn removeTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(postData) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btn setTitle:self.type==0? NSLocalizedString(@"Add consignee", nil):NSLocalizedString(@"Add consogner", nil) forState:UIControlStateNormal];
        [btn removeTarget:self action:@selector(postData) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)postData{
    NSString *yunFeiString = [NSString new];
    if (_isSelectCar) {
        yunFeiString = @"1";
    } else {
        yunFeiString = @"0";
    }
    NSLog(@"---点击了确定---%@",_addressIdString);
    NSDictionary *tmpDic = @{@"address_id":_addressIdString,@"yunfei":yunFeiString,@"addressName":_addressName,@"addressMobile":_addressMobile,@"address_userId":_addressUserId};
    _addAddressInfoBlock(tmpDic);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBtnClick:(UIButton *)sender{
    if (self.type==0) {
    
    TYDP_AddConsigneeController *addVC = [[TYDP_AddConsigneeController alloc]init];
    addVC.type=self.type;
    if (sender.tag == 100) {//添加联系人
        addVC.pushType = 1;
    }else{//编辑联系人
        addVC.pushType = 0;
        TYDP_ConsigneeModel *model = [TYDP_ConsigneeModel new];
        NSIndexPath *indexPath = [_tableVC indexPathForCell:(TYDP_ConsigneeCell *)sender.superview.superview.superview];
        model = _dataSource[indexPath.row];
        addVC.model = model;
    }
    [self.navigationController pushViewController:addVC animated:YES];
        
    }
    
    else
    {
        addSenderAddressViewController *addVC = [[addSenderAddressViewController alloc]init];
        addVC.type=self.type;
        if (sender.tag == 100) {//添加联系人
            addVC.pushType = 1;
        }else{//编辑联系人
            addVC.pushType = 0;
            TYDP_ConsigneeModel *model = [TYDP_ConsigneeModel new];
            NSIndexPath *indexPath = [_tableVC indexPathForCell:(TYDP_ConsigneeCell *)sender.superview.superview.superview];
            model = _dataSource[indexPath.row];
            addVC.model = model;
        }
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDP_ConsigneeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYDP_ConsigneeCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[TYDP_ConsigneeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_ConsigneeCell.h"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.changeBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.pushType == 1) {//从个人中心（我的）页面push过来
        cell.selectBtn.hidden = YES;
        cell.rightConstrsint.constant = 20;
    }else{//从订单页面push过来
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"selected_b1"] forState:UIControlStateNormal];
        if (indexPath == _currentIndex) {
            [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"selected_b0"] forState:UIControlStateNormal];
        }
        [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    TYDP_ConsigneeModel *model = [TYDP_ConsigneeModel new];
    model = _dataSource[indexPath.row];
    cell.nameLab.text = model.name;
    cell.numberLab.text = model.mobile;
    cell.IDnumberLab.text = model.id_number;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bggradient_person_"] forBarMetrics:UIBarMetricsDefault];
    self.tabBarController.tabBar.hidden = YES;
//    if (self.pushType == 0){
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
    [self requestData];
    [MobClick beginLogPageView:@"收货人管理界面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
//    if (self.pushType == 0){
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
    [MobClick endLogPageView:@"收货人管理界面"];
}

@end
