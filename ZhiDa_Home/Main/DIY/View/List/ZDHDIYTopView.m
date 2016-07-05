//
//  ZDHDIYTopView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHDIYTopView.h"
#import "ZDHDIYTopImageView.h"
//Libs
#import "Masonry.h"
@interface ZDHDIYTopView()
@property (strong, nonatomic) ZDHDIYTopImageView *leftView;
@property (strong, nonatomic) ZDHDIYTopImageView *rightView;
@end

@implementation ZDHDIYTopView
#pragma mark - Init methods
- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = [UIColor colorWithRed:232/256.0 green:234/256.0 blue:235/256.0 alpha:1];
    self.userInteractionEnabled = YES;
    //左侧View
    _leftView = [[ZDHDIYTopImageView alloc] init];
    [_leftView setTopViewMode:kLeftMode];
    [self addSubview:_leftView];
    //右侧View
    _rightView = [[ZDHDIYTopImageView alloc] init];
    [_rightView setTopViewMode:kRightMode];
    [self addSubview:_rightView];
}
- (void)setSubViewLayout{
    //左侧View
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_centerX);
    }];
    //右侧View
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftView.mas_right);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//创建空间按钮
- (void)creatSpaceTitleButtonWithArray:(NSArray *)spaceTitleArray{
    [_leftView reloadViewWithArray:spaceTitleArray];
}
//创建样式按钮
- (void)creatStyleTitleButtonWithArray:(NSArray *)styleTitleArray{
    [_rightView reloadViewWithArray:styleTitleArray];
}

@end
