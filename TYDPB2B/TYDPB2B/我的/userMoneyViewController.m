//
//  userMoneyViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/9.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "userMoneyViewController.h"
#import "userMoneyTableViewCell.h"
#import "TYDP_ConsigneeModel.h"
#import "TYDP_NoConsigneeController.h"
#import "addUserMoneyViewController.h"
@interface userMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableVC;
    NSIndexPath *_currentIndex;//被选中的indexpath
    UIImageView *_selectBtnImg;//买家找车（运费自付）前面的按钮
    BOOL _isSelectCar;
    NSMutableArray *_dataSource;
    //    BOOL _isSelectAddress;
    MBProgressHUD *_MBHUD;
    NSMutableString * bank_count;
    NSMutableString * goods_amount_count;
    UILabel *numberLabel;
    UILabel *allKaLabel;
    NSInteger index;
    UILabel *morenqihuoLable;
    UILabel *morenxianhuoLable;

}
@property(nonatomic, copy)NSString *addressIdString;
@property(nonatomic, copy)NSString *addressName;
@property(nonatomic, copy)NSString *addressMobile;
@property(nonatomic, copy)NSString *addressUserId;


@end

@implementation userMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    bank_count=[[NSMutableString alloc] init];
    goods_amount_count=[[NSMutableString alloc] init];
    index=0;
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
    NSDictionary *params = @{@"model":@"seller",@"action":@"getShopBankList",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"sellergetShopBankList%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
                debugLog(@"bankData:%@",data);
        if ([[NSString stringWithFormat:@"%@",data[@"content"][@"shop"][@"bank_switch"]] isEqualToString:@"0"]) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window Message:NSLocalizedString(@"Funds have not yet been opened", nil) HiddenAfterDelay:1.5];
            [self.navigationController popViewControllerAnimated:NO];
        }
        
        if ([data[@"error"] isEqualToString:@"0"]) {
            bank_count=[NSMutableString stringWithFormat:@"%@",data[@"content"][@"bank_count"]];
            goods_amount_count=[NSMutableString stringWithFormat:@"%@",data[@"content"][@"goods_amount_count"]];
            
            numberLabel.text=goods_amount_count;
            allKaLabel.text=bank_count;

            [self analyseData:data[@"content"][@"bank_list"]];
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
    self.title=NSLocalizedString(@"Capital account", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView * banerImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_me_buyer"]];
    banerImage.frame=CGRectMake(0, NavHeight, ScreenWidth, 160);
    [self.view addSubview:banerImage];
    
    numberLabel = [UILabel new];
    numberLabel.textAlignment=NSTextAlignmentCenter;
    [numberLabel setText:[NSString stringWithFormat:@"%@",goods_amount_count]];
    [numberLabel setFont:ThemeFont(14)];
    [numberLabel setTextColor:[UIColor whiteColor]];
    numberLabel.alpha=0.7;
    //        [middleTopLabel setTextColor:[UIColor grayColor]];
    [banerImage addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(banerImage).with.offset(0);
        make.left.equalTo(banerImage).with.offset(0);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *sign_numberLabel = [UILabel new];
    sign_numberLabel.textAlignment=NSTextAlignmentCenter;
    [sign_numberLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"yuejiaoyi_count", nil)]];
    [sign_numberLabel setFont:ThemeFont(14)];
    [sign_numberLabel setTextColor:[UIColor whiteColor]];
    sign_numberLabel.alpha=0.7;
    //        [middleTopLabel setTextColor:[UIColor grayColor]];
    [banerImage addSubview:sign_numberLabel];
    [sign_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(banerImage).with.offset(20);
        make.left.equalTo(banerImage).with.offset(0);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(20);
    }];
    

    allKaLabel = [UILabel new];
    allKaLabel.textAlignment=NSTextAlignmentCenter;
    [allKaLabel setText:[NSString stringWithFormat:@"%@",bank_count]];
    [allKaLabel setFont:ThemeFont(14)];
    [allKaLabel setTextColor:[UIColor whiteColor]];
    allKaLabel.alpha=0.7;
    //        [middleTopLabel setTextColor:[UIColor grayColor]];
    [banerImage addSubview:allKaLabel];
    [allKaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(banerImage).with.offset(0);
        make.right.equalTo(banerImage).with.offset(0);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *sign_allKaLabel = [UILabel new];
    sign_allKaLabel.textAlignment=NSTextAlignmentCenter;
    [sign_allKaLabel setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Numbers of account", nil)]];
    [sign_allKaLabel setFont:ThemeFont(14)];
    [sign_allKaLabel setTextColor:[UIColor whiteColor]];
    sign_allKaLabel.alpha=0.7;
    //        [middleTopLabel setTextColor:[UIColor grayColor]];
    [banerImage addSubview:sign_allKaLabel];
    [sign_allKaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(banerImage).with.offset(20);
        make.right.equalTo(banerImage).with.offset(0);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(20);
    }];
    
    
    
    
    morenqihuoLable = [UILabel new];
    morenqihuoLable.textAlignment=NSTextAlignmentCenter;
    [morenqihuoLable setText:[NSString stringWithFormat:NSLocalizedString(@"Future", nil)]];
    [morenqihuoLable setFont:ThemeFont(14)];
    [morenqihuoLable setTextColor:mainColor];
    [morenqihuoLable setBackgroundColor:RGBACOLOR(234, 234, 234, 1)];

    morenqihuoLable.alpha=0.7;
    //        [middleTopLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:morenqihuoLable];
    [morenqihuoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(banerImage.mas_bottom).with.offset(0);
        make.left.equalTo(banerImage).with.offset(0);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(40);
    }];
    morenqihuoLable.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qihuoTapMethod:)];
    [morenqihuoLable addGestureRecognizer:tap];
    
    
    morenxianhuoLable = [UILabel new];
    morenxianhuoLable.textAlignment=NSTextAlignmentCenter;
    [morenxianhuoLable setText:[NSString stringWithFormat:NSLocalizedString(@"Spot", nil)]];
    [morenxianhuoLable setFont:ThemeFont(14)];
    [morenxianhuoLable setTextColor:[UIColor grayColor]];
    [morenxianhuoLable setBackgroundColor:RGBACOLOR(234, 234, 234, 1)];

    morenxianhuoLable.alpha=0.7;
    //        [middleTopLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:morenxianhuoLable];
    [morenxianhuoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(banerImage.mas_bottom).with.offset(0);
        make.right.equalTo(banerImage).with.offset(0);
        make.width.mas_equalTo(ScreenWidth/2-1);
        make.height.mas_equalTo(40);
    }];
    morenxianhuoLable.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xianhuoTapMethod:)];
    [morenxianhuoLable addGestureRecognizer:tap1];
    
    //创建tableview
    _tableVC = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight+160+40, ScreenWidth, ScreenHeight-TabbarHeight-NavHeight-160-40)];
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
    
    [_tableVC registerNib:[UINib nibWithNibName:@"userMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:@"userMoneyTableViewCell"];
    
    //添加联系人按钮
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:addbtn];
    addbtn.frame = CGRectMake(0, ScreenHeight-TabbarHeight, ScreenWidth, TabbarHeight);
    [addbtn setBackgroundColor:RGBACOLOR(218, 154, 41, 1)];
    [addbtn setTitle:NSLocalizedString(@"+Creat an account", nil) forState:UIControlStateNormal];
    [addbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addbtn setBackgroundColor:mainColor];
    [addbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addbtn.titleLabel setFont:ThemeFont(18)];
    [addbtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addbtn.tag = 100;
}

- (void)qihuoTapMethod:(UITapGestureRecognizer *)tap
{
    //资金账户，报盘编辑与复制，出价留言
    [morenqihuoLable setTextColor:mainColor];
    [morenxianhuoLable setTextColor:[UIColor grayColor]];
    index=0;
    [_tableVC reloadData];
}


- (void)xianhuoTapMethod:(UITapGestureRecognizer *)tap
{
    [morenqihuoLable setTextColor:[UIColor grayColor]];
    [morenxianhuoLable setTextColor:mainColor];
    index=1;
     [_tableVC reloadData];
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
    if (index==0) {
        [self saveMoRen_qihuoBtnClick:sender];
    }
    if (index==1) {
        [self saveMoRenBtnClick:sender];
    }
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
        [btn setTitle:NSLocalizedString(@"+Creat an account", nil) forState:UIControlStateNormal];
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
    _addMoneyMsgInfoBlock(tmpDic);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBtnClick:(UIButton *)sender{
    addUserMoneyViewController *addVC = [[addUserMoneyViewController alloc]init];
    if (sender.tag == 100) {//添加联系人
        addVC.pushType = 1;
    }else{//编辑联系人
        addVC.pushType = 0;
        TYDP_ConsigneeModel *model = [TYDP_ConsigneeModel new];
        NSIndexPath *indexPath = [_tableVC indexPathForCell:(userMoneyTableViewCell *)sender.superview.superview.superview];
        model = _dataSource[indexPath.row];
        addVC.model = model;
    }
    [self.navigationController pushViewController:addVC animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    userMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userMoneyTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[userMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userMoneyTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.changeBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    TYDP_ConsigneeModel *model = [TYDP_ConsigneeModel new];
    model = _dataSource[indexPath.row];
    cell.nameLab.text = model.username;
    cell.numberLab.text = model.deposit_bank;
    cell.IDnumberLab.text = model.account;
    if (index==0) {
        if ([[NSString stringWithFormat:@"%@",model.is_future] isEqualToString:@"1"]) {
             [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"selected_b0"] forState:UIControlStateNormal];
        }
        else
        {
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"selected_b1"] forState:UIControlStateNormal];
        }
    }
    if (index==1) {
        if ([[NSString stringWithFormat:@"%@",model.is_spot] isEqualToString:@"1"]) {
            [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"selected_b0"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"selected_b1"] forState:UIControlStateNormal];
        }
    }
    cell.selectBtn.tag=indexPath.row;
    [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.deleteBtn.tag=indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(seleteBtnClickToPostData:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)seleteBtnClickToPostData:(UIButton *)sender {
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    TYDP_ConsigneeModel *model = [TYDP_ConsigneeModel new];
    model = _dataSource[sender.tag];
    NSDictionary *params = @{@"model":@"seller",@"action":@"delBank",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"sellerdelBank%@",ConfigNetAppKey]],@"bank_id":model.Id,@"user_id":[userdefaul objectForKey:@"user_id"]};
    debugLog(@"deleteparam:%@",params);

    [TYDPManager tydp_baseGetReqWithUrlStr:PHPURL params:params success:^(id data) {
        debugLog(@"deletedata:%@",data);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [self.view Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.0];
            [self requestData];
        }
    } failure:^(TYDPError *error) {
        
    }];
}

