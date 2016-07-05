//
//  ZDHClothDetailCommenCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHClothDetailCommenCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kSelfWidth 75
@interface ZDHClothDetailCommenCell()
@property (assign, nonatomic) BOOL isSelected;
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) UIImage *selectedImage;
@end
@implementation ZDHClothDetailCommenCell
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
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1;
    _isSelected = NO;
    //图片
    _backImageView = [[UIImageView alloc] init];
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_backImageView];
    //选择图片
    _selectedImage = [UIImage imageNamed:@"com_img_sel"];
    _selectedImageView = [[UIImageView alloc] initWithImage:_selectedImage];
    _selectedImageView.hidden = YES;
    [self.contentView addSubview:_selectedImageView];
}
- (void)setSubViewLayout{
    //图片
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //选择图片
    [_selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_selectedImage.size);
        make.right.equalTo(0);
        make.top.equalTo(0);
    }];
}
#pragma mark - Event response
- (void)setIsSelected:(BOOL)status{
    _isSelected = status;
    if (_isSelected == YES) {
        _selectedImageView.hidden = NO;
    }else{
        _selectedImageView.hidden = YES;
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//填入图片
- (void)reloadImageView:(id)imageString{
    if ([imageString isKindOfClass:[UIImage class]]) {
        //已经离线下载
        _backImageView.image = imageString;
    }else{
        //若没有图片时
        if ([imageString isEqualToString:@""]) {
            _backImageView.image = [UIImage imageNamed:@"600_600_2"];
        }else{
            [_backImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMGURL,imageString]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //下载图片开始
                //加载进度条
                dispatch_async(dispatch_get_main_queue(), ^{
                
                   SDPieProgressView *pv = [[SDPieProgressView alloc] init];
                    [_backImageView addSubview:pv];
                    [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(_backImageView);
                        make.width.height.mas_equalTo(40);
                    }];
                    pv.progress = (float)receivedSize/(float)expectedSize;
                });
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //下载完成
                for (UIView *subView in _backImageView.subviews) {
                    if ([subView isKindOfClass:[SDPieProgressView class]]) {
                        [subView removeFromSuperview];
                    }
                }
            }];
        }
    }
}
@end

