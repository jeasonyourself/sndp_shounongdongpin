//
//  TYDP_MineController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/14.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_MineController.h"
#import "TYDP_MineCellA.h"
#import "TYDP_MineCellB.h"
#import "TYDP_MineCellC.h"
#import "TYDP_MyMessageController.h"//我的消息
#import "TYDP_SetController.h"//设置
#import "TYDP_SetDataController.h"//编辑资料
#import "TYDP_MyWantController.h"//我的求购
#import "TYDP_CareController.h"//我的关注
#import "TYDP_BargainController.h"//我的还价
#import "TYDP_IndentController.h"//全部订单
#import "TYDP_AfterServiceController.h"//售后服务
#import "TYDP_ConsigneeController.h"//收货人管理
#import "TYDP_CustomerServiceController.h"//专属客服
#import "TYDP_LoginController.h"
#import "TYDPManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TYDP_UserInfoModel.h"
#import "ZYTabBar.h"
#import "TYDP_sellerCenterViewController.h"
#import "toBeSellerViewController.h"
@interface TYDP_MineController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tabView;
    NSArray *_imgArr;//图片
    NSArray *_titleArr;//左边文字
    NSArray *_subTitleArr;//右边文字
    NSString *_tokenStr;
    NSString *_user_id;
    UILabel *_nameLab;//用户昵称
    UIImageView *_VIPimg;//会员类型
    UILabel *_moneyLab;//余额钱数
    UIImageView *_portraitImg;//头像
    TYDP_UserInfoModel *_model;
    MBProgressHUD *_MBHUD;
}
@end

@implementation TYDP_MineController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

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

//当登录过期或用户信息有问题时退出登录
- (void)logout{
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    [userdefaul removeObjectForKey:@"token"];
    [userdefaul removeObjectForKey:@"user_name"];
    [userdefaul removeObjectForKey:@"user_id"];
    [userdefaul removeObjectForKey:@"user_face"];
    [userdefaul removeObjectForKey:@"alias"];
    [userdefaul removeObjectForKey:@"mobile_phone"];
    [userdefaul removeObjectForKey:@"user_rank"];

}
- (void)requestData{
    [self creatHUD];
    NSString *sign = [TYDPManager md5:[NSString stringWithFormat:@"userinfo%@",ConfigNetAppKey]];
    NSDictionary *params = @{@"model":@"user",@"action":@"info",@"user_id":_user_id,@"token":_tokenStr,@"sign":sign};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
                debugLog(@"userinfoData:%@",data);
        //        NSLog(@"%@",data[@"message"]);
        if ([data[@"error"]isEqualToString:@"1002"]) {
            [_MBHUD setLabelText:@"登录已过期，请重新登录"];
            NSLog(@"登录已过期，请重新登录");
            [_MBHUD hide:YES afterDelay:1.5f];
            [self logout];
            TYDP_LoginController *loginVC = [TYDP_LoginController new];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else if ([data[@"error"]isEqualToString:@"0"]){
            if (!_model) {
                _model = [TYDP_UserInfoModel new];
            }
            if (!data[@"content"][@"address"]) {
                data[@"content"][@"address"]=@"";
            }
            [_model setValuesForKeysWithDictionary:data[@"content"]];
            [PSDefaults setObject:[NSString stringWithFormat:@"%@",_model.user_rank] forKey:@"user_rank"];
            debugLog(@"_model_model:%@",_model);
            [_MBHUD hide:YES];
            [self configUIwithData];
        }else{
            [_MBHUD setLabelText:data[@"message"]];
            [_MBHUD hide:YES afterDelay:1.5f];
            NSLog(@"%@",data[@""]);
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [_MBHUD hide:YES afterDelay:1.5f];
        NSLog(@"%@",error);
    }];
}

