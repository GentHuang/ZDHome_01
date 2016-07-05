//
//  ZDHDIYBottomRightButton.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDIYBottomRightButton.h"
//Lib
#import "Masonry.h"
//Macros
#define kUnSelectedButtonColor [[UIColor colorWithRed:223/256.0 green:223/256.0 blue:223/256.0 alpha:1] CGColor]

@interface ZDHDIYBottomRightButton()
@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UILabel *numberLabel;
@end
@implementation ZDHDIYBottomRightButton
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
    self.layer.borderWidth = 2;
    self.layer.borderColor = kUnSelectedButtonColor;
    //图片
    _topImageView = [[UIImageView alloc] init];
    _topImageView.backgroundColor = WHITE;
    [self addSubview:_topImageView];
    //型号标签
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.text = @"asdasda";
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_numberLabel];
}
- (void)setSubViewLayout{
    //型号标签
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-7);
        make.left.and.right.equalTo(0);
        make.height.equalTo(15);
        make.centerX.equalTo(self.mas_centerX);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//选择Button模式
- (void)setButtonMode:(ButtonMode)mode{
    switch (mode) {
        case 0:
            [self setBigButtonMode];
            break;
        case 1:
            [self setMidButtonMode];
            break;
        case 2:
            [self setSmallButtonMode];
            break;
        default:
            break;
    }
}
//大
- (void)setBigButtonMode{
    //大图
    [_topImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.equalTo(2);
        make.right.equalTo(-2);
        make.height.equalTo(100);
    }];
    _numberLabel.hidden = NO;
}
//中
- (void)setMidButtonMode{
    //中图
    [_topImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(223/2);
        make.width.equalTo(221/2);
    }];
    _numberLabel.hidden = YES;
}
//小
- (void)setSmallButtonMode{
    //小图
    [_topImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(2);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(241/2);
        make.width.equalTo(243/2);
    }];
    _numberLabel.hidden = NO;
}
//刷新图片
- (void)reloadImageView:(NSString *)image{
    
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,image]]];
//    __block SDPieProgressView *pv;
//    __block UIImageView *selfView = _topImageView;
//    [selfView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGURL,image]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        //下载图片开始
//        //加载进度条
//        if (!pv) {
//            pv = [[SDPieProgressView alloc] init];
//            [selfView addSubview:pv];
//            [pv mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.mas_equalTo(selfView);
//                make.width.height.mas_equalTo(50);
//            }];
//        }
//        pv.progress = (float)receivedSize/(float)expectedSize;
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        //下载完成
//        for (UIView *subView in selfView.subviews) {
//            if ([subView isKindOfClass:[SDPieProgressView class]]) {
//                [subView removeFromSuperview];
//            }
//        }
//    }];
}
//刷新型号标签
- (void)reloadNumberTitle:(NSString *)title{
    _numberLabel.text = title;
}
//选中模式
- (void)selected{
    self.layer.borderColor = [UIColor colorWithRed:233/256.0 green:0/256.0 blue:108/256.0 alpha:1].CGColor;

}
//未选中模式
- (void)unSelected{
    self.layer.borderColor = kUnSelectedButtonColor;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    
}


@end
