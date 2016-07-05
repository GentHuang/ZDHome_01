//
//  ZDHSearchSmallCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHSearchSmallButton.h"
//Lib
#import "Masonry.h"
@implementation ZDHSearchSmallButton
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
    [self setBackgroundImage:[UIImage imageNamed:@"src_btn_nol3"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"src_btn_sel3"] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 8)];
}
- (void)setSubViewLayout{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(82);
        make.height.equalTo(40);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新
- (void)reloadButtonTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}
@end
