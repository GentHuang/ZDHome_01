//
//  ZDHSearchBigCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHSearchBigButton.h"
//Lib
#import "Masonry.h"
@implementation ZDHSearchBigButton
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
    [self setBackgroundImage:[UIImage imageNamed:@"src_btn_nol2"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"src_btn_sel2"] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 8)];
    
}
- (void)setSubViewLayout{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(111);
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
