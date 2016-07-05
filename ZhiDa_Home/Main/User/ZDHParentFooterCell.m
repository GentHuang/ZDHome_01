//
//  ZDHParentFooterView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHParentFooterCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kButtonWidth 82
#define kButtonHeight 30
@interface ZDHParentFooterCell()
@property (strong, nonatomic) UIButton *logoutButton;
@property (strong, nonatomic) UIButton *changePSWButton;
@property (strong, nonatomic) UIView *blackLine;
@end

@implementation ZDHParentFooterCell
#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self setSubViewLayout];
        [self notificationRecieve];
    }
    return self;
}
#pragma mark - Life circle
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = LIGHTGRAY;
    //退出登录
    _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_logoutButton setBackgroundImage:[UIImage imageNamed:@"vip_img_btn1"] forState:UIControlStateNormal];
        [_logoutButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_logoutButton];
    //修改密码
    _changePSWButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _changePSWButton.selected = NO;
    [_changePSWButton setBackgroundImage:[UIImage imageNamed:@"vip_img_btn2"] forState:UIControlStateNormal];
    [_changePSWButton setBackgroundImage:[UIImage imageNamed:@"vip_img_btn2_selected"] forState:UIControlStateSelected];
    [_changePSWButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_changePSWButton];
    //BlackLine
    _blackLine = [[UIView alloc] init];
    _blackLine.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_blackLine];
}
- (void)setSubViewLayout{
    //黑色下划线
    [_blackLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(0.5);
        make.width.equalTo(self);
        make.height.equalTo(0.5);
    }];
    [_logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@kButtonWidth);
        make.height.equalTo(@kButtonHeight);
        make.bottom.equalTo(-17);
        make.left.equalTo(5);
    }];
    [_changePSWButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_logoutButton);
        make.left.equalTo(_logoutButton.mas_right).with.offset(5);
        make.top.equalTo(_logoutButton.mas_top);
    }];
}
#pragma mark - Event response
//接收通知
- (void)notificationRecieve{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ChangeSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ChangeCancel" object:nil];
}
//通知反馈
- (void)notificationResponse:(NSNotification *)notification{
    _changePSWButton.selected = NO;
}
//点击按钮
- (void)buttonPressed:(UIButton *)button{
    NSString *name;
    if (button == _changePSWButton) {
        //修改密码
        button.selected = YES;
        name = @"ChangePSW";
    }else{
        //退出登录
        name = @"LogoutRequest";
    }
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:nil];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
@end
