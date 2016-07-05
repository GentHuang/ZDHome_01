//
//  ZDHChangePSWView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHChangePSWView.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHChangePSWViewViewModel.h"
@interface ZDHChangePSWView()<UITextFieldDelegate>
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UITextField *oldText;
@property (strong, nonatomic) UIView *oldLine;
@property (strong, nonatomic) UITextField *pswText;
@property (strong, nonatomic) UIView *pswLine;
@property (strong, nonatomic) UITextField *confirmText;
@property (strong, nonatomic) UIView *confirmLine;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *commitButton;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) ZDHChangePSWViewViewModel *vcViewModel;
@end
@implementation ZDHChangePSWView
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHChangePSWViewViewModel alloc] init];
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
    //CancelButton
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"vip_img_close"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_cancelButton];
    //旧密码
    _oldText = [[UITextField alloc] init];
    _oldText.borderStyle = UITextBorderStyleNone;
    _oldText.placeholder = @"请输入旧密码";
    _oldText.font = FONTSIZESBOLD(25);
    _oldText.delegate = self;
    _oldText.secureTextEntry = YES;
    [_backView addSubview:_oldText];
    //旧密码
    _oldLine = [[UIView alloc] init];
    _oldLine.backgroundColor = LIGHTGRAY;
    [_backView addSubview:_oldLine];
    //新密码
    _pswText = [[UITextField alloc] init];
    _pswText.borderStyle = UITextBorderStyleNone;
    _pswText.placeholder = @"新密码";
    _pswText.font = FONTSIZESBOLD(25);
    _pswText.delegate = self;
    _pswText.secureTextEntry = YES;
    [_backView addSubview:_pswText];
    //新密码
    _pswLine = [[UIView alloc] init];
    _pswLine.backgroundColor = LIGHTGRAY;
    [_backView addSubview:_pswLine];
    //再次输入新密码
    _confirmText = [[UITextField alloc] init];
    _confirmText.borderStyle = UITextBorderStyleNone;
    _confirmText.placeholder = @"再次输入新密码";
    _confirmText.font = FONTSIZESBOLD(25);
    _confirmText.delegate = self;
    _confirmText.secureTextEntry = YES;
    [_backView addSubview:_confirmText];
    //再次输入新密码
    _confirmLine = [[UIView alloc] init];
    _confirmLine.backgroundColor = LIGHTGRAY;
    [_backView addSubview:_confirmLine];
     //确认
    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitButton setBackgroundColor:[UIColor colorWithRed:196.0/225 green:0 blue:74.0/225 alpha:1]];
    [_commitButton setTitle:@"确        认" forState:UIControlStateNormal];
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
        //CancelButton
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(11);
        make.right.equalTo(-11);
        make.width.equalTo(18);
        make.height.equalTo(20);
    }];
    //旧密码
    [_oldText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(33);
        make.left.equalTo(40);
        make.right.equalTo(-40);
        make.height.equalTo(30);
    }];
    //旧密码
    [_oldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_oldText.mas_bottom);
        make.height.equalTo(0.5);
        make.left.equalTo(_oldText.mas_left);
        make.right.equalTo(_oldText.mas_right);
    }];
    //新密码
    [_pswText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oldLine.mas_bottom).with.offset(45);
        make.left.equalTo(40);
        make.right.equalTo(-40);
        make.height.equalTo(30);
    }];
    //新密码
    [_pswLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_pswText.mas_bottom);
        make.height.equalTo(0.5);
        make.left.equalTo(_pswText.mas_left);
        make.right.equalTo(_pswText.mas_right);
    }];
    //确认
    [_confirmText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pswLine.mas_bottom).with.offset(45);
        make.left.equalTo(40);
        make.right.equalTo(-40);
        make.height.equalTo(30);
    }];
    //确认
    [_confirmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_confirmText.mas_bottom);
        make.height.equalTo(0.5);
        make.left.equalTo(_confirmText.mas_left);
        make.right.equalTo(_confirmText.mas_right);
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
    [_oldText resignFirstResponder];
    [_pswText resignFirstResponder];
    [_confirmText resignFirstResponder];
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
//点击按钮
- (void)buttonPressed:(UIButton *)button{
    __block NSString *name;
    if (button == _cancelButton) {
        name = @"ChangeCancel";
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:nil];
    }else if (button == _commitButton){
        //点击登录
        //先检查所有密码框是否为空
        if ([_oldText.text isEqualToString:@""]) {
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入旧密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alView show];
        }else if([_pswText.text isEqualToString:@""]){
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入新密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alView show];
        }else if([_confirmText.text isEqualToString:@""]){
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请再次输入新密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alView show];
        }else if(![_confirmText.text isEqualToString:_pswText.text]){
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入的密码不一致哦" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alView show];
        }else{
            //修改密码
            [self startDownloading];
            [_vcViewModel changePSWWithName:[ZDHSellMan shareInstance].sellManName psw:_oldText.text newpsd:_confirmText.text success:^(NSMutableArray *resultArray) {
               //修改成功
                [self stopDownloading];
                UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功，请使用新密码重新登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alView show];
                name = @"ChangeSuccess";
                //发出通知
                [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:nil];
            } fail:^(NSError *error) {
                //修改失败
                [self stopDownloading];
                UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改失败，请确认旧密码是否输入正确" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alView show];
            }];
        }
    }
}
#pragma mark - Other methods
//加载登录
- (void)startDownloading{
    [_commitButton setTitle:@"" forState:UIControlStateNormal];
    [_indicatorView startAnimating];
}
//停止登录
- (void)stopDownloading{
    [_commitButton setTitle:@"确        认" forState:UIControlStateNormal];
    [_indicatorView stopAnimating];
}
@end