- (void)configUIwithData{
    //用户昵称
    if ([_model.user_name isEqualToString:@""]) {
        _nameLab.text = @"";
    }else{
        _nameLab.text = _model.user_name;
    }
//    CGSize nameSize = [_nameLab sizeThatFits:CGSizeMake(100*Width, 20*Height)];
//    _nameLab.frame = CGRectMake(110*Width, 70*Height+30*Width, nameSize.width, nameSize.height);
    
    //会员类型
//    UIImage *tmpImage = [UIImage imageNamed:@"person_icon_member"];
//    _VIPimg.frame = CGRectMake(_nameLab.frame.origin.x+nameSize.width+10*Width, _nameLab.frame.origin.y+1, 85*Width, 85*Width*(tmpImage.size.height/tmpImage.size.width));
//        //余额
//    _moneyLab.text = [NSString stringWithFormat:@"%@",_model.formated_user_money];
    
    //关注
    
    //头像
    if (![_model.user_face isEqualToString:@""]) {
        [_portraitImg sd_setImageWithURL:[NSURL URLWithString:_model.user_face] placeholderImage:[UIImage imageNamed:@"person_head_default"]];
        //WY 在编辑用户信息后更新保存的plist信息
        [[NSUserDefaults standardUserDefaults] setObject:_model.user_face forKey:@"user_face"];//头像
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [_tabView reloadData];
}

- (void)creatUI{
    //    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    //    _tokenStr = [userdefaul objectForKey:@"token"];
    //    _user_id = [userdefaul objectForKey:@"user_id"];
    //    if (!_tokenStr||!_user_id) {
    //        TYDP_LoginController *loginVC = [TYDP_LoginController new];
    //        [self.navigationController pushViewController:loginVC animated:NO];
    //        [loginVC ReturnBlock:^(NSString *user_id, NSString *token) {
    //            _tokenStr = token;
    //            _user_id = user_id;
    //            [self requestData];
    //        }];
    //    }else{
    //        [self requestData];
    //    }
    _model = [TYDP_UserInfoModel new];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    CurrentWindow.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    //数据源赋值
    _imgArr = @[@"person_icon_buy",@"person_icon_aftersales",@"person_-icon_bargain",@"person_icon_pickup",@"server_icon"];
    _titleArr = @[NSLocalizedString(@"After sale service", nil),NSLocalizedString(@"Consignee management", nil),NSLocalizedString(@"Contact Customer Service", nil),NSLocalizedString(@"Inviting friends ", nil)];
    _subTitleArr = @[@"",@"",@"",@""];
    
    _tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 145*Height+20, ScreenWidth, ScreenHeight-145*Height-20-TabbarHeight)];
    [self.view addSubview:_tabView];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    [_tabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];//隐藏分割线
    _tabView.showsVerticalScrollIndicator = NO;
    
    //取消Tableview上的按钮高亮效果延迟效果（如头视图和脚视图上的Button）
    _tabView.delaysContentTouches = NO;
    
    //取消Tableviewcell上的按钮高亮效果延迟效果（当需要在cell上添加Button时直接在上一句代码后增加如下代码）
    for (UIView *currentView in _tabView.subviews) {
        if([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
        }
    }
    
    //创建头视图
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 145*Height+20)];
    [self.view addSubview:headImg];
    headImg.image = [UIImage imageNamed:@"bg_account"];
    headImg.userInteractionEnabled = YES;
    
    UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, 145*Height+20, ScreenWidth, 10*Height)];
    [headImg addSubview:grayLine];
    grayLine.backgroundColor = RGBACOLOR(235, 235, 235, 1);
    
    //设置按钮
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [headImg addSubview:setBtn];
    setBtn.frame = CGRectMake(ScreenWidth-60*Width, 0, 60*Width, 60*Width);
    [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *setBtnImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"person_icon_set"]];
    [headImg addSubview:setBtnImg];
     setBtnImg.frame = CGRectMake(ScreenWidth-30*Width, 10*Height+20, 20*Width, 20*Width);
    
    
    //消息按钮
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [headImg addSubview:messageBtn];
    
    messageBtn.frame = CGRectMake(0, 0, 60*Width, 60*Width);

    [messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *messageBtnImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_mompare"]];
    [headImg addSubview:messageBtnImg];
    messageBtnImg.frame = CGRectMake(10*Width, 10*Height+20, 24*Width, 24*Width);
    
    UILabel * qieLable = [UILabel new];
    [headImg addSubview:qieLable];
    qieLable.text = NSLocalizedString(@"Shift", nil);
    qieLable.font=[UIFont systemFontOfSize:12.0];
    CGSize qieSize = [qieLable sizeThatFits:CGSizeMake(100*Width, 20*Height)];
    qieLable.frame = CGRectMake(40*Width, 12*Height+20, qieSize.width, qieSize.height);
    qieLable.textColor = [UIColor whiteColor];
    UITapGestureRecognizer *qieTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qieTap)];
    [qieLable addGestureRecognizer:qieTap];
    qieLable.userInteractionEnabled = YES;
    
    //头像
    _portraitImg = [[UIImageView alloc]initWithFrame:CGRectMake(20*Width, 70*Height, 80*Width, 80*Width)];
    [headImg addSubview:_portraitImg];
    _portraitImg.layer.cornerRadius = 40*Width;
    _portraitImg.layer.borderWidth = 2;
    _portraitImg.layer.borderColor = [[UIColor whiteColor]CGColor];
    _portraitImg.layer.masksToBounds = YES;
    _portraitImg.image = [UIImage imageNamed:@"person_head_default"];//实际图片网络获取
    
    //添加手势
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tgrClick)];
    [_portraitImg addGestureRecognizer:tgr];
    _portraitImg.userInteractionEnabled = YES;
    
    //用户昵称
    _nameLab = [UILabel new];
    [headImg addSubview:_nameLab];
