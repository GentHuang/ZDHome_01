//
//  ZDHHomePageHotSellCellView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHHomePageHotSellCellView.h"
//Libs
#import "Masonry.h"
//Macros
#define kTitleFontSize 18
#define kDescFontSize 15

@interface ZDHHomePageHotSellCellView()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UIImageView *photoView;
@end

@implementation ZDHHomePageHotSellCellView
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
//初始化UI
- (void)createUI{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    //图片
    _photoView = [[UIImageView alloc] init];
    //不拉伸图片
    _photoView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_photoView];
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONTSIZESBOLD(kTitleFontSize);
    [self addSubview:_titleLabel];
    //描述
    _descLabel = [[UILabel alloc] init];
    _descLabel.font = FONTSIZES(kDescFontSize);
    _descLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_descLabel];
}
//选择图片的Size
- (void)setViewSize:(ViewSize)size{
    switch (size) {
        case 0:
            [self setBigSize];
            break;
        case 1:
            [self setMidSize];
            break;
        case 2:
            [self setSmallRightSize];
            break;
        case 3:
            [self setSmallLeftSize];
            break;
        default:
            break;
    }
}
- (void)setBigSize{
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(2);
        make.height.equalTo(195);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(200);
        make.left.equalTo(15);
        make.right.equalTo(0);
        make.height.equalTo(@kTitleFontSize);
    }];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(@0);
        make.height.equalTo(@kDescFontSize);
    }];
}
- (void)setMidSize{
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(1);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.equalTo(210);
        make.width.mas_equalTo(210);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(200);
        make.left.equalTo(15);
        make.right.equalTo(0);
        make.height.equalTo(@kTitleFontSize);
    }];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(0);
        make.height.equalTo(@kDescFontSize);
    }];
}
- (void)setSmallRightSize{
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(1);
        make.centerX.mas_equalTo(self.mas_centerX).with.offset(20);
        make.height.equalTo(120);
        make.width.mas_equalTo(120);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(75);
        make.left.equalTo(15);
        make.right.equalTo(0);
        make.height.equalTo(@kTitleFontSize);
    }];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_titleLabel.mas_left);
        make.width.equalTo(_titleLabel.mas_width);
        make.height.equalTo(@kDescFontSize);
    }];
    
}
- (void)setSmallLeftSize{
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2);
        make.left.mas_equalTo(2);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(120);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(75);
        make.left.equalTo(_photoView.mas_right);
        make.right.equalTo(0);
        make.height.equalTo(20);
    }];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_titleLabel.mas_left);
        make.width.equalTo(_titleLabel.mas_width);
        make.height.equalTo(_titleLabel.mas_height);
    }];
    
}

#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新图片
- (void)reloadPhotoView:(NSString *)photoImage{
    
    [_photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,photoImage]]];
//    NSLog(@"连接-------》%@",[NSString stringWithFormat:DESIGNIMGURL,photoImage]);
}
//刷新文字
- (void)reloadTitle:(NSString *)title desc:(NSString *)desc{
    _titleLabel.text = title;
    _descLabel.text = desc;
}

@end
