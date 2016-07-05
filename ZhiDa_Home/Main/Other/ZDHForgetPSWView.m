//
//  ZDHForgetPSWView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHForgetPSWView.h"
//Libs
#import "Masonry.h"
#import "ZDHNetworkManager.h"
#import "ZDHLoginView.h"

@interface ZDHForgetPSWView()<UITextFieldDelegate>
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UITextField *mailText;
@property (strong, nonatomic) UIView *mailLine;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *commitButton;
@property (strong, nonatomic) UIButton *bottomCancelButton;
@end
@implementation ZDHForgetPSWView
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
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
    _topLabel.text = @"找回密码";
    _topLabel.font = FONTSIZESBOLD(32);
    [_backView addSubview:_topLabel];
    //CancelButton
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"vip_img_close"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_cancelButton];
    //mailText
    _mailText = [[UITextField alloc] init];
    _mailText.borderStyle = UITextBorderStyleNone;
    _mailText.placeholder = @"请输入邮箱进行验证";
    _mailText.font = FONTSIZESBOLD(25);
    _mailText.delegate = self;
    [_backView addSubview:_mailText];
    //mailLine
    _mailLine = [[UIView alloc] init];
    _mailLine.backgroundColor = LIGHTGRAY;
    [_backView addSubview:_mailLine];
    //确认
    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitButton setBackgroundColor:[UIColor colorWithRed:196.0/225 green:0 blue:74.0/225 alpha:1]];
    [_commitButton setTitle:@"提        交" forState:UIControlStateNormal];
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:26];
    [_commitButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_commitButton];
    //取消
    _bottomCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomCancelButton setBackgroundColor:[UIColor colorWithRed:65.0/225 green:65/255.0 blue:65.0/225 alpha:1]];
    [_bottomCancelButton setTitle:@"取        消" forState:UIControlStateNormal];
    [_bottomCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bottomCancelButton.titleLabel.font = [UIFont systemFontOfSize:26];
    [_bottomCancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_bottomCancelButton];
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
        make.width.equalTo(200);
    }];
    //CancelButton
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(11);
        make.right.equalTo(-11);
        make.width.equalTo(18);
        make.height.equalTo(20);
    }];
    //mailText
    [_mailText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(40);
        make.right.equalTo(-40);
        make.height.equalTo(30);
        make.top.equalTo(_topLabel.mas_bottom).with.offset(80);
    }];
    //mailLine
    [_mailLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_mailText.mas_bottom);
        make.height.equalTo(0.5);
        make.left.equalTo(_mailText.mas_left);
        make.right.equalTo(_mailText.mas_right);
    }];
    //登录
    [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-17);
        make.left.equalTo(40);
        make.height.equalTo(57);
        make.width.equalTo(193);
    }];
    //取消
    [_bottomCancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-17);
        make.right.equalTo(-40);
        make.height.equalTo(57);
        make.width.equalTo(193);
    }];
}
#pragma mark - Event response
//点击回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_mailText resignFirstResponder];
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
    
    NSString *name;
    if (button == _cancelButton || button == _bottomCancelButton) {
        name = @"ForgetCancel";
    }else if (button == _commitButton){
        
        if ([self judgeEmailFormatWithEmailAccount:_mailText.text] == NO) {
            
            return;
        }
        name = @"ForgetCommit";
    }
    //发出通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:nil];
//--------------修改邮箱发送的通知--------------------
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:self
                                                      userInfo:@{@"Email":[NSString stringWithFormat:@"%@",_mailText.text]}];
}

//-----------------------------------------------------------
#pragma mark sendEmail
//点击提交按钮
- (void)ForgetPSWCommitEmail:(NSNotification*)notif success:(SuccessBlock)success fail:(FailBlock)fail{
    //发送反馈
    NSString *string = notif.userInfo[@"Email"];
//    if (string.length == 0) {
//        _statusMsg = @"请输入邮箱/手机号/账号";
//        fail(nil);
//    }else{
        //拼接路径
        NSString *urlstringCommimt = [NSString stringWithFormat:KForgetPWSendEmail,string];
        [[ZDHNetworkManager sharedManager] POST:urlstringCommimt parameters:nil success:^ void(AFHTTPRequestOperation * opretation , id reponstObject) {
            NSArray *responseArray = reponstObject;
            NSString *msginfoString = [[responseArray firstObject] valueForKey:@"msginfo"];
            if ([msginfoString isEqualToString:@"fail"]) {
                //反馈发送失败
                _statusMsg = @"反馈发送失败";
                fail(nil);
            }else{
                _statusMsg = @"反馈发送成功";
                //反馈发送成功
                success(nil);
            }
        } failure:^ void(AFHTTPRequestOperation * opretation, NSError * error) {
            _statusMsg = @"网络开小差";
            fail(nil);
        }];
//    }
}

#pragma mark - Other methods

-(BOOL)test:(NSNotification*)notif{
    
    NSString *string = notif.userInfo[@"Email"];
    UIAlertView *alerview = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    BOOL isEmailString;
    BOOL isPhoneString;
    if (string.length==0) {
        alerview.title = @"请输入邮箱/手机号/账号";
        [alerview show];
        return NO;
    }else{
        //制作一个正则表达式的字符串
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        //判断是否属于邮件类型
        isEmailString = [emailTest evaluateWithObject:string];
        //判断是否属于手机号
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        isPhoneString = [phoneTest evaluateWithObject:phoneTest];
        
        if (isEmailString ==YES||isPhoneString==YES) {
            //拼接路径
            NSString *urlstringCommimt = [NSString stringWithFormat:KForgetPWSendEmail,string];
            [[ZDHNetworkManager sharedManager] POST:urlstringCommimt parameters:nil success:^ void(AFHTTPRequestOperation * opretation , id reponstObject) {
                alerview.title = @"发送成功";
                [alerview show];
            } failure:^ void(AFHTTPRequestOperation * opretation, NSError * error) {
                alerview.title = @"发送失败";
                [alerview show];
            }];
            
            return YES;
        }
        else {
            alerview.title = @"格式错误";
            [alerview show];
            return NO;
        }
        return NO;
    }
}

- (BOOL) judgeEmailFormatWithEmailAccount:(NSString *)string{
    
    BOOL isEmailString;
    UIAlertView *alerview = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    if (string.length==0) {
        alerview.title = @"您还没有输入邮箱号哦~~";
        [alerview show];
        return NO;
    }
    //制作一个正则表达式的字符串
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //判断是否属于邮件类型
    isEmailString = [emailTest evaluateWithObject:string];
    if (isEmailString == NO) {
            
        alerview.title = @"您输入的不是邮箱哦~~";
        [alerview show];
        return NO;
    }
    return YES;
}

@end
