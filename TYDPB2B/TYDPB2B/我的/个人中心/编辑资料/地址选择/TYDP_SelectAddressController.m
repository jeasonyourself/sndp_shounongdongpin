//
//  TYDP_SelectAddressController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/8/12.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_SelectAddressController.h"

@interface TYDP_SelectAddressController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *_dataSource;
    NSInteger _col0currentRow;
    NSInteger _col1currentRow;
    NSString *_address;
    NSString *_ProvinceId;
    NSString *_CityId;
}
@end

@implementation TYDP_SelectAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)creatUI{
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tap];
    self.view.userInteractionEnabled = YES;
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight/3*2, ScreenWidth, ScreenHeight/3)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [view addSubview:headV];
    headV.backgroundColor = RGBACOLOR(218, 218, 218, 1);
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [headV addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(0, 0, 80, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [headV addSubview:sureBtn];
    sureBtn.frame = CGRectMake(ScreenWidth-80, 0, 80, 40);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight/3-40)];
    [view addSubview:picker];
    picker.delegate = self;
    picker.dataSource = self;
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"address" ofType:@"json"];
    NSString *strJson = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    _dataSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    for (int i = 0; i<_dataSource.count; i++) {
        NSDictionary *provinceData = _dataSource[i];
        if ([provinceData[@"id"]isEqualToString:self.provinceId]) {
            _col0currentRow = i;
            for (int j = 0; j<[provinceData[@"city_list"] count]; j++) {
                NSDictionary *cityData = provinceData[@"city_list"][j];
                if ([cityData[@"id"]isEqualToString:self.cityId]) {
                    _col1currentRow = j;
                    _address = [NSString stringWithFormat:@"%@ %@",provinceData[@"name"],cityData[@"name"]];
                }
            }
        }
    }
    [picker selectRow:_col0currentRow inComponent:0 animated:NO];
    [picker selectRow:_col1currentRow inComponent:1 animated:NO];
}

- (void)tapGesture{
    [self.view removeFromSuperview];
}

- (void)cancelBtnClick{
    [self.view removeFromSuperview];
}

- (void)sureBtnClick{
    NSLog(@"确定");
    if (!_address||!_ProvinceId||!_CityId) {
        _ProvinceId = self.provinceId;
        _CityId = self.cityId;
    }
    //    NSLog(@"_address:%@",_address);
    self.retBlock(_address,_ProvinceId,_CityId);
    [self.view removeFromSuperview];
}

- (void)retTextBlock:(sendAddressBlock)block{
    self.retBlock = block;
}

//返回有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _dataSource.count;
    }else{
        //        NSLog(@"-----%ld",[_dataSource[_col0currentRow][@"city_list"] count]);
        return [_dataSource[_col0currentRow][@"city_list"] count];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _col0currentRow = row;
        _col1currentRow = 0;
        //        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView reloadAllComponents];
    }else{
        _col1currentRow = row;
    }
    NSString *provinceName = _dataSource[_col0currentRow][@"name"];
    NSString *cityName = _dataSource[_col0currentRow][@"city_list"][_col1currentRow][@"name"];
    _address = [NSString stringWithFormat:@"%@ %@",provinceName,cityName];
    
    _ProvinceId = _dataSource[_col0currentRow][@"id"];
    _CityId = _dataSource[_col0currentRow][@"city_list"][_col1currentRow][@"id"];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return _dataSource[row][@"name"];
    }else{
        return _dataSource[_col0currentRow][@"city_list"][row][@"name"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"地址选择界面"];
}
- (void)viewWillAppear:(BOOL)animated {
    [MobClick beginLogPageView:@"地址选择界面"];
}
@end
