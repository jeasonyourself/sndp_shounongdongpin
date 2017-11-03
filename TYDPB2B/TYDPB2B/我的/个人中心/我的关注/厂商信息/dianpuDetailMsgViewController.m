//
//  dianpuDetailMsgViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/10/24.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "dianpuDetailMsgViewController.h"
#import "ZYTabBar.h"
@interface dianpuDetailMsgViewController ()
@property(nonatomic ,strong)NSMutableDictionary * shopDic;
@end

@implementation dianpuDetailMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.title=NSLocalizedString(@"Stall detail",nil);
    //
    _shopDic=[[NSMutableDictionary alloc] init];
    self.view.backgroundColor=RGBACOLOR(234, 234, 234, 1);
    [self getOrderData];
}
- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getOrderData {
    if (self.shop_id) {
        NSDictionary *params = @{@"model":@"user",@"action":@"get_shop",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"userget_shop%@",ConfigNetAppKey]],@"shop_id":self.shop_id,@"user_id":[PSDefaults objectForKey:@"user_id"]};
        [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
            NSLog(@"shopdetailData:%@",data[@"content"]);
            if (![data[@"error"] intValue]) {
                _shopDic=data[@"content"];
                [self crestUI];
            } else {
                [self.view Message:data[@"message"] HiddenAfterDelay:1.0];
            }
        } failure:^(TYDPError *error) {
            NSLog(@"---ShopDetailError:%@---",error);
        }];
    }
}
- (void)crestUI {

    
    float cellHeight=40.0;
    float allcellHeight=10;
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);;
        make.top.equalTo(self.view.mas_top).with.offset(NavHeight);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(40);
    }];

    UILabel *topLabel = [UILabel new];
    [bgView addSubview:topLabel];
    [topLabel setText:[NSString stringWithFormat:@"%@",_shopDic[@"shop_name"]]];
    [topLabel setTextColor:[UIColor lightGrayColor]];
    [topLabel setFont:ThemeFont(16)];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).with.offset(MiddleGap);;
        make.top.equalTo(bgView.mas_top).with.offset(0);
        make.width.mas_equalTo((ScreenWidth-2*MiddleGap)/2);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *righttopLabel = [UILabel new];
    [bgView addSubview:righttopLabel];
    righttopLabel.textAlignment=NSTextAlignmentRight;
    [righttopLabel setText:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Following",nil),_shopDic[@"follow_count"]]];
    [righttopLabel setTextColor:[UIColor lightGrayColor]];
    [righttopLabel setFont:ThemeFont(16)];
    [righttopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).with.offset(-MiddleGap);;
        make.top.equalTo(bgView.mas_top).with.offset(0);
        make.width.mas_equalTo((ScreenWidth-2*MiddleGap)/2);
        make.height.mas_equalTo(40);
    }];

    

    for (int i =0 ; i<3; i++) {
        cellHeight=40;
        cellHeight=i>0?40:[self heightForCellWithText:_shopDic[@"shop_info"] andFont:[NSNumber numberWithFloat:16.0] andWidth:[NSNumber numberWithFloat:ScreenWidth-30-100]]>40?[self heightForCellWithText:_shopDic[@"shop_info"] andFont:[NSNumber numberWithFloat:16.0] andWidth:[NSNumber numberWithFloat:ScreenWidth-30-100]]:40;
        UIView * landView = [UIView new];
        landView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:landView];
        [landView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(0);;
            make.top.equalTo(bgView.mas_bottom).with.offset(allcellHeight);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.height.mas_equalTo(cellHeight);
        }];
        
        UILabel *topLabel1 = [UILabel new];
        [landView addSubview:topLabel1];
        if (i==0) {
             [topLabel1 setText:NSLocalizedString(@"About the stall",nil)];
        }
        if (i==1) {
            [topLabel1 setText:NSLocalizedString(@"Stall location",nil)];
        }
        if (i==2) {
            [topLabel1 setText:NSLocalizedString(@"Time of opening",nil)];
        }
       
        [topLabel1 setTextColor:[UIColor lightGrayColor]];
        [topLabel1 setFont:ThemeFont(16)];
        [topLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(landView.mas_left).with.offset(MiddleGap);;
            make.top.equalTo(landView).with.offset(0);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(40);
        }];
        
        
        
        UILabel *righttopLabel1 = [UILabel new];
        [landView addSubview:righttopLabel1];
        if (i==0) {
            [righttopLabel1 setText:[NSString stringWithFormat:@"%@",_shopDic[@"shop_info"]]];
        }
        if (i==1) {
            [righttopLabel1 setText:[NSString stringWithFormat:@"%@",_shopDic[@"address"]]];
        }
        if (i==2) {
            [righttopLabel1 setText:[NSString stringWithFormat:@"%@",_shopDic[@"created"]]];
        }
        
        [righttopLabel1 setTextColor:[UIColor lightGrayColor]];
        [righttopLabel1 setFont:ThemeFont(16)];
        [righttopLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(landView.mas_right).with.offset(MiddleGap);;
            make.top.equalTo(landView).with.offset(0);
            make.left.equalTo(topLabel1.mas_right).with.offset(10);;
            make.height.mas_equalTo(cellHeight);
        }];

        allcellHeight=allcellHeight+cellHeight+1;

    }
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 字符串高度
- (CGFloat)heightForCellWithText:(NSString *)text andFont:(NSNumber*)fontSize andWidth:(NSNumber*)width{
    static CGFloat padding = 10.0;
    
    UIFont *systemFont = [UIFont systemFontOfSize:[fontSize floatValue]];
    CGSize textSize = CGSizeMake([width floatValue], CGFLOAT_MAX);
    
    //        CGSize sizeWithFont = [text sizeWithFont:systemFont constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];//ios7开始禁用
    
    CGRect rectToFit = [text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: systemFont} context:nil];
    
#if defined(__LP64__) && __LP64__
    return ceil(rectToFit.size.height) + padding;
#else
    return ceilf(rectToFit.size.height) + padding;
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=YES;
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"店铺详情"];
}
- (void)viewDidAppear:(BOOL)animated {
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=YES;
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=YES;
    self.tabBarController.tabBar.hidden = YES;
    
    [MobClick endLogPageView:@"店铺详情"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
