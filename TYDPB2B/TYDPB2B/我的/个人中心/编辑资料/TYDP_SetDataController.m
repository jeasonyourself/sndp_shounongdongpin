//
//  TYDP_setDataController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/15.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_SetDataController.h"
#import "TYDP_CaptchaController.h"
#import "TYDPManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TYDP_SelectAddressController.h"
#import "TYDPPhotoPickerManager.h"
#import "TYDP_ChangeMobileController.h"

@interface TYDP_SetDataController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    UITextField *_currentTF;
    NSArray *_modelArr;
    MBProgressHUD *_MBHUD;
}

@property(nonatomic, strong)TYDPPhotoPickerManager *photoPickerManager;
@property (nonatomic,copy)NSString *provinceId;//省份id
@property (nonatomic,copy)NSString *cityId;//城市id

@end

@implementation TYDP_SetDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"编辑资料界面"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"编辑资料界面"];
}

- (void)retBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.view.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    self.navigationItem.title = @"编辑资料";
    
    //头像
    UIView *viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, 99*Height)];
    [self.view addSubview:viewHead];
    viewHead.backgroundColor = [UIColor whiteColor];
    
    UIImageView*leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(20*Width, 42.5*Height, 15*Height, 15*Height)];
    [viewHead addSubview:leftImg];
    leftImg.image = [UIImage imageNamed:@"edit_icon_portrait"];
    
    UILabel *headLab = [[UILabel alloc]initWithFrame:CGRectMake(40*Width+15*Height, 30*Height, 60*Width, 40*Height)];
    [viewHead addSubview:headLab];
    headLab.text = @"头像";
    
    UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-100*Width, 17*Height, 66*Height, 66*Height)];
    [viewHead addSubview:rightImg];
    rightImg.layer.cornerRadius = 33*Height;
    rightImg.layer.masksToBounds = YES;
    if (!self.model.user_face) {
        rightImg.image = [UIImage imageNamed:@"person_head_default"];
    }else{
        [rightImg sd_setImageWithURL:[NSURL URLWithString:self.model.user_face]];//从网络获取
    }
    rightImg.userInteractionEnabled = YES;
    rightImg.tag = 300;
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHeadImg:)];
    [rightImg addGestureRecognizer:headTap];
    
    NSArray *imgArr = @[@"edit_icon_username",@"edit_icon_name",@"edit_icon_gender",@"edit_icon_phone",@"edit_icon_email",@"edit_icon_location",@"edit_icon_name",@"edit_icon_name"];
    
    NSArray *titleArr = @[@"请输入用户名",@"请输入真实姓名",@"性别",@"请输入手机号",@"请输入邮箱",@"所在地",@"店铺名称",@"店铺详情"];
    
    if (!_modelArr) {
        _modelArr = [NSArray copy];
    }
    if (!self.model) {
        _modelArr = @[@"",@"",@"",@"",@"",@"",@""];
    }else{
        _modelArr = @[self.model.user_name,self.model.alias,[self.model.sex isEqualToString:@"1"]?@"男":@"女",self.model.mobile_phone,self.model.email,self.model.address,self.model.shop_name,self.model.shop_info];
    }
    debugLog(@"uuuusertype:%@",[PSDefaults objectForKey:@"userType"]);
    int count;
    if ([[PSDefaults objectForKey:@"userType"] isEqualToString:@"1"]) {
        count=8;
    }
    else
    {
        count=6;
    }
    for (int i = 0; i<count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, (100+45*i)*Height+NavHeight, ScreenWidth, 45*Height)];
        [self.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(20*Width, 15*Height, 15*Height, 15*Height)];
        [view addSubview:leftImg];
        leftImg.image = [UIImage imageNamed:imgArr[i]];
        
        if (i == 2||i == 5) {
            UILabel *labLeft = [[UILabel alloc]initWithFrame:CGRectMake(40*Width+15*Height, 5*Height, 61*Width, 35*Height)];
            [view addSubview:labLeft];
            labLeft.text = titleArr[i];
            
            UILabel *labRight = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-200*Width, 5*Height, 180*Width, 35*Height)];
            [view addSubview:labRight];
            if (i == 2) {
                if ([self.model.sex isEqual: @"1"]) {
                    labRight.text = @"男";
                }else if([self.model.sex isEqual: @"2"]){
                    labRight.text = @"女";
                }else{
                    labRight.text = @"请选择";
                }
            }else{
                self.cityId = self.model.city;
                self.provinceId = self.model.province;
                if (!self.provinceId||!self.cityId) {
                    labRight.text = @"请选择";
                }else{
                    labRight.text = [self findAddressWithProvince:self.provinceId City:self.cityId];
                }
            }
            labRight.textAlignment = NSTextAlignmentRight;
            labRight.tag = 100+i;
            labRight.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTouch:)];
            [labRight addGestureRecognizer:labTap];
        }
        else if(i == 0){
            if ([_modelArr[i] isEqualToString:@""]||[_modelArr[i] isEqualToString:_modelArr[3]]) {
                UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(40*Width+15*Height, 5*Height, 280*Width, 35*Height)];
                [view addSubview:tf];
                tf.tag = 100+i;
                if ([_modelArr[0]isEqualToString:_modelArr[3]]) {
                    tf.text = _modelArr[0];
                }else{
                    tf.placeholder = titleArr[i];
                }
            }else{
                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(40*Width+15*Height, 5*Height, 280*Width, 35*Height)];
                [view addSubview:lab];
                lab.tag = 100+i;
                lab.text = _modelArr[i];
            }
        }else if(i == 3){//手机号码
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(40*Width+15*Height, 5*Height, 280*Width, 35*Height)];
            [view addSubview:lab];
            lab.text = _modelArr[i];
            lab.tag = 100+i;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeMobileTap)];
            [lab addGestureRecognizer:tap];
            lab.userInteractionEnabled = YES;
            
            //向右小箭头
            UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_return_choose_nor"]];
            [view addSubview:imgV];
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.right.equalTo(view).offset(-20*Width);
                make.width.mas_equalTo(10*Width);
                make.height.mas_equalTo(20*Height);
            }];
        }else{
            UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(40*Width+15*Height, 5*Height, 280*Width, 35*Height)];
            [view addSubview:tf];
