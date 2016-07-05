//
//  ZDHProductCenterBrandView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHProductCenterBrandView.h"
//Libs
#import "Masonry.h"
@implementation ZDHProductCenterBrandView
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 0.5;
    self.userInteractionEnabled = YES;
    
    _firstImageView = [[UIImageView alloc] init];
    _firstImageView.image = [UIImage imageNamed:@"app4-4.jpg"];
    [self addSubview:_firstImageView];
    [_firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@10);
        make.height.equalTo(@260);
        make.width.equalTo(self).with.offset(@-20);
    }];
    _secondImageView = [[UIImageView alloc] init];
    _secondImageView.image = [UIImage imageNamed:@"firstsample"];
    [self addSubview:_secondImageView];
    [_secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstImageView.mas_bottom).with.offset(@30);
        make.left.equalTo(_firstImageView.mas_left);
        make.width.equalTo(_firstImageView.mas_width);
        make.bottom.equalTo(@-60);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
@end
