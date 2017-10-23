//
//  TYDP_selectViewController.m
//  TYDPB2B
//
//  Created by 张俊松 on 2017/8/29.
//  Copyright © 2017年 泰洋冻品. All rights reserved.
//

#import "TYDP_selectViewController.h"
#import "OfferRightViewCell.h"
#import "TopCategoryModel.h"
#import "FilterSiteListModel.h"
#import "FilterSiteBrandListModel.h"
#import "FilterSellListModel.h"
#import "FilterCatDataBigModel.h"
#import "offerTypeModel.h"
#import "FilterSiteBrandListModel.h"
#import "goodsNameModel.h"
#import "ZYTabBar.h"
#import "brandListModel.h"
#import "goodsNameListModel.h"
typedef enum {
    TopConfirmButtonMessage = 1,
    BottomConfirmButtonMessage,
    SearchCancelButtonMessage
}BUTTONMESSAGE;

@interface TYDP_selectViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, strong)UIView *navigationBarView;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic,strong)UIButton *searchCancelButton;
@property(nonatomic, strong)UITableView *myTableView;
@property(nonatomic, strong)MBProgressHUD *MBHUD;
@property(nonatomic, strong)NSString *signString;
@property(nonatomic, strong)NSString *signIdString;
@property(nonatomic, strong)brandListModel * brandListMD;
@property(nonatomic, strong)goodsNameListModel * goodsNameListMD;
@property(nonatomic, strong)UIButton * addBtn;
@end