//            if (i == 3) {//手机号输入框定制数字键盘
//                tf.keyboardType = UIKeyboardTypeNumberPad;
//            }
            tf.tag = 100+i;
            if ([_modelArr[i] isEqualToString:@""]) {
                tf.placeholder = titleArr[i];
            }else{
                
                tf.text = _modelArr[i];
            }
            tf.delegate = self;
//            if (i == 3) {
//                tf.keyboardType = UIKeyboardTypeNumberPad;
//                tf.frame = CGRectMake(40*Width+15*Height, 10*Height, 200*Width, 35*Height);
//                
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//                [view addSubview:btn];
//                btn.frame = CGRectMake(ScreenWidth-120*Width, 10*Height, 100*Width, 35*Height);
//                [btn setBackgroundColor:RGBACOLOR(84, 133, 222, 1)];
//                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                btn.titleLabel.font = [UIFont systemFontOfSize:15];
//                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                btn.layer.cornerRadius = 5;
//                btn.layer.masksToBounds = YES;
//                [btn addTarget:self action:@selector(getNumber) forControlEvents:UIControlEventTouchUpInside];
//            }else{
//                tf.frame = CGRectMake(40*Width+15*Height, 10*Height, 280*Width, 35*Height);
//            }
        }
    }
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:saveBtn];
    saveBtn.frame = CGRectMake(40*Width, 526*Height+NavHeight, ScreenWidth-80*Width, 40*Height);
    [saveBtn setBackgroundColor:mainColor];
    saveBtn.layer.cornerRadius = 25*Height;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeMobileTap{
    TYDP_ChangeMobileController *changeMobileVC = [TYDP_ChangeMobileController new];
    UILabel *lab = (UILabel *)[self.view viewWithTag:103];
    changeMobileVC.oldMobile = lab.text;
    [changeMobileVC retMobileAndCodeBlock:^(NSString *mobile) {
        lab.text = mobile;
    }];
    [self.navigationController pushViewController:changeMobileVC animated:YES];
}

////获取验证码
//- (void)getNumber{
//    NSLog(@"获取验证码");
//    UITextField *tf = (UITextField *)[self.view viewWithTag:103];//tag = 103
//    if (tf.text.length==11) {
//        TYDP_CaptchaController *capVC = [[TYDP_CaptchaController alloc]init];
//        capVC.mobileNum = tf.text;
//        capVC.view.frame = CurrentWindow.frame;
//        [self addChildViewController:capVC];
//        [self.view addSubview:capVC.view];
//        [CurrentWindow addSubview:capVC.view];
//    }else{
//        NSLog(@"请输入11位手机号");
//    }
//}

- (NSString *)findAddressWithProvince:(NSString*)province City:(NSString*)city{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"address" ofType:@"json"];
    NSString *strJson = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *addressArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *provinceName = [NSString new];
    NSString *cityName = [NSString new];
    for (NSDictionary *provinceData in addressArr) {
        if ([provinceData[@"id"]isEqualToString:province]) {
            provinceName = provinceData[@"name"];
            for (NSDictionary *cityData in provinceData[@"city_list"]) {
                if ([cityData[@"id"]isEqualToString:city]) {
                    cityName = cityData[@"name"];
                }
            }
        }
    }
    return [NSString stringWithFormat:@"%@ %@",provinceName,cityName];
}

