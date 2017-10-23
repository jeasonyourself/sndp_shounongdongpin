//
//  TYDP_HistoryOfferViewController.m
//  TYDPB2B
//
//  Created by Wangye on 16/7/26.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_HistoryOfferViewController.h"
#import "OfferHistoryModel.h"

@interface TYDP_HistoryOfferViewController ()
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UIScrollView *baseScrollView;
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)NSArray *topListArray;
@property(nonatomic, strong)NSArray *testDataArray;
@property(nonatomic, strong)NSArray *bottomTestArray;
@end

@implementation TYDP_HistoryOfferViewController
-(NSArray *)topListArray {
    if (!_topListArray) {
        _topListArray = [NSArray arrayWithObjects:@"国       家：",@"厂       号：",@"品       名：",@"规       格：",@"港       口：",@"包       装：", nil];
    }
    return _topListArray;
}
-(NSArray *)testDataArray {
    if (!_testDataArray) {
        _testDataArray = [NSArray arrayWithObjects:@"加拿大",@"391",@"猪整头",@"25KG/件 50件/吨",@"天津",@"抄码", nil];
    }
    return _testDataArray;
}
-(NSArray *)bottomTestArray {
    if (!_bottomTestArray) {
        _bottomTestArray = [NSArray arrayWithObjects:@"2016/06/30",@"2016/06/30",@"2016/06/30", nil];
    }
    return _bottomTestArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createWholeUI];
}
- (void)createWholeUI{
    [self.view setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
    [self setUpNavigationBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight-1, ScreenWidth,ScreenHeight-NavHeight)];
    [self.view addSubview:_baseScrollView];
    _containerView = [UIView new];
    [_baseScrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_baseScrollView);
        make.width.equalTo(_baseScrollView);
//        make.height.mas_equalTo(ScreenHeight*2);
    }];
    [self createTopUI];
}

