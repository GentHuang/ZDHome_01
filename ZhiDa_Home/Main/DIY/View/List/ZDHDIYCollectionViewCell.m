//
//  ZDHDIYCollectionViewCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHDIYCollectionViewCell.h"
//Libs
#import "Masonry.h"

@interface ZDHDIYCollectionViewCell()
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *photoImageView;
@property (strong, nonatomic) UIImageView *shadowImageView;
@property (strong, nonatomic) UIImage *backImage;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation ZDHDIYCollectionViewCell
#pragma mark - Init methods
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    //背景阴影
    _backImage = [UIImage imageNamed:@"DIY_img_bg"];
    _backImageView = [[UIImageView alloc] initWithImage:_backImage];
    [self.contentView addSubview:_backImageView];
    //图片
    _photoImageView = [[UIImageView alloc] init];
    [_backImageView addSubview:_photoImageView];
    //标题阴影
    _shadowImageView = [[UIImageView alloc] init];
    _shadowImageView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.8];
    [_photoImageView addSubview:_shadowImageView];
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONTSIZES(20);
    _titleLabel.textColor = WHITE;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"title";
    [_shadowImageView addSubview:_titleLabel];
}
- (void)setSubViewLayout{
    //背景阴影
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //图片
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_backImageView).with.offset(-5);
        make.width.equalTo(_backImageView.mas_width);
        make.height.equalTo(_backImageView.mas_height);
    }];
    //标题阴影
    [_shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(0);
        make.height.equalTo(40);
        make.width.equalTo(_backImageView.mas_width);
    }];
    //标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_shadowImageView);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新图片
- (void)reloadImageView:(NSString *)imageString{
//    __block UIImageView *selfView = _photoImageView;
    [_photoImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,imageString]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //加载进度条
//        dispatch_async(dispatch_get_main_queue(), ^{
//        
//            SDPieProgressView *pv = [[SDPieProgressView alloc] init];
//            [selfView addSubview:pv];
//            [pv mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.mas_equalTo(selfView);
//                make.width.height.mas_equalTo(50);
//            }];
//            pv.progress = (float)receivedSize/(float)expectedSize;
//        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //下载完成
//        for (UIView *subView in selfView.subviews) {
//            if ([subView isKindOfClass:[SDPieProgressView class]]) {
//                [subView removeFromSuperview];
//            }
//        }
    }];
}
//刷新标题
- (void)reloadTitle:(NSString *)title{
    _titleLabel.text = title;
}
@end