@implementation TYDP_selectViewController
@synthesize addBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
     _signString = [[NSString alloc] init];
    _signIdString= [[NSString alloc] init];
    self.view.backgroundColor=RGBACOLOR(231, 231, 231, 1);
    debugLog(@"_goodsCharacterArr11:%@",_goodsCharacterArr[0]);
    
    // Do any additional setup after loading the view.
}
#pragma mark 设置导航栏
- (void)setUpNavigationBar {
    _navigationBarView = [UIView new];
    _navigationBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
    _navigationBarView.backgroundColor=mainColor;
    [self.view addSubview:_navigationBarView];
    UILabel *navigationLabel = [UILabel new];
//    [navigationLabel setText:@"筛选"];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setTextColor:[UIColor whiteColor]];
    [_navigationBarView addSubview:navigationLabel];
    [navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navigationBarView);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap/2);
        make.width.mas_equalTo(NavHeight);
        make.height.mas_equalTo(NavHeight/2);
    }];
    
    addBtn =[[UIButton alloc] init];
    [_navigationBarView addSubview:addBtn];
    addBtn.backgroundColor=[UIColor whiteColor];
    [addBtn setTitleColor:mainColor forState:UIControlStateNormal];
    addBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_navigationBarView).with.offset(-Gap);
        make.centerY.equalTo(_navigationBarView).with.offset(Gap);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.clipsToBounds = YES;
    addBtn.layer.cornerRadius = 3;
    
    debugLog(@"_goodsCharacterArr:%@",_goodsCharacterArr[0]);
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (_firstFrontSelectedRowNumber){
                case 100:{
                    addBtn.hidden=YES;
                    break;
                }
                case 101:{
                    addBtn.hidden=NO;
                    
                    break;
                }
                case 102:{
                    addBtn.hidden=YES;
                     break;
                }
                case 103:{
                    addBtn.hidden=NO;
                    
                    break;
                }
                case 104:{
                    addBtn.hidden=YES;
                }
                case 402:{
                    addBtn.hidden=YES;
                    break;
                }
                default:
                    addBtn.hidden=YES;
                    break;
            }
        }
        else
        {
            if (_goods_num==2) {
                switch (_firstFrontSelectedRowNumber){
                    case 100:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 101:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 102:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 103:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 104:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 402:{
                        addBtn.hidden=YES;
                        break;
                    }
                    default:
                        break;
                }
            }
            else if (_goods_num==4) {
                switch (_firstFrontSelectedRowNumber){
                    case 100:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 101:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 102:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 103:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 104:{
                        addBtn.hidden=YES;
                        break;
                    }
                        
                    case 300:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 301:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 302:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 303:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 304:{
                        addBtn.hidden=YES;
                        break;
                    }
                        
                    case 602:{
                        addBtn.hidden=YES;
                        break;
                    }
                    default:
                        break;
                }
            }
            else
            {
                switch (_firstFrontSelectedRowNumber){
                    case 100:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 101:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 102:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 103:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 104:{
                        addBtn.hidden=YES;
                        break;
                    }
                        
                    case 300:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 301:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 302:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 303:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 304:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 500:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 501:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 502:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 503:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 504:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 802:{
                        addBtn.hidden=YES;
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }
    
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (_firstFrontSelectedRowNumber){
                    
                case 100:{
                    addBtn.hidden=YES;
                    break;
                }
                case 104:{
                    addBtn.hidden=YES;
                    break;
                }
                    
                case 200:{
                    addBtn.hidden=YES;
                    break;
                }
                case 201:{
                    addBtn.hidden=NO;
                    break;
                }
                case 202:{
                    addBtn.hidden=YES;
                    break;
                }
                case 203:{
                    addBtn.hidden=NO;
                    break;
                }
                case 204:{
                    addBtn.hidden=YES;
                    break;
                }
                case 502:{
                    addBtn.hidden=YES;
                    break;
                }
                default:
                    break;
            }
        }
        else
        {
            if (_goods_num==2) {
                switch (_firstFrontSelectedRowNumber){
                        
                    case 100:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 104:{
                        addBtn.hidden=YES;
                        break;
                    }
                        
                    case 200:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 201:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 202:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 203:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 204:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 502:{
                        addBtn.hidden=YES;
                        break;
                    }
                    default:
                        break;
                }
            }
            else if (_goods_num==4)
            {
                switch (_firstFrontSelectedRowNumber){
                        
                    case 100:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 104:{
                        addBtn.hidden=YES;
                        break;
                    }
                        
                    case 200:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 201:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 202:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 203:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 204:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 400:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 401:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 402:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 403:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 404:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 702:{
                        addBtn.hidden=YES;
                        break;
                    }
                    default:
                        break;
                }
            }
            else
            {
                switch (_firstFrontSelectedRowNumber){
                        
                    case 100:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 104:{
                        addBtn.hidden=YES;
                        break;
                    }
                        
                    case 200:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 201:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 202:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 203:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 204:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 400:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 401:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 402:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 403:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 404:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 600:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 601:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 602:{
                        addBtn.hidden=YES;
                        break;
                    }
                    case 603:{
                        addBtn.hidden=NO;
                        break;
                    }
                    case 604:{
                        addBtn.hidden=YES;
                        break;
                    }
                        
                    case 902:{
                        addBtn.hidden=YES;
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }
    
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
    [self creatUI];
}
-(void)addBtnClick:(UIButton *)Btn
{
    if ([_searchBar.text isEqualToString:@""]||_searchBar.text == nil) {
        [self.view Message:@"亲，请先填入信息后添加" HiddenAfterDelay:1.0];
        return;
    }
    debugLog(@"_goodsCharacterArr:%@",_goodsCharacterArr[0]);
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (_firstFrontSelectedRowNumber){
                
                case 101:{
                    addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                    
                    break;
                }
               
                case 103:{
                    addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                    
                    break;
                }
                default:
                    break;
            }
        }
        else
        {
            if (_goods_num==2) {
                switch (_firstFrontSelectedRowNumber){
                    
                    case 101:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                    
                    case 103:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                    default:
                        break;
                }
            }
            else if (_goods_num==4) {
                switch (_firstFrontSelectedRowNumber){
                   
                    case 101:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                    
                    case 103:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                        
                    case 301:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                
                    case 303:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                    default:
                        break;
                }
            }
            else
            {
                switch (_firstFrontSelectedRowNumber){
                    
                    case 101:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                    
                    case 103:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                    
                    case 301:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                    
                    case 303:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                   
                    case 501:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                   
                    case 503:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                    
                    default:
                        break;
                }
            }
        }
    }
    
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (_firstFrontSelectedRowNumber){
                    
                case 201:{
                    addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                    break;
                }
                
                case 203:{
                    addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                    break;
                }
                
                default:
                    break;
            }
        }
        else
        {
            if (_goods_num==2) {
                switch (_firstFrontSelectedRowNumber){
                        
                    case 201:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                    
                    case 203:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                default:
                        break;
                }
            }
            else if (_goods_num==4)
            {
                switch (_firstFrontSelectedRowNumber){
                        
                    
                    case 201:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                    
                    case 203:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                    
                    case 401:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                    
                    case 403:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                    
                    default:
                        break;
                }
            }
            else
            {
                switch (_firstFrontSelectedRowNumber){
                        
                    
                    case 201:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                    
                    case 203:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                    
                    case 401:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                    
                    case 403:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                    
                    case 601:{
                        addBtn.hidden=NO;[self addBrandListDataWithNewDic];
                        break;
                    }
                    
                    case 603:{
                        addBtn.hidden=NO;[self addgoodsNameListWithNewDic];
                        break;
                    }
                    
                    default:
                        break;
                }
            }
        }
    }
}