//    _nameLab.text = @"用户昵称";
    _nameLab.font=[UIFont systemFontOfSize:15.0];
//    CGSize nameSize = [_nameLab sizeThatFits:CGSizeMake(260*Width, 20*Height)];
    _nameLab.frame = CGRectMake(110*Width, 70*Height+30*Width, 260*Width, 20*Height);
    _nameLab.textColor = [UIColor whiteColor];
    
    //会员类型
//    UIImage *tmpImage = [UIImage imageNamed:@"person_icon_member"];
//    _VIPimg = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLab.frame.origin.x+nameSize.width+10*Width, _nameLab.frame.origin.y+1, 85*Width, 85*Width*(tmpImage.size.height/tmpImage.size.width))];
//    [headImg addSubview:_VIPimg];
//    _VIPimg.image = tmpImage;
    
    //余额
//    UILabel *YuE = [[UILabel alloc]initWithFrame:CGRectMake(110*Width, 89*Height+20, 45*Width, 20*Height)];
//    [headImg addSubview:YuE];
//    YuE.text = @"余额";
//    YuE.textColor = [UIColor whiteColor];
//    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(155*Width, 89*Height+20, ScreenWidth-165*Width, 20*Height)];
//    [headImg addSubview:_moneyLab];
//    _moneyLab.textColor = RGBACOLOR(229, 161, 71, 1);
//    _moneyLab.font = [UIFont systemFontOfSize:15];
//    _moneyLab.text = @"";
    
//    //关注
//    UILabel *GuanZhu = [[UILabel alloc]initWithFrame:CGRectMake(110*Width, 110*Height+20, 40*Width, 20*Height)];
//    [headImg addSubview:GuanZhu];
//    GuanZhu.text = @"关注";
//    GuanZhu.textColor = [UIColor whiteColor];
//    GuanZhu.userInteractionEnabled = YES;
//    
//    UILabel *careLab = [[UILabel alloc]initWithFrame:CGRectMake(155*Width, 110*Height+20, 120*Width, 20*Height)];
//    [headImg addSubview:careLab];
//    careLab.textColor = RGBACOLOR(229, 161, 71, 1);
//    careLab.font = [UIFont systemFontOfSize:15];
//    careLab.text = [NSString stringWithFormat:@"0"];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(careLabTap)];
//    [GuanZhu addGestureRecognizer:tap];
}

- (void)careLabTap{
    TYDP_CareController *careVC = [[TYDP_CareController alloc]init];
    [self.navigationController pushViewController:careVC animated:YES];
}

//头像单击手势
- (void)qieTap{
    [self messageBtnClick];
}


