//
//  ZDHUserProductListSectionFooter.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserProductListSectionFooter.h"
//Lib
#import "Masonry.h"
//Macro
#define kNameFont 20

@interface ZDHUserProductListSectionFooter()
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@end

@implementation ZDHUserProductListSectionFooter
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
    _backView.backgroundColor = WHITE;
    [self addSubview:_backView];
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"附加";
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_backView addSubview:_titleLabel];
    //小计标题
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"客厅小计:";
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    [_backView addSubview:_nameLabel];
    //花费
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.text = @"￥20,000";
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = _titleLabel.font;
    [_backView addSubview:_priceLabel];
}
- (void)setSubViewLayout{
    //背景
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(63/2);
        make.right.equalTo(-51/2);
        make.bottom.equalTo(0);
    }];
    //下划线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-1);
        make.left.and.right.equalTo(0);
        make.height.equalTo(1);
    }];
    //标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(56/2);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(22);
    }];
    //花费
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.right.equalTo(0);
    }];
    //小计标题
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceLabel.mas_centerY);
        make.right.equalTo(_priceLabel.mas_left).with.offset(-10);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新小计
- (void)reloadNameTitle:(NSString *)title{
    _nameLabel.text = title;
}
//刷新花费
- (void)reloadPriceTitle:(NSString *)title{
    _priceLabel.text = title;
}

@end

