//
//  ZDHMyOrderTopView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHMyOrderTopView.h"
//Libs
#import "Masonry.h"

@interface ZDHMyOrderTopView()
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) UIButton *orderButton;
@property (strong, nonatomic) UIButton *designButton;
@property (strong, nonatomic) UIButton *productButton;
@property (strong, nonatomic) UIView *lineView;
@end

@implementation ZDHMyOrderTopView
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
    self.backgroundColor = WHITE;
    //分割线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LIGHTGRAY;
    [self addSubview:_lineView];
    //我的订单
    _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_orderButton setBackgroundImage:[UIImage imageNamed:@"vip_nav_1" ] forState:UIControlStateNormal];
    [_orderButton setBackgroundImage:[UIImage imageNamed:@"vip_nav_1_selected" ] forState:UIControlStateSelected];
    [_orderButton addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _orderButton.selected = YES;
    [self addSubview:_orderButton];
    //我的设计
    _designButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_designButton setBackgroundImage:[UIImage imageNamed:@"vip_nav_2"] forState:UIControlStateNormal];
    [_designButton setBackgroundImage:[UIImage imageNamed:@"vip_nav_2_selected"] forState:UIControlStateSelected];
    [_designButton addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_designButton];
    //我的商品
    _productButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_productButton setBackgroundImage:[UIImage imageNamed:@"vip_nav_3"] forState:UIControlStateNormal];
    [_productButton setBackgroundImage:[UIImage imageNamed:@"vip_nav_3_selected"] forState:UIControlStateSelected];
    [_productButton addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_productButton];
}
- (void)setSubViewLayout{
    //分割线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(0);
        make.bottom.equalTo(-1);
        make.height.equalTo(1);
    }];
    //我的订单
    [_orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(249/2);
        make.height.equalTo(33);
        make.left.equalTo(152);
    }];
    //我的设计
    [_designButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_orderButton);
        make.top.equalTo(_orderButton.mas_top);
        make.left.equalTo(_orderButton.mas_right).with.offset(45);
    }];
    //我的商品
    [_productButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_orderButton);
        make.top.equalTo(_orderButton.mas_top);
        make.left.equalTo(_designButton.mas_right).with.offset(45);
    }];
}
#pragma mark - Event response
//点击按钮
- (void)topButtonPressed:(UIButton *)button{
    _orderButton.selected = NO;
    _designButton.selected = NO;
    _productButton.selected = NO;
    button.selected = YES;
    if (button == _orderButton) {
        self.selectedIndex = 0;
    }else if(button == _designButton){
        self.selectedIndex = 1;
    }else{
        self.selectedIndex = 2;
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods

@end
