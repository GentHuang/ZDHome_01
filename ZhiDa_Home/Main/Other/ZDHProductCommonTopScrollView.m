//
//  ZDHProductCommonTopScrollView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHProductCommonTopScrollView.h"
#import "ZDHCommonButton.h"
//Libs
#import "Masonry.h"
//Macros
#define kTopScrollViewHeight 45
#define kTitleButtonWidth 135
#define kTitleButtonTag 3000
@interface ZDHProductCommonTopScrollView()
@property (assign, nonatomic) int selectedIndex;
@property (assign, nonatomic) int buttonCount;
@property (strong, nonatomic) UIView *contentView;
@end
@implementation ZDHProductCommonTopScrollView
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
    self.showsVerticalScrollIndicator = NO;
    self.contentSize = self.frame.size;
    self.backgroundColor = [UIColor colorWithRed:232/256.0 green:234/256.0 blue:235/256.0 alpha:1];
    
    _contentView = [[UIView alloc] init];
    _contentView.userInteractionEnabled = YES;
    _contentView.backgroundColor = [UIColor clearColor];
//    _contentView.backgroundColor = [UIColor redColor];
    [self addSubview:_contentView];
}
- (void)setSubViewLayout{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@kTopScrollViewHeight);
        make.width.equalTo(@SCREEN_MAX_WIDTH);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
//        make.height.equalTo(self);
    }];
}
//刷新数据
- (void)reloadTopScrollViewWithArray:(NSArray *)array withIndex:(int)selectedIndex{
    //清除旧数据
    [self deleteSubView];
    if (array.count > 0) {
        
        _buttonCount = (int)array.count;
        _selectedIndex = 0;
        ZDHCommonButton *lastButton;
        for (int i = 0; i < array.count; i ++) {
            
            ZDHCommonButton *commonButton = [[ZDHCommonButton alloc] init];
            [commonButton setButtonWithTitleName:array[i]];
            if (i == selectedIndex) {
                
                [commonButton setIsSelected:YES];
            }else{
                
                [commonButton setIsSelected:NO];
            }
            [commonButton setTag:i+kTitleButtonTag];
            [commonButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [_contentView addSubview:commonButton];
            
            [commonButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(0);
                make.left.equalTo(@(i*kTitleButtonWidth));
                make.width.equalTo(@kTitleButtonWidth);
                make.bottom.equalTo(@0);
            }];
            lastButton = commonButton;
        }
//            [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(lastButton.mas_right);
//            }];
            [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(lastButton.mas_right);

            }];
    }
}
//刷新带地址的Title数据
- (void)reloadTopScrollViewWithImageUrlArray:(NSArray *)imageUrlArray{
    
    for (int i = 0; i < imageUrlArray.count; i ++) {
        ZDHCommonButton *allButton = (ZDHCommonButton *)[self viewWithTag:(i+kTitleButtonTag)];
        if ([imageUrlArray[i] isEqualToString:@""]) {
            allButton.enabled = NO;
        }else{
            allButton.enabled = YES;
        }
    }
}
#pragma mark - Event response
- (void)titleButtonPressed:(ZDHCommonButton *)button{
    
    for (int i = 0; i < _buttonCount; i ++) {
        ZDHCommonButton *tmpButton = (ZDHCommonButton *)[self viewWithTag:i+kTitleButtonTag];
        [tmpButton setIsSelected:NO];
    }
    [button setIsSelected:YES];
    self.selectedIndex = (int)(button.tag - kTitleButtonTag);
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//清除旧数据
- (void)deleteSubView{
    
    for (UIView *view in [_contentView subviews]) {
        
        [view removeFromSuperview];
    }
}
@end