-(void)searchClick
{
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (_firstFrontSelectedRowNumber){
                    
                case 101:{
                    addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                    
                    break;
                }
                    
                case 103:{
                    addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                    
                    break;
                }
                default:
                    break;
            }
        }
        else
        {
            if (_goods_num==2) {
                switch (_firstFrontSelectedRowNumber){
                        
                    case 101:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 103:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                    default:
                        break;
                }
            }
            else if (_goods_num==4) {
                switch (_firstFrontSelectedRowNumber){
                        
                    case 101:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 103:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                        
                    case 301:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 303:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                    default:
                        break;
                }
            }
            else
            {
                switch (_firstFrontSelectedRowNumber){
                        
                    case 101:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 103:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                        
                    case 301:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 303:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                        
                    case 501:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 503:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                        
                    default:
                        break;
                }
            }
        }
    }
    
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (_firstFrontSelectedRowNumber){
                    
                case 201:{
                    addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                    break;
                }
                    
                case 203:{
                    addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                    break;
                }
                    
                default:
                    break;
            }
        }
        else
        {
            if (_goods_num==2) {
                switch (_firstFrontSelectedRowNumber){
                        
                    case 201:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 203:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                    default:
                        break;
                }
            }
            else if (_goods_num==4)
            {
                switch (_firstFrontSelectedRowNumber){
                        
                        
                    case 201:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 203:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                        
                    case 401:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 403:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                        
                    default:
                        break;
                }
            }
            else
            {
                switch (_firstFrontSelectedRowNumber){
                        
                        
                    case 201:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 203:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                        
                    case 401:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 403:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                        
                    case 601:{
                        addBtn.hidden=NO;[self searchBrandListDataWithNewDic];
                        break;
                    }
                        
                    case 603:{
                        addBtn.hidden=NO;[self searchgoodsNameListWithNewDic];
                        break;
                    }
                        
                    default:
                        break;
                }
            }
        }
    }
}
- (void)leftItemClicked:(UIBarButtonItem *)item{
    
        [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)creatUI
{
    UIView *topView = [UIView new];
    [topView setBackgroundColor:[UIColor whiteColor]];
    topView.clipsToBounds = YES;
    topView.layer.cornerRadius = 5;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navigationBarView.mas_bottom).with.offset(MiddleGap);
        make.left.equalTo(self.view).with.offset(Gap);
        make.right.equalTo(self.view).with.offset(-Gap);
        make.height.mas_equalTo(CommonSearchViewHeight);
    }];
    _searchBar = [[UISearchBar alloc] init];
    [topView addSubview:_searchBar];
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    _searchBar.placeholder = [NSString stringWithFormat:@"产品／厂号／国家"];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = NO;
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topView).with.insets(UIEdgeInsetsMake(-2, -Gap, 4, -Gap));
    }];
    
    _myTableView = [UITableView new];
    _myTableView.clipsToBounds = YES;
    _myTableView.layer.cornerRadius = 5;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addBtn.hidden?_navigationBarView.mas_bottom: topView.mas_bottom).with.offset(MiddleGap);
        make.right.equalTo(topView);
        make.left.equalTo(topView);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
    }];
    
    
    _searchCancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _searchCancelButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [_searchCancelButton setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    _searchCancelButton.alpha = 0.3;
    [_searchCancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_myTableView reloadData];
}

