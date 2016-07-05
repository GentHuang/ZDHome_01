//
//  ZDHRightViewProductView.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

//View
#import "ZDHRightViewProductView.h"
#import "ZDHRightViewProductApartView.h"
#import "ZDHSearchSmallButton.h"
#import "ZDHSearchBigButton.h"
//Lib
#import "Masonry.h"
//Model
#import "ZDHSearchViewControllerNewListProtypelistModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeModel.h"
//Macro
#define kViewTag 26000
@interface ZDHRightViewProductView()
@property (assign, nonatomic) int buttonCount;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIView *backView;
@end
@implementation ZDHRightViewProductView
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
    //头部
    //背景
    _backView = [[UIView alloc] init];
    [self addSubview:_backView];
    //商品筛选
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"商品分类";
    _nameLabel.font = [UIFont boldSystemFontOfSize:25];
    _nameLabel.backgroundColor = WHITE;
    [_backView addSubview:_nameLabel];
}
- (void)setSubViewLayout{
    //头部
    //背景
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(152/2);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(190/2);
        make.right.equalTo(-20);
        make.height.equalTo(50);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//数组
- (void)reloadDataWithArray:(NSArray *)dataArray{
    
    //商品分类列表
    UIView *lastView;
    for (int i = 0; i < dataArray.count; i++) {
        ZDHSearchViewControllerNewListProtypelistModel *listModel = dataArray[i];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (ZDHSearchViewControllerNewListProtypelistChindtypeModel *chindModel in listModel.chindtype) {
            [titleArray addObject:chindModel.typename_conflict];
        }
        if (i== 0) {
            ZDHRightViewProductApartView *apartView =[[ZDHRightViewProductApartView alloc]init];
            [apartView reloadTitle:listModel.typename_conflict];
            [apartView reloadCell:titleArray];
            [self addSubview:apartView];
            [apartView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_backView.mas_bottom).with.offset(0);// 设置顶部距离
                make.left.right.equalTo(0);
            }];
            lastView = apartView;
        }
        else{
            ZDHRightViewProductApartView *apartView =[[ZDHRightViewProductApartView alloc]init];
            [apartView reloadTitle:listModel.typename_conflict];
            [apartView reloadCell:titleArray];
            [self addSubview:apartView];
            [apartView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(54/2);
                make.left.right.equalTo(0);
            }];
            lastView = apartView;
        }
    }
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(lastView.mas_bottom);
    }];
}

@end

