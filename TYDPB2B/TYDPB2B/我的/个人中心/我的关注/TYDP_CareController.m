//
//  TYDP_CareController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/19.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_CareController.h"
#import "TYDP_CareCell.h"
#import "TYDP_VendorController.h"
#import "TYDP_NewVendorModel.h"
#import "TYDP_followListIntroduceGoodsModel.h"
#import "TYDP_OfferDetailViewController.h"
@interface TYDP_CareController ()
{
    MBProgressHUD *_MBHUD;

}
@property(strong,nonatomic)NSMutableArray * allArr;

@end

@implementation TYDP_CareController

- (void)viewDidLoad {
    [super viewDidLoad];
    _allArr=[[NSMutableArray alloc] init];
    [self creatUI];
    
    [self requestData];
}

- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"我的关住";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.tableView.backgroundColor = RGBACOLOR(244, 244, 244, 1);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //取消Tableview上的按钮高亮效果延迟效果（如头视图和脚视图上的Button）
    self.tableView.delaysContentTouches = NO;
    
    //取消Tableviewcell上的按钮高亮效果延迟效果（当需要在cell上添加Button时直接在上一句代码后增加如下代码）
    for (UIView *currentView in self.tableView.subviews) {
    if([currentView isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView *)currentView).delaysContentTouches = NO;
        }
    }
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
- (void)requestData{
    [self creatHUD];
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"model":@"user",@"action":@"get_follow_store",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userget_follow_store%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"]};
    [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
                debugLog(@"followList:%@",data);
        if ([data[@"error"] isEqualToString:@"0"]) {
            [_MBHUD hide:YES];
             [_allArr addObjectsFromArray:[TYDP_NewVendorModel arrayOfModelsFromDictionaries:data[@"content"]error:nil]];
            [self.tableView reloadData];
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


- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDP_CareCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"TYDP_CareCell" owner:self options:nil] lastObject];
    if (!cell) {
        cell = [[TYDP_CareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TYDP_CareCell"];
    }
    TYDP_NewVendorModel *NewVendorMD=[_allArr objectAtIndex:indexPath.row];
    [cell.mainImg sd_setImageWithURL:[NSURL URLWithString:NewVendorMD.user_face] placeholderImage:nil];
    cell.numLab.text=NewVendorMD.shop_name;
    cell.detailLab.text=[NSString stringWithFormat:@"订单成交量:%@",NewVendorMD.order_num];
    if (NewVendorMD.good_list.count>0) {
        TYDP_followListIntroduceGoodsModel *followListIntroduceGoodsMD=[NewVendorMD.good_list objectAtIndex:0];
        [cell.firstImg sd_setImageWithURL:[NSURL URLWithString:followListIntroduceGoodsMD.goods_thumb] placeholderImage:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapMethod:)];
        [cell.firstImg addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = indexPath.row*1000+0;

    }
    if (NewVendorMD.good_list.count>1) {
        TYDP_followListIntroduceGoodsModel *followListIntroduceGoodsMD1=[NewVendorMD.good_list objectAtIndex:1];
        [cell.secondImg sd_setImageWithURL:[NSURL URLWithString:followListIntroduceGoodsMD1.goods_thumb] placeholderImage:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapMethod:)];
        [cell.secondImg addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = indexPath.row*1000+1;
    }

    if (NewVendorMD.good_list.count>2) {
        TYDP_followListIntroduceGoodsModel *followListIntroduceGoodsMD2=[NewVendorMD.good_list objectAtIndex:2];
        [cell.thirdImg sd_setImageWithURL:[NSURL URLWithString:followListIntroduceGoodsMD2.goods_thumb] placeholderImage:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapMethod:)];
        [cell.thirdImg addGestureRecognizer:tap];
        UIView *tmpView = [tap view];
        tmpView.tag = indexPath.row*1000+2;
    }
    cell.typeBtn.tag=indexPath.row;
    [cell.typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = 210;
    return cell;
}
- (void)imageTapMethod:(UITapGestureRecognizer *)tap {
    UIView *tmpView = [tap view];
    NSInteger row =tmpView.tag/1000;
    NSInteger tag =tmpView.tag%1000;
    TYDP_NewVendorModel *NewVendorMD=[_allArr objectAtIndex:row];
    TYDP_followListIntroduceGoodsModel *followListIntroduceGoodsMD=[NewVendorMD.good_list objectAtIndex:tag];
    TYDP_OfferDetailViewController *offerDetailViewCon = [[TYDP_OfferDetailViewController alloc] init];
    offerDetailViewCon.goods_id = followListIntroduceGoodsMD.goods_id;
    [self.navigationController pushViewController:offerDetailViewCon animated:YES];
}

-(void)typeBtnClick:(UIButton*)btn
{
    TYDP_NewVendorModel *NewVendorMD=[_allArr objectAtIndex:btn.tag];

    TYDP_VendorController *vendorCon = [[TYDP_VendorController alloc] init];
    vendorCon.shopId = NewVendorMD.shop_id;
    [self.navigationController pushViewController:vendorCon animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TYDP_VendorController *VC = [[TYDP_VendorController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