- (void)createTopUI {
    UIView *middleView = [UIView new];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    middleView.clipsToBounds = YES;
    middleView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:middleView];
    UIImage *topDecorateImage = [UIImage imageNamed:@"hoffer_img1"];
    NSInteger topDecorateImageHeight = 90*(topDecorateImage.size.height/topDecorateImage.size.width);
    NSInteger smallViewHeight = 50;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(Gap);
        make.top.equalTo(_baseScrollView).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(-Gap);
        make.height.mas_equalTo(smallViewHeight*self.topListArray.count+topDecorateImageHeight-5);
    }];
    UIImageView *topDecorateImageView = [UIImageView new];
    [topDecorateImageView setImage:topDecorateImage];
    [_baseScrollView addSubview:topDecorateImageView];
    [topDecorateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView).with.offset(-5);
        make.left.equalTo(middleView).with.offset(MiddleGap);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(topDecorateImageHeight);
    }];
    UILabel *topDecorateLabel = [UILabel new];
    [topDecorateLabel setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
    [middleView addSubview:topDecorateLabel];
    [topDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topDecorateImageView.mas_bottom);
        make.left.equalTo(middleView);
        make.right.equalTo(middleView);
        make.height.mas_equalTo(1);
    }];
    for (int i = 0; i < self.topListArray.count; i++) {
        UIView *smallView = [UIView new];
        [middleView addSubview:smallView];
        [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topDecorateLabel.mas_bottom).with.offset(smallViewHeight*i);;
            make.left.equalTo(middleView);
            make.right.equalTo(middleView);
            make.height.mas_equalTo(smallViewHeight);
        }];
        UILabel *smallBottomDecorateLabel = [UILabel new];
        [smallBottomDecorateLabel setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
        [smallView addSubview:smallBottomDecorateLabel];
        [smallBottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(smallView.mas_bottom);
            make.left.equalTo(middleView).with.offset(Gap);
            make.right.equalTo(middleView).with.offset(-Gap);
            make.height.mas_equalTo(1);
        }];
        UILabel *leftSmallLabel = [UILabel new];
        [smallView addSubview:leftSmallLabel];
        [leftSmallLabel setText:self.topListArray[i]];
        [leftSmallLabel setFont:ThemeFont(CommonFontSize+1)];
        [leftSmallLabel setTextColor:[UIColor grayColor]];
        [leftSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallView);
            make.left.equalTo(smallView).with.offset(30);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        NSString *infoString = [NSString stringWithFormat:@"暂无"];
        switch (i) {
            case 0:{
                if (![_offerDetailModel.region_name isEqualToString:@""]&&_offerDetailModel.region_name) {
                    infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.region_name];
                }
                break;
            }
            case 1:{
                if (![_offerDetailModel.brand_sn isEqualToString:@""]&&_offerDetailModel.brand_sn) {
                    infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.brand_sn];
                }
                break;
            }
            case 2:{
                if (![_offerDetailModel.goods_name isEqualToString:@""]&&_offerDetailModel.goods_name) {
                    infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.goods_name];
                }
                break;
            }
            case 3:{
                if ((![_offerDetailModel.spec_1 isEqualToString:@""]&&_offerDetailModel.spec_1)||(![_offerDetailModel.spec_2 isEqualToString:@""]&&_offerDetailModel.spec_2)) {
                    infoString = [NSString stringWithFormat:@"%@%@      %@%@",_offerDetailModel.spec_1,_offerDetailModel.spec_1_unit,_offerDetailModel.spec_2,_offerDetailModel.spec_2_unit];
                }
                break;
            }
            case 4:{
                if (![_offerDetailModel.port_name isEqualToString:@""]&&_offerDetailModel.port_name) {
                    infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.port_name];
                }
                break;
            }
            case 5:{
                if (![_offerDetailModel.pack_name isEqualToString:@""]&&_offerDetailModel.pack_name) {
                    infoString = [NSString stringWithFormat:@"%@",_offerDetailModel.pack_name];
                }
                break;
            }
        }
        UILabel *rightSmallLabel = [UILabel new];
        [smallView addSubview:rightSmallLabel];
        [rightSmallLabel setText:infoString];
        [rightSmallLabel setFont:ThemeFont(CommonFontSize+1)];
        [rightSmallLabel setTextColor:[UIColor blackColor]];
        [rightSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(smallView);
            make.left.equalTo(leftSmallLabel.mas_right);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
        }];
    }
    [self createBottomUI:middleView];
}
- (void)createBottomUI:(UIView *)frontView {
    NSArray *offerHistoryModelArray = [NSArray arrayWithArray:_offerDetailModel.bp_list];
    UIView *middleView = [UIView new];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    middleView.clipsToBounds = YES;
    middleView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:middleView];
    UIImage *topDecorateImage = [UIImage imageNamed:@"hoffer_img2"];
    NSInteger topDecorateImageHeight = 90*(topDecorateImage.size.height/topDecorateImage.size.width);
    NSInteger smallViewHeight = 70;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseScrollView).with.offset(Gap);
        make.top.equalTo(frontView.mas_bottom).with.offset(20);
        make.right.equalTo(_baseScrollView).with.offset(-Gap);
        make.height.mas_equalTo(smallViewHeight*offerHistoryModelArray.count+topDecorateImageHeight-5);
    }];
    UIImageView *topDecorateImageView = [UIImageView new];
    [topDecorateImageView setImage:topDecorateImage];
    [_baseScrollView addSubview:topDecorateImageView];
    [topDecorateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView).with.offset(-5);
        make.left.equalTo(middleView).with.offset(MiddleGap);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(topDecorateImageHeight);
    }];
    UILabel *topDecorateLabel = [UILabel new];
    [topDecorateLabel setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
    [middleView addSubview:topDecorateLabel];
    [topDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topDecorateImageView.mas_bottom);
        make.left.equalTo(middleView);
        make.right.equalTo(middleView);
        make.height.mas_equalTo(1);
    }];
    for (int i = 0; i < offerHistoryModelArray.count; i++) {
        OfferHistoryModel *offerHistoryModel = offerHistoryModelArray[i];
        UIView *smallView = [UIView new];
        [middleView addSubview:smallView];
        [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topDecorateLabel.mas_bottom).with.offset(smallViewHeight*i);;
            make.left.equalTo(middleView);
            make.right.equalTo(middleView);
            make.height.mas_equalTo(smallViewHeight);
        }];
        UILabel *smallBottomDecorateLabel = [UILabel new];
        [smallBottomDecorateLabel setBackgroundColor:RGBACOLOR(236, 243, 254, 1)];
        [smallView addSubview:smallBottomDecorateLabel];
        [smallBottomDecorateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(smallView.mas_bottom);
            make.left.equalTo(middleView).with.offset(Gap);
            make.right.equalTo(middleView).with.offset(-Gap);
            make.height.mas_equalTo(1);
        }];
        UILabel *leftSmallLabel = [UILabel new];
        [smallView addSubview:leftSmallLabel];
