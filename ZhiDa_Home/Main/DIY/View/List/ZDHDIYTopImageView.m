//
//  ZDHDIYTopImageView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHDIYTopImageView.h"
//Libs
#import "Masonry.h"
//Macros
#define kViewWidth 512
#define kLabelFontSize 22
#define kButtonHeight 31
#define kButtonWidth 80
#define kButtonLeftTag 10000
#define kButtonRightTag 20000
@interface ZDHDIYTopImageView()
@property (assign, nonatomic) int selectedMode;
@property (assign, nonatomic) int leftButtonCount;
@property (assign, nonatomic) int rightButtonCount;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) NSMutableArray *leftButtonSelectedArray;
@property (strong, nonatomic) NSMutableArray *rightButtonSelectedArray;
@end
@implementation ZDHDIYTopImageView
#pragma mark - Init methods
- (void)initData{
    _leftButtonSelectedArray = [NSMutableArray array];
    _rightButtonSelectedArray = [NSMutableArray array];
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
    _selectedMode = 0;
    self.userInteractionEnabled = YES;
    //左边Label
    _leftLabel = [[UILabel alloc] init];
    _leftLabel.font = FONTSIZESBOLD(kLabelFontSize);
    [self addSubview:_leftLabel];
}
- (void)setSubViewLayout{
    //左侧Label
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(29);
        make.left.equalTo(12);
        make.width.equalTo(120);
        make.height.equalTo(@kLabelFontSize);
    }];
}
#pragma mark - Event response
//点击按钮
- (void)buttonPressed:(UIButton *)button{
    if(_selectedMode == kLeftMode){
        //视觉处理
        for (int i = 0; i < _leftButtonCount; i ++) {
            UIButton *allButton = (UIButton *)[self viewWithTag:i+kButtonLeftTag];
            if (allButton != button) {
                allButton.selected = NO;
            }
        }
        button.selected = !button.selected;
        //点击左半部分按钮
        [_leftButtonSelectedArray removeAllObjects];
        NSNumber *selectedNum = [NSNumber numberWithInteger:(button.tag - kButtonLeftTag)];
        if (button.selected) {
            [_leftButtonSelectedArray addObject:selectedNum];
        }else if ( [_leftButtonSelectedArray indexOfObject:selectedNum] != NSNotFound){
            [_leftButtonSelectedArray removeObject:selectedNum];
        }
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"请选择空间" object:self userInfo:@{@"空间":_leftButtonSelectedArray}];
    }else{
        //视觉处理
        for (int i = 0; i < _rightButtonCount; i ++) {
            UIButton *allButton = (UIButton *)[self viewWithTag:i+kButtonRightTag];
            if (allButton != button) {
                allButton.selected = NO;
            }
        }
        button.selected = !button.selected;
        //点击右半部分按钮
        [_rightButtonSelectedArray removeAllObjects];
        NSNumber *selectedNum = [NSNumber numberWithInteger:(button.tag - kButtonRightTag)];
        if (button.selected) {
            [_rightButtonSelectedArray addObject:selectedNum];
        }else if ( [_rightButtonSelectedArray indexOfObject:selectedNum] != NSNotFound){
            [_rightButtonSelectedArray removeObject:selectedNum];
        }
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"请选择风格" object:self userInfo:@{@"风格":_rightButtonSelectedArray}];
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//选择模式
- (void)setTopViewMode:(TopViewMode)mode{
    _selectedMode = mode;
    switch (mode) {
        case 0:
            [self setLeftMode];
            break;
        case 1:
            [self setRightMode];
            break;
        default:
            break;
    }
}
- (void)setLeftMode{
    _leftLabel.text = @"请选择空间:";
}
- (void)setRightMode{
    _leftLabel.text = @"请选择风格:";
}
//创建按钮
- (void)reloadViewWithArray:(NSArray *)array{
    if (_selectedMode == kLeftMode) {
        _leftButtonCount = (int)array.count;
    }else{
        _rightButtonCount = (int)array.count;
    }
    _dataArray = array;
    //清空旧数据
    [self deleteAllButton];
    for (int i = 0; i < array.count; i ++) {
        UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [allButton setBackgroundImage:[UIImage imageNamed:@"DIY_img_border"] forState:UIControlStateNormal];
        [allButton setBackgroundImage:[UIImage imageNamed:@"DIY_img_border_selected"] forState:UIControlStateSelected];
        [allButton setTitle:array[i] forState:UIControlStateNormal];
        [allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [allButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        if (_selectedMode == kLeftMode) {
            _leftButtonCount = (int)array.count;
            [allButton setTag:(i+kButtonLeftTag)];
        }else{
            _rightButtonCount = (int)array.count;
            [allButton setTag:(i+kButtonRightTag)];
        }
        [self addSubview:allButton];
        if(i <= 3){
            [allButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@kButtonWidth);
                make.height.equalTo(@kButtonHeight);
                make.left.equalTo(@(145+(i*(kButtonWidth+12))));
                make.top.equalTo(25);
            }];
        }else{
            [allButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@kButtonWidth);
                make.height.equalTo(@kButtonHeight);
                make.left.equalTo(@(145+((i-4)*(kButtonWidth+12))));
                make.top.equalTo(74);
            }];
        }
    }
}
//清空旧按钮
- (void)deleteAllButton{
    if (_selectedMode == kLeftMode) {
        for (int i = 0; i < _leftButtonCount; i ++) {
            UIButton *allButton = (UIButton *)[self viewWithTag:i+kButtonLeftTag];
            [allButton removeFromSuperview];
        }
    }else{
        for (int i = 0; i < _rightButtonCount; i ++) {
            UIButton *allButton = (UIButton *)[self viewWithTag:i+kButtonRightTag];
            [allButton removeFromSuperview];
        }
    }
}
@end
