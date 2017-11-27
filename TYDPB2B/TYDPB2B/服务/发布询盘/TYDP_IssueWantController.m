//
//  TYDP_WantController.m
//  TYDPB2B
//
//  Created by 范井泉 on 16/7/14.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDP_IssueWantController.h"
#import "TYDP_LoginController.h"

@interface TYDP_IssueWantController ()<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    NSString *_user_id;
    NSString *_token;
    NSString *_user_name;
    NSString *_user_phone;
    MBProgressHUD *_MBHUD;
}

@property(nonatomic, strong)UIButton *cancelButton;
@property(nonatomic, strong)UITextField *tf1;
@property(nonatomic, strong)UITextField *tf2;
@end

@implementation TYDP_IssueWantController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)retBtnClick{
    if (_dismissOrPop) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)creatUI{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_return"] style:UIBarButtonItemStylePlain target:self action:@selector(retBtnClick)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bggradient_person_"] forBarMetrics:UIBarMetricsDefault];

    NSUserDefaults *userdefaul = [NSUserDefaults standardUserDefaults];
    _user_id = [userdefaul objectForKey:@"user_id"];
    _user_name = [userdefaul objectForKey:@"alias"];
    _user_phone = [userdefaul objectForKey:@"mobile_phone"];
    _token = [userdefaul objectForKey:@"token"];
    
    self.navigationItem.title = NSLocalizedString(@"Post enquiries", nil);
    
    self.view.backgroundColor = RGBACOLOR(246, 246, 246, 1);

    NSArray *titleArr = @[NSLocalizedString(@"Enquiry Subject", nil),NSLocalizedString(@"Product category", nil),NSLocalizedString(@"Enquired Products", nil),NSLocalizedString(@"No. of Enquiry", nil),NSLocalizedString(@"Range of price", nil),NSLocalizedString(@"Delivery address", nil)];
    CGFloat tmpFontSize;
    if (ScreenHeight == TYDPIphone5sHeight) {
        tmpFontSize = 13.0f;
    } else {
        tmpFontSize = 13.0f;
    }
    for (int i = 0; i<6; i++) {
        UIView  *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, (50*i+15)*Height+NavHeight, ScreenWidth, 50*Height)];
        [self.view addSubview:cellView];
        cellView.backgroundColor = [UIColor whiteColor];
        
        //灰色的线
        UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, 49*Height, ScreenWidth, 0.5)];
        [cellView addSubview:grayLine];
        grayLine.backgroundColor = RGBACOLOR(203, 203, 203, 1);
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15*Width, 0, 130*Width, 50*Height)];
        [cellView addSubview:titleLab];
        titleLab.text = titleArr[i];
        [titleLab setFont:ThemeFont(tmpFontSize)];
        if (i == 0||i == 2) {//求购标题，求购产品
            UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(145*Width, 0, ScreenWidth-115*Width, 50*Height)];
            [cellView addSubview:tf];
            tf.tag = 200+i;
            tf.font=[UIFont systemFontOfSize:14.0];
            if (i == 0) {
                tf.placeholder = NSLocalizedString(@"Enter inquiry subject", nil);
                //灰色的线
                UIView *grayLineTop = [[UIView alloc]initWithFrame:CGRectMake(0, -1, ScreenWidth, 0.5)];
                [cellView addSubview:grayLineTop];
                grayLineTop.backgroundColor = RGBACOLOR(203, 203, 203, 1);
            }else{
                tf.placeholder = NSLocalizedString(@"Enter inquiry Products", nil);
            }
        }else if (i == 1){//产品种类
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(145*Width, 0, ScreenWidth-115*Width, 50*Height)];
            [cellView addSubview:lab];
            lab.userInteractionEnabled = YES;
            lab.text =NSLocalizedString(@"Please choose", nil);
            lab.textColor = RGBACOLOR(198, 198, 204, 1);
            lab.tag = 201;
            lab.font=[UIFont systemFontOfSize:14.0];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTap)];
            [lab addGestureRecognizer:tap];
        }else if (i == 3){//求购数量
            UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(145*Width, 0, 161*Width, 50*Height)];
            [cellView addSubview:tf];
            tf.delegate = self;
            tf.tag = 200+i;
            tf.font=[UIFont systemFontOfSize:14.0];
            tf.placeholder = NSLocalizedString(@"Enter amount of enquiry", nil);
            tf.keyboardType = UIKeyboardTypeNumberPad;
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(310*Width, 0, 30*Width, 50*Height)];
            [cellView addSubview:lab];
            lab.font=[UIFont systemFontOfSize:14.0];
            lab.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"MT",nil)];
            lab.textColor = RGBACOLOR(203, 203, 203, 1);
        }else if (i == 4){//价格范围
            _tf1 = [[UITextField alloc]initWithFrame:CGRectMake(140*Width, 0, 70*Width, 50*Height)];
            [cellView addSubview:_tf1];
            _tf1.placeholder = NSLocalizedString(@"Min", nil);
            _tf1.keyboardType = UIKeyboardTypeNumberPad;
            _tf1.tag = 204;
            _tf1.delegate = self;
            _tf1.font=[UIFont systemFontOfSize:14.0];
            UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(215*Width, 0, 20*Width, 50*Height)];
            [cellView addSubview:lab1];
            lab1.text = NSLocalizedString(@"to", nil);
            [lab1 setFont:ThemeFont(tmpFontSize)];
            _tf2 = [[UITextField alloc]initWithFrame:CGRectMake(240*Width, 0, 70*Width, 50*Height)];
            _tf2.font=[UIFont systemFontOfSize:14.0];
            [cellView addSubview:_tf2];
            _tf2.placeholder = NSLocalizedString(@"Max", nil);
            _tf2.keyboardType = UIKeyboardTypeNumberPad;
            _tf2.tag = 205;
            _tf2.delegate = self;
            UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(310*Width, 0, 65*Width, 50*Height)];
            [cellView addSubview:lab2];
            lab2.font=[UIFont systemFontOfSize:13.0];
            lab2.text = NSLocalizedString(@"RMB/MT",nil);
            lab2.textColor = RGBACOLOR(203, 203, 203, 1);
        }else{//收货地
//            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-25*Width, 15*Height, 10*Width, 20*Height)];
//            [cellView addSubview:img];
//            img.image = [UIImage imageNamed:@"ico_return_choose_nor"];
//            
//            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-155*Width, 0, 120*Width, 50*Height)];
//            [cellView addSubview:lab];
//            lab.text = @"输入收货地址";
//            lab.textColor = RGBACOLOR(203, 203, 203, 1);
//            lab.textAlignment = NSTextAlignmentRight;
//            
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            [cellView addSubview:btn];
//            btn.frame = CGRectMake(0, 0, ScreenWidth, 50*Height);
//            [btn addTarget:self action:@selector(addAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
            UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(145*Width, 0, ScreenWidth - 115*Width, 50*Height)];
            [cellView addSubview:tf];
            tf.delegate = self;
            tf.tag = 206;
            tf.font=[UIFont systemFontOfSize:14.0];
            tf.placeholder = NSLocalizedString(@"Enter the receiving address", nil);
        }
    }
    //编辑备注信息
    UIView *textV = [[UIView alloc]initWithFrame:CGRectMake(0, 315*Height+NavHeight, ScreenWidth, 110*Height)];
    [self.view addSubview:textV];
    textV.backgroundColor = [UIColor whiteColor];
    
    //灰色的线
    UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, 109*Height, ScreenWidth, 0.5)];
    [textV addSubview:grayLine];
    grayLine.backgroundColor = RGBACOLOR(203, 203, 203, 1);
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15*Width, 0, ScreenWidth-30*Width, 35*Height)];
    [textV addSubview:lab];
    lab.text = NSLocalizedString(@"Please input remark info", nil);
    lab.font=[UIFont systemFontOfSize:14.0];
    lab.textColor = RGBACOLOR(203, 203, 203, 1);
    lab.tag = 300;
    
    UITextView *tv = [[UITextView alloc]initWithFrame:CGRectMake(10*Width, 0, ScreenWidth-20*Width, 110*Height)];
    [textV addSubview:tv];
    tv.backgroundColor = [UIColor clearColor];
    tv.font = [UIFont systemFontOfSize:14];
    tv.delegate = self;
    tv.tag = 500;
    
    for (int i=0; i<2; i++) {
        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, (500+50*i)*Height, ScreenWidth, 50*Height)];
        [self.view addSubview:cellView];
        cellView.backgroundColor = [UIColor whiteColor];
        
        //灰色的线
        UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, 49*Height, ScreenWidth, 0.5)];
        [cellView addSubview:grayLine];
        grayLine.backgroundColor = RGBACOLOR(203, 203, 203, 1);
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15*Width, 0, 130*Width, 50*Height)];
        [cellView addSubview:lab];
        [lab setFont:ThemeFont(tmpFontSize)];
        UILabel *tf = [[UILabel alloc]initWithFrame:CGRectMake(150*Width, 0, 200*Width, 50*Height)];
        [tf setFont:ThemeFont(tmpFontSize)];
        [cellView addSubview:tf];
        
        if (i == 0) {
            //灰色的线
            UIView *grayLineTop = [[UIView alloc]initWithFrame:CGRectMake(0, -1, ScreenWidth, 0.5)];
            [cellView addSubview:grayLineTop];
            grayLineTop.backgroundColor = RGBACOLOR(203, 203, 203, 1);
            lab.text = NSLocalizedString(@"Name of poster", nil);
            tf.text = _user_name;
        }else{
            lab.text = NSLocalizedString(@"Poster's phone NO.", nil);
            tf.text = _user_phone;
        }
    }
    
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:submitBtn];
    submitBtn.frame = CGRectMake(0, ScreenHeight-50*Height, ScreenWidth, 50*Height);
    [submitBtn.titleLabel setFont:ThemeFont(18.0)];
    [submitBtn setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.backgroundColor = mainColor;
    [submitBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    if (self.model) {
        [self configUIWithModel];
    }
    
    if (!_token||!_user_id||!_user_name||!_user_phone) {
        TYDP_LoginController *loginVC = [TYDP_LoginController new];
        [self.navigationController pushViewController:loginVC animated:NO];
    }
}

- (void)configUIWithModel{
    UITextField *titleTF = (UITextField*)[self.view viewWithTag:200];
    UILabel *typeLab = (UILabel *)[self.view viewWithTag:201];
    UITextField *goods_nameTF = (UITextField*)[self.view viewWithTag:202];
    UITextField *goods_numTF = (UITextField*)[self.view viewWithTag:203];
    UITextField *price_lowTF = (UITextField*)[self.view viewWithTag:204];
    UITextField *price_upTF = (UITextField*)[self.view viewWithTag:205];
    UITextField *addressTF = (UITextField*)[self.view viewWithTag:206];
    UITextView *memoTV = (UITextView*)[self.view viewWithTag:500];
    titleTF.text = self.model.title;
    typeLab.text = self.model.type;
    typeLab.textColor = [UIColor blackColor];
    goods_nameTF.text = self.model.goods_name;
    goods_numTF.text = self.model.goods_num;
    price_lowTF.text = self.model.price_low;
    price_upTF.text = self.model.price_up;
    addressTF.text = self.model.address;
    memoTV.text = self.model.memo;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"发布询盘界面"];
}
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"发布询盘界面"];
}
//添加收货地址
- (void)addAddressBtnClick{
    [self removeKeyboard];
    NSLog(@"添加收货地址");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    UILabel *lab = (UILabel *)[self.view viewWithTag:300];
    lab.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        UILabel *lab = (UILabel *)[self.view viewWithTag:300];
        lab.hidden = NO;
    }
}