//        [leftSmallLabel setBackgroundColor:[UIColor greenColor]];
        [leftSmallLabel setText:offerHistoryModel.add_time];
        [leftSmallLabel setFont:ThemeFont(CommonFontSize+1)];
        [leftSmallLabel setTextColor:[UIColor grayColor]];
        [leftSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(smallView).with.offset(Gap);
            make.left.equalTo(smallView).with.offset(15);
            make.width.mas_equalTo(ScreenWidth/3);
            make.height.mas_equalTo(30);
        }];
        UILabel *rightSmallLabel = [UILabel new];
//        [rightSmallLabel setBackgroundColor:[UIColor greenColor]];
        [smallView addSubview:rightSmallLabel];
        [rightSmallLabel setText:offerHistoryModel.goods_amount];
        [rightSmallLabel setTextAlignment:NSTextAlignmentCenter];
        [rightSmallLabel setFont:ThemeFont(CommonFontSize+1)];
        [rightSmallLabel setTextColor:[UIColor grayColor]];
        [rightSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(smallView).with.offset(Gap);
            make.right.equalTo(smallView);
            make.width.mas_equalTo(ScreenWidth/2.5);
            make.height.mas_equalTo(30);
        }];
        UILabel *historyIndicateLabel = [UILabel new];
        [historyIndicateLabel setBackgroundColor:RGBACOLOR(249, 160, 45, 1)];
        historyIndicateLabel.clipsToBounds = YES;
        historyIndicateLabel.layer.cornerRadius = 7;
        [smallView addSubview:historyIndicateLabel];
        [historyIndicateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftSmallLabel.mas_bottom);
            make.left.equalTo(leftSmallLabel);
            make.height.mas_equalTo(13);
            make.width.mas_equalTo((ScreenWidth-4*Gap)*([offerHistoryModel.rate intValue]/100.0));
        }];
        if (i == offerHistoryModelArray.count - 1) {
            [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(smallView).with.offset(20);
            }];
        }
    }
}
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    [self.view addSubview:_navigationBarView];
    _navigationBarView.backgroundColor=mainColor;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationBarView addSubview:backButton];
    UIImage *backButtonImage = [UIImage imageNamed:@"navi_return_btn_nor"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 0)];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navigationBarView).with.offset(Gap);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100*(backButtonImage.size.height/backButtonImage.size.width));
    }];
    UILabel *navigationLabel = [UILabel new];
    [_navigationBarView addSubview:navigationLabel];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setTextColor:[UIColor whiteColor]];
    [navigationLabel setText:[NSString stringWithFormat:@"报盘信息"]];
    [navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(ScreenWidth/3);
        make.height.mas_equalTo(25);
    }];
}
- (void)leftItemClicked:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"报盘历史界面"];
}
- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"报盘历史界面"];
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