//保存按钮点击事件
- (void)saveBtnClick{
    NSLog(@"保存");
   
        [self requestData];
    
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

//地点，性别选择点击事件
- (void)chooseTouch:(UIGestureRecognizer *)sender{
    if ([sender view].tag == 102) {
        NSLog(@"性别选择");
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
    }else{
        NSLog(@"所在地");
        TYDP_SelectAddressController *selectAddressVC = [TYDP_SelectAddressController new];
        [self addChildViewController:selectAddressVC];
        [selectAddressVC retTextBlock:^(NSString *addressName, NSString *privinceId, NSString *cityId) {
            UILabel *lab = (UILabel *)[self.view viewWithTag:105];
            lab.text = addressName;
            self.provinceId = privinceId;
            self.cityId = cityId;
            //            NSLog(@"addressName:%@---privinceId:%@---cityId:%@",addressName,privinceId,cityId);
        }];
        selectAddressVC.provinceId = self.model.province;
        selectAddressVC.cityId = self.model.city;
        [self.view addSubview:selectAddressVC.view];
        [CurrentWindow addSubview:selectAddressVC.view];
    }
}

//选择性别
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *Str;
    if (buttonIndex == 0) {
        Str = @"男";
    }else{
        Str = @"女";
    }
    UILabel *lab = [self.view viewWithTag:102];
    lab.text = Str;
    if ([Str isEqualToString:@"男"]) {
        self.model.sex = @"0";
    }else{
        self.model.sex = @"1";
    }
}

//换头像点击事件
- (void)changeHeadImg:(UIGestureRecognizer *)sender{
    NSLog(@"头像的tag：%ld",(long)[sender view].tag);
    _photoPickerManager = [TYDPPhotoPickerManager shared];
    [_photoPickerManager showActionSheetInView:nil fromController:self completion:^(UIImage *image) {
        UIImageView *imgV = (UIImageView*)[self.view viewWithTag:300];
        imgV.image = image;
        NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
        NSDictionary *params = @{@"model":@"user",@"action":@"edit_info",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"useredit_info%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"]};
        [TYDPManager upLoadPic:params withImage:imgV.image withName:@"head_img" withView:self.view];
    } cancelBlock:^{
        
    }];
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
    UITextField *tf1 = (UITextField*)[self.view viewWithTag:101];
    //    UITextField *tf3 = (UITextField*)[self.view viewWithTag:103];
    UITextField *tf3 = (UITextField*)[self.view viewWithTag:103];
    UITextField *tf4 = (UITextField*)[self.view viewWithTag:104];
    UITextField *tf7 = (UITextField*)[self.view viewWithTag:106];
    UITextField *tf8 = (UITextField*)[self.view viewWithTag:107];

    NSString *user_name;
    UIView *view0 = [self.view viewWithTag:100];
    if ([view0 isKindOfClass:[UITextField class]]) {
        UITextField *view0 = (UITextField *)[self.view viewWithTag:100];
        user_name = view0.text;
    }else{
        user_name = @"";
    }
    if (!self.cityId ||!self.provinceId) {
        [_MBHUD setLabelText:@"请选择您所在城市"];
        [_MBHUD hide:YES afterDelay:1];
        NSLog(@"请选择您所在城市");
    }else{
        [_MBHUD setLabelText:@"请稍后..."];
        NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
        NSDictionary *params;
         if ([[PSDefaults objectForKey:@"userType"] isEqualToString:@"0"]) {
             params = @{@"model":@"user",@"action":@"edit_info",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"useredit_info%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"alias":tf1.text,@"sex":self.model.sex,@"mobile_phone":tf3.text,@"email":tf4.text,@"city":self.cityId,@"province":self.provinceId,@"user_name":user_name};
         }
        else
        {
            params = @{@"model":@"user",@"action":@"edit_info",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"useredit_info%@",ConfigNetAppKey]],@"user_id":[userdefaul objectForKey:@"user_id"],@"token":[userdefaul objectForKey:@"token"],@"alias":tf1.text,@"sex":self.model.sex,@"mobile_phone":tf3.text,@"email":tf4.text,@"city":self.cityId,@"province":self.provinceId,@"user_name":user_name,@"shop_name":tf7.text,@"shop_info":tf8.text};
        }
        [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
//            NSLog(@"%@",data);
//            NSLog(@"%@",data[@"message"]);
            if ([data[@"error"]isEqualToString:@"0"]) {
                [_MBHUD hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
                //WY 在编辑用户信息后更新保存的plist信息
                [userdefaul setObject:tf1.text forKey:@"alias"];//用户名
                [userdefaul synchronize];
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
}

@end
