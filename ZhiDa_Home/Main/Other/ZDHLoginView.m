//
//  ZDHLoginView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHLoginView.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHLoginViewViewModel.h"

//获取用户名
#import "ZDHSellMan.h"

@interface ZDHLoginView()<UITextFieldDelegate>
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UIView *backView;
//@property (strong, nonatomic) UITextField *nameText;
@property (strong, nonatomic) UITextField *pswText;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *remmenberButton;
@property (strong, nonatomic) UIButton *forgetButton;
@property (strong, nonatomic) UIButton *commitButton;
@property (strong, nonatomic) UIView *nameLine;
@property (strong, nonatomic) UIView *pswLine;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) ZDHLoginViewViewModel *vcViewModel;
@property (strong, nonatomic) NSUserDefaults *userDefault;

@end
@implementation ZDHLoginView
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHLoginViewViewModel alloc] init];
    //userDefault
    _userDefault = [NSUserDefaults standardUserDefaults];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    //BackView
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = WHITE;
    [self addSubview:_backView];
    //TopLabel
    _topLabel = [[UILabel alloc] init];
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.text = @"登录";
    _topLabel.font = FONTSIZESBOLD(32);
    [_backView addSubview:_topLabel];
    //CancelButton
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"vip_img_close"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_cancelButton];
    //NameText
    _nameText = [[UITextField alloc] init];
    _nameText.borderStyle = UITextBorderStyleNone;
    _nameText.placeholder = @"手机号/用户名";
    
    if ([[_userDefault valueForKey:@"记住账号"] boolValue]) {
        _nameText.text = [_userDefault valueForKey:@"账号"];
    }else{
        _nameText.text = @"";
    }
    _nameText.font = FONTSIZESBOLD(25);
    _nameText.delegate = self;
    [_backView addSubview:_nameText];
    //nameLine
    _nameLine = [[UIView alloc] init];
    _nameLine.backgroundColor = LIGHTGRAY;
    [_backView addSubview:_nameLine];
    //PswText
    _pswText = [[UITextField alloc] init];
    _pswText.borderStyle = UITextBorderStyleNone;
    _pswText.placeholder = @"密码";
    _pswText.font = FONTSIZESBOLD(25);
    _pswText.delegate = self;
    _pswText.returnKeyType = UIReturnKeyJoin;
    _pswText.secureTextEntry = YES;
    [_backView addSubview:_pswText];
    //PswLine
    _pswLine = [[UIView alloc] init];
    _pswLine.backgroundColor = LIGHTGRAY;
    [_backView addSubview:_pswLine];
    //记住账号
    _remmenberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _remmenberButton.selected = [[_userDefault valueForKey:@"记住账号"] boolValue];
    [_remmenberButton setTitle:@"记住账号" forState:UIControlStateNormal];
    [_remmenberButton setImage:[UIImage imageNamed:@"log_btn_rem"] forState:UIControlStateNormal];
    [_remmenberButton setImage:[UIImage imageNamed:@"log_btn_rem_sel"] forState:UIControlStateSelected];
    [_remmenberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_remmenberButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_remmenberButton];
    //忘记密码
    _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgetButton setTitleColor:PINK forState:UIControlStateNormal];
    [_forgetButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_forgetButton];
    //确认
    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitButton setBackgroundColor:[UIColor colorWithRed:196.0/225 green:0 blue:74.0/225 alpha:1]];
    [_commitButton setTitle:@"登        录" forState:UIControlStateNormal];
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:26];
    [_commitButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_commitButton];
    //登录等待
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView stopAnimating];
    [_commitButton addSubview:_indicatorView];
}
- (void)setSubViewLayout{
    //BackView
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(490);
        make.height.equalTo(317);
    }];
    //TopLabel
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView.mas_centerX);
        make.top.equalTo(18);
        make.height.equalTo(32);
        make.width.equalTo(100);
    }];
    //CancelButton
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(11);
        make.right.equalTo(-11);
        make.width.equalTo(18);
        make.height.equalTo(20);
    }];
    //NameText
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLabel.mas_bottom).with.offset(40);
        make.left.equalTo(40);
        make.right.equalTo(-40);
        make.height.equalTo(30);
    }];
    //NameLine
    [_nameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_nameText.mas_bottom);
        make.height.equalTo(0.5);
        make.left.equalTo(_nameText.mas_left);
        make.right.equalTo(_nameText.mas_right);
    }];
    //pswText
    [_pswText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLine.mas_bottom).with.offset(30);
        make.left.equalTo(40);
        make.right.equalTo(-40);
        make.height.equalTo(30);
    }];
    //pswLine
    [_pswLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_pswText.mas_bottom);
        make.height.equalTo(0.5);
        make.left.equalTo(_pswText.mas_left);
        make.right.equalTo(_pswText.mas_right);
    }];
    //记住账号
    [_remmenberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pswLine.mas_bottom).with.offset(20);
        make.left.equalTo(_pswLine.mas_left);
        make.height.equalTo(15);
        make.width.equalTo(90);
    }];
    //忘记密码
    [_forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pswLine.mas_bottom).with.offset(20);
        make.right.equalTo(-30);
        make.height.equalTo(15);
        make.width.equalTo(100);
    }];
    //登录
    [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-17);
        make.centerX.equalTo(_backView.mas_centerX);
        make.height.equalTo(57);
        make.width.equalTo(418);
    }];
    //登录加载
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_commitButton);
    }];
}
#pragma mark - Event response
//点击回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_nameText resignFirstResponder];
    [_pswText resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [_backView layoutIfNeeded];
    }];
    [UIView commitAnimations];
}
#pragma mark - Network request
#pragma mark - Protocol methods
//UITextFieldDelegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.5 animations:^{
        [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).with.offset(-170);
        }];
        [_backView layoutIfNeeded];
    }];
    [UIView commitAnimations];
    return YES;
}
//点击模拟键盘的加入
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==_pswText) {
        [self buttonPressed:_commitButton];
    }
    return YES;
}
//点击按钮
- (void)buttonPressed:(UIButton *)button{
    __block NSString *name;
    if (button == _cancelButton) {
        //取消
        name = @"LoginCancel";
    }else if (button == _commitButton){
        //点击登录
        //先检查用户名或者密码框是否为空
        if ([_nameText.text isEqualToString:@""]) {
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alView show];
        }else if([_pswText.text isEqualToString:@""]){
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alView show];
        }else{
            //开始登录
            [self startDownloading];
            [_vcViewModel getLoginWithName:_nameText.text PSW:_pswText.text Success:^(NSMutableArray *resultArray) {
               //登录成功
                name = @"LoginSuccess";
                //存入沙盒
                [[NSUserDefaults standardUserDefaults]setValue:[ZDHSellMan shareInstance].realName forKey:@"用户名"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //发出通知
                [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:nil];
                [self stopDownloading];
            } fail:^(NSError *error) {
                //登录失败
                [self stopDownloading];
                UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alView show];
            }];
        }
    }else if (button == _forgetButton){
        //忘记密码
        name = @"ForgetRequest";
    }else if (button == _remmenberButton){
        //记住账号
        button.selected = !button.selected;
        [_userDefault setValue:[NSNumber numberWithBool:button.selected] forKey:@"记住账号"];
    }
    //使用了记住账号
    if (_remmenberButton.selected) {
        [_userDefault setValue:_nameText.text forKey:@"账号"];
    }else{
        [_userDefault setValue:@"" forKey:@"账号"];
    }
    [_userDefault synchronize];

    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:nil];
}
#pragma mark - Other methods
//加载登录
- (void)startDownloading{
    [_commitButton setTitle:@"" forState:UIControlStateNormal];
    [_indicatorView startAnimating];
}
//停止登录
- (void)stopDownloading{
    [_commitButton setTitle:@"登        录" forState:UIControlStateNormal];
    [_indicatorView stopAnimating];
}

@end
