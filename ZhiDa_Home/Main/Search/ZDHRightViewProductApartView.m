//
//  ZDHRightViewProductApartView.m
//  ZhiDa_Home
//
//  Created by apple on 16/1/22.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDHRightViewProductApartView.h"
#import "ZDHSearchSmallButton.h"
#import "ZDHSearchBigButton.h"
//Lib
#import "Masonry.h"
//Macro
#define kCellWidth 111
#define kCellHeight 40
#define kButtonTag 16000
@interface ZDHRightViewProductApartView()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *lineView;
@property (assign, nonatomic) int buttonCount;
@end

@implementation ZDHRightViewProductApartView
#pragma mark - Init methods
- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
        [self setSubViewLayout];
        [self notificationRecieve];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    //Title
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"";
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_titleLabel];
    //LineView
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:164/256.0 green:164/256.0 blue:164/256.0 alpha:1];
    [self addSubview:_lineView];
}
- (void)setSubViewLayout{
    //LineView
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(1);
        make.height.equalTo(0.5);
        make.left.equalTo(190/2);
        make.right.equalTo(-20);
    }];
    //Title
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).with.offset(22);
        make.width.equalTo(196/2);
        make.height.equalTo(20);
        make.left.equalTo(_lineView.mas_left);
    }];
    
}
#pragma mark - Event response
//点击按钮
- (void)buttonPressed:(UIButton *)button{
    if (button.selected == YES) {
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"商品" object:self userInfo:@{@"titleName":@"全不选"}];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHSearchRightView" object:self userInfo:nil];
        button.selected = NO;
    }else{
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"商品" object:self userInfo:@{@"titleName":button.titleLabel.text}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHSearchRightView" object:self userInfo:nil];
        button.selected = YES;
    }
}
//接收通知
- (void)notificationRecieve{
    //监视点击商品分类按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"商品" object:nil];
}
//通知反馈
- (void)notificationResponse:(NSNotification *)notification{
    
    //监视点击商品分类按钮
    if ([notification.name isEqualToString:@"商品"]) {
        for (int i = 0; i < _buttonCount; i ++) {
            UIButton *allButton = (UIButton *)[self viewWithTag:i+kButtonTag];
            allButton.selected = NO;
        }
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新
- (void)reloadCell:(NSArray *)array{
    //先清空数据
    [self deleteAllButton];
    _buttonCount = (int)array.count;
    UIView *lastView;
    for (int i = 0,j = 0; i < array.count; i ++,j++) {
        if (j==3) {
            j = 0;
        }
        UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [allButton setTag:(i+kButtonTag)];
        [allButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [allButton setTitle:array[i] forState:UIControlStateNormal];
        [allButton setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 8)];
        [allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [allButton setBackgroundImage:[UIImage imageNamed:@"src_btn_nol2"] forState:UIControlStateNormal];
        [allButton setBackgroundImage:[UIImage imageNamed:@"src_btn_sel2"] forState:UIControlStateSelected];
        [self addSubview:allButton];
        if (i < 3) {
            [allButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel.mas_top).with.offset(-13);
                make.left.equalTo(_titleLabel.mas_right).with.offset(j*(kCellWidth+55));
                make.width.equalTo(kCellWidth);
                make.height.equalTo(kCellHeight);
            }];
            lastView = allButton;
        }else{
            [allButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(13);
                make.left.equalTo(_titleLabel.mas_right).with.offset(j*(kCellWidth+55));
                make.width.equalTo(kCellWidth);
                make.height.equalTo(kCellHeight);
            }];
        }
        if (j == 2 || i == (array.count-1)) {
            lastView = allButton;
        }
    }
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(lastView.mas_bottom);
    }];
}
//删除所有按钮
- (void)deleteAllButton{
    if (_buttonCount > 0) {
        for (int i = 0; i < _buttonCount; i ++) {
            UIButton *allButton = (UIButton *)[self viewWithTag:(i+kButtonTag)];
            [allButton removeFromSuperview];
        }
    }
}
//更新标题
- (void)reloadTitle:(NSString *)title{
    _titleLabel.text = title;
}
@end

