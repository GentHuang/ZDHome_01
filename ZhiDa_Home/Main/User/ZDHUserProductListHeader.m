//
//  ZDHUserProductListHeader.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserProductListHeader.h"
//Lib
#import "Masonry.h"
//Macro
#define kNameFont 20

@interface ZDHUserProductListHeader()
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSArray *nameArray;
@end

@implementation ZDHUserProductListHeader
#pragma mark - Init methods
- (void)initData
{
    _nameArray = @[@"产品信息",@"单价",@"数量",@"价格"];
}
- (instancetype)init{
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
    //背景
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = WHITE;
    [self addSubview:_backView];
    //下划线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:164/256.0 green:164/256.0 blue:164/256.0 alpha:1];
    [_backView addSubview:_lineView];
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"客厅";
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_backView addSubview:_titleLabel];
    //创建列表
    for (int i = 0; i < _nameArray.count; i ++) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = _nameArray[i];
        nameLabel.font = FONTSIZES(20);
        [_backView addSubview:nameLabel];
        if (i == 0) {
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(154/2);
                make.left.equalTo(0);
                make.width.equalTo(416/2);
                make.height.equalTo(kNameFont);
            }];
        }
        if (i == 1) {
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(154/2);
                make.left.equalTo(820/2);
                make.width.equalTo(144/2);
                make.height.equalTo(kNameFont);
            }];
        }
        if (i == 2) {
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(154/2);
                make.left.equalTo(1240/2);
                make.width.equalTo(533/2);
                make.height.equalTo(kNameFont);
            }];
        }
        if (i == 3) {
            nameLabel.textAlignment = NSTextAlignmentRight;
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(154/2);
                make.right.equalTo(0);
                make.width.equalTo(165/2);
                make.height.equalTo(kNameFont);
            }];
        }
    }
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
    
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新标题
- (void)reloadTitle:(NSString *)title{
    _titleLabel.text = title;
}
@end
