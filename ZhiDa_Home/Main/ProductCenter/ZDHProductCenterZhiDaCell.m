//
//  ZDHProductCenterZhiDaCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHProductCenterZhiDaCell.h"
//Libs
#import "Masonry.h"
@interface ZDHProductCenterZhiDaCell()
@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@end
@implementation ZDHProductCenterZhiDaCell
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
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.shadowRadius = 10.0;
    self.layer.shadowColor = [YAHEI CGColor];
    self.layer.shadowOpacity = 0.6;
    self.backgroundColor = WHITE;
    //上部图片
    _topImageView = [[UIImageView alloc] init];
    _topImageView.image = nil;
    [self.contentView addSubview:_topImageView];
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
}
- (void)setSubViewLayout{
    //上部图片
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-50);
        make.left.and.right.equalTo(self);
        make.top.equalTo(1);
    }];
    //标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_bottom).with.offset(-25);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新图片
- (void)reloadCellWithImage:(id)imageString{
    if ([imageString isKindOfClass:[UIImage class]]) {
        //读取离线下载图片
        _topImageView.image = imageString;
    }else{
        //网络下载图片
        __block UIImageView *selfView = _topImageView;
        __block SDPieProgressView *pv;
        [_topImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,imageString]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //下载图片开始
            //加载进度条
            dispatch_async(dispatch_get_main_queue(), ^{
            if (!pv) {
                pv = [[SDPieProgressView alloc] init];
                [selfView addSubview:pv];
                [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(selfView);
                    make.width.height.mas_equalTo(50);
                }];
            }
            pv.progress = (float)receivedSize/(float)expectedSize;
            });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //下载完成
            for (UIView *subView in selfView.subviews) {
                if ([subView isKindOfClass:[SDPieProgressView class]]) {
                    [subView removeFromSuperview];
                }
            }
        }];
    }
}
//刷新标题
- (void)reloadCellWithTitleName:(NSString *)titleName{
    _titleLabel.text = titleName;
}
@end

