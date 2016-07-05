//
//  ZDHDIYDetailBottomLeftView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHDIYDetailBottomLeftView.h"
//Libs
#import "Masonry.h"
//Macros
#define kBottomViewHeight 140//162
#define kBottomViewWidth 162
@interface ZDHDIYDetailBottomLeftView()
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) UIButton *upButton;
@property (strong, nonatomic) UIButton *downButton;
@end

@implementation ZDHDIYDetailBottomLeftView
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
- (void)createUI{
    self.backgroundColor = PINK;
    //替换按钮
    _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _upButton.selected = YES;
    [_upButton setBackgroundImage:[UIImage imageNamed:@"DIY_img_nav4"] forState:UIControlStateNormal];
    [_upButton setBackgroundImage:[UIImage imageNamed:@"DIY_img_nav3"] forState:UIControlStateSelected];
    [_upButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_upButton];
    //清单按钮
    _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downButton setBackgroundImage:[UIImage imageNamed:@"DIY_img_nav1"] forState:UIControlStateNormal];
    [_downButton setBackgroundImage:[UIImage imageNamed:@"DIY_img_nav2"] forState:UIControlStateSelected];
    [_downButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_downButton];
    
    
}
- (void)setSubViewLayout{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@kBottomViewWidth);
        make.height.equalTo(@kBottomViewHeight);
    }];
    //清单按钮
    [_upButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(12);
        make.top.equalTo(8);
        make.left.equalTo(17);
        make.width.equalTo(282/2 - 5);
        make.height.equalTo(132/2 - 5);
    }];
    //替换按钮
    [_downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_upButton);
        make.left.equalTo(_upButton.mas_left);
        make.top.equalTo(_upButton.mas_bottom).with.offset(7);
//        make.top.equalTo(_upButton.mas_bottom).with.offset(15);
    }];
}
#pragma mark - Getters and setters
#pragma mark - Event response
- (void)buttonPressed:(UIButton *)button{
    _upButton.selected = NO;
    _downButton.selected = NO;
    button.selected = YES;
    if (button == _downButton) {
        self.selectedIndex = 0;
    }else{
        self.selectedIndex = 1;
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
@end
