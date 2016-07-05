//
//  ZDHProductCenterBrandBigImageCollectionCell.m
//  ZhiDa_Home
//
//  Created by apple on 16/3/25.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDHProductCenterBrandBigImageCollectionCell.h"
#import "SDPieProgressView.h"
#import <Masonry.h>
#import "ZDHProductCommonBigImageView.h"

@interface ZDHProductCenterBrandBigImageCollectionCell()
@property (strong, nonatomic) ZDHProductCommonBigImageView *imageBackground;
@property (strong, nonatomic) SDPieProgressView *pv;
@end

@implementation ZDHProductCenterBrandBigImageCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    //bannerImageView
    _imageBackground = [[ZDHProductCommonBigImageView alloc] init];
    _imageBackground.backgroundColor = WHITE;
    [self.contentView addSubview:_imageBackground];
}
- (void)setSubViewLayout{
    //bannerImageView
    [_imageBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
#pragma mark - Event response
#pragma mark - Data request
#pragma mark - Protocol methods
#pragma mark - Other methods
//获取图片
- (void)loadImageViewWithImage:(id)image{
    if (self.pv) {
        [self.pv removeFromSuperview];
        self.pv = nil;
    }
    if ([image isKindOfClass:[UIImage class]]) {
        //已经离线下载
        _imageBackground.image = image;
    }else{
        //网络下载
        self.pv = [[SDPieProgressView alloc]init];
        [_imageBackground addSubview:self.pv];
        [_pv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(80);
        }];
        __weak __typeof(self) weaks = self;
        [_imageBackground sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,image]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //加载进度条
            dispatch_async(dispatch_get_main_queue(), ^{
               weaks.pv.progress = (float)receivedSize/(float)expectedSize;
            });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //下载完成
            [weaks.pv removeFromSuperview];
            weaks.pv = nil;
        }];
    }
}
@end
