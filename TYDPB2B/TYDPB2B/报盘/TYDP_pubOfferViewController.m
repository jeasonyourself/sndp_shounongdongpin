//
//  TYDP_pubOfferViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/21.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "TYDP_pubOfferViewController.h"
#import "sixSelectBtnTableViewCell.h"
#import "twoSelectBtnTableViewCell.h"
#import "threeSelectBtnTableViewCell.h"
#import "selectTableViewCell.h"
#import "inputTableViewCell.h"
#import "makeImageTableViewCell.h"
#import "signTextViewTableViewCell.h"
#import "name_inputTableViewCell.h"
#import "addNew_pinGuiTableViewCell.h"
#import "addOrDeleteNew_pingGuiTableViewCell.h"

#import "pubOfferModel.h"
#import "TopCategoryModel.h"
#import "FilterSiteListModel.h"
#import "FilterSiteBrandListModel.h"
#import "FilterSellListModel.h"
#import "FilterCatDataBigModel.h"
#import "offerTypeModel.h"
#import "brandListModel.h"
#import "goodsNameListModel.h"
#import <PGDatePicker/PGDatePicker.h>
#import "TYDP_selectViewController.h"
#import "XuanZeTuPianCell.h"
#import "ZYTabBar.h"
#import "TYDPHttpManager.h"


#define ServerIP @"http://www.taiyanggo.com/app/api.php"

#define ORIGINAL_MAX_WIDTH 360.0f


@interface TYDP_pubOfferViewController ()<UITableViewDelegate,UITableViewDataSource,fsBtnClickDelegate,fstBtnClickDelegate,fstffsBtnClickDelegate,addNew_pinGuiBtnClickDelegate,addOrDeleteNew_pinGuiBtnClickDelegate,PGDatePickerDelegate,selectTitleDelegate,xuanZeTuPianDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIImagePickerController *_imagePickerController;

}
- (IBAction)textFieldEditChanged:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *pubBtn;
- (IBAction)pubBtnClick:(UIButton *)sender;
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)MBProgressHUD *MBHUD;

@property(nonatomic, strong)NSMutableArray * goodsCharacterArr;
@property(nonatomic, strong)NSMutableArray * pingGui_goodsArr;

@property(nonatomic, strong)pubOfferModel * pubOfferMD;
@property(nonatomic, strong)brandListModel * brandListMD;
@property(nonatomic, strong)goodsNameListModel * goodsNameListMD;
@property(nonatomic, strong)brandListModel * brandListMD1;
@property(nonatomic, strong)goodsNameListModel * goodsNameListMD1;
@property(nonatomic, strong)brandListModel * brandListMD2;
@property(nonatomic, strong)goodsNameListModel * goodsNameListMD2;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *fengmianimageViewArray;

@property (nonatomic, strong) NSMutableArray *data_imageViewArray;
@property (nonatomic, strong) NSMutableArray *data_fengmianimageViewArray;



@property(nonatomic, strong)NSMutableDictionary * dic1 ;//用来记录国家厂号信息
@property(nonatomic, strong)NSMutableDictionary * dic2 ;//用来记录包装规格信息
@property(nonatomic, strong)NSMutableDictionary * dic3 ;//用来记录国家厂号信息
@property(nonatomic, strong)NSMutableDictionary * dic4 ;//用来记录包装规格信息
@property(nonatomic, strong)NSMutableDictionary * dic5 ;//用来记录国家厂号信息
@property(nonatomic, strong)NSMutableDictionary * dic6 ;//用来记录包装规格信息
@property(nonatomic, strong)NSMutableDictionary * otherDic ;//用来记录库存、金额、预付条款、备注信息、是否上架、姓名、电话
@end

@implementation TYDP_pubOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    @"7",@"6",@"4",@"5",@"11",@"10"
    _goodsCharacterArr=[[NSMutableArray alloc] initWithObjects:@"7",@"4",@"11",nil];
    _dic1 = [[NSMutableDictionary alloc] init];//用来记录国家厂号信息
    _dic2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"shop_price_unit",@"8" ,@"pack",nil];//用来记录包装规格信息
    _dic3 = [[NSMutableDictionary alloc] init];//用来记录国家厂号信息
    _dic4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"shop_price_unit",@"8" ,@"pack",nil];//用来记录包装规格信息
    _dic5 = [[NSMutableDictionary alloc] init];//用来记录国家厂号信息
    _dic6 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"shop_price_unit",@"8" ,@"pack",nil];//用来记录包装规格信息
    _pingGui_goodsArr=[[NSMutableArray alloc] initWithObjects:_dic1,_dic2, nil];
    
    _otherDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"currency",@"1" ,@"is_on_sale",nil];//用来记录国家厂号信息
    
    _data_fengmianimageViewArray=[[NSMutableArray alloc] init];
    _data_imageViewArray=[[NSMutableArray alloc] init];
    _fengmianimageViewArray=[[NSMutableArray alloc] init];
    _imageViewArray=[[NSMutableArray alloc] init];
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    [self setUpNavigationBar];
    [self getNeedDataWithNewDic];
    
   
    
    
    // Do any additional setup after loading the view.
}
#pragma mark 设置导航栏
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    [_navigationBarView setBackgroundColor:mainColor];
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    [self.view addSubview:_navigationBarView];
    
    
    UILabel *navigationLabel = [UILabel new];
    if ([self.if_addOrEditOrCopy isEqualToString:@"1"]) {
        [navigationLabel setText:NSLocalizedString(@"Post offer", nil)];
    }
    if ([self.if_addOrEditOrCopy isEqualToString:@"2"]) {
        [navigationLabel setText:NSLocalizedString(@"Edit offer", nil)];
    }
    if ([self.if_addOrEditOrCopy isEqualToString:@"3"]) {
        [navigationLabel setText:NSLocalizedString(@"Copy offer", nil)];
    }
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setTextColor:[UIColor whiteColor]];
    [_navigationBarView addSubview:navigationLabel];
    [navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap/2);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(NavHeight/2);
    }];

    
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
}
- (void)leftItemClicked:(UIBarButtonItem *)item{
    
    if (_dismissOrPop) {
       [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 获取报盘信息
- (void)baoPanData{
    
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    
    NSString* _user_id = [userdefaul objectForKey:@"user_id"];
    
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"get_offer_info",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"get_offer_info",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"user_id":_user_id,@"goods_id":self.goods_id}];
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id dat) {
        debugLog(@"baopandatatatata:%@",dat);
        if (![dat[@"error"] intValue]) {
            NSDictionary* data=dat[@"content"];
            _goodsCharacterArr[0]=[NSString stringWithFormat:@"%@",data[@"goods_type"]];
            _goodsCharacterArr[1]=[NSString stringWithFormat:@"%@",data[@"sell_type"]];
            _goodsCharacterArr[2]=[NSString stringWithFormat:@"%@",data[@"offer"]];
            debugLog(@"_goodsCharacterArr_goodsCharacterArr:%@",_goodsCharacterArr);
            if (data[@"goods_base"])//多个产品
            {
                NSArray* arr=data[@"goods_base"];
                    if (arr.count>0) {
                        NSDictionary * firstDic=[arr objectAtIndex:0];;
                        
                        _dic1[@"region_id"]=[NSString stringWithFormat:@"%@",firstDic[@"region"]];
                        _dic1[@"region_name"]=[NSString stringWithFormat:@"%@",firstDic[@"region_name"]];
                        
                        _dic1[@"brand_id"]=[NSString stringWithFormat:@"%@",firstDic[@"brand_ids"]];
                        _dic1[@"brand_name"]=[NSString stringWithFormat:@"%@",firstDic[@"brand_sn"]];
                        
                        _dic1[@"cat_id"]=[NSString stringWithFormat:@"%@",firstDic[@"cat_id_first"]];
                        
                        for (TopCategoryModel * TopCategoryMD in _pubOfferMD.cat_list) {
                            if ([TopCategoryMD.cat_id isEqualToString:[NSString stringWithFormat:@"%@",_dic1[@"cat_id"]]]) {
                                _dic1[@"cat_name"]=[NSString stringWithFormat:@"%@",TopCategoryMD.cat_name];
                                break;
                            }
                        }
                        _dic1[@"base_id"]=[NSString stringWithFormat:@"%@",firstDic[@"base_ids"]];
                        _dic1[@"base_name"]=[NSString stringWithFormat:@"%@",firstDic[@"goods_names"]];
                        _dic1[@"make_date"]=[NSString stringWithFormat:@"%@",firstDic[@"make_date"]];
                        
//                        _dic2[@"shop_price_unit"]=[NSString stringWithFormat:@"%@",firstDic[@"shop_price_unit"]];
                        _dic2[@"spec_1"]=[NSString stringWithFormat:@"%@",firstDic[@"specs_1"]];
//                        _dic2[@"goods_weight"]=_dic2[@"specs_1"];
                        
                        _dic2[@"spec_3"]=[NSString stringWithFormat:@"%@",firstDic[@"specs_3"]];
                        _dic2[@"goods_weight"]=_dic2[@"specs_3"];
                        
                        _dic2[@"pack"]=[NSString stringWithFormat:@"%@",firstDic[@"packs"]];
                        _dic2[@"spec_txt"]=[NSString stringWithFormat:@""];
                    
                        [_pingGui_goodsArr removeAllObjects];
                        [_pingGui_goodsArr addObject:_dic1];
                        [_pingGui_goodsArr addObject:_dic2];}
                    
                    if (arr.count>1) {
                        NSDictionary * firstDic=[arr objectAtIndex:1];;
                        
                        _dic3[@"region_id"]=[NSString stringWithFormat:@"%@",firstDic[@"region"]];
                        _dic3[@"region_name"]=[NSString stringWithFormat:@"%@",firstDic[@"region_name"]];
                        
                        _dic3[@"brand_id"]=[NSString stringWithFormat:@"%@",firstDic[@"brand_ids"]];
                        _dic3[@"brand_name"]=[NSString stringWithFormat:@"%@",firstDic[@"brand_sn"]];
                        
                        _dic3[@"cat_id"]=[NSString stringWithFormat:@"%@",firstDic[@"cat_id_first"]];
                        
                        for (TopCategoryModel * TopCategoryMD in _pubOfferMD.cat_list) {
                            if ([TopCategoryMD.cat_id isEqualToString:[NSString stringWithFormat:@"%@",_dic3[@"cat_id"]]]) {
                                _dic3[@"cat_name"]=[NSString stringWithFormat:@"%@",TopCategoryMD.cat_name];
                                break;
                            }
                        }
                        _dic3[@"base_id"]=[NSString stringWithFormat:@"%@",firstDic[@"base_ids"]];
                        _dic3[@"base_name"]=[NSString stringWithFormat:@"%@",firstDic[@"goods_names"]];
                        _dic3[@"make_date"]=[NSString stringWithFormat:@"%@",firstDic[@"make_date"]];
                        
                        //                        _dic2[@"shop_price_unit"]=[NSString stringWithFormat:@"%@",firstDic[@"shop_price_unit"]];
                        _dic4[@"spec_1"]=[NSString stringWithFormat:@"%@",firstDic[@"specs_1"]];
                        //                        _dic2[@"goods_weight"]=_dic2[@"specs_1"];
                        
                        _dic4[@"spec_3"]=[NSString stringWithFormat:@"%@",firstDic[@"specs_3"]];
                        _dic4[@"goods_weight"]=_dic4[@"specs_3"];
                        
                        _dic4[@"pack"]=[NSString stringWithFormat:@"%@",firstDic[@"packs"]];
                        _dic4[@"spec_txt"]=[NSString stringWithFormat:@""];
                    
                        [_pingGui_goodsArr addObject:_dic3];
                        [_pingGui_goodsArr addObject:_dic4];
                    }
                    
                if (arr.count>2) {
                    NSDictionary * firstDic=[arr objectAtIndex:2];;
                    
                    _dic5[@"region_id"]=[NSString stringWithFormat:@"%@",firstDic[@"region"]];
                    _dic5[@"region_name"]=[NSString stringWithFormat:@"%@",firstDic[@"region_name"]];
                    
                    _dic5[@"brand_id"]=[NSString stringWithFormat:@"%@",firstDic[@"brand_ids"]];
                    _dic5[@"brand_name"]=[NSString stringWithFormat:@"%@",firstDic[@"brand_sn"]];
                    
                    _dic5[@"cat_id"]=[NSString stringWithFormat:@"%@",firstDic[@"cat_id_first"]];
                    
                    for (TopCategoryModel * TopCategoryMD in _pubOfferMD.cat_list) {
                        if ([TopCategoryMD.cat_id isEqualToString:[NSString stringWithFormat:@"%@",_dic5[@"cat_id"]]]) {
                            _dic5[@"cat_name"]=[NSString stringWithFormat:@"%@",TopCategoryMD.cat_name];
                            break;
                        }
                    }
                    _dic5[@"base_id"]=[NSString stringWithFormat:@"%@",firstDic[@"base_ids"]];
                    _dic5[@"base_name"]=[NSString stringWithFormat:@"%@",firstDic[@"goods_names"]];
                    _dic5[@"make_date"]=[NSString stringWithFormat:@"%@",firstDic[@"make_date"]];
                    
                    //                        _dic2[@"shop_price_unit"]=[NSString stringWithFormat:@"%@",firstDic[@"shop_price_unit"]];
                    _dic6[@"spec_1"]=[NSString stringWithFormat:@"%@",firstDic[@"specs_1"]];
                    //                        _dic2[@"goods_weight"]=_dic2[@"specs_1"];
                    
                    _dic6[@"spec_3"]=[NSString stringWithFormat:@"%@",firstDic[@"specs_3"]];
                    _dic6[@"goods_weight"]=_dic6[@"specs_3"];
                    
                    _dic6[@"pack"]=[NSString stringWithFormat:@"%@",firstDic[@"packs"]];
                    _dic6[@"spec_txt"]=[NSString stringWithFormat:@""];
                
                    [_pingGui_goodsArr addObject:_dic5];
                    [_pingGui_goodsArr addObject:_dic6];
                }
                
                
            }
            else//单个产品
            {
            
            _dic1[@"region_id"]=[NSString stringWithFormat:@"%@",data[@"region_id"]];
            _dic1[@"region_name"]=[NSString stringWithFormat:@"%@",data[@"region_name"]];
            
            _dic1[@"brand_id"]=[NSString stringWithFormat:@"%@",data[@"brand_id"]];
            _dic1[@"brand_name"]=[NSString stringWithFormat:@"%@",data[@"brand_sn"]];
            
            _dic1[@"cat_id"]=[NSString stringWithFormat:@"%@",data[@"cat_id_first"]];
            
                for (TopCategoryModel * TopCategoryMD in _pubOfferMD.cat_list) {
                    if ([TopCategoryMD.cat_id isEqualToString:[NSString stringWithFormat:@"%@",_dic1[@"cat_id"]]]) {
                        _dic1[@"cat_name"]=[NSString stringWithFormat:@"%@",TopCategoryMD.cat_name];
                        break;
                    }
                }
                
            _dic1[@"base_id"]=[NSString stringWithFormat:@"%@",data[@"base_id"]];
            _dic1[@"base_name"]=[NSString stringWithFormat:@"%@",data[@"base_name"]];
             _dic1[@"make_date"]=[NSString stringWithFormat:@"%@",data[@"make_date"]];
                
                _dic2[@"shop_price_unit"]=[NSString stringWithFormat:@"%@",data[@"shop_price_unit"]];
                 _dic2[@"spec_1"]=[NSString stringWithFormat:@"%@",data[@"spec_1"]];
                _dic2[@"goods_weight"]=_dic2[@"spec_1"];

                 _dic2[@"pack"]=[NSString stringWithFormat:@"%@",data[@"pack"]];
                 _dic2[@"spec_txt"]=[NSString stringWithFormat:@"%@",data[@"spec_txt"]];
            
                [_pingGui_goodsArr removeAllObjects];
                [_pingGui_goodsArr addObject:_dic1];
                [_pingGui_goodsArr addObject:_dic2];
            }
            
            //其他信息
            _otherDic[@"goods_number"]=[NSString stringWithFormat:@"%@",data[@"goods_number"]];
            _otherDic[@"goods_local"]=[NSString stringWithFormat:@"%@",data[@"goods_local"]];
            _otherDic[@"currency"]=[NSString stringWithFormat:@"%@",data[@"currency"]];
            _otherDic[@"currency_money"]=[NSString stringWithFormat:@"%@",data[@"currency_money_input"]];
            _otherDic[@"prepay"]=[NSString stringWithFormat:@"%@",data[@"prepay"]];
            
            for (offerTypeModel * TopCategoryMD in _pubOfferMD.prepay) {
                if ([TopCategoryMD.id isEqualToString:[NSString stringWithFormat:@"%@",_otherDic[@"prepay"]]]) {
                    _otherDic[@"prepay_name"]=[NSString stringWithFormat:@"%@",TopCategoryMD.val];
                    break;
                }
            }
            
            
            _otherDic[@"offer_type"]=[NSString stringWithFormat:@"%@",data[@"offer_type"]];
            
            if ([_otherDic[@"offer_type"] isEqualToString:@"1"]) {
                _otherDic[@"offer_type_name"]=@"CIF";
            }
            if ([_otherDic[@"offer_type"] isEqualToString:@"2"]) {
                _otherDic[@"offer_type_name"]=@"FOB";
            }
            if ([_otherDic[@"offer_type"] isEqualToString:@"3"]) {
                _otherDic[@"offer_type_name"]=@"DDP";
            }
            if ([_otherDic[@"offer_type"] isEqualToString:@"34"]) {
                _otherDic[@"offer_type_name"]=@"CFR";
            }
            
            _otherDic[@"goods_sn"]=[NSString stringWithFormat:@"%@",data[@"goods_sn"]];
            _otherDic[@"arrive_date"]=[NSString stringWithFormat:@"%@",data[@"arrive_date"]];
            _otherDic[@"lading_date"]=[NSString stringWithFormat:@"%@",data[@"lading_date"]];
            _otherDic[@"port"]=[NSString stringWithFormat:@"%@",data[@"port"]];
            for (FilterSellListModel * TopCategoryMD in _pubOfferMD.port) {
                if ([TopCategoryMD.id isEqualToString:[NSString stringWithFormat:@"%@",_otherDic[@"port"]]]) {
                    _otherDic[@"port_name"]=[NSString stringWithFormat:@"%@",TopCategoryMD.val];
                    break;
                }
            }
            
            
            _otherDic[@"goods_txt"]=[NSString stringWithFormat:@"%@",data[@"goods_txt"]];
            _otherDic[@"is_on_sale"]=[NSString stringWithFormat:@"%@",data[@"is_on_sale"]];
            
            if (![data[@"good_face"] isEqualToString:@""])//封面是否为空
            {
                
            NSData * data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"good_face"]]]];
            [_data_fengmianimageViewArray removeAllObjects];
            [_fengmianimageViewArray removeAllObjects];
            debugLog(@"data1data1:%@",[UIImage imageWithData:data1]);
            [_fengmianimageViewArray addObject:[UIImage imageWithData:data1]];
            [_data_fengmianimageViewArray addObject:
                 [TYDPManager resetSizeOfImageData:[UIImage imageWithData:data1] maxSize:300]];
                
            }
            
            if ([data[@"picture_list"] isKindOfClass:[NSArray class]]){
                NSArray * arr=data[@"picture_list"];
                if (arr.count!=0) {
                    for (NSDictionary * dic in arr) {
                        if (![dic[@"img_url"] isEqualToString:@""])//图片是否为空
                        {
                            NSData * data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"img_url"]]]];
                            [_imageViewArray addObject:[UIImage imageWithData:data1]];
                            
                            [_data_fengmianimageViewArray addObject:
                             [TYDPManager resetSizeOfImageData:[UIImage imageWithData:data1] maxSize:300]];
                        }
                        
                    }
                }
            }

            

            [_myTableView reloadData];
            
        } else {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Check Internet connection",nil)]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        NSLog(@"%@",error);
    }];
}


#pragma 获取前置信息
- (void)getNeedDataWithNewDic{
    
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    
    NSString* _user_id = [userdefaul objectForKey:@"user_id"];
    
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"get_offer_index",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"get_offer_index",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"user_id":_user_id}];
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"needdataparams:%@",data);
        if (![data[@"error"] intValue]) {
            _pubOfferMD = [[pubOfferModel alloc] initWithDictionary:data[@"content"] error:nil];

            if (![_pubOfferMD.user_info[@"user_rank"] isEqualToString:@"2"]) {
                 UIWindow * window = [UIApplication sharedApplication].keyWindow;
                [window Message:NSLocalizedString(@"Please apply for seller account first", nil) HiddenAfterDelay:2.0];
                [self leftItemClicked:nil];
            }
            if ([_pubOfferMD.user_info[@"alias"] isEqualToString:@""]) {
                
            }
            else
            {
                _otherDic[@"alias"]=_pubOfferMD.user_info[@"alias"] ;
            }
            
            if ([_pubOfferMD.user_info[@"mobile_phone"] isEqualToString:@""]) {
                
            }
            else
            {
                _otherDic[@"mobile_phone"]=_pubOfferMD.user_info[@"mobile_phone"] ;
            }
            
            if (![self.if_addOrEditOrCopy isEqualToString:@"1"]) {
                [self baoPanData];
            }
            else
            {
            
            }
            
            
        } else {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Check Internet connection",nil)]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        NSLog(@"%@",error);
    }];
}

#pragma 获取厂号列表
- (void)getBrandListDataWithNewDic:(NSString *)str and:(NSInteger)which_secion_dic{
    
    
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"get_brand_list",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"get_brand_list",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"sid":str}];
    debugLog(@"sitedataparparamsams:%@",params);
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"sitedataparams:%@",data);
        if (![data[@"error"] intValue]) {
            if (which_secion_dic==1) {
                _brandListMD = [[brandListModel alloc] initWithDictionary:data[@"content"] error:nil];
            }
           if (which_secion_dic==2) {
                _brandListMD1 = [[brandListModel alloc] initWithDictionary:data[@"content"] error:nil];
            }
            if (which_secion_dic==3) {
                _brandListMD2 = [[brandListModel alloc] initWithDictionary:data[@"content"] error:nil];
            }
            
            
        } else {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Check Internet connection",nil)]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        NSLog(@"%@",error);
    }];
}

#pragma 获取产品名称信息
- (void)getgoodsNameListWithNewDic:(NSString *)str and:(NSInteger)which_secion_dic{
    
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"get_goods_name",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"get_goods_name",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"cat_id":str}];
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"goodsNamedataparams:%@",data);
        if (![data[@"error"] intValue]) {
            if (which_secion_dic==1) {
                _goodsNameListMD = [[goodsNameListModel alloc] initWithDictionary:data[@"content"] error:nil];
            }
            if (which_secion_dic==2) {
                _goodsNameListMD1 = [[goodsNameListModel alloc] initWithDictionary:data[@"content"] error:nil];
            }
            if (which_secion_dic==3) {
                _goodsNameListMD2 = [[goodsNameListModel alloc] initWithDictionary:data[@"content"] error:nil];
            }
            
        } else {
            [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Check Internet connection",nil)]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        NSLog(@"%@",error);
    }];
}


#pragma mark -tableViewDelegatez

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])
        //现货
    {
        return 8+_pingGui_goodsArr.count;
        
    }
    else
