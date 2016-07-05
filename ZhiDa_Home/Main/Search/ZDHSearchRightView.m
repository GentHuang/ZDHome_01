//
//  ZDHSearchRightView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHSearchRightView.h"
#import "ZDHRightViewRoomView.h"
#import "ZDHRightViewBrandView.h"
#import "ZDHRightViewProductView.h"
#import "ZDHRightViewStyleView.h"

//Libs
#import "Masonry.h"
@interface ZDHSearchRightView()
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) ZDHRightViewBrandView *brandView;
@property (strong, nonatomic) ZDHRightViewProductView *productView;
@property (strong, nonatomic) ZDHRightViewRoomView *roomView;
@property (strong, nonatomic) ZDHRightViewStyleView *styleView;
@end
@implementation ZDHSearchRightView
#pragma mark - Init methods
- (void)initData{
    _firstArray = [NSArray array];
    _secondArray = [NSArray array];
    _thirdArray = [NSArray array];
    _fourthArray = [NSArray array];
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
    //ContentView
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = WHITE;
    [self addSubview:_contentView];
}
- (void)setSubViewLayout{
    //ContentView
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(self);
    }];
}
#pragma mark - Event response
//点击提交
//- (void)buttonPressed:(UIButton *)button{
//    //发出通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHSearchRightView" object:self userInfo:nil];
//}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新ScrollView
- (void)reloadScrollView{
    //清空旧数据
    [self deleteSubView:_contentView];
//    //品牌
//    _brandView = [[ZDHRightViewBrandView alloc] init];
//    [_brandView reloadTitle:@"品牌:"];
//    if (_firstArray.count > 0) {
//        [_brandView reloadCell:_firstArray];
//    }
//    [_contentView addSubview:_brandView];
//    [_brandView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(10);
//        make.left.right.equalTo(0);
//    }];
//    //空间
//    _roomView = [[ZDHRightViewRoomView alloc] init];
//    [_roomView reloadTitle:@"空间:"];
//    if (_thirdArray.count > 0) {
//        [_roomView reloadCell:_thirdArray];
//    }
//    [_contentView addSubview:_roomView];
//    [_roomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_brandView.mas_bottom).with.offset(54/2);
//        make.left.right.equalTo(0);
//    }];
//    //风格
//    _styleView = [[ZDHRightViewStyleView alloc] init];
//    [_styleView reloadTitle:@"风格:"];
//    if (_fourthArray.count > 0) {
//        [_styleView reloadCell:_fourthArray];
//    }
//    [_contentView addSubview:_styleView];
//    [_styleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_roomView.mas_bottom).with.offset(54/2);
//        make.left.right.equalTo(0);
//    }];
    //商品
    _productView = [[ZDHRightViewProductView alloc] init];
    [_contentView addSubview:_productView];
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(0);//.with.offset(54/2);
        make.left.right.equalTo(0);
    }];
    //按钮背景
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = WHITE;
    [_contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(276/2);
    }];
    //提交按钮
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.hidden = YES;
//    [button setBackgroundImage:[UIImage imageNamed:@"src_btn_commit"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(backView.mas_centerX);
//        make.bottom.equalTo(backView.mas_bottom).with.offset(-20);
//        make.width.equalTo(560/2);
//        make.height.equalTo(97/2);
//    }];
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView.mas_bottom);
    }];
}
//刷新商品分类
- (void)reloadProductWithArray:(NSArray *)dataArray{
    [_productView reloadDataWithArray:dataArray];
}

//清空子View
- (void)deleteSubView:(UIView *)view{
    for (UIView *subView in view.subviews) {
        [subView removeFromSuperview];
    }
}

@end