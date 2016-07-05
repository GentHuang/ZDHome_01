//
//  ZDDesignMethodCollectionCell.m
//  ZhiDa_Home
//
//  Created by apple on 16/3/24.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDDesignMethodCollectionCell.h"
#import <Masonry.h>
#import "ZDHProductCommonBigImageView.h"
#import "SDPieProgressView.h"
@interface ZDDesignMethodCollectionCell()
@property (strong, nonatomic) UIImageView *ProductImageView;
@property (strong, nonatomic) SDPieProgressView *pv;
@end

@implementation ZDDesignMethodCollectionCell
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
    _ProductImageView = [[ZDHProductCommonBigImageView alloc] init];
    _ProductImageView.backgroundColor = WHITE;
    [self.contentView addSubview:_ProductImageView];
}
- (void)setSubViewLayout{
    //bannerImageView
    [_ProductImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
#pragma mark - Event response
#pragma mark - Data request
#pragma mark - Protocol methods
#pragma mark - Other methods
//获取图片
- (void)loadImageViewWithImage:(NSString *)imageString{
    NSLog(@"产品清单图片%@",[NSString stringWithFormat:IMGURL,imageString]);
    [_ProductImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMGURL,imageString]]];
    
    if (self.pv) {
        [self.pv removeFromSuperview];
        self.pv = nil;
    }
        //网络下载
        self.pv = [[SDPieProgressView alloc]init];
        [_ProductImageView addSubview:self.pv];
        [_pv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(80);
        }];
        __weak __typeof(self) weaks = self;
        [_ProductImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,imageString]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //下载图片开始
            //加载进度条
            weaks.pv.progress = (float)receivedSize/(float)expectedSize;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //下载完成
            [weaks.pv removeFromSuperview];
            weaks.pv = nil;
        }];
}
@end
