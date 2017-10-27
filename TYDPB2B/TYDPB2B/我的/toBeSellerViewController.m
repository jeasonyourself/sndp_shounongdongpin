//
//  toBeSellerViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/9/20.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "toBeSellerViewController.h"
#import "tobeSeller_enterTableViewCell.h"
#import "tobeSeller_subBtnTableViewCell.h"
#import "tobeSeller_addressTableViewCell.h"
#import "tobeSeller_fiveSelectTableViewCell.h"
#import "tobeSeller_bannerImageTableViewCell.h"
#import "signTextViewTableViewCell.h"
#import "TYDP_SelectAddressController.h"
@interface toBeSellerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,fstffBtnClickDelegate,tobeSeller_subBtnClickDelegate>
{
MBProgressHUD *_MBHUD;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)NSMutableDictionary *pubDic;
@property(nonatomic, strong)NSMutableArray *selectArr;
@property(nonatomic, strong)NSString * addressString;
@end

@implementation toBeSellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pubDic=[NSMutableDictionary new];
    _selectArr=[[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0", nil];
    
    [self setUpNavigationBar ];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegateMethod
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    switch (textField.tag) {
        case 2:
            _pubDic[@"shop_name"]=textField.text;
            break;
        case 3:
            _pubDic[@"real_name"]=textField.text;
            break;
        case 4:
            _pubDic[@"email"]=textField.text;
            break;
        case 5:
            _pubDic[@"address"]=textField.text;
            break;
        default:
            break;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _pubDic[@"shop_info"]=textView.text;

}
- (void) fstffClick:(NSInteger)sender
{
    [_selectArr replaceObjectAtIndex:sender withObject:[[_selectArr objectAtIndex:sender] isEqualToString:@"0"]?@"1":@"0"];
    [_myTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return self.view.frame.size.width*222/375;
    }
    else if (indexPath.row<8) {
        return 50;
    }
    else if (indexPath.row==8) {
        return 80;
    }
    else
    {
    return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        static NSString * const cellID = @"tobeSeller_bannerImageCell";
        tobeSeller_bannerImageTableViewCell *cell=(tobeSeller_bannerImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row<6)
    {
        static NSString * const cellID = @"tobeSeller_enterCell";
        tobeSeller_enterTableViewCell *cell=(tobeSeller_enterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        switch (indexPath.row) {
            case 1:
                cell.inputTextField.userInteractionEnabled=NO;
                cell.inputTextField.text=_TYDP_UserInfoMD.user_name;
                break;
            case 2:
                cell.inputTextField.userInteractionEnabled=YES;
                cell.inputTextField.placeholder=@"请输入店铺名称";
            break;
            case 3:
                cell.inputTextField.userInteractionEnabled=YES;
                cell.inputTextField.placeholder=@"请输入真实姓名";
                break;
            case 4:
                cell.inputTextField.userInteractionEnabled=YES;
                cell.inputTextField.placeholder=@"请输入邮箱";
                break;
            case 5:
                cell.inputTextField.userInteractionEnabled=YES;
                cell.inputTextField.placeholder=@"请输入企业地址";
                break;
            default:
                break;
        }
        cell.inputTextField.tag=indexPath.row;
        cell.inputTextField.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    else if (indexPath.row==6)
    {
        static NSString * const cellID = @"tobeSeller_fiveSelectCell";
        tobeSeller_fiveSelectTableViewCell *cell=(tobeSeller_fiveSelectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.delegate=self;
        if ([[_selectArr objectAtIndex:0] isEqualToString:@"0"]) {
            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
        }
        else
        {
        cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
        }
        
        
        if ([[_selectArr objectAtIndex:1] isEqualToString:@"0"]) {
            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
        }
        else
        {
            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
        }
        
        
        if ([[_selectArr objectAtIndex:2] isEqualToString:@"0"]) {
            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
        }
        else
        {
            cell.thirdImage.image=[UIImage imageNamed:@"yes_select"];
        }
        
        
        if ([[_selectArr objectAtIndex:3] isEqualToString:@"0"]) {
            cell.forthImage.image=[UIImage imageNamed:@"no_select"];
        }
        else
        {
            cell.forthImage.image=[UIImage imageNamed:@"yes_select"];
        }
        
        if ([[_selectArr objectAtIndex:4] isEqualToString:@"0"]) {
            cell.fifthImage.image=[UIImage imageNamed:@"no_select"];
        }
        else
        {
            cell.fifthImage.image=[UIImage imageNamed:@"yes_select"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row==7)
    {
        static NSString * const cellID = @"tobeSeller_addressCell";
        tobeSeller_addressTableViewCell *cell=(tobeSeller_addressTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.addressLable.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
        [cell.addressLable addGestureRecognizer:tap];
        cell.addressLable.text=_addressString?_addressString:@"";
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row==8)
    {
        static NSString * const cellID = @"signTextViewCell";
        signTextViewTableViewCell *cell=(signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.signTextView.placeholder=@"请输入店铺简介";
        cell.signTextView.text =_pubDic[@"shop_info"];
        cell.signTextView.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString * const cellID = @"tobeSeller_subBtnCell";
        tobeSeller_subBtnTableViewCell *cell=(tobeSeller_subBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tapMethod:(UITapGestureRecognizer *)tap
{
    TYDP_SelectAddressController *selectAddressVC = [TYDP_SelectAddressController new];
    [self addChildViewController:selectAddressVC];
    [selectAddressVC retTextBlock:^(NSString *addressName, NSString *privinceId, NSString *cityId) {
        UILabel *lab = (UILabel *)[self.view viewWithTag:105];
        lab.text = addressName;
        _pubDic[@"province"] = privinceId;
        _pubDic[@"city"] = cityId;
        _addressString=[NSString stringWithFormat:@"%@",addressName];
        [_myTableView reloadData];
        //            NSLog(@"addressName:%@---privinceId:%@---cityId:%@",addressName,privinceId,cityId);
    }];
    selectAddressVC.provinceId = @"";
    selectAddressVC.cityId = @"";
    [self.view addSubview:selectAddressVC.view];
    [CurrentWindow addSubview:selectAddressVC.view];
}

- (void) tobeSeller_subBtnClick:(NSInteger)sender
{
    [self creatHUD];
    BOOL isSelect=NO;
    debugLog(@"_selectArr_selectArr:%@",_selectArr);
    _pubDic[@"product"]=@"";
    for (int i =0 ; i<_selectArr.count; i++) {
        NSString * str=[_selectArr objectAtIndex:i];
        if ([str isEqualToString:@"1"]) {
            isSelect=YES;
            switch (i) {
                case 0:
                   _pubDic[@"product"]=[_pubDic[@"product"] isEqualToString:@""]?[NSString stringWithFormat:@"猪"]:[NSString stringWithFormat:@"%@ 猪",_pubDic[@"product"]];
                    break;
                case 1:
                    _pubDic[@"product"]=[_pubDic[@"product"] isEqualToString:@""]?[NSString stringWithFormat:@"牛"]:[NSString stringWithFormat:@"%@ 牛",_pubDic[@"product"]];
                    break;
                case 2:
                    _pubDic[@"product"]=[_pubDic[@"product"] isEqualToString:@""]?[NSString stringWithFormat:@"羊"]:[NSString stringWithFormat:@"%@ 羊",_pubDic[@"product"]];
                    break;
                case 3:
                     _pubDic[@"product"]=[_pubDic[@"product"] isEqualToString:@""]?[NSString stringWithFormat:@"禽类"]:[NSString stringWithFormat:@"%@ 禽类",_pubDic[@"product"]];
                    break;
                case 4:
                    _pubDic[@"product"]=[_pubDic[@"product"] isEqualToString:@""]?[NSString stringWithFormat:@"水产"]:[NSString stringWithFormat:@"%@ 水产",_pubDic[@"product"]];
                    break;
                default:
                    break;
            }
        }
        else
        {
        
        }
    }
    
    if (_pubDic[@"real_name"]&&_pubDic[@"address"]&&_pubDic[@"shop_name"]&&_pubDic[@"email"]&&isSelect) {
        
    }
    else
    {
        [self.view Message:@"请完善申请资料" HiddenAfterDelay:1.5];
        return;
    }
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * params=[[NSMutableDictionary alloc] init];
    NSDictionary *paramDic = @{@"model":@"seller",@"action":@"ruzhu",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"sellerruzhu%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"] };
    [params setValuesForKeysWithDictionary:paramDic];
    [params setValuesForKeysWithDictionary:_pubDic];
    debugLog(@"sendParamas:%@",params);
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
         debugLog(@"shenqingData:%@",data);
        if ([data[@"error"]isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window Message:@"入驻申请提交成功，请等待审核" HiddenAfterDelay:1.5];
             [self leftItemClicked:nil];
            
        }else{
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1];
            NSLog(@"%@",data[@"message"]);
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [_MBHUD hide:YES afterDelay:1];
        NSLog(@"error:%@",error);
    }];
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

#pragma mark 设置导航栏
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.backgroundColor=mainColor;
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    [self.view addSubview:_navigationBarView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationBarView addSubview:backButton];
    UIImage *backButtonImage = [UIImage imageNamed:@"product_icon_return"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30*(backButtonImage.size.height/backButtonImage.size.width));
    }];
    
    UILabel *titleLable = [UILabel new];
    [_navigationBarView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [titleLable setText:@"申请入驻"];
    
    titleLable.textColor=[UIColor whiteColor];
    [titleLable setFont:ThemeFont(16)];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    
    
    
}
- (void)leftItemClicked:(UIBarButtonItem *)item{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [MobClick beginLogPageView:@"入驻商家界面"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"入驻商家界面"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
