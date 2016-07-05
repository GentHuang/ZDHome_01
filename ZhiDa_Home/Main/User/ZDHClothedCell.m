//
//  ZDHClothedCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHClothedCell.h"
//Libs
#import "Masonry.h"

@interface ZDHClothedCell()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIView *labelBackView;
@property (strong, nonatomic) UIImageView *photoImageView;
@end

@implementation ZDHClothedCell
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
    //LabelBackView
    _labelBackView = [[UIView alloc] init];
    _labelBackView.backgroundColor = WHITE;
    [self.contentView addSubview:_labelBackView];
    //NameLabel
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"迪马";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = FONTSIZES(20);
    [_labelBackView addSubview:_nameLabel];
    //图片
    _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"420_600"]];
    [self.contentView addSubview:_photoImageView];
}
- (void)setSubViewLayout{
    //LabelBackView
    [_labelBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(0);
        make.height.equalTo(50);
    }];
    //NameLabel
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_labelBackView);
        make.width.equalTo(_labelBackView.mas_width);
        make.height.equalTo(20);
    }];
    //图片
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(0);
        make.bottom.equalTo(_labelBackView.mas_top);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新标题
- (void)reloadNameWithString:(NSString *)nameString{
    _nameLabel.text = nameString;
}
//刷新图片
//
- (void)reloadImageWithImage:(id)imageString{
    if ([imageString isKindOfClass:[UIImage class]]) {
        //若本地有下载
        _photoImageView.image = imageString;
    }else{
        //若没有图片时
        if ([imageString isEqualToString:@""]) {
            _photoImageView.image = [UIImage imageNamed:@"420_600"];
        }else{
            __block SDPieProgressView *pv;
            if (!pv) {
                pv = [[SDPieProgressView alloc] init];
                [_photoImageView addSubview:pv];
                [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(_photoImageView);
                    make.width.height.mas_equalTo(50);
                }];
            }
            [_photoImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMGURL,imageString]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //下载图片开始
                //加载进度条
                dispatch_async(dispatch_get_main_queue(), ^{
                
                     pv.progress = (float)receivedSize/(float)expectedSize;
                });
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //下载完成
                for (UIView *subView in _photoImageView.subviews) {
                    if ([subView isKindOfClass:[SDPieProgressView class]]) {
                        [subView removeFromSuperview];
                    }
                }
            }];
        }
    }
}
@end