- (void)buttonClicked:(UIButton *)button {
    
    [_searchBar resignFirstResponder];
    [_searchCancelButton removeFromSuperview];
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view addSubview:_searchCancelButton];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchActionMethod];
}
- (void)searchActionMethod {
    NSMutableDictionary *filterDic = [NSMutableDictionary dictionary];
    [filterDic setObject:_searchBar.text forKey:@"keywords"];
    if ([_searchBar.text isEqualToString:@""]||_searchBar.text == nil) {
        [_MBHUD setLabelText:@"亲，没有输入搜索关键字哦。"];
        [self.view addSubview:_MBHUD];
        [_MBHUD show:YES];
        [_MBHUD hide:YES afterDelay:1.0f];
    } else {
        
        [self searchClick];
        
        [_searchBar resignFirstResponder];
        [_searchCancelButton removeFromSuperview];
    }
}

#pragma 获取厂号列表
- (void)addBrandListDataWithNewDic{
    
    
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"add_brand",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"add_brand",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"sid":_fid,@"brand_sn":_searchBar.text}];
    debugLog(@"sitedataparparamsams:%@",params);
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"addBrandListparams:%@",data);
        if (![data[@"error"] intValue]) {
            [self.view Message:@"添加成功" HiddenAfterDelay:1.0];
            [self searchBrandListDataWithNewDic];
        }
        else {
            [_MBHUD setLabelText:@"网络故障。。。"];
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
- (void)getBrandListDataWithNewDic{
    
    
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"get_brand_list",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"get_brand_list",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"sid":_fid}];
    debugLog(@"sitedataparparamsams:%@",params);
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"sitedataparams:%@",data);
        if (![data[@"error"] intValue]) {
            
                _brandListMD = [[brandListModel alloc] initWithDictionary:data[@"content"] error:nil];
            self.rightSecondAgencyArray=_brandListMD.brand_list;
            [_myTableView reloadData];
            }
        else {
            [_MBHUD setLabelText:@"网络故障。。。"];
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
- (void)searchBrandListDataWithNewDic{
    
    
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"get_brand_list",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"get_brand_list",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"sid":_fid,@"brand_sn":_searchBar.text}];
    debugLog(@"sitedataparparamsams:%@",params);
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"sitedataparams:%@",data);
        if (![data[@"error"] intValue]) {
            
            _brandListMD = [[brandListModel alloc] initWithDictionary:data[@"content"] error:nil];
            self.rightSecondAgencyArray=_brandListMD.brand_list;
            [_myTableView reloadData];
        }
        else {
            [_MBHUD setLabelText:@"网络故障。。。"];
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
- (void)addgoodsNameListWithNewDic{
    
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"add_base",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"add_base",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"cat_id":_fid,@"base_name":_searchBar.text}];
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"addgoodsNameparams:%@",data);
        if (![data[@"error"] intValue]) {
            [self.view Message:@"添加成功" HiddenAfterDelay:1.0];
            [self searchgoodsNameListWithNewDic];
            
        } else {
            [_MBHUD setLabelText:@"网络故障。。。"];
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
- (void)getgoodsNameListWithNewDic{
    
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"get_goods_name",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"get_goods_name",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"cat_id":_fid}];
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"goodsNamedataparams:%@",data);
        if (![data[@"error"] intValue]) {
           
            _goodsNameListMD = [[goodsNameListModel alloc] initWithDictionary:data[@"content"] error:nil];
            self.rightSecondAgencyArray=_goodsNameListMD.goods_name_list;
            [_myTableView reloadData];
            
        } else {
            [_MBHUD setLabelText:@"网络故障。。。"];
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

- (void)searchgoodsNameListWithNewDic{
    
    NSString *Sign = [NSString stringWithFormat:@"%@%@%@",@"seller_offer",@"get_goods_name",ConfigNetAppKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"get_goods_name",@"sign":[TYDPManager md5:Sign],@"model":@"seller_offer",@"cat_id":_fid,@"goods_name":_searchBar.text}];
    [TYDPManager tydp_basePostReqWithUrlStr:@"" params:params success:^(id data) {
        debugLog(@"goodsNamedataparams:%@",data);
        if (![data[@"error"] intValue]) {
            
            _goodsNameListMD = [[goodsNameListModel alloc] initWithDictionary:data[@"content"] error:nil];
            self.rightSecondAgencyArray=_goodsNameListMD.goods_name_list;
            [_myTableView reloadData];
            
        } else {
            [_MBHUD setLabelText:@"网络故障。。。"];
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


#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    debugLog(@"_rightSecondAgencyArray.count:%ld",_rightSecondAgencyArray.count);
    return _rightSecondAgencyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
        OfferRightViewCell *cell = [OfferRightViewCell cellWithTableView:tableView];
        [cell.mainImageView setImage:[UIImage imageNamed:@"offer_line_blue"]];
        [cell.nameLabel setTextColor:[UIColor lightGrayColor]];
            //除产品cell外其它cell的处理过程
            NSString *agencyString = [[NSString alloc] init];
    debugLog(@"_goodsCharacterArr:%@",_goodsCharacterArr[0]);
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (_firstFrontSelectedRowNumber){
                case 100:{
                    FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                    break;
                }
                case 101:{
                    FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                    break;
                }
                case 102:{
                    TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                    break;
                }
                case 103:{
                    goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                    break;
                }
                case 104:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                case 402:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                default:
                    break;
            }
        }
        else
        {
        if (_goods_num==2) {
            switch (_firstFrontSelectedRowNumber){
                case 100:{
                    FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                    break;
                }
                case 101:{
                    FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                    break;
                }
                case 102:{
                    TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                    break;
                }
                case 103:{
                    goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                    break;
                }
                case 104:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                case 402:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                default:
                    break;
            }
        }
        else if (_goods_num==4) {
            switch (_firstFrontSelectedRowNumber){
                case 100:{
                    FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                    break;
                }
                case 101:{
                    FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                    break;
                }
                case 102:{
                    TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                    break;
                }
                case 103:{
                    goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                    break;
                }
                case 104:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                    
                case 300:{
                    FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                    break;
                }
                case 301:{
                    FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                    break;
                }
                case 302:{
                    TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                    break;
                }
                case 303:{
                    goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                    break;
                }
                case 304:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                    
                case 602:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                default:
                    break;
            }
        }
        else
        {
            switch (_firstFrontSelectedRowNumber){
                case 100:{
                    FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                    break;
                }
                case 101:{
                    FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                    break;
                }
                case 102:{
                    TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                    break;
                }
                case 103:{
                    goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                    break;
                }
                case 104:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                    
                case 300:{
                    FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                    break;
                }
                case 301:{
                    FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                    break;
                }
                case 302:{
                    TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                    break;
                }
                case 303:{
                    goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                    break;
                }
                case 304:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                case 500:{
                    FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                    break;
                }
                case 501:{
                    FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                    break;
                }
                case 502:{
                    TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                    break;
                }
                case 503:{
                    goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                    break;
                }
                case 504:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                case 802:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                default:
                    break;
            }
        }
    }
    }
    
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (_firstFrontSelectedRowNumber){
                    
                case 100:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                case 104:{
                    FilterSellListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                    
                case 200:{
                    FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                    break;
                }
                case 201:{
                    FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                    break;
                }
                case 202:{
                    TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                    break;
                }
                case 203:{
                    goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                    break;
                }
                case 204:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                case 502:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    agencyString = [NSString stringWithFormat:@"%@",model.val];
                    break;
                }
                default:
                    break;
            }
        }
        else
        {
            if (_goods_num==2) {
                switch (_firstFrontSelectedRowNumber){
                        
                    case 100:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                    case 104:{
                        FilterSellListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                        
                    case 200:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                        break;
                    }
                    case 201:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        break;
                    }
                    case 202:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                        break;
                    }
                    case 203:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                        break;
                    }
                    case 204:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                    case 502:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                    default:
                        break;
                }
            }
            else if (_goods_num==4)
            {
                switch (_firstFrontSelectedRowNumber){
                        
                    case 100:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                    case 104:{
                        FilterSellListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                        
                    case 200:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                        break;
                    }
                    case 201:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        break;
                    }
                    case 202:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                        break;
                    }
                    case 203:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                        break;
                    }
                    case 204:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                    case 400:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                        break;
                    }
                    case 401:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        break;
                    }
                    case 402:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                        break;
                    }
                    case 403:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                        break;
                    }
                    case 404:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                    case 702:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                    default:
                        break;
                }
            }
            else
            {
                switch (_firstFrontSelectedRowNumber){
                        
                    case 100:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                    case 104:{
                        FilterSellListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                        
                    case 200:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                        break;
                    }
                    case 201:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        break;
                    }
                    case 202:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                        break;
                    }
                    case 203:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                        break;
                    }
                    case 204:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                    case 400:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                        break;
                    }
                    case 401:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        break;
                    }
                    case 402:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                        break;
                    }
                    case 403:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                        break;
                    }
                    case 404:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                    case 600:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.site_name];
                        break;
                    }
                    case 601:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        break;
                    }
                    case 602:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.cat_name];
                        break;
                    }
                    case 603:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.goods_name];
                        break;
                    }
                    case 604:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }

                    case 902:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        agencyString = [NSString stringWithFormat:@"%@",model.val];
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }
    
            //其它cell
            [cell.nameLabel setText:[NSString stringWithFormat:@"%@",agencyString]];
            [cell.nameLabel setTextColor:[UIColor lightGrayColor]];
            UIImage *selectedImage = [UIImage imageNamed:@"offer_icon_right"];
            [cell.indicateImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).with.offset(-MiddleGap);
                make.centerY.mas_equalTo(cell.contentView);
                make.width.mas_equalTo(selectedImage.size.width);
                make.height.mas_equalTo(selectedImage.size.height);
            }];