//全屏除了输入框以为的点击事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeKeyboard];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {

}
//收键盘
- (void)removeKeyboard{
    UITextView *tv = [(UITextView *)self.view viewWithTag:500];
    [tv resignFirstResponder];
    for (int i = 200; i<206; i++) {
        UITextField *tf = [(UITextField *)self.view viewWithTag:i];
        [tf resignFirstResponder];
    }
}

- (void)chooseTap{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Pork", nil),NSLocalizedString(@"Beef", nil),NSLocalizedString(@"Lamb", nil),NSLocalizedString(@"Poultry", nil),NSLocalizedString(@"Seafoods", nil),NSLocalizedString(@"Other", nil), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSArray *typeArr = @[NSLocalizedString(@"Pork", nil),NSLocalizedString(@"Beef", nil),NSLocalizedString(@"Lamb", nil),NSLocalizedString(@"Poultry", nil),NSLocalizedString(@"Seafoods", nil),NSLocalizedString(@"Other", nil)];
    UILabel *lab = [(UILabel*)self.view viewWithTag:201];
    lab.text = typeArr[buttonIndex];
    lab.textColor = [UIColor blackColor];
}

- (void)creatHUD{
    if (!_MBHUD) {
        _MBHUD = [[MBProgressHUD alloc] init];
        [self.view addSubview:_MBHUD];
    }
    [_MBHUD setAnimationType:MBProgressHUDAnimationFade];
    [_MBHUD setMode:MBProgressHUDModeText];
    [_MBHUD setLabelText:nil];
    [_MBHUD show:YES];
}

