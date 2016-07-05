//
//  ZDHProductDetailViewHeaderView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductDetailViewHeaderView.h"
//Lib
#import "Masonry.h"
@interface ZDHProductDetailViewHeaderView()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *backView;
@end
@implementation ZDHProductDetailViewHeaderView
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
    //背景
    _backView = [[UIView alloc] init];
    [self addSubview:_backView];
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:25];
    [_backView addSubview:_titleLabel];
}
- (void)setSubViewLayout{
    //背景
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(self);
    }];
    //标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backView.mas_centerY);
        make.left.equalTo(12);
        make.height.equalTo(50);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新标题
- (void)reloadTitleName:(NSString *)title{
    _titleLabel.text = title;
}
//使用大标题
- (void)useBigTitle{
    _titleLabel.font = [UIFont systemFontOfSize:25];
}
//使用小标题
- (void)useSmallTitle{
    _titleLabel.font = [UIFont systemFontOfSize:17];
}
@end