- (void)saveMoRenBtnClick:(UIButton *)sender {
    
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    TYDP_ConsigneeModel *model = [TYDP_ConsigneeModel new];
    model = _dataSource[sender.tag];

    NSDictionary *params = @{@"model":@"seller",@"action":@"defaultBank",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"sellerdefaultBank%@",ConfigNetAppKey]],@"bank_id":model.Id,@"user_id":[userdefaul objectForKey:@"user_id"],@"good_type":@"spot"};
    [TYDPManager tydp_baseGetReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
           [self.view Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.0];
            [self requestData];

        }
    } failure:^(TYDPError *error) {
        
    }];
}

- (void)saveMoRen_qihuoBtnClick:(UIButton *)sender {
    
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    TYDP_ConsigneeModel *model = [TYDP_ConsigneeModel new];
    model = _dataSource[sender.tag];
    NSDictionary *params = @{@"model":@"seller",@"action":@"defaultBank",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"sellerdefaultBank%@",ConfigNetAppKey]],@"bank_id":model.Id,@"user_id":[userdefaul objectForKey:@"user_id"],@"good_type":@"future"};
    [TYDPManager tydp_baseGetReqWithUrlStr:PHPURL params:params success:^(id data) {
        if ([data[@"error"]isEqualToString:@"0"]) {
            [self.view Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.0];
            [self requestData];

        }
    } failure:^(TYDPError *error) {
        
    }];
    
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