//            //判断是否为选中状态 奇数为选中 偶数为未选中
//            if (_otherCellSaveFlagStateArray.count) {
//                if ([_otherCellSaveFlagStateArray[indexPath.row] intValue]%2) {
//                    [cell.indicateImageView setImage:selectedImage];
//                } else {
//                    [cell.indicateImageView setImage:nil];
//                }
                cell.containerView.hidden = YES;
           
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"7"])//现货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
    
            switch (_firstFrontSelectedRowNumber){
        case 100:{
            FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
            _signString = [NSString stringWithFormat:@"%@",model.site_name];
            _signIdString=[NSString stringWithFormat:@"%@",model.id];
            break;
        }
        case 101:{
            FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
            _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
            _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
            break;
        }
        case 102:{
            TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
            _signString = [NSString stringWithFormat:@"%@",model.cat_name];
            _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
            break;
        }
        case 103:{
            goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
            _signString = [NSString stringWithFormat:@"%@",model.goods_name];
            _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
            break;
        }
       
        case 402:{
            offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
            _signString = [NSString stringWithFormat:@"%@",model.val];
            _signIdString=[NSString stringWithFormat:@"%@",model.id];
            break;
        }
            default:
            break;
    }
        }
        else//整柜
        {
            if (_goods_num==2) {
                switch (_firstFrontSelectedRowNumber){
                    case 100:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 101:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 102:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 103:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                        
                    case 402:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    default:
                        break;
                }
            }
            else if (_goods_num==4) {
                switch (_firstFrontSelectedRowNumber){
                    case 100:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 101:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 102:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 103:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                    case 300:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 301:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 302:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 303:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                    case 602:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    default:
                        break;
                }
            }
            else
            {
                switch (_firstFrontSelectedRowNumber){
                    case 100:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 101:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 102:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 103:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                    case 300:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 301:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 302:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 303:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                    case 500:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 501:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 502:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 503:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                    case 802:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }

    if ([[_goodsCharacterArr objectAtIndex:0] isEqualToString:@"6"])//期货
    {
        if ([[_goodsCharacterArr objectAtIndex:1] isEqualToString:@"4"])//零售
        {
            switch (_firstFrontSelectedRowNumber){
                case 100:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    _signString = [NSString stringWithFormat:@"%@",model.val];
                    _signIdString=[NSString stringWithFormat:@"%@",model.id];
                    break;
                }
                case 104:{
                    FilterSellListModel *model = _rightSecondAgencyArray[indexPath.row];
                    _signString = [NSString stringWithFormat:@"%@",model.val];
                    _signIdString=[NSString stringWithFormat:@"%@",model.id];
                    break;
                }

                case 200:{
                    FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                    _signString = [NSString stringWithFormat:@"%@",model.site_name];
                    _signIdString=[NSString stringWithFormat:@"%@",model.id];
                    break;
                }
                case 201:{
                    FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                    _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                    _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                    break;
                }
                case 202:{
                    TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                    _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                    _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                    break;
                }
                case 203:{
                    goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                    _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                    _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                    break;
                }
                    
                case 502:{
                    offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                    _signString = [NSString stringWithFormat:@"%@",model.val];
                    _signIdString=[NSString stringWithFormat:@"%@",model.id];
                    break;
                }
                default:
                    break;
            }
        }
        else//整柜
        {
            if (_goods_num==2) {
                switch (_firstFrontSelectedRowNumber){
                    case 100:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 104:{
                        FilterSellListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                        
                    case 200:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 201:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 202:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 203:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                        
                    case 502:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    default:
                        break;
                }
            }
            else if (_goods_num==4) {
                switch (_firstFrontSelectedRowNumber){
                    case 100:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 104:{
                        FilterSellListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                        
                    case 200:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 201:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 202:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 203:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                    case 400:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 401:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 402:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 403:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                    case 702:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    default:
                        break;
                }
            }
            else
            {
                switch (_firstFrontSelectedRowNumber){
                    case 100:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 104:{
                        FilterSellListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                        
                    case 200:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 201:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 202:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 203:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                    case 400:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 401:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 402:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 403:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                    case 600:{
                        FilterSiteListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.site_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    case 601:{
                        FilterSiteBrandListModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.brand_sn];
                        _signIdString=[NSString stringWithFormat:@"%@",model.brand_id];
                        break;
                    }
                    case 602:{
                        TopCategoryModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.cat_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.cat_id];
                        break;
                    }
                    case 603:{
                        goodsNameModel *model =_rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.goods_name];
                        _signIdString=[NSString stringWithFormat:@"%@",model.goods_id];
                        break;
                    }
                    case 902:{
                        offerTypeModel *model = _rightSecondAgencyArray[indexPath.row];
                        _signString = [NSString stringWithFormat:@"%@",model.val];
                        _signIdString=[NSString stringWithFormat:@"%@",model.id];
                        break;
                    }
                    default:
                        break;
                }
            }
        }

    }

    [self leftItemClicked:nil];
    [_delegate selectTitleClick:_signString andId:_signIdString byTag:self.view.tag];
}

- (void)viewWillAppear:(BOOL)animated {
    debugLog(@"_goodsCharacterArr222:%@",_goodsCharacterArr[0]);
    [self setUpNavigationBar];
    self.navigationController.navigationBarHidden = YES;
    [MobClick beginLogPageView:@"选择界面"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [MobClick endLogPageView:@"选择界面"];
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