- (void)requestData{
    [self creatHUD];
    if ([_tf1.text intValue] > [_tf2.text intValue]) {
        [_MBHUD setLabelText:NSLocalizedString(@"The price range is reversed", nil)];
        [_MBHUD hide:YES afterDelay:1];
    } else {
        UITextField *titleTF = (UITextField*)[self.view viewWithTag:200];
        UILabel *typeLab = (UILabel *)[self.view viewWithTag:201];
        UITextField *goods_nameTF = (UITextField*)[self.view viewWithTag:202];
        UITextField *goods_numTF = (UITextField*)[self.view viewWithTag:203];
        UITextField *price_lowTF = (UITextField*)[self.view viewWithTag:204];
        UITextField *price_upTF = (UITextField*)[self.view viewWithTag:205];
        UITextField *addressTF = (UITextField*)[self.view viewWithTag:206];
        UITextView *memoTV = (UITextView*)[self.view viewWithTag:500];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary: @{@"model":@"other",@"action":@"save_purchase",@"sign":[TYDPManager md5:[NSString stringWithFormat:@"othersave_purchase%@",ConfigNetAppKey]],@"user_id":_user_id,@"token":_token,@"goods_name":goods_nameTF.text,@"title":titleTF.text,@"goods_num":goods_numTF.text,@"price_low":price_lowTF.text,@"price_up":price_upTF.text,@"address":addressTF.text,@"user_phone":_user_phone,@"memo":memoTV.text,@"type":typeLab.text}];
        for (NSString * key in params.allKeys) {
            if ([[params objectForKey:key] isEqualToString:@""]) {
                [self.view Message:NSLocalizedString(@"Missing parameters", nil) HiddenAfterDelay:1.0];
                return;
            }
        }
        params[@"user_name"]=_user_name;
        if (self.model) {
            [params setObject:self.model.Id forKey:@"id"];
        }
        [TYDPManager tydp_basePostReqWithUrlStr:PHPURL params:params success:^(id data) {
            NSLog(@"%@",data);
            if ([data[@"error"]isEqualToString:@"0"]) {
                [_MBHUD hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [_MBHUD setLabelText:data[@"message"]];
                [_MBHUD hide:YES afterDelay:1];
            }
        } failure:^(TYDPError *error) {
            NSLog(@"%@",error);
        }];
    }
}

@end