//        期货
    {
        return 9+_pingGui_goodsArr.count;

        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (section) {
                case 0:
                    return 1;
                    break;
                case 1:
                    return 5;
                    break;
                case 2:
                    return 4;
                    break;
                case 3:
                    return 2;
                    break;
                case 4:
                    return 3;
                    break;
                case 5:
                    return 1;
                    break;
                case 6:
                    return 1;
                    break;
                case 7:
                    return 1;
                    break;
                case 8:
                    return 2;
                    break;
                case 9:
                    return 1;
                    
                default:
                    return 0;
                    break;
            }

        }
        else//整柜
        {
            if (_pingGui_goodsArr.count==2) {
                switch (section) {
                    case 0:
                        return 1;
                        break;
                    case 1:
                        return 5;
                        break;
                    case 2:
                        return 5;
                        break;
                    case 3:
                        return  2;
                        break;
                        
                    case 4:
                        return 3;
                        break;
                    case 5:
                        return 1;
                        break;
                    case 6:
                        return 1;
                        break;
                        
                    case 7:
                        return 1;
                        break;
                    case 8:
                        return 2;
                        break;
                    case 9:
                        return 1;
                        
                    default:
                        return 0;
                        break;
                }
            }
            else  if (_pingGui_goodsArr.count==4) {
                switch (section) {
                    case 0:
                        return 1;
                        break;
                    case 1:
                        return 5;
                        break;
                    case 2:
                        return 4;
                        break;
                    case 3:
                        return  5;
                        break;
                        
                    case 4:
                        return 5;
                        break;
                    case 5:
                        return  2;
                        break;
                        
                    case 6:
                        return 3;
                        break;
                    case 7:
                        return 1;
                        break;
                    case 8:
                        return 1;
                        break;
                        
                    case 9:
                        return 1;
                        break;
                    case 10:
                        return 2;
                        break;
                    case 11:
                        return 1;
                        
                    default:
                        return 0;
                        break;
                }

            
        }
            else
            {
                switch (section) {
                    case 0:
                        return 1;
                        break;
                    case 1:
                        return 5;
                        break;
                    case 2:
                        return 4;
                        break;
                    case 3:
                        return  5;
                        break;
                        
                    case 4:
                        return 5;
                        break;
                    case 5:
                        return  5;
                        break;
                        
                    case 6:
                        return 5;
                        break;
                    case 7:
                        return  2;
                        break;
                        
                    case 8:
                        return 3;
                        break;
                    case 9:
                        return 1;
                        break;
                    case 10:
                        return 1;
                        break;
                        
                    case 11:
                        return 1;
                        break;
                    case 12:
                        return 2;
                        break;
                        
                    case 13:
                        return 1;
                    default:
                        return 0;
                        break;
                }

            }

    }
    }
    else//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 5;
                break;
            case 2:
                return 5;
                break;
            case 3:
                return 4;
                break;
            case 4:
                return 1;
                break;
            case 5:
                return 3;
                break;
            case 6:
                return 1;
                break;
            case 7:
                return 1;
                break;
            case 8:
                return 1;
                break;
            case 9:
                return 2;
                break;
            case 10:
                return 1;
                
            default:
                return 0;
                break;
        }
    }
        else//整柜
        {
            if (_pingGui_goodsArr.count==2) {
                switch (section) {
                    case 0:
                        return 1;
                        break;
                    case 1:
                        return 5;
                        break;
                    case 2:
                        return 5;
                        break;
                    case 3:
                        return  5;
                        break;
                    case 4:
                        return  1;
                        break;
                        
                    case 5:
                        return 3;
                        break;
                    case 6:
                        return 1;
                        break;
                    case 7:
                        return 1;
                        break;
                        
                    case 8:
                        return 1;
                        break;
                    case 9:
                        return 2;
                        break;
                        
                    case 10:
                        return 1;
                    default:
                        return 0;
                        break;
                }
            }
            else  if (_pingGui_goodsArr.count==4) {
                switch (section) {
                    case 0:
                        return 1;
                        break;
                    case 1:
                        return 5;
                        break;
                    case 2:
                        return 5;
                        break;
                    case 3:
                        return  4;
                        break;
                    case 4:
                        return 5;
                        break;
                    case 5:
                        return  5;
                        break;
                    case 6:
                        return  1;
                        break;
                        
                    case 7:
                        return 3;
                        break;
                    case 8:
                        return 1;
                        break;
                    case 9:
                        return 1;
                        break;
                        
                    case 10:
                        return 1;
                        break;
                    case 11:
                        return 2;
                        break;
                    case 12:
                        return 1;
                        
                    default:
                        return 0;
                        break;
                }
            }
            else
            {
                switch (section) {
                    case 0:
                        return 1;
                        break;
                    case 1:
                        return 5;
                        break;
                    case 2:
                        return 5;
                        break;
                    case 3:
                        return  4;
                        break;
                    case 4:
                        return 5;
                        break;
                    case 5:
                        return  5;
                        break;
                    case 6:
                        return 5;
                        break;
                    case 7:
                        return  5;
                        break;
                    case 8:
                        return  1;
                        break;
                        
                    case 9:
                        return 3;
                        break;
                    case 10:
                        return 1;
                        break;
                    case 11:
                        return 1;
                        break;
                        
                    case 12:
                        return 1;
                        break;
                    case 13:
                        return 2;
                        break;
                        
                    case 14:
                        return 1;
                    default:
                        return 0;
                        break;
                }

                
            }

        }

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (indexPath.section) {
                case 0:
                    return 125;
                    break;
                case 1:
                    return 45;
                    break;
                case 2:
                    if (indexPath.row==3) {
                        return 80;
                    }
                    return 45;
                    break;
                case 3:
                    return 45;
                    break;
                case 4:
                    return 45;
                    break;
                case 5:
                    return 80;
                    break;
                case 6:
                    return 120;
                    break;
                case 7:
                    return 45;
                    break;
                case 8:
                    return 45;
                    break;
                case 9:
                    return  ([UIScreen mainScreen].bounds.size.width/3)*(_imageViewArray.count/3) +[UIScreen mainScreen].bounds.size.width/3+100;
                    break;
                    
                default:
                    return 0;
                    break;
            }
            
        }
        else//整柜
        {
            if (_pingGui_goodsArr.count==2) {
                
                switch (indexPath.section) {
                    case 0:
                        return 125;
                        break;
                    case 1:
                        return 45;
                        break;
                    case 2:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return indexPath.row==4? 50: 45;
                        break;
                    case 3:
                        return  45;
                        break;
                        
                    case 4:
                        return 45;
                        break;
                    case 5:
                        return 80;
                        break;
                    case 6:
                        return 120;
                        break;
                        
                    case 7:
                        return 45;
                        break;
                    case 8:
                        return 45;
                        break;
                    case 9:
                        return  ([UIScreen mainScreen].bounds.size.width/3)*(_imageViewArray.count/3) +[UIScreen mainScreen].bounds.size.width/3+100;
                        break;
                        
                    default:
                        return 0;
                        break;
                }
            }
            else  if (_pingGui_goodsArr.count==4) {
                switch (indexPath.section) {
                    case 0:
                        return 125;
                        break;
                    case 1:
                        return 45;
                        break;
                    case 2:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return 45;
                        break;
                    case 3:
                        return  45;
                        break;
                    case 4:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return  indexPath.row==4? 50: 45;
                        break;

                    case 5:
                        return  45;
                        break;
                    case 6:
                        return 45;
                        break;
                    case 7:
                        return 80;
                        break;
                    case 8:
                        return 120;
                        break;
                        
                    case 9:
                        return 45;
                        break;
                    case 10:
                        return 45;
                        break;
                    case 11:
                        return  ([UIScreen mainScreen].bounds.size.width/3)*(_imageViewArray.count/3) +[UIScreen mainScreen].bounds.size.width/3+100;
                        break;
                        
                    default:
                        return 0;
                        break;
                }
            }
            else
            {
                switch (indexPath.section) {
                    case 0:
                        return 125;
                        break;
                    case 1:
                        return 45;
                        break;
                    case 2:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return 45;
                        break;
                    case 3:
                        return  45;
                        break;
                    case 4:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return  indexPath.row==4?50: 45;
                        
                        break;
                    case 5:
                        return  45;
                        break;
                    case 6:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return  indexPath.row==4? 50: 45;
                        return 45;
                        break;
                    case 7:
                        return  45;
                        break;
                    case 8:
                        return 45;
                        break;
                    case 9:
                        return 80;
                        break;
                    case 10:
                        return 120;
                        break;
                        
                    case 11:
                        return 45;
                        break;
                    case 12:
                        return 45;
                        break;
                    case 13:
                        return  ([UIScreen mainScreen].bounds.size.width/3)*(_imageViewArray.count/3) +[UIScreen mainScreen].bounds.size.width/3+100;
                        break;
                        
                    default:
                        return 0;
                        break;
                }
                
            }
            
        }
    }
    else//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (indexPath.section) {
                case 0:
                    return 125;
                    break;
                case 1:
                    return 45;
                    break;
                case 2:
                    return 45;
                    break;
                case 3:
                    if (indexPath.row==3) {
                        return 80;
                    }
                    return 45;
                    break;
                case 4:
                    return 45;
                    break;
                case 5:
                    return 45;
                    break;

                case 6:
                    return 80;
                    break;
                case 7:
                    return 120;
                    break;
                case 8:
                    return 45;
                    break;
                case 9:
                    return 45;
                    break;
                case 10:
                    return  ([UIScreen mainScreen].bounds.size.width/3)*(_imageViewArray.count/3) +[UIScreen mainScreen].bounds.size.width/3+100;
                    break;
                    
                default:
                    return 0;
                    break;
            }
        }
        else//整柜
        {
            if (_pingGui_goodsArr.count==2) {
                switch (indexPath.section) {
                    case 0:
                        return 125;
                        break;
                    case 1:
                        return 45;
                        break;
                    case 2:
                        return 45;
                        break;
                    case 3:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return indexPath.row==4?50: 45;
                        break;
                    case 4:
                        return 45;
                        break;
                    case 5:
                        return 45;
                        break;
                        
                    case 6:
                        return 80;
                        break;
                    case 7:
                        return 120;
                        break;
                    case 8:
                        return 45;
                        break;
                    case 9:
                        return 40;
                        break;
                    case 10:
                        return  ([UIScreen mainScreen].bounds.size.width/3)*(_imageViewArray.count/3) +[UIScreen mainScreen].bounds.size.width/3+100;
                        break;
  
                        
                    default:
                        return 0;
                        break;
                }

            }
            else  if (_pingGui_goodsArr.count==4) {
                switch (indexPath.section) {
                    case 0:
                        return 125;
                        break;
                    case 1:
                        return 45;
                        break;
                    case 2:
                        return 45;
                        break;
                    case 3:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return  45;
                        break;
                    case 4:
                        return 45;
                        break;
                    case 5:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return indexPath.row==4?50: 45;
                        break;
                    case 6:
                        return 45;
                        break;
                    case 7:
                        return 45;
                        break;
                        
                    case 8:
                        return 80;
                        break;
                    case 9:
                        return 120;
                        break;
                    case 10:
                        return 40;
                        break;
                    case 11:
                        return 40;
                        break;
                    case 12:
                        return  ([UIScreen mainScreen].bounds.size.width/3)*(_imageViewArray.count/3) +[UIScreen mainScreen].bounds.size.width/3+100;
                        break;

                    default:
                        return 0;
                        break;
                }
            }
            else
            {
                switch (indexPath.section) {
                    case 0:
                        return 125;
                        break;
                    case 1:
                        return 45;
                        break;
                    case 2:
                        return 45;
                        break;
                    case 3:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return  45;
                        break;
                    case 4:
                        return 45;
                        break;
                    case 5:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return indexPath.row==4?50: 45;
                        break;
                    case 6:
                        return 45;
                        break;
                    case 7:
                        if (indexPath.row==3) {
                            return 80;
                        }
                        return indexPath.row==4?50: 45;
                        break;
                    case 8:
                        return 45;
                        break;
                    case 9:
                        return 45;
                        break;
                        
                    case 10:
                        return 80;
                        break;
                    case 11:
                        return 120;
                        break;
                    case 12:
                        return 45;
                        break;
                    case 13:
                        return 45;
                        break;
                    case 14:
                        return  ([UIScreen mainScreen].bounds.size.width/3)*(_imageViewArray.count/3) +[UIScreen mainScreen].bounds.size.width/3+100;
                        break;

                    default:
                        return 0;
                        break;
                }
            }
            
        }
        
    }

}
//设置分区的头部视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, self.view.frame.size.width, 30)];
//    label.text = @"  当地";
//    label.font = [UIFont boldSystemFontOfSize:16];
//    label.backgroundColor = [UIColor whiteColor];
//    return label;
//}
//设置分区头部视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
    if (indexPath.section==0) {
        static NSString * const cellID = @"sixSelectBtnCell";
        sixSelectBtnTableViewCell *cell = (sixSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.delegate=self;
        [cell.firstImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
         [cell.secondImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
        [cell.thirdImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
        [cell.forthImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"5"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
        [cell.fifthImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"11"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
         [cell.sixImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"10"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
        return cell;
    }
    else if (indexPath.section==1) {
        static NSString * const cellID = @"selectCell";
        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.nameLable.hidden=NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
        [cell addGestureRecognizer:tap];

        cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
            case 0:
                cell.nameLable.text=NSLocalizedString(@"Country", nil);
                if ([_dic1 objectForKey:@"region_id"]) {
                    cell.contentLable.text=[_dic1 objectForKey:@"region_name"];
                }
                else
                {
                    cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                }
                break;
            case 1:
                cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                if ([_dic1 objectForKey:@"brand_id"]) {
                    cell.contentLable.text=[_dic1 objectForKey:@"brand_name"];
                }
                else
                {
                    cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                }
                
                break;
            case 2:
                cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                if ([_dic1 objectForKey:@"cat_id"]) {
                    cell.contentLable.text=[_dic1 objectForKey:@"cat_name"];
                }
                else
                {
                    cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                }
                
                break;
            case 3:
                cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                if ([_dic1 objectForKey:@"base_id"]) {
                    cell.contentLable.text=[_dic1 objectForKey:@"base_name"];
                }
                else
                {
                    cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                }
                
                break;
            case 4:
                cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                if ([_dic1 objectForKey:@"make_date"]) {
                    cell.contentLable.text=[_dic1 objectForKey:@"make_date"];
                }
                else
                {
                    cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                }
                
                break;
            
            default:
                break;
        }
               return cell;
    }
    else if (indexPath.section==2) {
        if (indexPath.row==0) {
            static NSString * const cellID = @"twoSelectBtnCell";
            twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
            cell.nameLable.hidden=NO;
            cell.delegate=self;
            cell.tag=indexPath.section*100+indexPath.row;
            cell.nameLable.text=NSLocalizedString(@"Packing spec", nil);
            cell.firstLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"ctn",nil)];
            cell.secondLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"MT",nil)];
            if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                cell.secondImage.image=[UIImage imageNamed:@"no_select"];
            }
            if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
            }
            
            return cell;

        }
       else if (indexPath.row==1) {
            static NSString * const cellID = @"inputCell";
            inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
            cell.nameLable.hidden=YES;
           cell.tag=indexPath.section*100+indexPath.row;
           cell.inputField.delegate=self;
           cell.inputField.tag=cell.tag;
           
//             if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
//                 cell.unitLable.text=@"KG/件";
//             }
//            if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
//                cell.unitLable.text=@"%@";
//            }
           
           if ([_dic2 objectForKey:@"spec_1"]&&![[_dic2 objectForKey:@"spec_1"] isEqualToString:@""]) {
               cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic2 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
           }
           else
           {
           cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
           }
           
           if ([_dic2 objectForKey:@"spec_1"]) {
               cell.inputField.text=[_dic2 objectForKey:@"spec_1"];
               
           }
           else
           {
               cell.inputField.text=@"";
                           cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
           }
           
            return cell;
        }
       else if(indexPath.row==2) {
           static NSString * const cellID = @"twoSelectBtnCell";
           twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
           cell.nameLable.text=NSLocalizedString(@"weight", nil);
           cell.nameLable.hidden=NO;
           cell.delegate=self;
           cell.tag=indexPath.section*100+indexPath.row;
           cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
           cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
           if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"8"]) {
               cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
               cell.secondImage.image=[UIImage imageNamed:@"no_select"];
           }
           if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"9"]) {
               cell.firstImage.image=[UIImage imageNamed:@"no_select"];
               cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
           }

           return cell;
        }
       else {
            static NSString * const cellID = @"signTextViewCell";
            signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
           cell.tag=indexPath.section*100+indexPath.row;
           cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
           cell.signTextView.delegate=self;
           if ([_dic2 objectForKey:@"spec_txt"]) {
               cell.signTextView.text=[_dic2 objectForKey:@"spec_txt"];
               cell.signTextView.PlaceholderLabel.hidden=YES;
               if ([[_dic2 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                   cell.signTextView.PlaceholderLabel.hidden=NO;
               }

           }
           else
           {
               cell.signTextView.text=@"";
               cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
               cell.signTextView.PlaceholderLabel.hidden=NO;
           }
           cell.signTextView.tag=cell.tag;
            return cell;
        }
        
        
    }
    else if (indexPath.section==3) {
        
        //这里
        if (indexPath.row==0) {
        static NSString * const cellID = @"inputCell";
            inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.tag=indexPath.section*100+indexPath.row;
        cell.nameLable.text=NSLocalizedString(@"Inventory", nil);
        cell.nameLable.hidden=NO;
        cell.inputField.delegate=self;
        cell.inputField.tag=cell.tag;
        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
            cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"ctn",nil)];
        }
        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
            cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"ctn",nil)];
        }
        
        if ([_otherDic objectForKey:@"goods_number"]) {
            cell.inputField.text=[_otherDic objectForKey:@"goods_number"];
        }
        else
        {
            cell.inputField.text=@"";
                           cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
        }

        
            return cell;
        }
        else  {
            static NSString * const cellID = @"name_inputCell";
            name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
            cell.tag=indexPath.section*100+indexPath.row;
            cell.nameLable.hidden=NO;
            cell.nameLable.text=NSLocalizedString(@"Current Location", nil);
            cell.name_inputField.delegate=self;
            cell.name_inputField.tag=cell.tag;
            cell.name_inputField.userInteractionEnabled=YES;
            if ([_otherDic objectForKey:@"goods_local"]) {
                cell.name_inputField.text=[_otherDic objectForKey:@"goods_local"];
            }
            else
            {
                cell.name_inputField.text=@"";
            }
            return cell;
        }

        
    }
    else if (indexPath.section==4) {
        if (indexPath.row==0) {
            static NSString * const cellID = @"threeSelectBtnCell";
            threeSelectBtnTableViewCell *cell = (threeSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
            cell.tag=indexPath.section*100+indexPath.row;
            cell.delegate=self;
            cell.nameLable.text=NSLocalizedString(@"Amount", nil);
            cell.nameLable.hidden=NO;
            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"1"]) {
                cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
            }
            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
            }
            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                cell.thirdImage.image=[UIImage imageNamed:@"yes_select"];
            }
            
            return cell;
        }
        else if (indexPath.row==1) {
            static NSString * const cellID = @"inputCell";
            inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
            cell.tag=indexPath.section*100+indexPath.row;
            cell.inputField.delegate=self;
            cell.inputField.tag=cell.tag;
            if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                if ([[_otherDic objectForKey:@"currency"]
                     isEqualToString:@"1"]) {
                    cell.unitLable.text=NSLocalizedString(@"RMB/ctn",nil);
                }
                if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                    cell.unitLable.text=NSLocalizedString(@"USD/ctn",nil);
                }
                if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                    cell.unitLable.text=NSLocalizedString(@"Euro/ctn",nil);
                }

            }
            if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                if ([[_otherDic objectForKey:@"currency"]
                     isEqualToString:@"1"]) {
                    cell.unitLable.text=NSLocalizedString(@"RMB/MT",nil);
                }
                if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                    cell.unitLable.text=NSLocalizedString(@"USD/MT",nil);
                }
                if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                    cell.unitLable.text=NSLocalizedString(@"Euro/MT",nil);
                }
            }

            
            if ([_otherDic objectForKey:@"currency_money"]) {
                cell.inputField.text=[_otherDic objectForKey:@"currency_money"];
            }
            else
            {
                cell.inputField.text=@"";
                           cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
            }
            
            cell.nameLable.hidden=YES;
            return cell;
        }
        else  {
            static NSString * const cellID = @"selectCell";
            selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
            [cell addGestureRecognizer:tap];

            cell.tag=indexPath.section*100+indexPath.row;
            cell.nameLable.text=NSLocalizedString(@"Prepayment term", nil);
            cell.nameLable.hidden=NO;
            if ([_otherDic objectForKey:@"prepay"]) {
                cell.contentLable.text=[_otherDic objectForKey:@"prepay_name"];
            }
            else
            {
            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
            }
            
            return cell;
        }
        
    }
    else if (indexPath.section==5) {
        static NSString * const cellID = @"makeImageCell";
        makeImageTableViewCell *cell = (makeImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.tag=indexPath.section*100+indexPath.row;
        cell.nameLable.hidden=NO;
        cell.fengMianImage.hidden=NO;
        if (_fengmianimageViewArray.count>0) {
            [cell.fengMianImage setImage:[_fengmianimageViewArray objectAtIndex:0]];
        }
        else{
        [cell.fengMianImage setImage:[UIImage imageNamed:@"addTM"]];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fengMianImageTapMethod:)];
        [cell addGestureRecognizer:tap];
        cell.nameLable.text=NSLocalizedString(@"Cover photo", nil);
        return cell;
        
    }

    else if (indexPath.section==6) {
        static NSString * const cellID = @"signTextViewCell";
        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.signTextView.hidden=NO;
        cell.tag=indexPath.section*100+indexPath.row;
        cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
            cell.signTextView.PlaceholderLabel.hidden=NO;
        if ([_otherDic objectForKey:@"goods_txt"]) {
            cell.signTextView.text=[_otherDic objectForKey:@"goods_txt"];
            cell.signTextView.PlaceholderLabel.hidden=YES;
            if ([[_otherDic objectForKey:@"goods_txt"] isEqualToString:@""]) {
                cell.signTextView.PlaceholderLabel.hidden=NO;
            }
        }
        else
        {
            cell.signTextView.text=@"";
            cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
            cell.signTextView.PlaceholderLabel.hidden=NO;
        }

        cell.signTextView.delegate=self;
        cell.signTextView.tag=cell.tag;
        return cell;
        
    }

    else if (indexPath.section==7) {
        static NSString * const cellID = @"twoSelectBtnCell";
        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.tag=indexPath.section*100+indexPath.row;
        cell.nameLable.hidden=NO;
        cell.nameLable.text=NSLocalizedString(@"Listing?", nil);
        cell.firstLable.text=NSLocalizedString(@"YES", nil);
        cell.secondLable.text=NSLocalizedString(@"NO", nil);
        if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"1"]) {
            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
        }
        if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"0"]) {
            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
        }

        return cell;
        
    }
    else if (indexPath.section==8) {
        static NSString * const cellID = @"name_inputCell";
        name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (indexPath.row==0) {
            cell.nameLable.hidden=NO;
            cell.tag=indexPath.section*100+indexPath.row;
            cell.nameLable.text=NSLocalizedString(@"Contact name", nil);
            
            if ([_otherDic objectForKey:@"alias"]) {
                cell.name_inputField.text=[_otherDic objectForKey:@"alias"];
                           }
            else
            {
                cell.name_inputField.text=@"";
            }
            
            if ([_pubOfferMD.user_info[@"alias"] isEqualToString:@""]) {
                cell.name_inputField.userInteractionEnabled=YES;
            }
            else
            {
                cell.name_inputField.userInteractionEnabled=NO;

            }
            
            
            cell.name_inputField.delegate=self;
            cell.name_inputField.tag=cell.tag;
        }
        if (indexPath.row==1) {
            cell.nameLable.hidden=NO;
            cell.tag=indexPath.section*100+indexPath.row;
            cell.nameLable.text=NSLocalizedString(@"Contact No.", nil);
            if ([_otherDic objectForKey:@"mobile_phone"]) {
                cell.name_inputField.text=[_otherDic objectForKey:@"mobile_phone"];
                
            }
            else
            {
                cell.name_inputField.text=@"";
            }
            
            if ([_pubOfferMD.user_info[@"mobile_phone"] isEqualToString:@""]) {
                
                cell.name_inputField.userInteractionEnabled=YES;
            }
            else
            {
                cell.name_inputField.userInteractionEnabled=NO;

            }
            
            cell.name_inputField.delegate=self;
            cell.name_inputField.tag=cell.tag;
        }
        return cell;
        
    }
            else
            {
                static NSString *cellName = @"XuanZeTuPianCell";
                XuanZeTuPianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                if(cell == nil){
                    
                    cell = [[XuanZeTuPianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                }
                cell.backgroundColor=[UIColor whiteColor];
                cell.delegate=self;
                cell.imageViewArray=_imageViewArray;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        
        else //整柜
        {
            if (_pingGui_goodsArr.count==2) {
                if (indexPath.section==0) {
                    static NSString * const cellID = @"sixSelectBtnCell";
                    sixSelectBtnTableViewCell *cell = (sixSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.delegate=self;
                    [cell.firstImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.secondImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.thirdImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.forthImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"5"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.fifthImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"11"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.sixImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"10"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    return cell;
                }

                else if (indexPath.section==1) {
                static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic1 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic1 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic1 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic1 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic1 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }

                else if (indexPath.section==2) {
                   if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                       cell.tag=indexPath.section*100+indexPath.row;
                       cell.inputField.tag=cell.tag;
                       cell.inputField.delegate=self;
                       
                       if ([_dic2 objectForKey:@"spec_1"]&&![[_dic2 objectForKey:@"spec_1"] isEqualToString:@""])  {
                           cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic2 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                       }
                       else
                       {
                           cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                       }

                       if ([_dic2 objectForKey:@"spec_1"]) {
                           cell.inputField.text=[_dic2 objectForKey:@"spec_1"];
                       }
                       
                       else
                       {
                           cell.inputField.text=@"";
                           cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                       }

                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic2 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic2 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }

                else if (indexPath.row==2) {
                    static NSString * const cellID = @"twoSelectBtnCell";
                    twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.text=NSLocalizedString(@"weight", nil);
                    cell.nameLable.hidden=NO;
                    cell.delegate=self;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                    cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                    if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"8"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                    }
                    if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"9"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                    }
                    
                    return cell;
                }
                    
                    else if (indexPath.row==3){
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic2 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic2 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic2 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }

                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }

                    else  {
                        static NSString * const cellID = @"addNew_pinGuiCell";
                        addNew_pinGuiTableViewCell *cell = (addNew_pinGuiTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        [cell.addBtn setTitle:NSLocalizedString(@"Add LCL product", nil) forState:UIControlStateNormal];
                        [cell.addBtn setBackgroundColor:mainColor];
                        cell.addBtn.tag=indexPath.section;
                        cell.delegate=self;
                        return cell;
                    }
                    
                }
                else if (indexPath.section==3) {
                    
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Inventory", nil);
                        cell.nameLable.hidden=NO;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"ctn",nil)];
                        }
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"FCL",nil)];
                        }
                        
                        if ([_otherDic objectForKey:@"goods_number"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"goods_number"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"name_inputCell";
                        name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"Current Location", nil);
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                        cell.name_inputField.userInteractionEnabled=YES;
                        if ([_otherDic objectForKey:@"goods_local"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"goods_local"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        return cell;
                    }
                    
                }
                else if (indexPath.section==4) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"threeSelectBtnCell";
                        threeSelectBtnTableViewCell *cell = (threeSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.delegate=self;
                        cell.nameLable.text=NSLocalizedString(@"Amount", nil);
                        cell.nameLable.hidden=NO;
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"1"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/ctn",nil);
                            }
                            
                        }
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/MT",nil);
                            }
                        }
                        
                        if ([_otherDic objectForKey:@"currency_money"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"currency_money"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        cell.nameLable.hidden=YES;
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Prepayment term", nil);
                        cell.nameLable.hidden=NO;
                        if ([_otherDic objectForKey:@"prepay"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"prepay_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        
                        return cell;
                    }
                    
                }
                else if (indexPath.section==5) {
                    static NSString * const cellID = @"makeImageCell";
                    makeImageTableViewCell *cell = (makeImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.fengMianImage.hidden=NO;
                    if (_fengmianimageViewArray.count>0) {
                        [cell.fengMianImage setImage:[_fengmianimageViewArray objectAtIndex:0]];
                    }
                    else{
                        [cell.fengMianImage setImage:[UIImage imageNamed:@"addTM"]];
                    }
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fengMianImageTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    cell.nameLable.text=NSLocalizedString(@"Cover photo", nil);
                    return cell;
                    
                }
                
                else if (indexPath.section==6) {
                    static NSString * const cellID = @"signTextViewCell";
                    signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.signTextView.hidden=NO;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
            cell.signTextView.PlaceholderLabel.hidden=NO;
                    if ([_otherDic objectForKey:@"goods_txt"]) {
                        cell.signTextView.text=[_otherDic objectForKey:@"goods_txt"];
                        cell.signTextView.PlaceholderLabel.hidden=YES;
                        if ([[_otherDic objectForKey:@"goods_txt"] isEqualToString:@""]) {
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }

                    }
                    else
                    {
                        cell.signTextView.text=@"";
                        cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
            cell.signTextView.PlaceholderLabel.hidden=NO;
                    }
                    
                    cell.signTextView.delegate=self;
                    cell.signTextView.tag=cell.tag;
                    return cell;
                    
                }
                
                else if (indexPath.section==7) {
                    static NSString * const cellID = @"twoSelectBtnCell";
                    twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.nameLable.text=NSLocalizedString(@"Listing?", nil);
                    cell.firstLable.text=NSLocalizedString(@"YES", nil);
                    cell.secondLable.text=NSLocalizedString(@"NO", nil);
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"1"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                    }
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"0"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                    }
                    
                    return cell;
                    
                }
                else if (indexPath.section==8) {
                    static NSString * const cellID = @"name_inputCell";
                    name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    if (indexPath.row==0) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact name", nil);
                        
                        if ([_otherDic objectForKey:@"alias"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"alias"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"alias"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    if (indexPath.row==1) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact No.", nil);
                        if ([_otherDic objectForKey:@"mobile_phone"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"mobile_phone"];
                            
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"mobile_phone"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    return cell;
                    
                }
                else
                {
                    static NSString *cellName = @"XuanZeTuPianCell";
                    XuanZeTuPianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                    if(cell == nil){
                        
                        cell = [[XuanZeTuPianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    }
                    cell.backgroundColor=[UIColor whiteColor];
                    cell.delegate=self;
                    cell.imageViewArray=_imageViewArray;
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
            else  if (_pingGui_goodsArr.count==4) {
                if (indexPath.section==0) {
                    static NSString * const cellID = @"sixSelectBtnCell";
                    sixSelectBtnTableViewCell *cell = (sixSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.delegate=self;
                    [cell.firstImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.secondImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.thirdImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.forthImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"5"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.fifthImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"11"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.sixImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"10"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    return cell;
                }
                
                else if (indexPath.section==1) {
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic1 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic1 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic1 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic1 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic1 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }

                else if (indexPath.section==2)   {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        if ([_dic2 objectForKey:@"spec_1"]&&![[_dic2 objectForKey:@"spec_1"] isEqualToString:@""])  {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic2 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                        }
                        else
                        {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                        }
                        
                        if ([_dic2 objectForKey:@"spec_1"]) {
                            cell.inputField.text=[_dic2 objectForKey:@"spec_1"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic2 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic2 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"twoSelectBtnCell";
                        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.text=NSLocalizedString(@"weight", nil);
                        cell.nameLable.hidden=NO;
                        cell.delegate=self;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                        cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                        if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"8"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"9"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    
                    else if (indexPath.row==3){
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic2 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic2 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic2 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }

                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }
                    
                    else  {
                        //不会到这
                        static NSString * const cellID = @"addNew_pinGuiCell";
                        addNew_pinGuiTableViewCell *cell = (addNew_pinGuiTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        [cell.addBtn setTitle:NSLocalizedString(@"Add LCL product", nil) forState:UIControlStateNormal];
                        [cell.addBtn setBackgroundColor:mainColor];
                        cell.addBtn.tag=indexPath.section;
                        cell.delegate=self;
                        return cell;
                    }
                    
                }
                

                else if (indexPath.section==3) {
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic3 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic3 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic3 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic3 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic3 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }

                else if (indexPath.section==4) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                       
                        if ([_dic4 objectForKey:@"spec_1"]&&![[_dic4 objectForKey:@"spec_1"] isEqualToString:@""])  {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic4 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                        }
                        else
                        {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                        }
                        
                        if ([_dic4 objectForKey:@"spec_1"]) {
                            cell.inputField.text=[_dic4 objectForKey:@"spec_1"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic4 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic4 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"twoSelectBtnCell";
                        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.text=NSLocalizedString(@"weight", nil);
                        cell.nameLable.hidden=NO;
                        cell.delegate=self;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                        cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                        if ([[_dic4 objectForKey:@"pack"] isEqualToString:@"8"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_dic4 objectForKey:@"pack"] isEqualToString:@"9"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    
                    else if (indexPath.row==3){
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic4 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic4 objectForKey:@"spec_txt"];
                             cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic4 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }
                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"addOrDeleteNew_pingGuiCell";
                        addOrDeleteNew_pingGuiTableViewCell *cell = (addOrDeleteNew_pingGuiTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.addBtn.tag=indexPath.section;
                        cell.deleteBtn.tag=indexPath.section+100;
                        cell.delegate=self;
                        return cell;
                    }
                    
                }
                else if (indexPath.section==5) {
                    
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Inventory", nil);
                        cell.nameLable.hidden=NO;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"ctn",nil)];
                        }
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"FCL",nil)];
                        }
                        
                        if ([_otherDic objectForKey:@"goods_number"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"goods_number"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"name_inputCell";
                        name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"Current Location", nil);
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                        cell.name_inputField.userInteractionEnabled=YES;
                        if ([_otherDic objectForKey:@"goods_local"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"goods_local"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        return cell;
                    }
                    
                }
                else if (indexPath.section==6) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"threeSelectBtnCell";
                        threeSelectBtnTableViewCell *cell = (threeSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.delegate=self;
                        cell.nameLable.text=NSLocalizedString(@"Amount", nil);
                        cell.nameLable.hidden=NO;
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"1"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/ctn",nil);
                            }
                            
                        }
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/MT",nil);
                            }
                        }
                        if ([_otherDic objectForKey:@"currency_money"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"currency_money"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        cell.nameLable.hidden=YES;
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Prepayment term", nil);
                        cell.nameLable.hidden=NO;
                        if ([_otherDic objectForKey:@"prepay"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"prepay_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        
                        return cell;
                    }
                    
                }
                else if (indexPath.section==7) {
                    static NSString * const cellID = @"makeImageCell";
                    makeImageTableViewCell *cell = (makeImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.fengMianImage.hidden=NO;
                    if (_fengmianimageViewArray.count>0) {
                        [cell.fengMianImage setImage:[_fengmianimageViewArray objectAtIndex:0]];
                    }
                    else{
                        [cell.fengMianImage setImage:[UIImage imageNamed:@"addTM"]];
                    }
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fengMianImageTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    cell.nameLable.text=NSLocalizedString(@"Cover photo", nil);
                    return cell;
                    
                }
                
                else if (indexPath.section==8) {
                    static NSString * const cellID = @"signTextViewCell";
                    signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.signTextView.hidden=NO;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
            cell.signTextView.PlaceholderLabel.hidden=NO;
                    if ([_otherDic objectForKey:@"goods_txt"]) {
                        cell.signTextView.text=[_otherDic objectForKey:@"goods_txt"];
                        cell.signTextView.PlaceholderLabel.hidden=YES;
                        if ([[_otherDic objectForKey:@"goods_txt"] isEqualToString:@""]) {
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }

                    }
                    else
                    {
                        cell.signTextView.text=@"";
                        cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
            cell.signTextView.PlaceholderLabel.hidden=NO;
                    }
                    
                    cell.signTextView.delegate=self;
                    cell.signTextView.tag=cell.tag;
                    return cell;
                    
                }
                
                else if (indexPath.section==9) {
                    static NSString * const cellID = @"twoSelectBtnCell";
                    twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.nameLable.text=NSLocalizedString(@"Listing?", nil);
                    cell.firstLable.text=NSLocalizedString(@"YES", nil);
                    cell.secondLable.text=NSLocalizedString(@"NO", nil);
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"1"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                    }
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"0"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                    }
                    
                    return cell;
                    
                }
                else if (indexPath.section==10) {
                    static NSString * const cellID = @"name_inputCell";
                    name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    if (indexPath.row==0) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact name", nil);
                        
                        if ([_otherDic objectForKey:@"alias"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"alias"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"alias"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    if (indexPath.row==1) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact No.", nil);
                        if ([_otherDic objectForKey:@"mobile_phone"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"mobile_phone"];
                            
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"mobile_phone"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    return cell;
                    
                }
                else
                {
                    static NSString *cellName = @"XuanZeTuPianCell";
                    XuanZeTuPianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                    if(cell == nil){
                        
                        cell = [[XuanZeTuPianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    }
                    cell.backgroundColor=[UIColor whiteColor];
                    cell.delegate=self;
                    cell.imageViewArray=_imageViewArray;
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                }

            }
            else
            {
                if (indexPath.section==0) {
                    static NSString * const cellID = @"sixSelectBtnCell";
                    sixSelectBtnTableViewCell *cell = (sixSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.delegate=self;
                    [cell.firstImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.secondImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.thirdImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.forthImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"5"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.fifthImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"11"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.sixImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"10"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    return cell;
                }
                
                else if (indexPath.section==1) {
                    
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic1 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic1 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic1 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic1 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic1 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }
                
                else if (indexPath.section==2)   {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        if ([_dic2 objectForKey:@"spec_1"]&&![[_dic2 objectForKey:@"spec_1"] isEqualToString:@""])  {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic2 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                        }
                        else
                        {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                        }
                        
                        if ([_dic2 objectForKey:@"spec_1"]) {
                            cell.inputField.text=[_dic2 objectForKey:@"spec_1"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic2 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic2 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"twoSelectBtnCell";
                        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.text=NSLocalizedString(@"weight", nil);
                        cell.nameLable.hidden=NO;
                        cell.delegate=self;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                        cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                        if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"8"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"9"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    
                    else if (indexPath.row==3){
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic2 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic2 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic2 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }

                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }
                    
                    else  {
                        //不会到这
                        static NSString * const cellID = @"addNew_pinGuiCell";
                        addNew_pinGuiTableViewCell *cell = (addNew_pinGuiTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        [cell.addBtn setTitle:NSLocalizedString(@"Add LCL product", nil) forState:UIControlStateNormal];
                        [cell.addBtn setBackgroundColor:mainColor];
                        cell.addBtn.tag=indexPath.section;
                        cell.delegate=self;
                        return cell;
                    }
                    
                }
                else if (indexPath.section==3) {
                    
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic3 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic3 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic3 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic3 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic3 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }
                else if (indexPath.section==4) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                       
                        if ([_dic4 objectForKey:@"spec_1"]&&![[_dic4 objectForKey:@"spec_1"] isEqualToString:@""])  {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic4 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                        }
                        else
                        {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                        }
                        
                        if ([_dic4 objectForKey:@"spec_1"]) {
                            cell.inputField.text=[_dic4 objectForKey:@"spec_1"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic4 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic4 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"twoSelectBtnCell";
                        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.text=NSLocalizedString(@"weight", nil);
                        cell.nameLable.hidden=NO;
                        cell.delegate=self;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                        cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                        if ([[_dic4 objectForKey:@"pack"] isEqualToString:@"8"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_dic4 objectForKey:@"pack"] isEqualToString:@"9"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    
                    else if (indexPath.row==3){
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic4 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic4 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic4 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }

                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }

                else  {
                        //改成只能删
                        static NSString * const cellID = @"addNew_pinGuiCell";
                        addNew_pinGuiTableViewCell *cell = (addNew_pinGuiTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        [cell.addBtn setTitle:NSLocalizedString(@"Delete this product", nil) forState:UIControlStateNormal];
                        [cell.addBtn setBackgroundColor:[UIColor lightGrayColor]];
                        cell.addBtn.tag=indexPath.section;
                        cell.delegate=self;
                        return cell;
                    }
                    
                }
                else if (indexPath.section==5) {
                    
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic5 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic5 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic5 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic5 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic5 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic5 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic5 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic5 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic5 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic5 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }
                else if (indexPath.section==6) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                       
                        if ([_dic6 objectForKey:@"spec_1"]&&![[_dic6 objectForKey:@"spec_1"] isEqualToString:@""])  {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic6 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                        }
                        else
                        {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                        }
                        
                        if ([_dic6 objectForKey:@"spec_1"]) {
                            cell.inputField.text=[_dic6 objectForKey:@"spec_1"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic6 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic6 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"twoSelectBtnCell";
                        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.text=NSLocalizedString(@"weight", nil);
                        cell.nameLable.hidden=NO;
                        cell.delegate=self;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                        cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                        if ([[_dic6 objectForKey:@"pack"] isEqualToString:@"8"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_dic6 objectForKey:@"pack"] isEqualToString:@"9"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    
                    else if (indexPath.row==3){
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic6 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic6 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic6 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }
                            
                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }
                    
                    else  {
                        //改成只能删
                        static NSString * const cellID = @"addNew_pinGuiCell";
                        addNew_pinGuiTableViewCell *cell = (addNew_pinGuiTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        [cell.addBtn setTitle:NSLocalizedString(@"Delete this product", nil) forState:UIControlStateNormal];
                        [cell.addBtn setBackgroundColor:[UIColor lightGrayColor]];
                        cell.addBtn.tag=indexPath.section;
                        cell.delegate=self;
                        return cell;
                    }
                    
                }
                else if (indexPath.section==7) {
                    
                    //这里
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Inventory", nil);
                        cell.nameLable.hidden=NO;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"ctn",nil)];
                        }
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"FCL",nil)];
                        }
                        
                        if ([_otherDic objectForKey:@"goods_number"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"goods_number"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"name_inputCell";
                        name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"Current Location", nil);
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                        cell.name_inputField.userInteractionEnabled=YES;
                        if ([_otherDic objectForKey:@"goods_local"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"goods_local"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        return cell;
                    }
                    
                }
                else if (indexPath.section==8) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"threeSelectBtnCell";
                        threeSelectBtnTableViewCell *cell = (threeSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.delegate=self;
                        cell.nameLable.text=NSLocalizedString(@"Amount", nil);
                        cell.nameLable.hidden=NO;
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"1"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/ctn",nil);
                            }
                            
                        }
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/MT",nil);
                            }
                        }
                        
                        if ([_otherDic objectForKey:@"currency_money"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"currency_money"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        cell.nameLable.hidden=YES;
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Prepayment term", nil);
                        cell.nameLable.hidden=NO;
                        if ([_otherDic objectForKey:@"prepay"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"prepay_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        
                        return cell;
                    }
                    
                }
                else if (indexPath.section==9) {
                    static NSString * const cellID = @"makeImageCell";
                    makeImageTableViewCell *cell = (makeImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.fengMianImage.hidden=NO;
                    if (_fengmianimageViewArray.count>0) {
                        [cell.fengMianImage setImage:[_fengmianimageViewArray objectAtIndex:0]];
                    }
                    else{
                        [cell.fengMianImage setImage:[UIImage imageNamed:@"addTM"]];
                    }
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fengMianImageTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    cell.nameLable.text=NSLocalizedString(@"Cover photo", nil);
                    return cell;
                    
                }
                
                else if (indexPath.section==10) {
                    static NSString * const cellID = @"signTextViewCell";
                    signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.signTextView.hidden=NO;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
            cell.signTextView.PlaceholderLabel.hidden=NO;
                    if ([_otherDic objectForKey:@"goods_txt"]) {
                        cell.signTextView.text=[_otherDic objectForKey:@"goods_txt"];
            cell.signTextView.PlaceholderLabel.hidden=YES;
                        if ([[_otherDic objectForKey:@"goods_txt"] isEqualToString:@""]) {
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                    }
                    else
                    {
                        cell.signTextView.text=@"";
                        cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
            cell.signTextView.PlaceholderLabel.hidden=NO;
                    }
                    
                    cell.signTextView.delegate=self;
                    cell.signTextView.tag=cell.tag;
                    return cell;
                    
                }
                
                else if (indexPath.section==11) {
                    static NSString * const cellID = @"twoSelectBtnCell";
                    twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.nameLable.text=NSLocalizedString(@"Listing?", nil);
                    cell.firstLable.text=NSLocalizedString(@"YES", nil);
                    cell.secondLable.text=NSLocalizedString(@"NO", nil);
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"1"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                    }
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"0"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                    }
                    
                    return cell;
                    
                }
                else if (indexPath.section==12) {
                    static NSString * const cellID = @"name_inputCell";
                    name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    if (indexPath.row==0) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact name", nil);
                        
                        if ([_otherDic objectForKey:@"alias"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"alias"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"alias"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    if (indexPath.row==1) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact No.", nil);
                        if ([_otherDic objectForKey:@"mobile_phone"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"mobile_phone"];
                            
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"mobile_phone"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    return cell;
                    
                }
                else
                {
                    static NSString *cellName = @"XuanZeTuPianCell";
                    XuanZeTuPianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                    if(cell == nil){
                        
                        cell = [[XuanZeTuPianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    }
                    cell.backgroundColor=[UIColor whiteColor];
                    cell.delegate=self;
                    cell.imageViewArray=_imageViewArray;
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }

        }
    }
    
    
#pragma qihuo
    else//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (indexPath.section==0) {
                static NSString * const cellID = @"sixSelectBtnCell";
                sixSelectBtnTableViewCell *cell = (sixSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                cell.delegate=self;
                [cell.firstImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                [cell.secondImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                [cell.thirdImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                [cell.forthImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"5"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                [cell.fifthImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"11"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                [cell.sixImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"10"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                return cell;
            }
            else if (indexPath.section==1) {
                
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"Offer type", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"offer_type"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"offer_type_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                         return cell;

                    }
                    else if (indexPath.row==1)
                    {
                        static NSString * const cellID = @"name_inputCell";
                        name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                        cell.name_inputField.userInteractionEnabled=YES;

                        cell.nameLable.text=NSLocalizedString(@"Order No.", nil);
                        if ([_otherDic objectForKey:@"goods_sn"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"goods_sn"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }

                         return cell;
                    }
                   else if (indexPath.row==2) {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"ETA", nil);
                       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                       [cell addGestureRecognizer:tap];
                       
                       cell.tag=indexPath.section*100+indexPath.row;
                       if ([_otherDic objectForKey:@"arrive_date"]) {
                           cell.contentLable.text=[_otherDic objectForKey:@"arrive_date"];
                       }
                       else
                       {
                           cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                       }
                        return cell;
                       
                    }
                   else if (indexPath.row==3) {
                       static NSString * const cellID = @"selectCell";
                       selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                       cell.nameLable.hidden=NO;
                       cell.nameLable.text=NSLocalizedString(@"ETD", nil);
                       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                       [cell addGestureRecognizer:tap];
                       
                       cell.tag=indexPath.section*100+indexPath.row;
                       if ([_otherDic objectForKey:@"lading_date"]) {
                           cell.contentLable.text=[_otherDic objectForKey:@"lading_date"];
                       }
                       else
                       {
                           cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                       }
                        return cell;
                   }
                   else  {
                       static NSString * const cellID = @"selectCell";
                       selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                       cell.nameLable.hidden=NO;
                       cell.nameLable.text=NSLocalizedString(@"port of Arrival", nil);
                       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                       [cell addGestureRecognizer:tap];
                       
                       cell.tag=indexPath.section*100+indexPath.row;
                       if ([_otherDic objectForKey:@"port"]) {
                           cell.contentLable.text=[_otherDic objectForKey:@"port_name"];
                       }
                       else
                       {
                           cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                       }
                        return cell;
                   }
            }
            else if (indexPath.section==2)  {
                static NSString * const cellID = @"selectCell";
                selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                cell.nameLable.hidden=NO;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                [cell addGestureRecognizer:tap];
                
                cell.tag=indexPath.section*100+indexPath.row;
                switch (indexPath.row) {
                    case 0:
                        cell.nameLable.text=NSLocalizedString(@"Country", nil);
                        if ([_dic1 objectForKey:@"region_id"]) {
                            cell.contentLable.text=[_dic1 objectForKey:@"region_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        
                        break;
                    case 1:
                        cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                        if ([_dic1 objectForKey:@"brand_id"]) {
                            cell.contentLable.text=[_dic1 objectForKey:@"brand_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        
                        break;
                    case 2:
                        cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                        if ([_dic1 objectForKey:@"cat_id"]) {
                            cell.contentLable.text=[_dic1 objectForKey:@"cat_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        
                        break;
                    case 3:
                        cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                        if ([_dic1 objectForKey:@"base_id"]) {
                            cell.contentLable.text=[_dic1 objectForKey:@"base_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        
                        break;
                    case 4:
                        cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                        if ([_dic1 objectForKey:@"make_date"]) {
                            cell.contentLable.text=[_dic1 objectForKey:@"make_date"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        
                        break;
                        
                    default:
                        break;
                }
                return cell;
            }
            else if (indexPath.section==3) {
                if (indexPath.row==0) {
                    static NSString * const cellID = @"twoSelectBtnCell";
                    twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    cell.delegate=self;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.text=NSLocalizedString(@"Packing spec", nil);
                    cell.firstLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"ctn",nil)];
                    cell.secondLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"MT",nil)];
                    if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                    }
                    if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                    }
                    
                    return cell;
                    
                }
                else if (indexPath.row==1) {
                    static NSString * const cellID = @"inputCell";
                    inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=YES;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.inputField.delegate=self;
                    cell.inputField.tag=cell.tag;
                    if ([_dic2 objectForKey:@"spec_1"]&&![[_dic2 objectForKey:@"spec_1"] isEqualToString:@""])  {
                        cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic2 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                    }
                    else
                    {
                        cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                    }

                    if ([_dic2 objectForKey:@"spec_1"]) {
                        cell.inputField.text=[_dic2 objectForKey:@"spec_1"];
                    }
                    else
                    {
                        cell.inputField.text=@"";
                           cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                    }
                    return cell;
                }
                else if(indexPath.row==2) {
                    static NSString * const cellID = @"twoSelectBtnCell";
                    twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.text=NSLocalizedString(@"weight", nil);
                    cell.nameLable.hidden=NO;
                    cell.delegate=self;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                    cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                    if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"8"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                    }
                    if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"9"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                    }
                    
                    return cell;
                }
                else {
                    static NSString * const cellID = @"signTextViewCell";
                    signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                    cell.signTextView.delegate=self;
                    if ([_dic2 objectForKey:@"spec_txt"]) {
                        cell.signTextView.text=[_dic2 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                        if ([[_dic2 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }

                    }
                    else
                    {
                        cell.signTextView.text=@"";
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
               cell.signTextView.PlaceholderLabel.hidden=NO;
                    }
                    cell.signTextView.tag=cell.tag;
                    return cell;
                }
                
                
            }
            else if (indexPath.section==4) {
                
                //这里
                static NSString * const cellID = @"inputCell";
                inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                cell.tag=indexPath.section*100+indexPath.row;
                cell.nameLable.text=NSLocalizedString(@"Inventory", nil);
                cell.nameLable.hidden=NO;
                cell.inputField.delegate=self;
                cell.inputField.tag=cell.tag;
                if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                    cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"ctn",nil)];
                }
                if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                    cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"ctn",nil)];
                }
                
                if ([_otherDic objectForKey:@"goods_number"]) {
                    cell.inputField.text=[_otherDic objectForKey:@"goods_number"];
                }
                else
                {
                    cell.inputField.text=@"";
                           cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                }
                
                
                return cell;
                
            }
            else if (indexPath.section==5) {
                if (indexPath.row==0) {
                    static NSString * const cellID = @"threeSelectBtnCell";
                    threeSelectBtnTableViewCell *cell = (threeSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.delegate=self;
                    cell.nameLable.text=NSLocalizedString(@"Amount", nil);
                    cell.nameLable.hidden=NO;
                    if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"1"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                    }
                    if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                    }
                    if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        cell.thirdImage.image=[UIImage imageNamed:@"yes_select"];
                    }
                    
                    return cell;
                }
                else if (indexPath.row==1) {
                    static NSString * const cellID = @"inputCell";
                    inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.inputField.delegate=self;
                    cell.inputField.tag=cell.tag;
                    if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                        if ([[_otherDic objectForKey:@"currency"]
                             isEqualToString:@"1"]) {
                            cell.unitLable.text=NSLocalizedString(@"RMB/ctn",nil);
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                            cell.unitLable.text=NSLocalizedString(@"USD/ctn",nil);
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                            cell.unitLable.text=NSLocalizedString(@"Euro/ctn",nil);
                        }
                        
                    }
                    if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                        if ([[_otherDic objectForKey:@"currency"]
                             isEqualToString:@"1"]) {
                            cell.unitLable.text=NSLocalizedString(@"RMB/MT",nil);
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                            cell.unitLable.text=NSLocalizedString(@"USD/MT",nil);
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                            cell.unitLable.text=NSLocalizedString(@"Euro/MT",nil);
                        }
                    }
                    
                    if ([_otherDic objectForKey:@"currency_money"]) {
                        cell.inputField.text=[_otherDic objectForKey:@"currency_money"];
                    }
                    else
                    {
                        cell.inputField.text=@"";
                           cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                    }
                    
                    cell.nameLable.hidden=YES;
                    return cell;
                }
                else  {
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.text=NSLocalizedString(@"Prepayment term", nil);
                    cell.nameLable.hidden=NO;
                    if ([_otherDic objectForKey:@"prepay"]) {
                        cell.contentLable.text=[_otherDic objectForKey:@"prepay_name"];
                    }
                    else
                    {
                        cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                    }
                    
                    return cell;
                }
                
            }
            else if (indexPath.section==6) {
                static NSString * const cellID = @"makeImageCell";
                makeImageTableViewCell *cell = (makeImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                cell.tag=indexPath.section*100+indexPath.row;
                cell.nameLable.hidden=NO;
                cell.fengMianImage.hidden=NO;
                if (_fengmianimageViewArray.count>0) {
                    [cell.fengMianImage setImage:[_fengmianimageViewArray objectAtIndex:0]];
                }
                else
                {
                 [cell.fengMianImage setImage:[UIImage imageNamed:@"addTM"]];
                }
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fengMianImageTapMethod:)];
                [cell addGestureRecognizer:tap];
                cell.nameLable.text=NSLocalizedString(@"Cover photo", nil);
                return cell;
                
            }
            
            else if (indexPath.section==7) {
                static NSString * const cellID = @"signTextViewCell";
                signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                cell.signTextView.hidden=NO;
                cell.tag=indexPath.section*100+indexPath.row;
                cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
            cell.signTextView.PlaceholderLabel.hidden=NO;
                if ([_otherDic objectForKey:@"goods_txt"]) {
                    cell.signTextView.text=[_otherDic objectForKey:@"goods_txt"];
                    cell.signTextView.PlaceholderLabel.hidden=YES;
                    if ([[_otherDic objectForKey:@"goods_txt"] isEqualToString:@""]) {
                        cell.signTextView.PlaceholderLabel.hidden=NO;
                    }
                }
                else
                {
                    cell.signTextView.text=@"";
                     cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
            cell.signTextView.PlaceholderLabel.hidden=NO;
                }
                
                cell.signTextView.delegate=self;
                cell.signTextView.tag=cell.tag;
                return cell;
                
            }
            
            else if (indexPath.section==8) {
                static NSString * const cellID = @"twoSelectBtnCell";
                twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                cell.tag=indexPath.section*100+indexPath.row;
                cell.nameLable.hidden=NO;
                cell.nameLable.text=NSLocalizedString(@"Listing?", nil);
                cell.firstLable.text=NSLocalizedString(@"YES", nil);
                cell.secondLable.text=NSLocalizedString(@"NO", nil);
                if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"1"]) {
                    cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                    cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                }
                if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"0"]) {
                    cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                    cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                }
                
                return cell;
                
            }
            else if (indexPath.section==9) {
                static NSString * const cellID = @"name_inputCell";
                name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (indexPath.row==0) {
                    cell.nameLable.hidden=NO;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.text=NSLocalizedString(@"Contact name", nil);
                    
                    if ([_otherDic objectForKey:@"alias"]) {
                        cell.name_inputField.text=[_otherDic objectForKey:@"alias"];
                    }
                    else
                    {
                        cell.name_inputField.text=@"";
                    }
                    
                    if ([_pubOfferMD.user_info[@"alias"] isEqualToString:@""]) {
                        cell.name_inputField.userInteractionEnabled=YES;
                    }
                    else
                    {
                        cell.name_inputField.userInteractionEnabled=NO;
                        
                    }
                    
                    
                    cell.name_inputField.delegate=self;
                    cell.name_inputField.tag=cell.tag;
                }
                if (indexPath.row==1) {
                    cell.nameLable.hidden=NO;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.text=NSLocalizedString(@"Contact No.", nil);
                    if ([_otherDic objectForKey:@"mobile_phone"]) {
                        cell.name_inputField.text=[_otherDic objectForKey:@"mobile_phone"];
                        
                    }
                    else
                    {
                        cell.name_inputField.text=@"";
                    }
                    
                    if ([_pubOfferMD.user_info[@"mobile_phone"] isEqualToString:@""]) {
                        cell.name_inputField.userInteractionEnabled=YES;
                    }
                    else
                    {
                        cell.name_inputField.userInteractionEnabled=NO;
                        
                    }
                    
                    cell.name_inputField.delegate=self;
                    cell.name_inputField.tag=cell.tag;
                }
                return cell;
                
            }
            else
            {
                static NSString *cellName = @"XuanZeTuPianCell";
                XuanZeTuPianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                if(cell == nil){
                    
                    cell = [[XuanZeTuPianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                }
                cell.backgroundColor=[UIColor whiteColor];
                cell.delegate=self;
                cell.imageViewArray=_imageViewArray;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        
        else //整柜
        {
            if (_pingGui_goodsArr.count==2) {
                if (indexPath.section==0) {
                    static NSString * const cellID = @"sixSelectBtnCell";
                    sixSelectBtnTableViewCell *cell = (sixSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.delegate=self;
                    [cell.firstImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.secondImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.thirdImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.forthImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"5"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.fifthImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"11"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.sixImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"10"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    return cell;
                }
                else if (indexPath.section==1) {
                    
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"Offer type", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"offer_type"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"offer_type_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                        
                    }
                    else if (indexPath.row==1)
                    {
                        static NSString * const cellID = @"name_inputCell";
                        name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                        cell.name_inputField.userInteractionEnabled=YES;
                        
                        cell.nameLable.text=NSLocalizedString(@"Order No.", nil);
                        if ([_otherDic objectForKey:@"goods_sn"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"goods_sn"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"ETA", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"arrive_date"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"arrive_date"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                        
                    }
                    else if (indexPath.row==3) {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"ETD", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"lading_date"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"lading_date"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"port of Arrival", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"port"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"port_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                    }
                }

                else if (indexPath.section==2) {
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic1 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic1 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic1 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic1 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic1 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }
                
                else if (indexPath.section==3) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        if ([_dic2 objectForKey:@"spec_1"]&&![[_dic2 objectForKey:@"spec_1"] isEqualToString:@""])  {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic2 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                        }
                        else
                        {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                        }
                        
                        if ([_dic2 objectForKey:@"spec_1"]) {
                            cell.inputField.text=[_dic2 objectForKey:@"spec_1"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic2 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic2 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"twoSelectBtnCell";
                        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.text=NSLocalizedString(@"weight", nil);
                        cell.nameLable.hidden=NO;
                        cell.delegate=self;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                        cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                        if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"8"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"9"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    
                    else if (indexPath.row==3){
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                        cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic2 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic2 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic2 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }
                            
                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }
                    
                    else  {
                        static NSString * const cellID = @"addNew_pinGuiCell";
                        addNew_pinGuiTableViewCell *cell = (addNew_pinGuiTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        [cell.addBtn setTitle:NSLocalizedString(@"Add LCL product", nil) forState:UIControlStateNormal];
                        [cell.addBtn setBackgroundColor:mainColor];
                        cell.addBtn.tag=indexPath.section;
                        cell.delegate=self;
                        return cell;
                    }
                    
                }
                else if (indexPath.section==4) {
                    
                   
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Inventory", nil);
                        cell.nameLable.hidden=NO;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                        
                        cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"FCL",nil)];
                        
                        
                        if ([_otherDic objectForKey:@"goods_number"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"goods_number"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        return cell;
                    
                }
                else if (indexPath.section==5) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"threeSelectBtnCell";
                        threeSelectBtnTableViewCell *cell = (threeSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.delegate=self;
                        cell.nameLable.text=NSLocalizedString(@"Amount", nil);
                        cell.nameLable.hidden=NO;
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"1"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/ctn",nil);
                            }
                            
                        }
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/MT",nil);
                            }
                        }
                        if ([_otherDic objectForKey:@"currency_money"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"currency_money"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        cell.nameLable.hidden=YES;
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Prepayment term", nil);
                        cell.nameLable.hidden=NO;
                        if ([_otherDic objectForKey:@"prepay"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"prepay_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        
                        return cell;
                    }
                    
                }
                else if (indexPath.section==6) {
                    static NSString * const cellID = @"makeImageCell";
                    makeImageTableViewCell *cell = (makeImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.fengMianImage.hidden=NO;
                    if (_fengmianimageViewArray.count>0) {
                        [cell.fengMianImage setImage:[_fengmianimageViewArray objectAtIndex:0]];
                    }
                    else{
                        [cell.fengMianImage setImage:[UIImage imageNamed:@"addTM"]];
                    }
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fengMianImageTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    cell.nameLable.text=NSLocalizedString(@"Cover photo", nil);
                    return cell;
                    
                }
                
                else if (indexPath.section==7) {
                    static NSString * const cellID = @"signTextViewCell";
                    signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.signTextView.hidden=NO;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
                    cell.signTextView.PlaceholderLabel.hidden=NO;
                    if ([_otherDic objectForKey:@"goods_txt"]) {
                        cell.signTextView.text=[_otherDic objectForKey:@"goods_txt"];
                        cell.signTextView.PlaceholderLabel.hidden=YES;
                        if ([[_otherDic objectForKey:@"goods_txt"] isEqualToString:@""]) {
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        
                    }
                    else
                    {
                        cell.signTextView.text=@"";
                        cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
                        cell.signTextView.PlaceholderLabel.hidden=NO;
                    }
                    
                    cell.signTextView.delegate=self;
                    cell.signTextView.tag=cell.tag;
                    return cell;
                    
                }
                
                else if (indexPath.section==8) {
                    static NSString * const cellID = @"twoSelectBtnCell";
                    twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.nameLable.text=NSLocalizedString(@"Listing?", nil);
                    cell.firstLable.text=NSLocalizedString(@"YES", nil);
                    cell.secondLable.text=NSLocalizedString(@"NO", nil);
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"1"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                    }
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"0"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                    }
                    
                    return cell;
                    
                }
                else if (indexPath.section==9) {
                    static NSString * const cellID = @"name_inputCell";
                    name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    if (indexPath.row==0) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact name", nil);
                        
                        if ([_otherDic objectForKey:@"alias"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"alias"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"alias"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    if (indexPath.row==1) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact No.", nil);
                        if ([_otherDic objectForKey:@"mobile_phone"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"mobile_phone"];
                            
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"mobile_phone"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    return cell;
                    
                }
                else
                {
                    static NSString *cellName = @"XuanZeTuPianCell";
                    XuanZeTuPianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                    if(cell == nil){
                        
                        cell = [[XuanZeTuPianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    }
                    cell.backgroundColor=[UIColor whiteColor];
                    cell.delegate=self;
                    cell.imageViewArray=_imageViewArray;
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
            else  if (_pingGui_goodsArr.count==4) {
                if (indexPath.section==0) {
                    static NSString * const cellID = @"sixSelectBtnCell";
                    sixSelectBtnTableViewCell *cell = (sixSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.delegate=self;
                    [cell.firstImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.secondImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.thirdImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.forthImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"5"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.fifthImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"11"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.sixImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"10"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    return cell;
                }
                else if (indexPath.section==1) {
                    
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"Offer type", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"offer_type"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"offer_type_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                        
                    }
                    else if (indexPath.row==1)
                    {
                        static NSString * const cellID = @"name_inputCell";
                        name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                        cell.name_inputField.userInteractionEnabled=YES;
                        
                        cell.nameLable.text=NSLocalizedString(@"Order No.", nil);
                        if ([_otherDic objectForKey:@"goods_sn"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"goods_sn"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"ETA", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"arrive_date"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"arrive_date"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                        
                    }
                    else if (indexPath.row==3) {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"ETD", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"lading_date"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"lading_date"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"port of Arrival", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"port"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"port_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                    }
                }
                
                else if (indexPath.section==2) {
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic1 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic1 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic1 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic1 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic1 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }
                else if (indexPath.section==3) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        if ([_dic2 objectForKey:@"spec_1"]&&![[_dic2 objectForKey:@"spec_1"] isEqualToString:@""])  {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic2 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                        }
                        else
                        {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                        }
                        
                        if ([_dic2 objectForKey:@"spec_1"]) {
                            cell.inputField.text=[_dic2 objectForKey:@"spec_1"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic2 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic2 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"twoSelectBtnCell";
                        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.text=NSLocalizedString(@"weight", nil);
                        cell.nameLable.hidden=NO;
                        cell.delegate=self;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                        cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                        if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"8"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"9"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    
                    else {
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                        cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic2 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic2 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic2 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }
                            
                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }
                    
                }
                else if (indexPath.section==4) {
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic3 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic3 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic3 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic3 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic3 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }
                else if (indexPath.section==5) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        if ([_dic4 objectForKey:@"spec_1"]&&![[_dic4 objectForKey:@"spec_1"] isEqualToString:@""])  {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic4 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                        }
                        else
                        {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                        }
                        
                        if ([_dic4 objectForKey:@"spec_1"]) {
                            cell.inputField.text=[_dic4 objectForKey:@"spec_1"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic4 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic4 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"twoSelectBtnCell";
                        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.text=NSLocalizedString(@"weight", nil);
                        cell.nameLable.hidden=NO;
                        cell.delegate=self;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                        cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                        if ([[_dic4 objectForKey:@"pack"] isEqualToString:@"8"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_dic4 objectForKey:@"pack"] isEqualToString:@"9"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    
                    else if(indexPath.row==3) {
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                        cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic4 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic4 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic4 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }
                            
                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }
                    
                    else  {
                        static NSString * const cellID = @"addOrDeleteNew_pingGuiCell";
                        addOrDeleteNew_pingGuiTableViewCell *cell = (addOrDeleteNew_pingGuiTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.addBtn.tag=indexPath.section;
                        cell.deleteBtn.tag=indexPath.section+100;
                        cell.delegate=self;
                        return cell;
                    }
                    
                }
                else if (indexPath.section==6) {
                    
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Inventory", nil);
                        cell.nameLable.hidden=NO;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                        
                        cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"FCL",nil)];
                        
                        
                        if ([_otherDic objectForKey:@"goods_number"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"goods_number"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        
                        return cell;
                    
                }
                else if (indexPath.section==7) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"threeSelectBtnCell";
                        threeSelectBtnTableViewCell *cell = (threeSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.delegate=self;
                        cell.nameLable.text=NSLocalizedString(@"Amount", nil);
                        cell.nameLable.hidden=NO;
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"1"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/ctn",nil);
                            }
                            
                        }
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/MT",nil);
                            }
                        }
                        if ([_otherDic objectForKey:@"currency_money"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"currency_money"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        cell.nameLable.hidden=YES;
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Prepayment term", nil);
                        cell.nameLable.hidden=NO;
                        if ([_otherDic objectForKey:@"prepay"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"prepay_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        
                        return cell;
                    }
                    
                }
                else if (indexPath.section==8) {
                    static NSString * const cellID = @"makeImageCell";
                    makeImageTableViewCell *cell = (makeImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.fengMianImage.hidden=NO;
                    if (_fengmianimageViewArray.count>0) {
                        [cell.fengMianImage setImage:[_fengmianimageViewArray objectAtIndex:0]];
                    }
                    else{
                        [cell.fengMianImage setImage:[UIImage imageNamed:@"addTM"]];
                    }
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fengMianImageTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    cell.nameLable.text=NSLocalizedString(@"Cover photo", nil);
                    return cell;
                    
                }
                
                else if (indexPath.section==9) {
                    static NSString * const cellID = @"signTextViewCell";
                    signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.signTextView.hidden=NO;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
                    cell.signTextView.PlaceholderLabel.hidden=NO;
                    if ([_otherDic objectForKey:@"goods_txt"]) {
                        cell.signTextView.text=[_otherDic objectForKey:@"goods_txt"];
                        cell.signTextView.PlaceholderLabel.hidden=YES;
                        if ([[_otherDic objectForKey:@"goods_txt"] isEqualToString:@""]) {
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        
                    }
                    else
                    {
                        cell.signTextView.text=@"";
                        cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
                        cell.signTextView.PlaceholderLabel.hidden=NO;
                    }
                    
                    cell.signTextView.delegate=self;
                    cell.signTextView.tag=cell.tag;
                    return cell;
                    
                }
                
                else if (indexPath.section==10) {
                    static NSString * const cellID = @"twoSelectBtnCell";
                    twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.nameLable.text=NSLocalizedString(@"Listing?", nil);
                    cell.firstLable.text=NSLocalizedString(@"YES", nil);
                    cell.secondLable.text=NSLocalizedString(@"NO", nil);
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"1"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                    }
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"0"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                    }
                    
                    return cell;
                    
                }
                else if (indexPath.section==11) {
                    static NSString * const cellID = @"name_inputCell";
                    name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    if (indexPath.row==0) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact name", nil);
                        
                        if ([_otherDic objectForKey:@"alias"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"alias"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"alias"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    if (indexPath.row==1) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact No.", nil);
                        if ([_otherDic objectForKey:@"mobile_phone"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"mobile_phone"];
                            
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"mobile_phone"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    return cell;
                    
                }
                else
                {
                    static NSString *cellName = @"XuanZeTuPianCell";
                    XuanZeTuPianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                    if(cell == nil){
                        
                        cell = [[XuanZeTuPianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    }
                    cell.backgroundColor=[UIColor whiteColor];
                    cell.delegate=self;
                    cell.imageViewArray=_imageViewArray;
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                }

            }
            else
            {
                if (indexPath.section==0) {
                    static NSString * const cellID = @"sixSelectBtnCell";
                    sixSelectBtnTableViewCell *cell = (sixSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.delegate=self;
                    [cell.firstImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.secondImage setImage:[[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.thirdImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.forthImage setImage:[[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"5"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.fifthImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"11"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    [cell.sixImage setImage:[[_goodsCharacterArr objectAtIndex:2] isEqualToString:@"10"]?[UIImage imageNamed:@"yes_select"]:[UIImage imageNamed:@"no_select"]];
                    return cell;
                }
                else if (indexPath.section==1) {
                    
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"Offer type", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"offer_type"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"offer_type_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                        
                    }
                    else if (indexPath.row==1)
                    {
                        static NSString * const cellID = @"name_inputCell";
                        name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                        cell.name_inputField.userInteractionEnabled=YES;
                        
                        cell.nameLable.text=NSLocalizedString(@"Order No.", nil);
                        if ([_otherDic objectForKey:@"goods_sn"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"goods_sn"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"ETA", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"arrive_date"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"arrive_date"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                        
                    }
                    else if (indexPath.row==3) {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"ETD", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"lading_date"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"lading_date"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=NO;
                        cell.nameLable.text=NSLocalizedString(@"port of Arrival", nil);
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        if ([_otherDic objectForKey:@"port"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"port_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        return cell;
                    }
                }
                
                else if (indexPath.section==2) {
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic1 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic1 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic1 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic1 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic1 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic1 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }
                else if (indexPath.section==3) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        if ([_dic2 objectForKey:@"spec_1"]&&![[_dic2 objectForKey:@"spec_1"] isEqualToString:@""])  {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic2 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                        }
                        else
                        {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                        }
                        
                        if ([_dic2 objectForKey:@"spec_1"]) {
                            cell.inputField.text=[_dic2 objectForKey:@"spec_1"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic2 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic2 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"twoSelectBtnCell";
                        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.text=NSLocalizedString(@"weight", nil);
                        cell.nameLable.hidden=NO;
                        cell.delegate=self;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                        cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                        if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"8"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_dic2 objectForKey:@"pack"] isEqualToString:@"9"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    
                    else {
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                        cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic2 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic2 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic2 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }
                            
                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }
                    
                }
                else if (indexPath.section==4) {
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic3 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic3 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic3 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic3 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic3 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic3 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }
                else if (indexPath.section==5) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        if ([_dic4 objectForKey:@"spec_1"]&&![[_dic4 objectForKey:@"spec_1"] isEqualToString:@""])  {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic4 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                        }
                        else
                        {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                        }
                        
                        if ([_dic4 objectForKey:@"spec_1"]) {
                            cell.inputField.text=[_dic4 objectForKey:@"spec_1"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic4 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic4 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"twoSelectBtnCell";
                        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.text=NSLocalizedString(@"weight", nil);
                        cell.nameLable.hidden=NO;
                        cell.delegate=self;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                        cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                        if ([[_dic4 objectForKey:@"pack"] isEqualToString:@"8"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_dic4 objectForKey:@"pack"] isEqualToString:@"9"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    
                    else if(indexPath.row==3) {
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                        cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic4 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic4 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic4 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }
                            
                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }
                    else  {
                        //改成删出
                        static NSString * const cellID = @"addNew_pinGuiCell";
                        addNew_pinGuiTableViewCell *cell = (addNew_pinGuiTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        [cell.addBtn setTitle:NSLocalizedString(@"Delete this product", nil) forState:UIControlStateNormal];
                        [cell.addBtn setBackgroundColor:[UIColor lightGrayColor]];
                        cell.addBtn.tag=indexPath.section;
                        cell.delegate=self;
                        return cell;
                    }
                    
                }
                else if (indexPath.section==6) {
                    static NSString * const cellID = @"selectCell";
                    selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.nameLable.hidden=NO;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    
                    cell.tag=indexPath.section*100+indexPath.row;               switch (indexPath.row) {
                        case 0:
                            cell.nameLable.text=NSLocalizedString(@"Country", nil);
                            if ([_dic5 objectForKey:@"region_id"]) {
                                cell.contentLable.text=[_dic5 objectForKey:@"region_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            break;
                        case 1:
                            cell.nameLable.text=NSLocalizedString(@"Plant No.", nil);
                            if ([_dic5 objectForKey:@"brand_id"]) {
                                cell.contentLable.text=[_dic5 objectForKey:@"brand_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 2:
                            cell.nameLable.text=NSLocalizedString(@"Product category", nil);
                            if ([_dic5 objectForKey:@"cat_id"]) {
                                cell.contentLable.text=[_dic5 objectForKey:@"cat_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 3:
                            cell.nameLable.text=NSLocalizedString(@"Product name", nil);
                            if ([_dic5 objectForKey:@"base_id"]) {
                                cell.contentLable.text=[_dic5 objectForKey:@"base_name"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                        case 4:
                            cell.nameLable.text=NSLocalizedString(@"Date of Manufacture", nil);
                            if ([_dic5 objectForKey:@"make_date"]) {
                                cell.contentLable.text=[_dic5 objectForKey:@"make_date"];
                            }
                            else
                            {
                                cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                            }
                            
                            break;
                            
                        default:
                            break;
                    }
                    return cell;
                }
                else if (indexPath.section==7) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        if ([_dic6 objectForKey:@"spec_1"]&&![[_dic6 objectForKey:@"spec_1"] isEqualToString:@""])  {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  %ld%@",NSLocalizedString(@"KG/ctn",nil),1000/[[_dic6 objectForKey:@"spec_1"] integerValue],NSLocalizedString(@"ctn/MT",nil)];
                        }
                        else
                        {
                            cell.unitLable.text=[NSString stringWithFormat:@"%@  0%@",NSLocalizedString(@"KG/ctn",nil),NSLocalizedString(@"ctn/MT",nil)];
                        }
                        
                        if ([_dic6 objectForKey:@"spec_1"]) {
                            cell.inputField.text=[_dic6 objectForKey:@"spec_1"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.hidden=YES;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.tag=cell.tag;
                        cell.inputField.delegate=self;
                        
                        cell.unitLable.text=NSLocalizedString(@"MT/FCL",nil);
                        
                        if ([_dic6 objectForKey:@"spec_3"]) {
                            cell.inputField.text=[_dic6 objectForKey:@"spec_3"];
                        }
                        
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==2) {
                        static NSString * const cellID = @"twoSelectBtnCell";
                        twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.nameLable.text=NSLocalizedString(@"weight", nil);
                        cell.nameLable.hidden=NO;
                        cell.delegate=self;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.firstLable.text=NSLocalizedString(@"Fixed weight", nil);
                        cell.secondLable.text=NSLocalizedString(@"Catch weight", nil);
                        if ([[_dic6 objectForKey:@"pack"] isEqualToString:@"8"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_dic6 objectForKey:@"pack"] isEqualToString:@"9"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    
                    else if(indexPath.row==3) {
                        static NSString * const cellID = @"signTextViewCell";
                        signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                        cell.signTextView.PlaceholderLabel.hidden=NO;
                        cell.signTextView.delegate=self;
                        if ([_dic6 objectForKey:@"spec_txt"]) {
                            cell.signTextView.text=[_dic6 objectForKey:@"spec_txt"];
                            cell.signTextView.PlaceholderLabel.hidden=YES;
                            if ([[_dic6 objectForKey:@"spec_txt"] isEqualToString:@""]) {
                                cell.signTextView.PlaceholderLabel.hidden=NO;
                            }
                            
                        }
                        else
                        {
                            cell.signTextView.text=@"";
                            cell.signTextView.placeholder=NSLocalizedString(@"Product Note", nil);
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        cell.signTextView.tag=cell.tag;                        return cell;
                    }
                    else  {
                        //改成删出
                        static NSString * const cellID = @"addNew_pinGuiCell";
                        addNew_pinGuiTableViewCell *cell = (addNew_pinGuiTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        [cell.addBtn setTitle:NSLocalizedString(@"Delete this product", nil) forState:UIControlStateNormal];
                        [cell.addBtn setBackgroundColor:[UIColor lightGrayColor]];
                        cell.addBtn.tag=indexPath.section;
                        cell.delegate=self;
                        return cell;
                    }
                    
                }
                else if (indexPath.section==8) {
                    
                    
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Inventory", nil);
                        cell.nameLable.hidden=NO;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                    
                        cell.unitLable.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"FCL",nil)];
                    
                        
                        if ([_otherDic objectForKey:@"goods_number"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"goods_number"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        
                        return cell;
                    
                }
                else if (indexPath.section==9) {
                    if (indexPath.row==0) {
                        static NSString * const cellID = @"threeSelectBtnCell";
                        threeSelectBtnTableViewCell *cell = (threeSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.delegate=self;
                        cell.nameLable.text=NSLocalizedString(@"Amount", nil);
                        cell.nameLable.hidden=NO;
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"1"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"no_select"];
                        }
                        if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                            cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                            cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                            cell.thirdImage.image=[UIImage imageNamed:@"yes_select"];
                        }
                        
                        return cell;
                    }
                    else if (indexPath.row==1) {
                        static NSString * const cellID = @"inputCell";
                        inputTableViewCell *cell = (inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.inputField.delegate=self;
                        cell.inputField.tag=cell.tag;
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"1"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/ctn",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/ctn",nil);
                            }
                            
                        }
                        if ([[_dic2 objectForKey:@"shop_price_unit"] isEqualToString:@"0"]) {
                            if ([[_otherDic objectForKey:@"currency"]
                                 isEqualToString:@"1"]) {
                                cell.unitLable.text=NSLocalizedString(@"RMB/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"2"]) {
                                cell.unitLable.text=NSLocalizedString(@"USD/MT",nil);
                            }
                            if ([[_otherDic objectForKey:@"currency"] isEqualToString:@"3"]) {
                                cell.unitLable.text=NSLocalizedString(@"Euro/MT",nil);
                            }
                        }
                        if ([_otherDic objectForKey:@"currency_money"]) {
                            cell.inputField.text=[_otherDic objectForKey:@"currency_money"];
                        }
                        else
                        {
                            cell.inputField.text=@"";
                            cell.inputField.placeholder=NSLocalizedString(@"Please enter", nil);
                        }
                        
                        cell.nameLable.hidden=YES;
                        return cell;
                    }
                    else  {
                        static NSString * const cellID = @"selectCell";
                        selectTableViewCell *cell = (selectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapMethod:)];
                        [cell addGestureRecognizer:tap];
                        
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Prepayment term", nil);
                        cell.nameLable.hidden=NO;
                        if ([_otherDic objectForKey:@"prepay"]) {
                            cell.contentLable.text=[_otherDic objectForKey:@"prepay_name"];
                        }
                        else
                        {
                            cell.contentLable.text=NSLocalizedString(@"Choose", nil);
                        }
                        
                        return cell;
                    }
                    
                }
                else if (indexPath.section==10) {
                    static NSString * const cellID = @"makeImageCell";
                    makeImageTableViewCell *cell = (makeImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.fengMianImage.hidden=NO;
                    if (_fengmianimageViewArray.count>0) {
                        [cell.fengMianImage setImage:[_fengmianimageViewArray objectAtIndex:0]];
                    }
                    else{
                        [cell.fengMianImage setImage:[UIImage imageNamed:@"addTM"]];
                    }
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fengMianImageTapMethod:)];
                    [cell addGestureRecognizer:tap];
                    cell.nameLable.text=NSLocalizedString(@"Cover photo", nil);
                    return cell;
                    
                }
                
                else if (indexPath.section==11) {
                    static NSString * const cellID = @"signTextViewCell";
                    signTextViewTableViewCell *cell = (signTextViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.signTextView.hidden=NO;
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
                    cell.signTextView.PlaceholderLabel.hidden=NO;
                    if ([_otherDic objectForKey:@"goods_txt"]) {
                        cell.signTextView.text=[_otherDic objectForKey:@"goods_txt"];
                        cell.signTextView.PlaceholderLabel.hidden=YES;
                        if ([[_otherDic objectForKey:@"goods_txt"] isEqualToString:@""]) {
                            cell.signTextView.PlaceholderLabel.hidden=NO;
                        }
                        
                    }
                    else
                    {
                        cell.signTextView.text=@"";
                        cell.signTextView.placeholder=NSLocalizedString(@"Note product message", nil);
                        cell.signTextView.PlaceholderLabel.hidden=NO;
                    }
                    
                    cell.signTextView.delegate=self;
                    cell.signTextView.tag=cell.tag;
                    return cell;
                    
                }
                
                else if (indexPath.section==12) {
                    static NSString * const cellID = @"twoSelectBtnCell";
                    twoSelectBtnTableViewCell *cell = (twoSelectBtnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    cell.tag=indexPath.section*100+indexPath.row;
                    cell.nameLable.hidden=NO;
                    cell.nameLable.text=NSLocalizedString(@"Listing?", nil);
                    cell.firstLable.text=NSLocalizedString(@"YES", nil);
                    cell.secondLable.text=NSLocalizedString(@"NO", nil);
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"1"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"yes_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"no_select"];
                    }
                    if ([[_otherDic objectForKey:@"is_on_sale"] isEqualToString:@"0"]) {
                        cell.firstImage.image=[UIImage imageNamed:@"no_select"];
                        cell.secondImage.image=[UIImage imageNamed:@"yes_select"];
                    }
                    
                    return cell;
                    
                }
                else if (indexPath.section==13) {
                    static NSString * const cellID = @"name_inputCell";
                    name_inputTableViewCell *cell = (name_inputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
                    if (indexPath.row==0) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact name", nil);
                        
                        if ([_otherDic objectForKey:@"alias"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"alias"];
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"alias"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    if (indexPath.row==1) {
                        cell.nameLable.hidden=NO;
                        cell.tag=indexPath.section*100+indexPath.row;
                        cell.nameLable.text=NSLocalizedString(@"Contact No.", nil);
                        if ([_otherDic objectForKey:@"mobile_phone"]) {
                            cell.name_inputField.text=[_otherDic objectForKey:@"mobile_phone"];
                            
                        }
                        else
                        {
                            cell.name_inputField.text=@"";
                        }
                        
                        if ([_pubOfferMD.user_info[@"mobile_phone"] isEqualToString:@""]) {
                            cell.name_inputField.userInteractionEnabled=YES;
                        }
                        else
                        {
                            cell.name_inputField.userInteractionEnabled=NO;
                            
                        }
                        
                        cell.name_inputField.delegate=self;
                        cell.name_inputField.tag=cell.tag;
                    }
                    return cell;
                    
                }
                else
                {
                    static NSString *cellName = @"XuanZeTuPianCell";
                    XuanZeTuPianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                    if(cell == nil){
                        
                        cell = [[XuanZeTuPianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    }
                    cell.backgroundColor=[UIColor whiteColor];
                    cell.delegate=self;
                    cell.imageViewArray=_imageViewArray;
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                }

            }
            
        }

    }
    
    //    cell.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -fstffsBtnClickDelegatez

- (void) fstffsClick:(NSInteger)sender
{
    if ([self.if_addOrEditOrCopy isEqualToString:@"2"]) {
        [self.view Message:NSLocalizedString(@"You can't change product type when edit offer", nil) HiddenAfterDelay:1.0];
        return;
    }
    if ([self.if_addOrEditOrCopy isEqualToString:@"3"]) {
        [self.view Message:NSLocalizedString(@"You can't change product type when copy offer", nil) HiddenAfterDelay:1.0];
        return;
    }
    
    debugLog(@"sendererer:%ld",sender);
    switch (sender) {
        case 0:
            [_goodsCharacterArr replaceObjectAtIndex:0 withObject:@"7"];
            if (_pingGui_goodsArr.count==4) {
                [_pingGui_goodsArr removeObjectAtIndex:3];
                [_pingGui_goodsArr removeObjectAtIndex:2];
            }
            if (_pingGui_goodsArr.count==6)
            {
                [_pingGui_goodsArr removeObjectAtIndex:5];
                [_pingGui_goodsArr removeObjectAtIndex:4];
            }
            break;
        case 1:
            [_goodsCharacterArr replaceObjectAtIndex:0 withObject:@"6"];
            if (_pingGui_goodsArr.count==4) {
                [_pingGui_goodsArr removeObjectAtIndex:3];
                [_pingGui_goodsArr removeObjectAtIndex:2];
            }
            if (_pingGui_goodsArr.count==6)
            {
                [_pingGui_goodsArr removeObjectAtIndex:5];
                [_pingGui_goodsArr removeObjectAtIndex:4];
                [_pingGui_goodsArr removeObjectAtIndex:3];
                [_pingGui_goodsArr removeObjectAtIndex:2];
                
            }
            break;
        case 2:
            [_goodsCharacterArr replaceObjectAtIndex:1 withObject:@"4"];
            if (_pingGui_goodsArr.count==4) {
                [_pingGui_goodsArr removeObjectAtIndex:3];
                [_pingGui_goodsArr removeObjectAtIndex:2];
            }
            if (_pingGui_goodsArr.count==6)
            {
                [_pingGui_goodsArr removeObjectAtIndex:5];
                [_pingGui_goodsArr removeObjectAtIndex:4];
            }
            break;
        case 3:
            [_goodsCharacterArr replaceObjectAtIndex:1 withObject:@"5"];
            if (_pingGui_goodsArr.count==4) {
                [_pingGui_goodsArr removeObjectAtIndex:3];
                [_pingGui_goodsArr removeObjectAtIndex:2];
            }
            if (_pingGui_goodsArr.count==6)
            {
                [_pingGui_goodsArr removeObjectAtIndex:5];
                [_pingGui_goodsArr removeObjectAtIndex:4];
            }
            break;
        case 4:
            [_goodsCharacterArr replaceObjectAtIndex:2 withObject:@"11"];
            break;
        case 5:
            [_goodsCharacterArr replaceObjectAtIndex:2 withObject:@"10"];
            break;
            
        default:
            break;
    }
    if (sender<4) {
        _brandListMD=nil;
        _goodsNameListMD=nil;
        _brandListMD1=nil;
        _goodsNameListMD1=nil;
        _brandListMD2=nil;
        _goodsNameListMD2=nil;
        [_pingGui_goodsArr removeAllObjects];
    [_otherDic removeAllObjects];
    [_dic1 removeAllObjects];//用来记录国家厂号信息
    [_dic2 removeAllObjects];
    [_dic3 removeAllObjects];
    [_dic4 removeAllObjects];
    [_dic5 removeAllObjects];
    [_dic6 removeAllObjects];
    [_fengmianimageViewArray removeAllObjects];
    [_imageViewArray removeAllObjects];
    [_data_fengmianimageViewArray removeAllObjects];
    [_data_imageViewArray removeAllObjects];
    
    _dic2[@"shop_price_unit"]=@"0";
    _dic2[@"pack"]=@"8";
    
    _dic4[@"shop_price_unit"]=@"0";
    _dic4[@"pack"]=@"8";
    
    _dic6[@"shop_price_unit"]=@"0";
    _dic6[@"pack"]=@"8";

    [_pingGui_goodsArr addObject:_dic1];
    [_pingGui_goodsArr addObject:_dic2];

    
    _otherDic[@"currency"]=@"1";
    _otherDic[@"is_on_sale"]=@"1";
    if ([_pubOfferMD.user_info[@"alias"] isEqualToString:@""]) {
        
    }
    else
    {
        _otherDic[@"alias"]=_pubOfferMD.user_info[@"alias"] ;
    }
    
    if ([_pubOfferMD.user_info[@"mobile_phone"] isEqualToString:@""]) {
        
    }
    else
    {
    _otherDic[@"mobile_phone"]=_pubOfferMD.user_info[@"mobile_phone"] ;
    }
    }

    [_myTableView reloadData];
}
- (void) fsClick:(NSInteger)sender andcellTag:(NSInteger)celltag
{
    NSInteger  secion=celltag/100;
    NSInteger  row = celltag%100;

    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==2) {
                if (row==0) {
                    if (sender==0) {
                        [_dic2 setObject:@"1" forKey:@"shop_price_unit"];
                    }
                    if (sender==1) {
                        [_dic2 setObject:@"0" forKey:@"shop_price_unit"];
                    }
                }
                
                if (row==2) {
                    if (sender==0) {
                        [_dic2 setObject:@"8" forKey:@"pack"];
                    }
                    if (sender==1) {
                        [_dic2 setObject:@"9" forKey:@"pack"];
                    }
                }

            }
            if (secion==7) {
                if (row==0) {
                    if (sender==0) {
                        [_otherDic setObject:@"1" forKey:@"is_on_sale"];
                    }
                    if (sender==1) {
                        [_otherDic setObject:@"0" forKey:@"is_on_sale"];
                    }
                }
            }

        }
        else
        {
            if ([_pingGui_goodsArr count]==2) {
                if (secion==2) {
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic2 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic2 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }
                if (secion==7) {
                    if (row==0) {
                        if (sender==0) {
                            [_otherDic setObject:@"1" forKey:@"is_on_sale"];
                        }
                        if (sender==1) {
                            [_otherDic setObject:@"0" forKey:@"is_on_sale"];
                        }
                    }
                }

            }
            else if ([_pingGui_goodsArr count]==4) {
                if (secion==2) {
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic2 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic2 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }
                if (secion==4) {
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic4 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic4 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }

                if (secion==9) {
                    if (row==0) {
                        if (sender==0) {
                            [_otherDic setObject:@"1" forKey:@"is_on_sale"];
                        }
                        if (sender==1) {
                            [_otherDic setObject:@"0" forKey:@"is_on_sale"];
                        }
                    }
                }

            }
            else
            {
                if (secion==2) {
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic2 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic2 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }
                if (secion==4) {
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic4 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic4 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }
                if (secion==6) {
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic6 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic6 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }
                
                if (secion==11) {
                    if (row==0) {
                        if (sender==0) {
                            [_otherDic setObject:@"1" forKey:@"is_on_sale"];
                        }
                        if (sender==1) {
                            [_otherDic setObject:@"0" forKey:@"is_on_sale"];
                        }
                    }
                }

            }
        }
        
    }
    
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==3) {
                if (row==0) {
                    if (sender==0) {
                        [_dic2 setObject:@"1" forKey:@"shop_price_unit"];
                    }
                    if (sender==1) {
                        [_dic2 setObject:@"0" forKey:@"shop_price_unit"];
                    }
                }
                
                if (row==2) {
                    if (sender==0) {
                        [_dic2 setObject:@"8" forKey:@"pack"];
                    }
                    if (sender==1) {
                        [_dic2 setObject:@"9" forKey:@"pack"];
                    }
                }
                
            }
        
            if (secion==8) {
                if (row==0) {
                    if (sender==0) {
                        [_otherDic setObject:@"1" forKey:@"is_on_sale"];
                    }
                    if (sender==1) {
                        [_otherDic setObject:@"0" forKey:@"is_on_sale"];
                    }
                }
            }
            

        }
        else
        {
            if ([_pingGui_goodsArr count]==2) {
                if (secion==3) {
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic2 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic2 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }
                
                if (secion==8) {
                    if (row==0) {
                        if (sender==0) {
                            [_otherDic setObject:@"1" forKey:@"is_on_sale"];
                        }
                        if (sender==1) {
                            [_otherDic setObject:@"0" forKey:@"is_on_sale"];
                        }
                    }
                }
                
                
            }
            else if ([_pingGui_goodsArr count]==4)
            {
                if (secion==3) {
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic2 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic2 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }
                if (secion==5) {
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic4 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic4 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }
                if (secion==10) {
                    if (row==0) {
                        if (sender==0) {
                            [_otherDic setObject:@"1" forKey:@"is_on_sale"];
                        }
                        if (sender==1) {
                            [_otherDic setObject:@"0" forKey:@"is_on_sale"];
                        }
                    }
                }
                
                
            }
            else
            {
                if (secion==3) {
                    
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic2 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic2 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }
                if (secion==5) {
                    
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic4 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic4 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }
                if (secion==7) {
                    
                    if (row==2) {
                        if (sender==0) {
                            [_dic6 setObject:@"8" forKey:@"pack"];
                        }
                        if (sender==1) {
                            [_dic6 setObject:@"9" forKey:@"pack"];
                        }
                    }
                    
                }

                if (secion==12) {
                    if (row==0) {
                        if (sender==0) {
                            [_otherDic setObject:@"1" forKey:@"is_on_sale"];
                        }
                        if (sender==1) {
                            [_otherDic setObject:@"0" forKey:@"is_on_sale"];
                        }
                    }
                }
                
                
            }
        }
        
    }

    [_myTableView reloadData];
}
- (void) fstClick:(NSInteger)sender andcellTag:(NSInteger)celltag
{
    NSInteger  secion=celltag/100;
    NSInteger  row = celltag%100;
    
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==4) {
                if (row==0) {
                    if (sender==0) {
                        [_otherDic setObject:@"1" forKey:@"currency"];
                    }
                    if (sender==1) {
                        [_otherDic setObject:@"2" forKey:@"currency"];
                    }
                    if (sender==2) {
                        [_otherDic setObject:@"3" forKey:@"currency"];
                    }
                }
            }
            
        }
        else
        {
            if ([_pingGui_goodsArr count]==2) {
                if (secion==4) {
                    if (row==0) {
                        if (sender==0) {
                            [_otherDic setObject:@"1" forKey:@"currency"];
                        }
                        if (sender==1) {
                            [_otherDic setObject:@"2" forKey:@"currency"];
                        }
                        if (sender==2) {
                            [_otherDic setObject:@"3" forKey:@"currency"];
                        }
                    }
                }
                
            }
            else if ([_pingGui_goodsArr count]==4) {
                if (secion==6) {
                    if (row==0) {
                        if (sender==0) {
                            [_otherDic setObject:@"1" forKey:@"currency"];
                        }
                        if (sender==1) {
                            [_otherDic setObject:@"2" forKey:@"currency"];
                        }
                        if (sender==2) {
                            [_otherDic setObject:@"3" forKey:@"currency"];
                        }
                    }
                }
                
            }
            else
            {
                if (secion==8) {
                    if (row==0) {
                        if (sender==0) {
                            [_otherDic setObject:@"1" forKey:@"currency"];
                        }
                        if (sender==1) {
                            [_otherDic setObject:@"2" forKey:@"currency"];
                        }
                        if (sender==2) {
                            [_otherDic setObject:@"3" forKey:@"currency"];
                        }
                    }
                }
                
            }
        }
    }

    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==5) {
                if (row==0) {
                    if (sender==0) {
                        [_otherDic setObject:@"1" forKey:@"currency"];
                    }
                    if (sender==1) {
                        [_otherDic setObject:@"2" forKey:@"currency"];
                    }
                    if (sender==2) {
                        [_otherDic setObject:@"3" forKey:@"currency"];
                    }
                }
            }
            
        }
        else
        {
            if ([_pingGui_goodsArr count]==2) {
                {
                    if (secion==5) {
                        if (row==0) {
                            if (sender==0) {
                                [_otherDic setObject:@"1" forKey:@"currency"];
                            }
                            if (sender==1) {
                                [_otherDic setObject:@"2" forKey:@"currency"];
                            }
                            if (sender==2) {
                                [_otherDic setObject:@"3" forKey:@"currency"];
                            }
                        }
                    }
                    
                }
            }
            else if ([_pingGui_goodsArr count]==4)
            {
                {
                    if (secion==7) {
                        if (row==0) {
                            if (sender==0) {
                                [_otherDic setObject:@"1" forKey:@"currency"];
                            }
                            if (sender==1) {
                                [_otherDic setObject:@"2" forKey:@"currency"];
                            }
                            if (sender==2) {
                                [_otherDic setObject:@"3" forKey:@"currency"];
                            }
                        }
                    }
                    
                }
            }
            else
            {
                {
                    if (secion==9) {
                        if (row==0) {
                            if (sender==0) {
                                [_otherDic setObject:@"1" forKey:@"currency"];
                            }
                            if (sender==1) {
                                [_otherDic setObject:@"2" forKey:@"currency"];
                            }
                            if (sender==2) {
                                [_otherDic setObject:@"3" forKey:@"currency"];
                            }
                        }
                    }
                    
                }
            }
        }
        
    }
    [_myTableView reloadData];
}

#pragma mark selectCellTapMethod
- (void)selectTapMethod:(UITapGestureRecognizer *)tap
{
    debugLog(@"taptaptapindex:%ld",tap.view.tag);
    NSInteger  secion=tap.view.tag/100;
    NSInteger  row = tap.view.tag%100;
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==1) {
                if (row==0) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==1) {
                    if (_brandListMD.brand_list.count==0) {
                        return;
                    }
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.fid=_dic1[@"region_id"];
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_brandListMD.brand_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==2) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;

                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==3) {
                    if (_goodsNameListMD.goods_name_list.count==0) {
                        return;
                    }

                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.fid=_dic1[@"cat_id"];

                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD.goods_name_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==4) {
                    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                    datePicker.delegate = self;
                    datePicker.tag=tap.view.tag;
                    [datePicker show];
                    datePicker.datePickerMode = PGDatePickerModeDate;

                }

            }
            if (secion==4) {
                if (row==2) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.prepay;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.prepay.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
            }

        }
        else
        {
        if (_pingGui_goodsArr.count==2) {
        
            if (secion==1) {
                if (row==0) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==1) {
                    if (_brandListMD.brand_list.count==0) {
                        return;
                    }
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.fid=_dic1[@"region_id"];
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_brandListMD.brand_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==2) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==3) {
                    if (_goodsNameListMD.goods_name_list.count==0) {
                        return;
                    }
                    
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.fid=_dic1[@"cat_id"];
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD.goods_name_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==4) {
                    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                    datePicker.delegate = self;
                    datePicker.tag=tap.view.tag;
                    [datePicker show];
                    datePicker.datePickerMode = PGDatePickerModeDate;
                    
                }
                
            }
            if (secion==4) {
                if (row==2) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;//可不用
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.prepay;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.prepay.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
            }
        }
        else if (_pingGui_goodsArr.count==4) {
            
            if (secion==1) {
                if (row==0) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==1) {
                    if (_brandListMD.brand_list.count==0) {
                        return;
                    }
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.fid=_dic1[@"region_id"];
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_brandListMD.brand_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==2) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==3) {
                    if (_goodsNameListMD.goods_name_list.count==0) {
                        return;
                    }
                    
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.fid=_dic1[@"cat_id"];
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD.goods_name_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==4) {
                    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                    datePicker.delegate = self;
                    datePicker.tag=tap.view.tag;
                    [datePicker show];
                    datePicker.datePickerMode = PGDatePickerModeDate;
                    
                }
                
            }
            if (secion==3) {
                if (row==0) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==1) {
                    if (_brandListMD1.brand_list.count==0) {
                        return;
                    }
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.fid=_dic3[@"region_id"];
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_brandListMD1.brand_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==2) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==3) {
                    if (_goodsNameListMD1.goods_name_list.count==0) {
                        return;
                    }
                    
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.fid=_dic3[@"cat_id"];
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD1.goods_name_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==4) {
                    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                    datePicker.delegate = self;
                    datePicker.tag=tap.view.tag;
                    [datePicker show];
                    datePicker.datePickerMode = PGDatePickerModeDate;
                    
                }
                
            }

            if (secion==6) {
                if (row==2) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goods_num=_pingGui_goodsArr.count;//可不用
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.prepay;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.prepay.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
            }
            
        }
        else
            {
                if (secion==1) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==1) {
                        if (_brandListMD.brand_list.count==0) {
                            return;
                        }
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic1[@"region_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_brandListMD.brand_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==3) {
                        if (_goodsNameListMD.goods_name_list.count==0) {
                            return;
                        }
                        
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic1[@"cat_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD.goods_name_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==4) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    
                }
                if (secion==3) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==1) {
                        if (_brandListMD1.brand_list.count==0) {
                            return;
                        }
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic3[@"region_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_brandListMD1.brand_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==3) {
                        if (_goodsNameListMD1.goods_name_list.count==0) {
                            return;
                        }
                        
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic3[@"cat_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD1.goods_name_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==4) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    
                }
                if (secion==5) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==1) {
                        if (_brandListMD2.brand_list.count==0) {
                            return;
                        }
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic5[@"region_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_brandListMD2.brand_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==3) {
                        if (_goodsNameListMD2.goods_name_list.count==0) {
                            return;
                        }
                        
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic5[@"cat_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD2.goods_name_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==4) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    
                }
                if (secion==8) {
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;//可不用
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.prepay;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.prepay.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                }

            }
        }
    }

    
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            
            if (secion==1) {
                if (row==0) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.offer_type;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==2) {
                    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                    datePicker.delegate = self;
                    datePicker.tag=tap.view.tag;
                    [datePicker show];
                    datePicker.datePickerMode = PGDatePickerModeDate;
                    
                }
                if (row==3) {
                    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                    datePicker.delegate = self;
                    datePicker.tag=tap.view.tag;
                    [datePicker show];
                    datePicker.datePickerMode = PGDatePickerModeDate;
                    
                }
                if (row==4) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.port;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }

            }
            if (secion==2) {
                if (row==0) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==1) {
                    if (_brandListMD.brand_list.count==0) {
                        return;
                    }
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.fid=_dic1[@"region_id"];

                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_brandListMD.brand_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==2) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==3) {
                    if (_goodsNameListMD.goods_name_list.count==0) {
                        return;
                    }
                    
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.fid=_dic1[@"cat_id"];
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD.goods_name_list;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
                if (row==4) {
                    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                    datePicker.delegate = self;
                    datePicker.tag=tap.view.tag;
                    [datePicker show];
                    datePicker.datePickerMode = PGDatePickerModeDate;
                    
                }
                
            }
            if (secion==5) {
                if (row==2) {
                    TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                    TYDP_selectVC.view.tag=tap.view.tag;
                    TYDP_selectVC.delegate=self;
                    TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                    TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                    TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.prepay;
                    debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.prepay.count);
                    [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                }
            }
            
        }
        else
        {
            if ([_pingGui_goodsArr count]==2) {
                if (secion==1) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.offer_type;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    if (row==3) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    if (row==4) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.port;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    
                }
                if (secion==2) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                         TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==1) {
                        if (_brandListMD.brand_list.count==0) {
                            return;
                        }
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic1[@"region_id"];
                         TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_brandListMD.brand_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                         TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==3) {
                        if (_goodsNameListMD.goods_name_list.count==0) {
                            return;
                        }
                        
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic1[@"cat_id"];
                         TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD.goods_name_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==4) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    
                }
                if (secion==5) {
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                         TYDP_selectVC.goods_num=_pingGui_goodsArr.count;//可不用
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.prepay;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.prepay.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                }


            }
            else if ([_pingGui_goodsArr count]==4)
            {
                if (secion==1) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.offer_type;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    if (row==3) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    if (row==4) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.port;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    
                }
                if (secion==2) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                         TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==1) {
                        if (_brandListMD.brand_list.count==0) {
                            return;
                        }
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic1[@"region_id"];
                         TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_brandListMD.brand_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                         TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==3) {
                        if (_goodsNameListMD.goods_name_list.count==0) {
                            return;
                        }
                        
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic1[@"cat_id"];
                         TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD.goods_name_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==4) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    
                }
                if (secion==4) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==1) {
                        if (_brandListMD1.brand_list.count==0) {
                            return;
                        }
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic3[@"region_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_brandListMD1.brand_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==3) {
                        if (_goodsNameListMD1.goods_name_list.count==0) {
                            return;
                        }
                        
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic3[@"cat_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD1.goods_name_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==4) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    
                }

                if (secion==7) {
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                         TYDP_selectVC.goods_num=_pingGui_goodsArr.count;//可不用
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.prepay;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.prepay.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                }
            }
            else
            {
                if (secion==1) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.offer_type;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    if (row==3) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    if (row==4) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.port;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    
                }
                if (secion==2) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==1) {
                        if (_brandListMD.brand_list.count==0) {
                            return;
                        }
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic1[@"region_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_brandListMD.brand_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==3) {
                        if (_goodsNameListMD.goods_name_list.count==0) {
                            return;
                        }
                        
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic1[@"cat_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD.goods_name_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==4) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    
                }
                if (secion==4) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==1) {
                        if (_brandListMD1.brand_list.count==0) {
                            return;
                        }
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic3[@"region_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_brandListMD1.brand_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==3) {
                        if (_goodsNameListMD1.goods_name_list.count==0) {
                            return;
                        }
                        
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic3[@"cat_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD1.goods_name_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==4) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    
                }
                if (secion==6) {
                    if (row==0) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.site_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==1) {
                        if (_brandListMD2.brand_list.count==0) {
                            return;
                        }
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic5[@"region_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_brandListMD2.brand_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.cat_list;
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==3) {
                        if (_goodsNameListMD2.goods_name_list.count==0) {
                            return;
                        }
                        
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.fid=_dic5[@"cat_id"];
                        TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_goodsNameListMD2.goods_name_list;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.site_list.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                    if (row==4) {
                        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
                        datePicker.delegate = self;
                        datePicker.tag=tap.view.tag;
                        [datePicker show];
                        datePicker.datePickerMode = PGDatePickerModeDate;
                        
                    }
                    
                }

                if (secion==9) {
                    if (row==2) {
                        TYDP_selectViewController *TYDP_selectVC=[TYDP_selectViewController new];
                        TYDP_selectVC.view.tag=tap.view.tag;
                        TYDP_selectVC.delegate=self;
                        TYDP_selectVC.firstFrontSelectedRowNumber=tap.view.tag;
                         TYDP_selectVC.goods_num=_pingGui_goodsArr.count;
                        TYDP_selectVC.goodsCharacterArr=_goodsCharacterArr;
                        TYDP_selectVC.rightSecondAgencyArray=_pubOfferMD.prepay;
                        debugLog(@"_pubOfferMD.site_list:%ld",_pubOfferMD.prepay.count);
                        [self presentViewController:TYDP_selectVC animated:YES completion:nil];
                    }
                }
            }
        }
    }
   
}

#pragma mark UITextFieldDelegateMethod

//- (IBAction)textFieldEditChanged:(UITextField *)textField {
//
//    NSInteger  secion=textField.tag/100;
//    NSInteger  row = textField.tag%100;
//    
//    debugLog(@"textFieldtextField:%@",textField.text);
//    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
//    {
//        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
//        {
//            if (secion==2) {
//                if (row==1) {
//                    [_dic2 setObject:textField.text forKey:@"spec_1"];
//                    [_dic2 setObject:textField.text forKey:@"goods_weight"];
//                }
//            }
//            
//        }
//        else//整柜
//        {
//            if (_pingGui_goodsArr.count==2) {
//                
//                if (secion==2) {
//                    if (row==0) {
//                        [_dic2 setObject:textField.text forKey:@"spec_1"];
//                        //                        [_dic2 setObject:textField.text forKey:@"goods_weight"];
//                    }
//                    
//                }
//                
//            }
//            else if (_pingGui_goodsArr.count==4){
//                if (secion==2) {
//                    if (row==0) {
//                        [_dic2 setObject:textField.text forKey:@"spec_1"];
//                        //                        [_dic2 setObject:textField.text forKey:@"goods_weight"];
//                    }
//                   
//                }
//                if (secion==4) {
//                    if (row==0) {
//                        [_dic4 setObject:textField.text forKey:@"spec_1"];
//                        //                        [_dic4 setObject:textField.text forKey:@"goods_weight"];
//                    }
//                    
//                }
//                
//            }
//            else
//            {
//                if (secion==2) {
//                    if (row==0) {
//                        [_dic2 setObject:textField.text forKey:@"spec_1"];
//                        //                        [_dic2 setObject:textField.text forKey:@"goods_weight"];
//                    }
//                    
//                }
//                
//                if (secion==4) {
//                    if (row==0) {
//                        [_dic4 setObject:textField.text forKey:@"spec_1"];
//                        //                        [_dic4 setObject:textField.text forKey:@"goods_weight"];
//                    }
//                    
//                }
//                
//                if (secion==6) {
//                    if (row==0) {
//                        [_dic6 setObject:textField.text forKey:@"spec_1"];
//                        //                        [_dic6 setObject:textField.text forKey:@"goods_weight"];
//                    }
//                    
//                    
//                }
//        
//            }
//         }
//    }
//    
//    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
//    {
//        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
//        {
//            if (secion==1) {
//                if (row==1) {
//                    [_otherDic setObject:textField.text forKey:@"goods_sn"];
//                }
//            }
//            
//        }
//        else
//        {
//            if ([_pingGui_goodsArr count]==2) {
//               
//                if (secion==3) {
//                    if (row==0) {
//                        [_dic2 setObject:textField.text forKey:@"spec_1"];
//                        //                        [_dic2 setObject:textField.text forKey:@"goods_weight"];
//                    }
//                   
//                }
//                
//        }
//            else if ([_pingGui_goodsArr count]==4)
//            {
//                {
//                    
//                    if (secion==3) {
//                        if (row==0) {
//                            [_dic2 setObject:textField.text forKey:@"spec_1"];
//                            //                            [_dic2 setObject:textField.text forKey:@"goods_weight"];
//                        }
//                        
//                    }
//                    if (secion==5) {
//                        if (row==0) {
//                            [_dic4 setObject:textField.text forKey:@"spec_1"];
//                            //                            [_dic4 setObject:textField.text forKey:@"goods_weight"];
//                        }
//                    }
//                    
//            }
//            }
//            else
//            {
//                {
//                    
//                    if (secion==3) {
//                        if (row==0) {
//                            [_dic2 setObject:textField.text forKey:@"spec_1"];
//                            //                            [_dic2 setObject:textField.text forKey:@"goods_weight"];
//                        }
//                       
//                        
//                    }
//                    if (secion==5) {
//                        if (row==0) {
//                            [_dic4 setObject:textField.text forKey:@"spec_1"];
//                            //                            [_dic4 setObject:textField.text forKey:@"goods_weight"];
//                        }
//                    }
//                    if (secion==7) {
//                        if (row==0) {
//                            [_dic6 setObject:textField.text forKey:@"spec_1"];
//                            //                            [_dic6 setObject:textField.text forKey:@"goods_weight"];
//                        }
//                    }
//                    
//                }
//                
//            }
//        }
//    }
//    [_myTableView reloadData];
//
//}


- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSInteger  secion=textField.tag/100;
    NSInteger  row = textField.tag%100;

    debugLog(@"textFieldtextField:%@",textField.text);
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==2) {
                if (row==1) {
                    [_dic2 setObject:textField.text forKey:@"spec_1"];
                    [_dic2 setObject:textField.text forKey:@"goods_weight"];
                }
            }
            
            if (secion==3) {
                if (row==0) {
                    [_otherDic setObject:textField.text forKey:@"goods_number"];
                }
                if (row==1) {
                    [_otherDic setObject:textField.text forKey:@"goods_local"];
                }
            }
            
            if (secion==4) {
                if (row==1) {
                    [_otherDic setObject:textField.text forKey:@"currency_money"];
                }
            }
            
            if (secion==8) {
                if (row==0) {
                    [_otherDic setObject:textField.text forKey:@"alias"];
                }
                if (row==1) {
                    [_otherDic setObject:textField.text forKey:@"mobile_phone"];
                }
            }
        }
        else//整柜
        {
            if (_pingGui_goodsArr.count==2) {
                
                if (secion==2) {
                    if (row==0) {
                        [_dic2 setObject:textField.text forKey:@"spec_1"];
//                        [_dic2 setObject:textField.text forKey:@"goods_weight"];
                    }
                    if (row==1) {
                        [_dic2 setObject:textField.text forKey:@"spec_3"];
                        [_dic2 setObject:textField.text forKey:@"goods_weight"];
                    }
                }
                
                if (secion==3) {
                    if (row==0) {
                        [_otherDic setObject:textField.text forKey:@"goods_number"];
                    }
                        if (row==1) {
                            [_otherDic setObject:textField.text forKey:@"goods_local"];
                        }
                    
                }
                
                if (secion==4) {
                    if (row==1) {
                        [_otherDic setObject:textField.text forKey:@"currency_money"];
                    }
                }
                
                if (secion==8) {
                    if (row==0) {
                        [_otherDic setObject:textField.text forKey:@"alias"];
                    }
                    if (row==1) {
                        [_otherDic setObject:textField.text forKey:@"mobile_phone"];
                    }
                }
            }
            else if (_pingGui_goodsArr.count==4){
            if (secion==2) {
                    if (row==0) {
                        [_dic2 setObject:textField.text forKey:@"spec_1"];
//                        [_dic2 setObject:textField.text forKey:@"goods_weight"];
                    }
                if (row==1) {
                    [_dic2 setObject:textField.text forKey:@"spec_3"];
                    [_dic2 setObject:textField.text forKey:@"goods_weight"];
                }
                
            }
                if (secion==4) {
                    if (row==0) {
                        [_dic4 setObject:textField.text forKey:@"spec_1"];
//                        [_dic4 setObject:textField.text forKey:@"goods_weight"];
                    }
                    if (row==1) {
                        [_dic4 setObject:textField.text forKey:@"spec_3"];
                        [_dic4 setObject:textField.text forKey:@"goods_weight"];
                    }

                }
                
                if (secion==5) {
                    if (row==0) {
                        [_otherDic setObject:textField.text forKey:@"goods_number"];
                    }
                    if (row==1) {
                        [_otherDic setObject:textField.text forKey:@"goods_local"];
                    }
                }
                
                if (secion==6) {
                    if (row==1) {
                        [_otherDic setObject:textField.text forKey:@"currency_money"];
                    }
                }
                
                if (secion==9) {
                    if (row==0) {
                        [_otherDic setObject:textField.text forKey:@"alias"];
                    }
                    if (row==1) {
                        [_otherDic setObject:textField.text forKey:@"mobile_phone"];
                    }
                }
            }
            else
            {
                if (secion==2) {
                    if (row==0) {
                        [_dic2 setObject:textField.text forKey:@"spec_1"];
//                        [_dic2 setObject:textField.text forKey:@"goods_weight"];
                    }
                    if (row==1) {
                        [_dic2 setObject:textField.text forKey:@"spec_3"];
                        [_dic2 setObject:textField.text forKey:@"goods_weight"];
                    }

                }
                
                if (secion==4) {
                    if (row==0) {
                        [_dic4 setObject:textField.text forKey:@"spec_1"];
//                        [_dic4 setObject:textField.text forKey:@"goods_weight"];
                    }
                    if (row==1) {
                        [_dic4 setObject:textField.text forKey:@"spec_3"];
                        [_dic4 setObject:textField.text forKey:@"goods_weight"];
                    }

                }
                
                if (secion==6) {
                    if (row==0) {
                        [_dic6 setObject:textField.text forKey:@"spec_1"];
//                        [_dic6 setObject:textField.text forKey:@"goods_weight"];
                    }
                    if (row==1) {
                        [_dic6 setObject:textField.text forKey:@"spec_3"];
                        [_dic6 setObject:textField.text forKey:@"goods_weight"];
                    }

                }
                if (secion==7) {
                    if (row==0) {
                        [_otherDic setObject:textField.text forKey:@"goods_number"];
                    }
                    if (row==1) {
                        [_otherDic setObject:textField.text forKey:@"goods_local"];
                    }
                }
                
                if (secion==8) {
                    if (row==1) {
                        [_otherDic setObject:textField.text forKey:@"currency_money"];
                    }
                }
                
                if (secion==11) {
                    if (row==0) {
                        [_otherDic setObject:textField.text forKey:@"alias"];
                    }
                    if (row==1) {
                        [_otherDic setObject:textField.text forKey:@"mobile_phone"];
                    }
                }
            }
        }
    }
    
    
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==1) {
                if (row==1) {
                    [_otherDic setObject:textField.text forKey:@"goods_sn"];
                }
            }
           
            if (secion==3) {
                if (row==1) {
                    [_dic2 setObject:textField.text forKey:@"spec_1"];
                    [_dic2 setObject:textField.text forKey:@"goods_weight"];
                }
            }
            
            if (secion==4) {
                if (row==0) {
                    [_otherDic setObject:textField.text forKey:@"goods_number"];
                }
            }
            
            if (secion==5) {
                if (row==1) {
                    [_otherDic setObject:textField.text forKey:@"currency_money"];
                }
            }
            
            if (secion==9) {
                if (row==0) {
                    [_otherDic setObject:textField.text forKey:@"alias"];
                }
                if (row==1) {
                    [_otherDic setObject:textField.text forKey:@"mobile_phone"];
                }
            }
        }
        else
        {
            if ([_pingGui_goodsArr count]==2) {
                if (secion==1) {
                    if (row==1) {
                        [_otherDic setObject:textField.text forKey:@"goods_sn"];
                    }
                }
                
                if (secion==3) {
                    if (row==0) {
                        [_dic2 setObject:textField.text forKey:@"spec_1"];
//                        [_dic2 setObject:textField.text forKey:@"goods_weight"];
                    }
                    if (row==1) {
                        [_dic2 setObject:textField.text forKey:@"spec_3"];
                        [_dic2 setObject:textField.text forKey:@"goods_weight"];
                    }

                }
                
                if (secion==4) {
                    if (row==0) {
                        [_otherDic setObject:textField.text forKey:@"goods_number"];
                    }
                }
                
                if (secion==5) {
                    if (row==1) {
                        [_otherDic setObject:textField.text forKey:@"currency_money"];
                    }
                }
                
                if (secion==9) {
                    if (row==0) {
                        [_otherDic setObject:textField.text forKey:@"alias"];
                    }
                    if (row==1) {
                        [_otherDic setObject:textField.text forKey:@"mobile_phone"];
                    }
                }
            }
            else if ([_pingGui_goodsArr count]==4)
            {
                {
                    if (secion==1) {
                        if (row==1) {
                            [_otherDic setObject:textField.text forKey:@"goods_sn"];
                        }
                    }
                    
                    if (secion==3) {
                        if (row==0) {
                            [_dic2 setObject:textField.text forKey:@"spec_1"];
//                            [_dic2 setObject:textField.text forKey:@"goods_weight"];
                        }
                        if (row==1) {
                            [_dic2 setObject:textField.text forKey:@"spec_3"];
                            [_dic2 setObject:textField.text forKey:@"goods_weight"];
                        }

                    }
                    if (secion==5) {
                        if (row==0) {
                            [_dic4 setObject:textField.text forKey:@"spec_1"];
//                            [_dic4 setObject:textField.text forKey:@"goods_weight"];
                        }
                        if (row==1) {
                            [_dic4 setObject:textField.text forKey:@"spec_3"];
                            [_dic4 setObject:textField.text forKey:@"goods_weight"];
                        }

                    }
                    
                    if (secion==6) {
                        if (row==0) {
                            [_otherDic setObject:textField.text forKey:@"goods_number"];
                        }
                    }
                    
                    if (secion==7) {
                        if (row==1) {
                            [_otherDic setObject:textField.text forKey:@"currency_money"];
                        }
                    }
                    
                    if (secion==11) {
                        if (row==0) {
                            [_otherDic setObject:textField.text forKey:@"alias"];
                        }
                        if (row==1) {
                            [_otherDic setObject:textField.text forKey:@"mobile_phone"];
                        }
                    }
                }
            }
            else
            {
                {
                    if (secion==1) {
                        if (row==1) {
                            [_otherDic setObject:textField.text forKey:@"goods_sn"];
                        }
                    }
                    
                    if (secion==3) {
                        if (row==0) {
                            [_dic2 setObject:textField.text forKey:@"spec_1"];
//                            [_dic2 setObject:textField.text forKey:@"goods_weight"];
                        }
                        if (row==1) {
                            [_dic2 setObject:textField.text forKey:@"spec_3"];
                            [_dic2 setObject:textField.text forKey:@"goods_weight"];
                        }

                    }
                    if (secion==5) {
                        if (row==0) {
                            [_dic4 setObject:textField.text forKey:@"spec_1"];
//                            [_dic4 setObject:textField.text forKey:@"goods_weight"];
                        }
                        if (row==1) {
                            [_dic4 setObject:textField.text forKey:@"spec_3"];
                            [_dic4 setObject:textField.text forKey:@"goods_weight"];
                        }

                    }
                    if (secion==7) {
                        if (row==0) {
                            [_dic6 setObject:textField.text forKey:@"spec_1"];
//                            [_dic6 setObject:textField.text forKey:@"goods_weight"];
                        }
                        if (row==1) {
                            [_dic6 setObject:textField.text forKey:@"spec_3"];
                            [_dic6 setObject:textField.text forKey:@"goods_weight"];
                        }

                    }
                    
                    if (secion==8) {
                        if (row==0) {
                            [_otherDic setObject:textField.text forKey:@"goods_number"];
                        }
                    }
                    
                    if (secion==9) {
                        if (row==1) {
                            [_otherDic setObject:textField.text forKey:@"currency_money"];
                        }
                    }
                    
                    if (secion==13) {
                        if (row==0) {
                            [_otherDic setObject:textField.text forKey:@"alias"];
                        }
                        if (row==1) {
                            [_otherDic setObject:textField.text forKey:@"mobile_phone"];
                        }
                    }
                }

            }
        }
    }

    [_myTableView reloadData];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSInteger  secion=textView.tag/100;
    NSInteger  row = textView.tag%100;
    debugLog(@"textViewtextView:%@",textView.text);
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==2) {
                if (row==3) {
                    [_dic2 setObject:textView.text forKey:@"spec_txt"];
                }
            }

            
            if (secion==6) {
                if (row==0) {
                    [_otherDic setObject:textView.text forKey:@"goods_txt"];
                }
            }
        }
        else//整柜
        {
            if (_pingGui_goodsArr.count==2) {
                if (secion==2) {
                    if (row==3) {
                        [_dic2 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                
                
                if (secion==6) {
                    if (row==0) {
                        [_otherDic setObject:textView.text forKey:@"goods_txt"];
                    }
                }
            }
            else if (_pingGui_goodsArr.count==4){
                if (secion==2) {
                    if (row==3) {
                        [_dic2 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                if (secion==4) {
                    if (row==3) {
                        [_dic4 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                
                if (secion==8) {
                    if (row==0) {
                        [_otherDic setObject:textView.text forKey:@"goods_txt"];
                    }
                }
            }

            else
            {
                
                if (secion==2) {
                    if (row==3) {
                        [_dic2 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                if (secion==4) {
                    if (row==3) {
                        [_dic4 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                if (secion==6) {
                    if (row==3) {
                        [_dic6 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                if (secion==10) {
                    if (row==0) {
                        [_otherDic setObject:textView.text forKey:@"goods_txt"];
                    }
                }
            }
        }
    }
    
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==3) {
                if (row==3) {
                    [_dic2 setObject:textView.text forKey:@"spec_txt"];
                }
            }
            
            
            if (secion==7) {
                if (row==0) {
                    [_otherDic setObject:textView.text forKey:@"goods_txt"];
                }
            }
        }
        else
        {
            if ([_pingGui_goodsArr count]==2) {
                if (secion==3) {
                    if (row==3) {
                        [_dic2 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                
                
                if (secion==7) {
                    if (row==0) {
                        [_otherDic setObject:textView.text forKey:@"goods_txt"];
                    }
                }
            }
            else if ([_pingGui_goodsArr count]==4)
            {
                if (secion==3) {
                    if (row==3) {
                        [_dic2 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                if (secion==5) {
                    if (row==3) {
                        [_dic4 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                
                if (secion==9) {
                    if (row==0) {
                        [_otherDic setObject:textView.text forKey:@"goods_txt"];
                    }
                }
            }
            else
            {
                if (secion==3) {
                    if (row==3) {
                        [_dic2 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                if (secion==5) {
                    if (row==3) {
                        [_dic4 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                if (secion==7) {
                    if (row==3) {
                        [_dic6 setObject:textView.text forKey:@"spec_txt"];
                    }
                }
                if (secion==11) {
                    if (row==0) {
                        [_otherDic setObject:textView.text forKey:@"goods_txt"];
                    }
                }
            }

        }
    }
    [_myTableView reloadData];
}
#pragma mark selectTitleDelegate
- (void)selectTitleClick:(NSString *)name andId:(NSString *)s_id byTag:(NSInteger)tag
{
    debugLog(@"name:%@--sid:%@--tag:%ld",name,s_id,tag);
    NSInteger  secion=tag/100;
    NSInteger  row = tag%100;
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==1) {
                if (row==0) {
                    [_dic1 setObject:s_id forKey:@"region_id"];
                    [_dic1 setObject:name forKey:@"region_name"];
                    [self getBrandListDataWithNewDic:s_id and:1];

                    [_dic1 removeObjectForKey:@"brand_id"];
                    [_dic1 removeObjectForKey:@"brand_name"];
                }
                if (row==1) {
                    [_dic1 setObject:s_id forKey:@"brand_id"];
                    [_dic1 setObject:name forKey:@"brand_name"];
                    
                }
                if (row==2) {
                    [_dic1 setObject:s_id forKey:@"cat_id"];
                    [_dic1 setObject:name forKey:@"cat_name"];
                    [self getgoodsNameListWithNewDic:s_id and:1];
                    [_dic1 removeObjectForKey:@"base_id"];
                    [_dic1 removeObjectForKey:@"base_name"];
                    
                }
                if (row==3) {
                    [_dic1 setObject:s_id forKey:@"base_id"];
                    [_dic1 setObject:name forKey:@"base_name"];
                    
                }
            }
            if (secion==4) {
                if (row==2) {
                    [_otherDic setObject:s_id forKey:@"prepay"];
                    [_otherDic setObject:name forKey:@"prepay_name"];
                }
            }
        }
        else//整柜
        {
            if (_pingGui_goodsArr.count==2) {
                if (secion==1) {
                    if (row==0) {
                        [_dic1 setObject:s_id forKey:@"region_id"];
                        [_dic1 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:1];
                        
                        [_dic1 removeObjectForKey:@"brand_id"];
                        [_dic1 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic1 setObject:s_id forKey:@"brand_id"];
                        [_dic1 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic1 setObject:s_id forKey:@"cat_id"];
                        [_dic1 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:1];
                        [_dic1 removeObjectForKey:@"base_id"];
                        [_dic1 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic1 setObject:s_id forKey:@"base_id"];
                        [_dic1 setObject:name forKey:@"base_name"];
                        
                    }
                }
                if (secion==4) {
                    if (row==2) {
                        [_otherDic setObject:s_id forKey:@"prepay"];
                        [_otherDic setObject:name forKey:@"prepay_name"];
                    }
                }
            }
            else if (_pingGui_goodsArr.count==4) {
                if (secion==1) {
                    if (row==0) {
                        [_dic1 setObject:s_id forKey:@"region_id"];
                        [_dic1 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:1];
                        
                        [_dic1 removeObjectForKey:@"brand_id"];
                        [_dic1 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic1 setObject:s_id forKey:@"brand_id"];
                        [_dic1 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic1 setObject:s_id forKey:@"cat_id"];
                        [_dic1 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:1];
                        [_dic1 removeObjectForKey:@"base_id"];
                        [_dic1 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic1 setObject:s_id forKey:@"base_id"];
                        [_dic1 setObject:name forKey:@"base_name"];
                        
                    }
                }
                if (secion==3) {
                    if (row==0) {
                        [_dic3 setObject:s_id forKey:@"region_id"];
                        [_dic3 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:2];
                        
                        [_dic3 removeObjectForKey:@"brand_id"];
                        [_dic3 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic3 setObject:s_id forKey:@"brand_id"];
                        [_dic3 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic3 setObject:s_id forKey:@"cat_id"];
                        [_dic3 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:2];
                        [_dic3 removeObjectForKey:@"base_id"];
                        [_dic3 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic3 setObject:s_id forKey:@"base_id"];
                        [_dic3 setObject:name forKey:@"base_name"];
                        
                    }
                }

                if (secion==6) {
                    if (row==2) {
                        [_otherDic setObject:s_id forKey:@"prepay"];
                        [_otherDic setObject:name forKey:@"prepay_name"];
                    }
                }
            }
            else
            {
                if (secion==1) {
                    if (row==0) {
                        [_dic1 setObject:s_id forKey:@"region_id"];
                        [_dic1 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:1];
                        
                        [_dic1 removeObjectForKey:@"brand_id"];
                        [_dic1 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic1 setObject:s_id forKey:@"brand_id"];
                        [_dic1 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic1 setObject:s_id forKey:@"cat_id"];
                        [_dic1 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:1];
                        [_dic1 removeObjectForKey:@"base_id"];
                        [_dic1 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic1 setObject:s_id forKey:@"base_id"];
                        [_dic1 setObject:name forKey:@"base_name"];
                        
                    }
                }
                if (secion==3) {
                    if (row==0) {
                        [_dic3 setObject:s_id forKey:@"region_id"];
                        [_dic3 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:2];
                        
                        [_dic3 removeObjectForKey:@"brand_id"];
                        [_dic3 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic3 setObject:s_id forKey:@"brand_id"];
                        [_dic3 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic3 setObject:s_id forKey:@"cat_id"];
                        [_dic3 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:2];
                        [_dic3 removeObjectForKey:@"base_id"];
                        [_dic3 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic3 setObject:s_id forKey:@"base_id"];
                        [_dic3 setObject:name forKey:@"base_name"];
                        
                    }
                }
                if (secion==5) {
                    if (row==0) {
                        [_dic5 setObject:s_id forKey:@"region_id"];
                        [_dic5 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:3];
                        
                        [_dic5 removeObjectForKey:@"brand_id"];
                        [_dic5 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic5 setObject:s_id forKey:@"brand_id"];
                        [_dic5 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic5 setObject:s_id forKey:@"cat_id"];
                        [_dic5 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:3];
                        [_dic5 removeObjectForKey:@"base_id"];
                        [_dic5 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic5 setObject:s_id forKey:@"base_id"];
                        [_dic5 setObject:name forKey:@"base_name"];
                        
                    }
                }
                if (secion==8) {
                    if (row==2) {
                        [_otherDic setObject:s_id forKey:@"prepay"];
                        [_otherDic setObject:name forKey:@"prepay_name"];
                    }
                }

            }
        }
    }
    
    
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==1) {
                if (row==0) {
                    [_otherDic setObject:s_id forKey:@"offer_type"];
                    [_otherDic setObject:name forKey:@"offer_type_name"];
                }
                if (row==4) {
                    [_otherDic setObject:s_id forKey:@"port"];
                    [_otherDic setObject:name forKey:@"port_name"];
                    
                }
            }
            
            if (secion==2) {
                if (row==0) {
                    [_dic1 setObject:s_id forKey:@"region_id"];
                    [_dic1 setObject:name forKey:@"region_name"];
                    [self getBrandListDataWithNewDic:s_id and:1];
                    
                    [_dic1 removeObjectForKey:@"brand_id"];
                    [_dic1 removeObjectForKey:@"brand_name"];
                }
                if (row==1) {
                    [_dic1 setObject:s_id forKey:@"brand_id"];
                    [_dic1 setObject:name forKey:@"brand_name"];
                    
                }
                if (row==2) {
                    [_dic1 setObject:s_id forKey:@"cat_id"];
                    [_dic1 setObject:name forKey:@"cat_name"];
                    [self getgoodsNameListWithNewDic:s_id and:1];
                    [_dic1 removeObjectForKey:@"base_id"];
                    [_dic1 removeObjectForKey:@"base_name"];
                    
                }
                if (row==3) {
                    [_dic1 setObject:s_id forKey:@"base_id"];
                    [_dic1 setObject:name forKey:@"base_name"];
                    
                }
            }
            if (secion==5) {
                if (row==2) {
                    [_otherDic setObject:s_id forKey:@"prepay"];
                    [_otherDic setObject:name forKey:@"prepay_name"];
                }
            }
        }
        else
        {
            if ([_pingGui_goodsArr count]==2) {
                if (secion==1) {
                    if (row==0) {
                        [_otherDic setObject:s_id forKey:@"offer_type"];
                        [_otherDic setObject:name forKey:@"offer_type_name"];
                    }
                    if (row==4) {
                        [_otherDic setObject:s_id forKey:@"port"];
                        [_otherDic setObject:name forKey:@"port_name"];
                        
                    }
                }
                
                if (secion==2) {
                    if (row==0) {
                        [_dic1 setObject:s_id forKey:@"region_id"];
                        [_dic1 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:1];
                        
                        [_dic1 removeObjectForKey:@"brand_id"];
                        [_dic1 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic1 setObject:s_id forKey:@"brand_id"];
                        [_dic1 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic1 setObject:s_id forKey:@"cat_id"];
                        [_dic1 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:1];
                        [_dic1 removeObjectForKey:@"base_id"];
                        [_dic1 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic1 setObject:s_id forKey:@"base_id"];
                        [_dic1 setObject:name forKey:@"base_name"];
                        
                    }
                }
                if (secion==5) {
                    if (row==2) {
                        [_otherDic setObject:s_id forKey:@"prepay"];
                        [_otherDic setObject:name forKey:@"prepay_name"];
                    }
                }
            }
            else if ([_pingGui_goodsArr count]==4)
            {
                if (secion==1) {
                    if (row==0) {
                        [_otherDic setObject:s_id forKey:@"offer_type"];
                        [_otherDic setObject:name forKey:@"offer_type_name"];
                    }
                    if (row==4) {
                        [_otherDic setObject:s_id forKey:@"port"];
                        [_otherDic setObject:name forKey:@"port_name"];
                        
                    }
                }
                
                if (secion==2) {
                    if (row==0) {
                        [_dic1 setObject:s_id forKey:@"region_id"];
                        [_dic1 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:1];
                        
                        [_dic1 removeObjectForKey:@"brand_id"];
                        [_dic1 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic1 setObject:s_id forKey:@"brand_id"];
                        [_dic1 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic1 setObject:s_id forKey:@"cat_id"];
                        [_dic1 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:1];
                        [_dic1 removeObjectForKey:@"base_id"];
                        [_dic1 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic1 setObject:s_id forKey:@"base_id"];
                        [_dic1 setObject:name forKey:@"base_name"];
                        
                    }
                }
                if (secion==4) {
                    if (row==0) {
                        [_dic3 setObject:s_id forKey:@"region_id"];
                        [_dic3 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:2];
                        
                        [_dic3 removeObjectForKey:@"brand_id"];
                        [_dic3 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic3 setObject:s_id forKey:@"brand_id"];
                        [_dic3 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic3 setObject:s_id forKey:@"cat_id"];
                        [_dic3 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:2];
                        [_dic3 removeObjectForKey:@"base_id"];
                        [_dic3 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic3 setObject:s_id forKey:@"base_id"];
                        [_dic3 setObject:name forKey:@"base_name"];
                        
                    }
                }
                if (secion==7) {
                    if (row==2) {
                        [_otherDic setObject:s_id forKey:@"prepay"];
                        [_otherDic setObject:name forKey:@"prepay_name"];
                    }
                }
            }
            else
            {
                if (secion==1) {
                    if (row==0) {
                        [_otherDic setObject:s_id forKey:@"offer_type"];
                        [_otherDic setObject:name forKey:@"offer_type_name"];
                    }
                    if (row==4) {
                        [_otherDic setObject:s_id forKey:@"port"];
                        [_otherDic setObject:name forKey:@"port_name"];
                        
                    }
                }
                
                if (secion==2) {
                    if (row==0) {
                        [_dic1 setObject:s_id forKey:@"region_id"];
                        [_dic1 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:1];
                        
                        [_dic1 removeObjectForKey:@"brand_id"];
                        [_dic1 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic1 setObject:s_id forKey:@"brand_id"];
                        [_dic1 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic1 setObject:s_id forKey:@"cat_id"];
                        [_dic1 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:1];
                        [_dic1 removeObjectForKey:@"base_id"];
                        [_dic1 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic1 setObject:s_id forKey:@"base_id"];
                        [_dic1 setObject:name forKey:@"base_name"];
                        
                    }
                }
                if (secion==4) {
                    if (row==0) {
                        [_dic3 setObject:s_id forKey:@"region_id"];
                        [_dic3 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:2];
                        
                        [_dic3 removeObjectForKey:@"brand_id"];
                        [_dic3 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic3 setObject:s_id forKey:@"brand_id"];
                        [_dic3 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic3 setObject:s_id forKey:@"cat_id"];
                        [_dic3 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:2];
                        [_dic3 removeObjectForKey:@"base_id"];
                        [_dic3 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic3 setObject:s_id forKey:@"base_id"];
                        [_dic3 setObject:name forKey:@"base_name"];
                        
                    }
                }
                if (secion==6) {
                    if (row==0) {
                        [_dic5 setObject:s_id forKey:@"region_id"];
                        [_dic5 setObject:name forKey:@"region_name"];
                        [self getBrandListDataWithNewDic:s_id and:3];
                        
                        [_dic5 removeObjectForKey:@"brand_id"];
                        [_dic5 removeObjectForKey:@"brand_name"];
                    }
                    if (row==1) {
                        [_dic5 setObject:s_id forKey:@"brand_id"];
                        [_dic5 setObject:name forKey:@"brand_name"];
                        
                    }
                    if (row==2) {
                        [_dic5 setObject:s_id forKey:@"cat_id"];
                        [_dic5 setObject:name forKey:@"cat_name"];
                        [self getgoodsNameListWithNewDic:s_id and:3];
                        [_dic5 removeObjectForKey:@"base_id"];
                        [_dic5 removeObjectForKey:@"base_name"];
                        
                    }
                    if (row==3) {
                        [_dic5 setObject:s_id forKey:@"base_id"];
                        [_dic5 setObject:name forKey:@"base_name"];
                        
                    }
                }
                if (secion==9) {
                    if (row==2) {
                        [_otherDic setObject:s_id forKey:@"prepay"];
                        [_otherDic setObject:name forKey:@"prepay_name"];
                    }
                }
            }
        }
    }

    
    
    [_myTableView reloadData];

}
    
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    
    NSInteger  secion=datePicker.tag/100;
    NSInteger  row = datePicker.tag%100;
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==1&&row==4) {
                [_dic1 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
            }
        }
        else//整柜
        {
            if (_pingGui_goodsArr.count==2) {
                if (secion==1&&row==4) {
                    [_dic1 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                }
            }
            else if (_pingGui_goodsArr.count==4) {
                if (secion==1&&row==4) {
                    [_dic1 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                }
                if (secion==3&&row==4) {
                    [_dic3 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                }
            }
            else
            {
                if (secion==1&&row==4) {
                    [_dic1 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                }
                if (secion==3&&row==4) {
                    [_dic3 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                }
                if (secion==5&&row==4) {
                    [_dic5 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                }

            }
        }
    }
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            if (secion==1&&row==2) {
                [_otherDic setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"arrive_date"];
            }
            
            if (secion==1&&row==3) {
                [_otherDic setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"lading_date"];
            }
            
            
            if (secion==2&&row==4) {
                [_dic1 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
            }
            
        }
        else
        {
            if ([_pingGui_goodsArr count]==2) {
                if (secion==1&&row==2) {
                    [_otherDic setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"arrive_date"];
                }
                
                if (secion==1&&row==3) {
                    [_otherDic setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"lading_date"];
                }
                
                
                if (secion==2&&row==4) {
                    [_dic1 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                }
                
            }
            else if ([_pingGui_goodsArr count]==4)
            {
                    if (secion==1&&row==2) {
                        [_otherDic setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"arrive_date"];
                    }
                    
                    if (secion==1&&row==3) {
                        [_otherDic setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"lading_date"];
                    }
                    
                    
                    if (secion==2&&row==4) {
                        [_dic1 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                    }
                    
                    if (secion==4&&row==4) {
                        [_dic3 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                    }
                }
            
            else
            {
                if (secion==1&&row==2) {
                    [_otherDic setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"arrive_date"];
                }
                
                if (secion==1&&row==3) {
                    [_otherDic setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"lading_date"];
                }
                
                
                if (secion==2&&row==4) {
                    [_dic1 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                }
                
                if (secion==4&&row==4) {
                    [_dic3 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                }
                if (secion==6&&row==4) {
                    [_dic5 setObject:[NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day] forKey:@"make_date"];
                }
            }


        }
    }
    [_myTableView reloadData];

}

#pragma mark addOrDelete
- (void) addNew_pinGuiClick:(NSInteger)sender
{
    if (sender==2||sender==3) {
   
    [_pingGui_goodsArr addObject:_dic3];
    [_pingGui_goodsArr addObject:_dic4];
    [_myTableView reloadData];
    }
    if (sender==4||sender==5) {
        
        //删除最后两个dic5、dic6
        [_pingGui_goodsArr removeObjectAtIndex:5];
        [_pingGui_goodsArr removeObjectAtIndex:4];
        //dic3、dic4替换dic5、dic6数据
        _dic4=[NSMutableDictionary dictionaryWithDictionary:_dic6];
        _dic3=[NSMutableDictionary dictionaryWithDictionary:_dic5];
        _brandListMD1=_brandListMD2;
        _goodsNameListMD1=_goodsNameListMD2;
        //清空后两个数据
        _brandListMD2=nil;
        _goodsNameListMD2=nil;
        [_dic6 removeAllObjects];
        [_dic5 removeAllObjects];
        [_myTableView reloadData];
    }
    if (sender==6||sender==7) {
        
        [_pingGui_goodsArr removeObjectAtIndex:5];
        [_pingGui_goodsArr removeObjectAtIndex:4];
        _brandListMD2=nil;
        _goodsNameListMD2=nil;
        [_dic5 removeAllObjects];
        [_dic6 removeAllObjects];
        [_myTableView reloadData];
    }
    
}

- (void) addOrDeleteNew_pinGuiClick:(NSInteger)sender
{
    if (sender==4||sender==5) {
        
        [_pingGui_goodsArr addObject:_dic5];
        [_pingGui_goodsArr addObject:_dic6];
        [_myTableView reloadData];
    }
    if (sender==104||sender==105) {
        [_pingGui_goodsArr removeObjectAtIndex:3];
        [_pingGui_goodsArr removeObjectAtIndex:2];
        _brandListMD1=nil;
        _goodsNameListMD1=nil;
        [_dic3 removeAllObjects];
        [_dic4 removeAllObjects];
        [_myTableView reloadData];
    }
    
 [_myTableView reloadData];
}

#pragma mark fengMianImageTapMethod
- (void)fengMianImageTapMethod:(UITapGestureRecognizer *)tap
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"从相册选取", @"拍照上传", nil];
    choiceSheet.tag=100;
    [choiceSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self downXuanZe:0 withTag:actionSheet.tag];
            
        }
            break;
        case 1:
        {
            [self downXuanZe:1 withTag:actionSheet.tag];
        }
            break;
        case 2:
        {
        }
            break;
        default:
            break;
    }
}


#pragma mark 选择图片
- (void)downXuanZe:(NSInteger)sender withTag:(NSInteger)atag{
    if (atag==100)//封面图片
    {
    switch (sender) {
            case 0:
            {
                GWLPhotoLibrayController *photoSelector = [GWLPhotoLibrayController photoLibrayControllerWithBlock:^(NSArray *images) {
                    self.tabBarController.tabBar.hidden = YES;
                    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
                    myBar.plusBtn.hidden=YES;
                    if (images.count>0) {
                        [_fengmianimageViewArray removeAllObjects];
                        [_data_fengmianimageViewArray removeAllObjects];
                        for (int i=0; i<images.count; i++) {
                            [_fengmianimageViewArray addObject:[self imageByScalingToMaxSize:[images objectAtIndex:i]]];
                            [_data_fengmianimageViewArray addObject:
                             [TYDPManager resetSizeOfImageData:[images objectAtIndex:i] maxSize:300]];
                        }
                    }
                    NSIndexPath *indexPath;
                    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])
                        //现货
                    {
                        indexPath=[NSIndexPath indexPathForRow:0 inSection:4+_pingGui_goodsArr.count-1];
                    }
                    else
                        //        期货
                    {
                        indexPath=[NSIndexPath indexPathForRow:0 inSection:5+_pingGui_goodsArr.count-1];
                    }
                    
                    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
                photoSelector.maxCount =1 ;
                photoSelector.multiAlbumSelect = YES;
                [self presentViewController:photoSelector animated:YES completion:^(){
                    self.tabBarController.tabBar.hidden = YES;
                    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
                    myBar.plusBtn.hidden=YES;
                }];
                
            }
                break;
            case 1:
            {
                _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
                _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
                _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                _imagePickerController.view.tag=atag;
                [self presentViewController:_imagePickerController animated:YES completion:^(){
                    self.tabBarController.tabBar.hidden = YES;
                    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
                    myBar.plusBtn.hidden=YES;
                }];
            }
                break;
            case 2:
            {
            }
                break;
            default:
                break;
        }
        
    }
    
    else
    {
        if (atag>100)//多图
        {
            if (_imageViewArray.count>=5&&atag==106) {
                [self.view Message:@"您最多可选5张照片" HiddenAfterDelay:1.0];
                return;
            }
            
            
            switch (sender) {
                case 0:
                {
                    GWLPhotoLibrayController *photoSelector = [GWLPhotoLibrayController photoLibrayControllerWithBlock:^(NSArray *images) {
                        self.tabBarController.tabBar.hidden = YES;
                        ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
                        myBar.plusBtn.hidden=YES;
                        
                        if (atag-101== _imageViewArray.count) {
                            if (images.count>0) {
                                for (int i=0; i<images.count; i++) {
                                    [_imageViewArray addObject:[self imageByScalingToMaxSize:[images objectAtIndex:i]]];
                                    [_data_imageViewArray addObject:
                                     [TYDPManager resetSizeOfImageData:[images objectAtIndex:i] maxSize:300]];
                                }
                            }
                        }
                        else
                        {
                            [_imageViewArray replaceObjectAtIndex:atag-101 withObject:[images objectAtIndex:0]];
                            [_data_imageViewArray replaceObjectAtIndex:atag-101 withObject:[TYDPManager resetSizeOfImageData:[images objectAtIndex:0] maxSize:300]];
                        }
                        
                        
                        NSIndexPath *indexPath;
                        if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])
                            //现货
                        {
                            indexPath=[NSIndexPath indexPathForRow:0 inSection:8+_pingGui_goodsArr.count-1];
                        }
                        else
                            //        期货
                        {
                            indexPath=[NSIndexPath indexPathForRow:0 inSection:9+_pingGui_goodsArr.count-1];
                        }
                        
                        XuanZeTuPianCell *cell = [_myTableView cellForRowAtIndexPath:indexPath];
                        NSInteger num =_imageViewArray.count/3;
                        
                        //    [_myTableView reloadData];
                        [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [cell.myCollectionView setFrame:CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width/3)*num +[UIScreen mainScreen].bounds.size.width/3+100)];
                    }];
                    if (atag-101== _imageViewArray.count) {
                        photoSelector.maxCount =5 - _imageViewArray.count;
                        
                    }
                    else
                    {
                        photoSelector.maxCount =1;
                        
                    }
                    photoSelector.multiAlbumSelect = YES;
                    [self presentViewController:photoSelector animated:YES completion:^(){
                        self.tabBarController.tabBar.hidden = YES;
                        ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
                        myBar.plusBtn.hidden=YES;
                    }];
                    
                }
                    break;
                case 1:
                {
                    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
                    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
                    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                    _imagePickerController.view.tag=atag;
                    [self presentViewController:_imagePickerController animated:YES completion:^(){
                        self.tabBarController.tabBar.hidden = YES;
                        ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
                        myBar.plusBtn.hidden=YES;
                    }];
                }
                    break;
                case 2:
                {
                }
                    break;
                default:
                    break;
            }
            
        }
    }

    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.tabBarController.tabBar.hidden = YES;
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=YES;
    
    if (picker.view.tag==100) {
        NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
            [_fengmianimageViewArray removeAllObjects];
            [_fengmianimageViewArray addObject:[self imageByScalingToMaxSize:info[UIImagePickerControllerEditedImage]]];
            
            [_data_fengmianimageViewArray removeAllObjects];
            [_data_fengmianimageViewArray addObject:
                 [TYDPManager resetSizeOfImageData:info[UIImagePickerControllerEditedImage] maxSize:300]];
        }
        
        NSIndexPath *indexPath;
        if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])
            //现货
        {
            indexPath=[NSIndexPath indexPathForRow:0 inSection:4+_pingGui_goodsArr.count-1];
        }
        else
            //        期货
        {
            indexPath=[NSIndexPath indexPathForRow:0 inSection:5+_pingGui_goodsArr.count-1];
        }
        [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (picker.view.tag>100) {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
        if (picker.view.tag==101+_imageViewArray.count)
        {
        [_imageViewArray addObject:[self imageByScalingToMaxSize:info[UIImagePickerControllerEditedImage]]];
        [_data_imageViewArray addObject:
         [TYDPManager resetSizeOfImageData:info[UIImagePickerControllerEditedImage] maxSize:300]];
        }
        else
        {
            [_imageViewArray replaceObjectAtIndex:picker.view.tag-101 withObject:[self imageByScalingToMaxSize:info[UIImagePickerControllerEditedImage]]];
            
             [_data_imageViewArray replaceObjectAtIndex:picker.view.tag-101 withObject:[TYDPManager resetSizeOfImageData:info[UIImagePickerControllerEditedImage] maxSize:300]];
        }
    }
    
    NSIndexPath *indexPath;
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])
        //现货
    {
        indexPath=[NSIndexPath indexPathForRow:0 inSection:8+_pingGui_goodsArr.count-1];
    }
    else
        //        期货
    {
        indexPath=[NSIndexPath indexPathForRow:0 inSection:9+_pingGui_goodsArr.count-1];
    }
    XuanZeTuPianCell *cell = [_myTableView cellForRowAtIndexPath:indexPath];
    NSInteger num =_imageViewArray.count/3;
    [cell.myCollectionView setFrame:CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width/3)*num +[UIScreen mainScreen].bounds.size.width/3+100)];
    //    [_myTableView reloadData];
    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}



-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"发布报盘界面"];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;

    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=YES;
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"发布报盘界面"];
    self.navigationController.navigationBarHidden = NO;

    self.tabBarController.tabBar.hidden = YES;
    ZYTabBar *myBar=(ZYTabBar *)self.tabBarController.tabBar;
    myBar.plusBtn.hidden=YES;
}

-(UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    UIGraphicsEndImageContext();
    return newImage;
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
-(void)uploadfengMianImage
{
    NSDictionary *params = @{@"model":@"seller_offer",@"action":@"upload_image",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"seller_offerupload_image%@",ConfigNetAppKey]]};
    
    NSDictionary *newParams = [TYDPManager addCommomParam:params];
    [[TYDPHttpManager sharedAFManager:ServerIP] POST:@"" parameters:newParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData: [_data_fengmianimageViewArray objectAtIndex:0] name:@"upload_img" fileName:[NSString stringWithFormat:@"%@.jpg",@"upload_img"] mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"responsefengmian:%@",responseObject);

        if ([responseObject[@"error"] isEqualToString:@"0"]) {
            [_otherDic setObject:responseObject[@"content"] forKey:@"good_face"];
            if (_data_imageViewArray.count!=0) {
                [self uploadImageArr];
                
            }
            else
            {
                [self pubAllDate];
            }
        
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];

}

-(void)uploadImageArr
{
    NSDictionary *params = @{@"model":@"seller_offer",@"action":@"upload_image",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"seller_offerupload_image%@",ConfigNetAppKey]]};
    
    NSDictionary *newParams = [TYDPManager addCommomParam:params];
    NSMutableArray * imageUrlArr=[NSMutableArray new];
    debugLog(@"");
    for (int i=0; i<[_data_imageViewArray count]; i++) {
    [[TYDPHttpManager sharedAFManager:ServerIP] POST:@"" parameters:newParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData: [_data_imageViewArray objectAtIndex:i]  name:@"upload_img" fileName:[NSString stringWithFormat:@"%@.jpg",@"upload_img"] mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        debugLog(@"imageArrrespicccc:%@",responseObject);
        
        if ([responseObject[@"error"] isEqualToString:@"0"]) {
            [imageUrlArr addObject:responseObject[@"content"]];
            if (imageUrlArr.count==_data_imageViewArray.count) {
                [_otherDic setObject:imageUrlArr forKey:@"picture_list"];
               [self pubAllDate];
            }
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
        
    }
    
}


-(void)pubAllDate
{
    
    if ([_otherDic[@"alias"] isEqualToString:@""]) {
        [self.view Message:NSLocalizedString(@"Legal name", nil) HiddenAfterDelay:1.0];
        return;
    }
    if ([_otherDic[@"mobile_phone"] isEqualToString:@""]) {
         [self.view Message:NSLocalizedString(@"Phone No.", nil) HiddenAfterDelay:1.0];
        return;
    }
      [_MBHUD setLabelText:NSLocalizedString(@"Wait a moment", nil)];
    if ([self.if_addOrEditOrCopy isEqualToString:@"1"]||[self.if_addOrEditOrCopy isEqualToString:@"3"])//新增和复制
    {
    if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
    {
    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    
    NSString* _user_id = [userdefaul objectForKey:@"user_id"];
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"offer_add",ConfigNetAppKey];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    params[@"user_id"]=_user_id;
    params[@"model"]=@"seller_offer";
    params[@"action"]=@"offer_add";
    params[@"sign"]=[TYDPManager md5:Sign];
    params[@"goods_type"]=[_goodsCharacterArr objectAtIndex:0];
    params[@"sell_type"]=[_goodsCharacterArr objectAtIndex:1];
    params[@"offer"]=[_goodsCharacterArr objectAtIndex:2];
    [params setValuesForKeysWithDictionary:_dic1];
    [params setValuesForKeysWithDictionary:_dic2];
    [params setValuesForKeysWithDictionary:_otherDic];
    
    
    debugLog(@"sendParam:%@",params);

        [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"pubpubparams:%@",data);
        if (![data[@"error"] intValue]) {
          
            [_MBHUD hide:YES];
            [self leftItemClicked:nil];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            
            if (![PSDefaults objectForKey:@"alias"]||[[PSDefaults objectForKey:@"alias"] isEqualToString:@""]) {
                [PSDefaults setObject:_otherDic[@"alias"] forKey:@"alias"];
            }
            if (![PSDefaults objectForKey:@"mobile_phone"]||[[PSDefaults objectForKey:@"mobile_phone"] isEqualToString:@""]) {
                [PSDefaults setObject:_otherDic[@"mobile_phone"] forKey:@"mobile_phone"];
            }
            
            [window Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.5];
        } else {
            [_MBHUD setLabelText:data[@"message"]];
            [self.view addSubview:_MBHUD];
            [_MBHUD show:YES];
            [_MBHUD hide:YES afterDelay:1.5f];
        }
    } failure:^(TYDPError *error) {
        [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        NSLog(@"%@",error);
    }];
}
    else
    {
    
        if ([_pingGui_goodsArr count]==2) {
            NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
            
            NSString* _user_id = [userdefaul objectForKey:@"user_id"];
            NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"offer_add",ConfigNetAppKey];
            
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            params[@"user_id"]=_user_id;
            params[@"model"]=@"seller_offer";
            params[@"action"]=@"offer_add";
            params[@"sign"]=[TYDPManager md5:Sign];
            params[@"goods_type"]=[_goodsCharacterArr objectAtIndex:0];
            params[@"sell_type"]=[_goodsCharacterArr objectAtIndex:1];
            params[@"offer"]=[_goodsCharacterArr objectAtIndex:2];
            params[@"region"]=[NSArray arrayWithObjects:_dic1[@"region_id"], nil];
            params[@"brand_ids"]=[NSArray arrayWithObjects:_dic1[@"brand_id"], nil];
            params[@"cat_ids"]=[NSArray arrayWithObjects:_dic1[@"cat_id"], nil];
            params[@"base_ids"]=[NSArray arrayWithObjects:_dic1[@"base_id"],nil];
            params[@"make_dates"]=[NSArray arrayWithObjects:_dic1[@"make_date"], nil];
            params[@"spec_txts"]=[NSArray arrayWithObjects:_dic2[@"spec_txt"], nil];
            params[@"specs_1"]=[NSArray arrayWithObjects:_dic2[@"spec_1"],nil];
             params[@"specs_3"]=[NSArray arrayWithObjects:_dic2[@"spec_3"],nil];
            params[@"goods_weight"]=[NSString stringWithFormat:@"%@",_dic2[@"spec_3"]];
            params[@"packs"]=[NSArray arrayWithObjects:_dic2[@"pack"],nil];

//            [params setValuesForKeysWithDictionary:_dic1];
//            [params setValuesForKeysWithDictionary:_dic2];
            [params setValuesForKeysWithDictionary:_otherDic];
            
            
            debugLog(@"sendParam:%@",params);
            
            [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
                debugLog(@"pubpubparams:%@",data);
                if (![data[@"error"] intValue]) {
                     [_MBHUD hide:YES];
                                [self leftItemClicked:nil];
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [window Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.5];
                    if (![PSDefaults objectForKey:@"alias"]||[[PSDefaults objectForKey:@"alias"] isEqualToString:@""]) {
                        [PSDefaults setObject:_otherDic[@"alias"] forKey:@"alias"];
                    }
                    if (![PSDefaults objectForKey:@"mobile_phone"]||[[PSDefaults objectForKey:@"mobile_phone"] isEqualToString:@""]) {
                        [PSDefaults setObject:_otherDic[@"mobile_phone"] forKey:@"mobile_phone"];
                    }
                    
                } else {
                    [_MBHUD setLabelText:data[@"message"]];
                    [self.view addSubview:_MBHUD];
                    [_MBHUD show:YES];
                    [_MBHUD hide:YES afterDelay:1.5f];
                }
            } failure:^(TYDPError *error) {
                [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
                [self.view addSubview:_MBHUD];
                [_MBHUD show:YES];
                NSLog(@"%@",error);
            }];
        }
        else  if ([_pingGui_goodsArr count]==4) {
            NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
            
            NSString* _user_id = [userdefaul objectForKey:@"user_id"];
            NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"offer_add",ConfigNetAppKey];
            
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            params[@"user_id"]=_user_id;
            params[@"model"]=@"seller_offer";
            params[@"action"]=@"offer_add";
            params[@"sign"]=[TYDPManager md5:Sign];
            params[@"goods_type"]=[_goodsCharacterArr objectAtIndex:0];
            params[@"sell_type"]=[_goodsCharacterArr objectAtIndex:1];
            params[@"offer"]=[_goodsCharacterArr objectAtIndex:2];
            params[@"region"]=[NSArray arrayWithObjects:_dic1[@"region_id"],_dic3[@"region_id"], nil];
            params[@"brand_ids"]=[NSArray arrayWithObjects:_dic1[@"brand_id"],_dic3[@"brand_id"], nil];
             params[@"cat_ids"]=[NSArray arrayWithObjects:_dic1[@"cat_id"],_dic3[@"cat_id"], nil];
             params[@"base_ids"]=[NSArray arrayWithObjects:_dic1[@"base_id"],_dic3[@"base_id"], nil];
             params[@"make_dates"]=[NSArray arrayWithObjects:_dic1[@"make_date"],_dic3[@"make_date"], nil];
             params[@"spec_txts"]=[NSArray arrayWithObjects:_dic2[@"spec_txt"],_dic4[@"spec_txt"], nil];
             params[@"specs_1"]=[NSArray arrayWithObjects:_dic2[@"spec_1"],_dic4[@"spec_1"], nil];
            params[@"specs_3"]=[NSArray arrayWithObjects:_dic2[@"spec_3"],_dic4[@"spec_3"], nil];
            float sum = [_dic2[@"spec_3"] floatValue]+[_dic4[@"spec_3"] floatValue];
             params[@"goods_weight"]=[NSString stringWithFormat:@"%lf",sum];
            params[@"packs"]=[NSArray arrayWithObjects:_dic2[@"pack"],_dic4[@"pack"], nil];
//            [params setValuesForKeysWithDictionary:_dic1];
//            [params setValuesForKeysWithDictionary:_dic2];
            [params setValuesForKeysWithDictionary:_otherDic];
            
            
            debugLog(@"sendParam:%@",params);
            
            [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
                [self.view Message:data[@"message"] HiddenAfterDelay:1.0];
                debugLog(@"pubpubparams:%@",data);
                if (![data[@"error"] intValue]) {
                     [_MBHUD hide:YES];
                                [self leftItemClicked:nil];
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [window Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.5];
                    if (![PSDefaults objectForKey:@"alias"]||[[PSDefaults objectForKey:@"alias"] isEqualToString:@""]) {
                        [PSDefaults setObject:_otherDic[@"alias"] forKey:@"alias"];
                    }
                    if (![PSDefaults objectForKey:@"mobile_phone"]||[[PSDefaults objectForKey:@"mobile_phone"] isEqualToString:@""]) {
                        [PSDefaults setObject:_otherDic[@"mobile_phone"] forKey:@"mobile_phone"];
                    }
                } else {
                    [_MBHUD setLabelText:data[@"message"]];
                    [self.view addSubview:_MBHUD];
                    [_MBHUD show:YES];
                    [_MBHUD hide:YES afterDelay:1.5f];
                }
            } failure:^(TYDPError *error) {
                [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
                [self.view addSubview:_MBHUD];
                [_MBHUD show:YES];
                NSLog(@"%@",error);
            }];
        }
        else
        {
            NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
            
            NSString* _user_id = [userdefaul objectForKey:@"user_id"];
            NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"offer_add",ConfigNetAppKey];
            
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            params[@"user_id"]=_user_id;
            params[@"model"]=@"seller_offer";
            params[@"action"]=@"offer_add";
            params[@"sign"]=[TYDPManager md5:Sign];
            params[@"goods_type"]=[_goodsCharacterArr objectAtIndex:0];
            params[@"sell_type"]=[_goodsCharacterArr objectAtIndex:1];
            params[@"offer"]=[_goodsCharacterArr objectAtIndex:2];
            params[@"region"]=[NSArray arrayWithObjects:_dic1[@"region_id"],_dic3[@"region_id"],_dic5[@"region_id"], nil];
            params[@"brand_ids"]=[NSArray arrayWithObjects:_dic1[@"brand_id"],_dic3[@"brand_id"], _dic5[@"brand_id"],nil];
            params[@"cat_ids"]=[NSArray arrayWithObjects:_dic1[@"cat_id"],_dic3[@"cat_id"],_dic5[@"cat_id"], nil];
            params[@"base_ids"]=[NSArray arrayWithObjects:_dic1[@"base_id"],_dic3[@"base_id"], _dic5[@"base_id"],nil];
            params[@"make_dates"]=[NSArray arrayWithObjects:_dic1[@"make_date"],_dic3[@"make_date"], _dic5[@"make_date"],nil];
            params[@"spec_txts"]=[NSArray arrayWithObjects:_dic2[@"spec_txt"],_dic4[@"spec_txt"], _dic6[@"spec_txt"],nil];
            params[@"specs_1"]=[NSArray arrayWithObjects:_dic2[@"spec_1"],_dic4[@"spec_1"], _dic6[@"spec_1"],nil];
            params[@"specs_3"]=[NSArray arrayWithObjects:_dic2[@"spec_3"],_dic4[@"spec_3"], _dic6[@"spec_3"],nil];
            float sum = [_dic2[@"spec_3"] floatValue]+[_dic4[@"spec_3"] floatValue]+[_dic6[@"spec_3"] floatValue];
            params[@"goods_weight"]=[NSString stringWithFormat:@"%lf",sum];
            params[@"packs"]=[NSArray arrayWithObjects:_dic2[@"pack"],_dic4[@"pack"], _dic6[@"pack"],nil];
            //            [params setValuesForKeysWithDictionary:_dic1];
            //            [params setValuesForKeysWithDictionary:_dic2];
            [params setValuesForKeysWithDictionary:_otherDic];
            
            
            debugLog(@"sendParam:%@",params);
            
            [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
                debugLog(@"pubpubparams:%@",data);
                
                if (![data[@"error"] intValue]) {
                     [_MBHUD hide:YES];
                                [self leftItemClicked:nil];
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [window Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.5];
                    if (![PSDefaults objectForKey:@"alias"]||[[PSDefaults objectForKey:@"alias"] isEqualToString:@""]) {
                        [PSDefaults setObject:_otherDic[@"alias"] forKey:@"alias"];
                    }
                    if (![PSDefaults objectForKey:@"mobile_phone"]||[[PSDefaults objectForKey:@"mobile_phone"] isEqualToString:@""]) {
                        [PSDefaults setObject:_otherDic[@"mobile_phone"] forKey:@"mobile_phone"];
                    }
                } else {
                    [_MBHUD setLabelText:data[@"message"]];
                    [self.view addSubview:_MBHUD];
                    [_MBHUD show:YES];
                    [_MBHUD hide:YES afterDelay:1.5f];
                }
            } failure:^(TYDPError *error) {
                [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
                [self.view addSubview:_MBHUD];
                [_MBHUD show:YES];
                NSLog(@"%@",error);
            }];
        }
    }
    }
    
    else//编辑
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
            
            NSString* _user_id = [userdefaul objectForKey:@"user_id"];
            NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"offer_edit",ConfigNetAppKey];
            
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            params[@"user_id"]=_user_id;
            params[@"model"]=@"seller_offer";
            params[@"action"]=@"offer_edit";
            params[@"goods_id"]=_goods_id;
            params[@"sign"]=[TYDPManager md5:Sign];
            params[@"goods_type"]=[_goodsCharacterArr objectAtIndex:0];
            params[@"sell_type"]=[_goodsCharacterArr objectAtIndex:1];
            params[@"offer"]=[_goodsCharacterArr objectAtIndex:2];
            [params setValuesForKeysWithDictionary:_dic1];
            [params setValuesForKeysWithDictionary:_dic2];
            [params setValuesForKeysWithDictionary:_otherDic];
            
            
            debugLog(@"sendParam:%@",params);
            
            [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
                debugLog(@"pubpubparams:%@",data);
                if (![data[@"error"] intValue]) {
                    
                    [_MBHUD hide:YES];
                    [self leftItemClicked:nil];
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [window Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.5];
                    if (![PSDefaults objectForKey:@"alias"]||[[PSDefaults objectForKey:@"alias"] isEqualToString:@""]) {
                        [PSDefaults setObject:_otherDic[@"alias"] forKey:@"alias"];
                    }
                    if (![PSDefaults objectForKey:@"mobile_phone"]||[[PSDefaults objectForKey:@"mobile_phone"] isEqualToString:@""]) {
                        [PSDefaults setObject:_otherDic[@"mobile_phone"] forKey:@"mobile_phone"];
                    }
                } else {
                    [_MBHUD setLabelText:data[@"message"]];
                    [self.view addSubview:_MBHUD];
                    [_MBHUD show:YES];
                    [_MBHUD hide:YES afterDelay:1.5f];
                }
            } failure:^(TYDPError *error) {
                [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
                [self.view addSubview:_MBHUD];
                [_MBHUD show:YES];
                NSLog(@"%@",error);
            }];
        }
        else
        {
            
            if ([_pingGui_goodsArr count]==2) {
                NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
                
                NSString* _user_id = [userdefaul objectForKey:@"user_id"];
                NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"offer_edit",ConfigNetAppKey];
                
                NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
                params[@"user_id"]=_user_id;
                params[@"model"]=@"seller_offer";
                params[@"action"]=@"offer_edit";
                params[@"goods_id"]=_goods_id;
                params[@"sign"]=[TYDPManager md5:Sign];
                params[@"goods_type"]=[_goodsCharacterArr objectAtIndex:0];
                params[@"sell_type"]=[_goodsCharacterArr objectAtIndex:1];
                params[@"offer"]=[_goodsCharacterArr objectAtIndex:2];
                params[@"region"]=[NSArray arrayWithObjects:_dic1[@"region_id"], nil];
                params[@"brand_ids"]=[NSArray arrayWithObjects:_dic1[@"brand_id"], nil];
                params[@"cat_ids"]=[NSArray arrayWithObjects:_dic1[@"cat_id"], nil];
                params[@"base_ids"]=[NSArray arrayWithObjects:_dic1[@"base_id"],nil];
                params[@"make_dates"]=[NSArray arrayWithObjects:_dic1[@"make_date"], nil];
                params[@"spec_txts"]=[NSArray arrayWithObjects:_dic2[@"spec_txt"], nil];
                params[@"specs_1"]=[NSArray arrayWithObjects:_dic2[@"spec_1"],nil];
                params[@"specs_3"]=[NSArray arrayWithObjects:_dic2[@"spec_3"],nil];
                params[@"goods_weight"]=[NSString stringWithFormat:@"%@",_dic2[@"spec_3"]];
                params[@"packs"]=[NSArray arrayWithObjects:_dic2[@"pack"],nil];
                
                //            [params setValuesForKeysWithDictionary:_dic1];
                //            [params setValuesForKeysWithDictionary:_dic2];
                [params setValuesForKeysWithDictionary:_otherDic];
                
                
                debugLog(@"sendParam:%@",params);
                
                [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
                    debugLog(@"pubpubparams:%@",data);
                    if (![data[@"error"] intValue]) {
                        [_MBHUD hide:YES];
                        [self leftItemClicked:nil];
                        UIWindow *window = [UIApplication sharedApplication].keyWindow;
                        [window Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.5];
                        if (![PSDefaults objectForKey:@"alias"]||[[PSDefaults objectForKey:@"alias"] isEqualToString:@""]) {
                            [PSDefaults setObject:_otherDic[@"alias"] forKey:@"alias"];
                        }
                        if (![PSDefaults objectForKey:@"mobile_phone"]||[[PSDefaults objectForKey:@"mobile_phone"] isEqualToString:@""]) {
                            [PSDefaults setObject:_otherDic[@"mobile_phone"] forKey:@"mobile_phone"];
                        }
                    } else {
                        [_MBHUD setLabelText:data[@"message"]];
                        [self.view addSubview:_MBHUD];
                        [_MBHUD show:YES];
                        [_MBHUD hide:YES afterDelay:1.5f];
                    }
                } failure:^(TYDPError *error) {
                    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
                    [self.view addSubview:_MBHUD];
                    [_MBHUD show:YES];
                    NSLog(@"%@",error);
                }];
            }
            else  if ([_pingGui_goodsArr count]==4) {
                NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
                
                NSString* _user_id = [userdefaul objectForKey:@"user_id"];
                NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"offer_edit",ConfigNetAppKey];
                
                NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
                params[@"user_id"]=_user_id;
                params[@"model"]=@"seller_offer";
                params[@"action"]=@"offer_edit";
                params[@"goods_id"]=_goods_id;
                params[@"sign"]=[TYDPManager md5:Sign];
                params[@"goods_type"]=[_goodsCharacterArr objectAtIndex:0];
                params[@"sell_type"]=[_goodsCharacterArr objectAtIndex:1];
                params[@"offer"]=[_goodsCharacterArr objectAtIndex:2];
                params[@"region"]=[NSArray arrayWithObjects:_dic1[@"region_id"],_dic3[@"region_id"], nil];
                params[@"brand_ids"]=[NSArray arrayWithObjects:_dic1[@"brand_id"],_dic3[@"brand_id"], nil];
                params[@"cat_ids"]=[NSArray arrayWithObjects:_dic1[@"cat_id"],_dic3[@"cat_id"], nil];
                params[@"base_ids"]=[NSArray arrayWithObjects:_dic1[@"base_id"],_dic3[@"base_id"], nil];
                params[@"make_dates"]=[NSArray arrayWithObjects:_dic1[@"make_date"],_dic3[@"make_date"], nil];
                params[@"spec_txts"]=[NSArray arrayWithObjects:_dic2[@"spec_txt"],_dic4[@"spec_txt"], nil];
                params[@"specs_1"]=[NSArray arrayWithObjects:_dic2[@"spec_1"],_dic4[@"spec_1"], nil];
                params[@"specs_3"]=[NSArray arrayWithObjects:_dic2[@"spec_3"],_dic4[@"spec_3"], nil];
                float sum = [_dic2[@"spec_3"] floatValue]+[_dic4[@"spec_3"] floatValue];
                params[@"goods_weight"]=[NSString stringWithFormat:@"%lf",sum];
                params[@"packs"]=[NSArray arrayWithObjects:_dic2[@"pack"],_dic4[@"pack"], nil];
                //            [params setValuesForKeysWithDictionary:_dic1];
                //            [params setValuesForKeysWithDictionary:_dic2];
                [params setValuesForKeysWithDictionary:_otherDic];
                
                
                debugLog(@"sendParam:%@",params);
                
                [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
                    [self.view Message:data[@"message"] HiddenAfterDelay:1.0];
                    debugLog(@"pubpubparams:%@",data);
                    if (![data[@"error"] intValue]) {
                        [_MBHUD hide:YES];
                        [self leftItemClicked:nil];
                        UIWindow *window = [UIApplication sharedApplication].keyWindow;
                        [window Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.5];
                        if (![PSDefaults objectForKey:@"alias"]||[[PSDefaults objectForKey:@"alias"] isEqualToString:@""]) {
                            [PSDefaults setObject:_otherDic[@"alias"] forKey:@"alias"];
                        }
                        if (![PSDefaults objectForKey:@"mobile_phone"]||[[PSDefaults objectForKey:@"mobile_phone"] isEqualToString:@""]) {
                            [PSDefaults setObject:_otherDic[@"mobile_phone"] forKey:@"mobile_phone"];
                        }
                    } else {
                        [_MBHUD setLabelText:data[@"message"]];
                        [self.view addSubview:_MBHUD];
                        [_MBHUD show:YES];
                        [_MBHUD hide:YES afterDelay:1.5f];
                    }
                } failure:^(TYDPError *error) {
                    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
                    [self.view addSubview:_MBHUD];
                    [_MBHUD show:YES];
                    NSLog(@"%@",error);
                }];
            }
            else
            {
                NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
                
                NSString* _user_id = [userdefaul objectForKey:@"user_id"];
                NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"offer_edit",ConfigNetAppKey];
                
                NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
                params[@"user_id"]=_user_id;
                params[@"model"]=@"seller_offer";
                params[@"action"]=@"offer_edit";
                params[@"goods_id"]=_goods_id;
                params[@"sign"]=[TYDPManager md5:Sign];
                params[@"goods_type"]=[_goodsCharacterArr objectAtIndex:0];
                params[@"sell_type"]=[_goodsCharacterArr objectAtIndex:1];
                params[@"offer"]=[_goodsCharacterArr objectAtIndex:2];
                params[@"region"]=[NSArray arrayWithObjects:_dic1[@"region_id"],_dic3[@"region_id"],_dic5[@"region_id"], nil];
                params[@"brand_ids"]=[NSArray arrayWithObjects:_dic1[@"brand_id"],_dic3[@"brand_id"], _dic5[@"brand_id"],nil];
                params[@"cat_ids"]=[NSArray arrayWithObjects:_dic1[@"cat_id"],_dic3[@"cat_id"],_dic5[@"cat_id"], nil];
                params[@"base_ids"]=[NSArray arrayWithObjects:_dic1[@"base_id"],_dic3[@"base_id"], _dic5[@"base_id"],nil];
                params[@"make_dates"]=[NSArray arrayWithObjects:_dic1[@"make_date"],_dic3[@"make_date"], _dic5[@"make_date"],nil];
                params[@"spec_txts"]=[NSArray arrayWithObjects:_dic2[@"spec_txt"],_dic4[@"spec_txt"], _dic6[@"spec_txt"],nil];
                params[@"specs_1"]=[NSArray arrayWithObjects:_dic2[@"spec_1"],_dic4[@"spec_1"], _dic6[@"spec_1"],nil];
                params[@"specs_3"]=[NSArray arrayWithObjects:_dic2[@"spec_3"],_dic4[@"spec_3"], _dic6[@"spec_3"],nil];
                float sum = [_dic2[@"spec_3"] floatValue]+[_dic4[@"spec_3"] floatValue]+[_dic6[@"spec_3"] floatValue];
                params[@"goods_weight"]=[NSString stringWithFormat:@"%lf",sum];
                params[@"packs"]=[NSArray arrayWithObjects:_dic2[@"pack"],_dic4[@"pack"], _dic6[@"pack"],nil];
                //            [params setValuesForKeysWithDictionary:_dic1];
                //            [params setValuesForKeysWithDictionary:_dic2];
                [params setValuesForKeysWithDictionary:_otherDic];
                
                
                debugLog(@"sendParam:%@",params);
                
                [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
                    debugLog(@"pubpubparams:%@",data);
                    
                    if (![data[@"error"] intValue]) {
                        [_MBHUD hide:YES];
                        [self leftItemClicked:nil];
                        UIWindow *window = [UIApplication sharedApplication].keyWindow;
                        [window Message:NSLocalizedString(@"Success", nil) HiddenAfterDelay:1.5];
                        if (![PSDefaults objectForKey:@"alias"]||[[PSDefaults objectForKey:@"alias"] isEqualToString:@""]) {
                            [PSDefaults setObject:_otherDic[@"alias"] forKey:@"alias"];
                        }
                        if (![PSDefaults objectForKey:@"mobile_phone"]||[[PSDefaults objectForKey:@"mobile_phone"] isEqualToString:@""]) {
                            [PSDefaults setObject:_otherDic[@"mobile_phone"] forKey:@"mobile_phone"];
                        }
                    } else {
                        [_MBHUD setLabelText:data[@"message"]];
                        [self.view addSubview:_MBHUD];
                        [_MBHUD show:YES];
                        [_MBHUD hide:YES afterDelay:1.5f];
                    }
                } failure:^(TYDPError *error) {
                    [_MBHUD setLabelText:[NSString stringWithFormat:@"%@",error]];
                    [self.view addSubview:_MBHUD];
                    [_MBHUD show:YES];
                    NSLog(@"%@",error);
                }];
            }
        }

    }
}


- (IBAction)pubBtnClick:(UIButton *)sender {
    [self creatHUD];
    if (_fengmianimageViewArray.count!=0) {
        
        [self uploadfengMianImage ];
        return;
    }
    else
    {
        if (_data_imageViewArray.count!=0) {
            [self uploadImageArr];
            return;
        }
        else
        {
            [self pubAllDate];
        }
    }
    
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

@end
