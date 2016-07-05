//
//  TTCFirstPageBannerViewCell.m
//  TTC_Broadband
//
//  Created by apple on 16/1/12.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import "ZDHProductCenterBrandBottomCollectionViewCell.h"
#import "ZDHProductCenterBrandBottomImageView.h"
#import "Masonry.h"
#import "SDPieProgressView.h"

#define kCollectionCellWidth 194
#define kCellImageTag   2000

@interface ZDHProductCenterBrandBottomCollectionViewCell()
@property (strong, nonatomic) UIImageView *bannerImageView;
@property (strong, nonatomic) ZDHProductCenterBrandBottomImageView *imageBackground;
@property (strong, nonatomic) SDPieProgressView *pv;
@end

@implementation ZDHProductCenterBrandBottomCollectionViewCell
#pragma mark - Init methods
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
    _bannerImageView = [[UIImageView alloc] init];
    _bannerImageView.backgroundColor = WHITE;
    _imageBackground = [[ZDHProductCenterBrandBottomImageView alloc]initWithImage:nil];
    [self.contentView addSubview:_bannerImageView];
    [self.contentView addSubview:_imageBackground];
}
- (void)setSubViewLayout{
    _imageBackground.frame = self.contentView.bounds;
    _bannerImageView.frame = self.contentView.bounds;

}
#pragma mark - Event response
#pragma mark - Data request
#pragma mark - Protocol methods
#pragma mark - Other methods
//获取图片
- (void)loadImageViewWithImage:(id)image withIndexTag:(NSString *)indexString{
    
    if (self.pv) {
        
        [self.pv removeFromSuperview];
        self.pv = nil;
    }
    if ([indexString isEqualToString: @"1"]) {
        
        [_imageBackground setIsSelected:YES];
    }
    else{
        
        [_imageBackground setIsSelected:NO];
    }
    if ([image isKindOfClass:[UIImage class]]) {
        //已经离线下载
        _bannerImageView.image = image;
    }else{
        //网络下载
    
        self.pv = [[SDPieProgressView alloc]init];
        [_bannerImageView addSubview:self.pv];
        [self.pv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bannerImageView);
            make.width.height.mas_equalTo(50);
        }];
        __weak __typeof(self) weaks = self;
        [_bannerImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,image]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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