//头像单击手势
- (void)tgrClick{
    NSLog(@"单击了头像");
    TYDP_SetDataController *setDataVC = [[TYDP_SetDataController alloc]init];
    setDataVC.model = _model;
    [self.navigationController pushViewController:setDataVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//关闭选中效果
    
     if ([[PSDefaults objectForKey:@"user_rank"] isEqualToString:@"2"]) {
    if (indexPath.row ==1){
        
        NSLog(@"售后服务");
        TYDP_AfterServiceController *asVC = [[TYDP_AfterServiceController alloc]init];
        
        [self.navigationController pushViewController:asVC animated:YES];
//    }else if (indexPath.row ==3){
//        NSLog(@"我的还价");
//        TYDP_BargainController *bargainVC = [[TYDP_BargainController alloc]init];
//        [self.navigationController pushViewController:bargainVC animated:YES];
//    }
    }
    if (indexPath.row ==2){
        NSLog(@"收货人管理");
        TYDP_ConsigneeController *consigneeVC = [[TYDP_ConsigneeController alloc]init];
        consigneeVC.pushType = 1;
        consigneeVC.type=[[PSDefaults objectForKey:@"userType"] isEqualToString:@"0"]?0:1;

        [self.navigationController pushViewController:consigneeVC animated:YES];
    }
    if (indexPath.row ==3) {
        NSLog(@"专属客服");
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[NSString stringWithFormat:@"%@",_model.customer_service]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
        if (indexPath.row ==4) {
            NSLog(@"邀请好友");
        }
}
    else
        
    {
        if (indexPath.row==1) {
            if ([[NSString stringWithFormat:@"%@",_model.join] isEqualToString:@"1"]) {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"seller_Storyboard" bundle:nil];
                toBeSellerViewController * toBeSellerVC = [story instantiateViewControllerWithIdentifier:@"toBeSellerVC"];
                toBeSellerVC.TYDP_UserInfoMD=_model;
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:toBeSellerVC];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }
            else
            {
                [self.view Message:_model.join HiddenAfterDelay:1.0];
            }
           
        }
        
        if (indexPath.row ==2){
            
            NSLog(@"售后服务");
            TYDP_AfterServiceController *asVC = [[TYDP_AfterServiceController alloc]init];
            
            [self.navigationController pushViewController:asVC animated:YES];
            //    }else if (indexPath.row ==3){
            //        NSLog(@"我的还价");
            //        TYDP_BargainController *bargainVC = [[TYDP_BargainController alloc]init];
            //        [self.navigationController pushViewController:bargainVC animated:YES];
            //    }
        }
        if (indexPath.row ==3){
            NSLog(@"收货人管理");
            TYDP_ConsigneeController *consigneeVC = [[TYDP_ConsigneeController alloc]init];
            consigneeVC.pushType = 1;
            consigneeVC.type=[[PSDefaults objectForKey:@"userType"] isEqualToString:@"0"]?0:1;
            
            [self.navigationController pushViewController:consigneeVC animated:YES];
        }
        if (indexPath.row ==4) {
            NSLog(@"专属客服");
            NSLog(@"专属客服");
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_model.customer_service];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        if (indexPath.row ==5) {
            NSLog(@"邀请好友");
        }

        
      
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[PSDefaults objectForKey:@"user_rank"] isEqualToString:@"2"]) {
        return 4;
    }
    else
    {
    return 5;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     if ([[PSDefaults objectForKey:@"user_rank"] isEqualToString:@"2"]) {
    if (indexPath.row == 0) {
        return 90;
    }else{
        return 46;
    }
         
     }
    
     else
     {
     
         if (indexPath.row == 0) {
             return 90;
         }
         else if (indexPath.row == 1) {
             return 323*ScreenWidth/1444;
         }
         else{
             return 46;
         }
     }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[PSDefaults objectForKey:@"user_rank"] isEqualToString:@"2"]) {
    
    if (indexPath.row == 0) {
        TYDP_MineCellA *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_MineCellA" owner:self options:nil] lastObject];
        if (!cell) {
            cell = [[TYDP_MineCellA alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_MineCellA"];
        }
        [self configCellA:cell];
        return cell;
    }else{
        TYDP_MineCellB *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_MineCellB" owner:self options:nil] lastObject];
        if (!cell) {
            cell = [[TYDP_MineCellB alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_MineCellB"];
        }
        cell.imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imgArr[indexPath.row-1]]];
        cell.lab1.text = [NSString stringWithFormat:@"%@",_titleArr[indexPath.row-1]];
        cell.lab2.text = [NSString stringWithFormat:@"%@",_subTitleArr[indexPath.row-1]];
        if (indexPath.row == 5) {
            UILabel *redBall = [[UILabel alloc]initWithFrame:CGRectMake(125, 5, 20, 20)];
            [cell.contentView addSubview:redBall];
            redBall.text = [NSString stringWithFormat:@"%d",_model.huck_num];
            redBall.font = [UIFont systemFontOfSize:10];
            redBall.textAlignment = NSTextAlignmentCenter;
            redBall.textColor = [UIColor whiteColor];
            redBall.backgroundColor = [UIColor redColor];
            redBall.layer.cornerRadius = 10;
            redBall.layer.masksToBounds = YES;
        }
        return cell;
    }
        
    }
    else
    {
    
        if (indexPath.row == 0) {
            TYDP_MineCellA *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_MineCellA" owner:self options:nil] lastObject];
            if (!cell) {
                cell = [[TYDP_MineCellA alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_MineCellA"];
            }
            [self configCellA:cell];
            return cell;
        }
        else if (indexPath.row == 1) {
            TYDP_MineCellC *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_MineCellC" owner:self options:nil] lastObject];
            if (!cell) {
                cell = [[TYDP_MineCellC alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_MineCellC"];
            }
            cell.bgImg.image=[UIImage imageNamed:NSLocalizedString(@"banner_me_en", nil)];
            return cell;
        }
        else{
            TYDP_MineCellB *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_MineCellB" owner:self options:nil] lastObject];
            if (!cell) {
                cell = [[TYDP_MineCellB alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_MineCellB"];
            }
            cell.imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imgArr[indexPath.row-2]]];
            cell.lab1.text = [NSString stringWithFormat:@"%@",_titleArr[indexPath.row-2]];
            cell.lab2.text = [NSString stringWithFormat:@"%@",_subTitleArr[indexPath.row-2]];
            if (indexPath.row == 6) {
                UILabel *redBall = [[UILabel alloc]initWithFrame:CGRectMake(125, 5, 20, 20)];
                [cell.contentView addSubview:redBall];
                redBall.text = [NSString stringWithFormat:@"%d",_model.huck_num];
                redBall.font = [UIFont systemFontOfSize:10];
                redBall.textAlignment = NSTextAlignmentCenter;
                redBall.textColor = [UIColor whiteColor];
                redBall.backgroundColor = [UIColor redColor];
                redBall.layer.cornerRadius = 10;
                redBall.layer.masksToBounds = YES;
            }
            return cell;
        }
    }
}

- (void)configCellA:(TYDP_MineCellA *)cell{
    //四个button
    NSArray *imgArr = @[@"icon_me_order",@"icon_me_ask",@"icon_me_payment",@"icon_me_focus"];
    NSArray *titleArr = @[NSLocalizedString(@"All orders", nil),NSLocalizedString(@"My inquiry", nil),NSLocalizedString(@"My bids", nil),NSLocalizedString(@"My Following", nil)];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cell.btnView addSubview:btn];
        btn.frame = CGRectMake(ScreenWidth/4*i, 0, ScreenWidth/4, cell.btnView.frame.size.height);
        [btn addTarget:self action:@selector(changeColorWithSender:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(changeColorWithSender:) forControlEvents:UIControlEventTouchDragEnter];
        [btn addTarget:self action:@selector(btnTouchDragExitEvent:) forControlEvents:UIControlEventTouchDragExit];
        [btn addTarget:self action:@selector(btnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        
        CGFloat btnW = btn.frame.size.width;
        
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArr[i]]]];
        [btn addSubview:img];
        img.frame = CGRectMake(btnW/2-12, cell.btnView.frame.size.height/2-22*Width, 24*Width, 24*Width);
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.btnView.frame.size.height/2+10*Width, btnW, 20)];
        [btn addSubview:lab];
        lab.text = [NSString stringWithFormat:@"%@",titleArr[i]];
        lab.font = [UIFont systemFontOfSize:15];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.numberOfLines=0;
        lab.lineBreakMode=NSLineBreakByTruncatingHead;
    }
}

- (void)btnTouchDragExitEvent:(UIButton *)sender{
    sender.backgroundColor = [UIColor clearColor];
}

- (void)btnTouchUpInside:(UIButton *)sender{
    sender.backgroundColor = [UIColor clearColor];
//    TYDP_IndentController *indentVC = [TYDP_IndentController new];
//    indentVC.listType = (int)sender.tag-99;
//    [self.navigationController pushViewController:indentVC animated:YES];
    if (sender.tag == 100) {
        NSLog(@"全部订单");
        TYDP_IndentController *indentVC = [[TYDP_IndentController alloc]init];
        indentVC.listType = 0;
        [self.navigationController pushViewController:indentVC animated:YES];
    }else if (sender.tag == 101){
        NSLog(@"我的询盘");
        TYDP_MyWantController *wantVC = [[TYDP_MyWantController alloc]init];
        [self.navigationController pushViewController:wantVC animated:YES];
    }else if (sender.tag == 102){
        NSLog(@"我的还价");
        TYDP_BargainController *bargainVC = [[TYDP_BargainController alloc]init];
        [self.navigationController pushViewController:bargainVC animated:YES];

    }else {
        NSLog(@"我的关注");
        TYDP_CareController *careVC = [[TYDP_CareController alloc]init];
        [self.navigationController pushViewController:careVC animated:YES];
    }
}

//自定义高亮状态背景颜色
- (void)changeColorWithSender:(UIButton *)sender{
    sender.backgroundColor = RGBACOLOR(217, 217, 217, 1);
}

//- (void)cellABtnClick{
//    NSLog(@"hjjjj");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置按钮
- (void)setBtnClick{
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"seller_Storyboard" bundle:nil];
//    toBeSellerViewController * toBeSellerVC = [story instantiateViewControllerWithIdentifier:@"toBeSellerVC"];
//    toBeSellerVC.TYDP_UserInfoMD=_model;
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:toBeSellerVC];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
//    NSLog(@"设置");
    TYDP_SetController *setVC = [[TYDP_SetController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}

//消息按钮
- (void)messageBtnClick{
    debugLog(@"切换%@",_model.user_rank);
    if (![[NSString stringWithFormat:@"%@",_model.user_rank] isEqualToString:@"2"]) {
        if ([[NSString stringWithFormat:@"%@",_model.join] isEqualToString:@"1"]) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window Message:NSLocalizedString(@" Please apply for seller account first ", nil) HiddenAfterDelay:1.0];
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"seller_Storyboard" bundle:nil];
            toBeSellerViewController * toBeSellerVC = [story instantiateViewControllerWithIdentifier:@"toBeSellerVC"];
            toBeSellerVC.TYDP_UserInfoMD=_model;
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:toBeSellerVC];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            [self.view Message:_model.join HiddenAfterDelay:1.0];
        }

       
    }
    else
    {
        TYDP_sellerCenterViewController * TYDP_sellerCenterVC = [[TYDP_sellerCenterViewController alloc] init];
        [PSDefaults setObject:@"1" forKey:@"userType"];
        self.navigationController.viewControllers = @[TYDP_sellerCenterVC];
        
    }
   
//    TYDP_MyMessageController *myMessageVC = [[TYDP_MyMessageController alloc]init];
//    [self.navigationController pushViewController:TYDP_sellerCenterVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=YES;
    self.tabBarController.tabBar.hidden = YES;

//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bggradient_person_"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick endLogPageView:@"我的一级界面"];
}
- (void)viewDidAppear:(BOOL)animated {
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;

}
- (void)viewWillAppear:(BOOL)animated{
    //    [self.navigationController.navigationBar setBarTintColor:RGBACOLOR(32, 32, 36, 1)];
    //    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
    
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    _tokenStr = [userdefaul objectForKey:@"token"];
    _user_id = [userdefaul objectForKey:@"user_id"];
    if (!_tokenStr||!_user_id) {
        TYDP_LoginController *loginVC = [TYDP_LoginController new];
        [self.navigationController pushViewController:loginVC animated:NO];
//        [loginVC ReturnBlock:^(NSString *user_id, NSString *token) {
//            _tokenStr = token;
//            _user_id = user_id;
//            [self requestData];
//        }];
    }else{
        [self requestData];
    }
    [MobClick beginLogPageView:@"我的一级界面"];
}


@end
