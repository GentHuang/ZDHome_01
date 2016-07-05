//
//  ZDHProductDetailDescCellImageView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHProductDetailCommenCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kSelfWidth 75
@interface ZDHProductDetailCommenCell()
@property (assign, nonatomic) BOOL isSelected;
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIView *loadBackView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@end
@implementation ZDHProductDetailCommenCell
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
    //等待下载
    _loadBackView = [[UIView alloc] init];
    _loadBackView.backgroundColor = WHITE;
    _loadBackView.hidden = YES;
    [self.contentView addSubview:_loadBackView];
    //
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_loadBackView addSubview:_indicatorView];
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
    //等待下载
    [_loadBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    //
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_loadBackView);
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
//下载图片
- (void)reloadImageView:(NSString *)imageString{
    //若没有图片时
    if ([imageString isEqualToString:@".gif"]) {
        _backImageView.image = [UIImage imageNamed:@"600_600_2"];
    }else{
        __block SDPieProgressView *pv;
        [_backImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,imageString]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //下载图片开始
            //加载进度条
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!pv) {
                    pv = [[SDPieProgressView alloc] init];
                    [_backImageView addSubview:pv];
                    [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(_backImageView);
                        make.width.height.mas_equalTo(40);
                    }];
                }
                pv.progress = (float)receivedSize/(float)expectedSize;
            });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //下载完成
//            dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *subView in _backImageView.subviews) {
                if ([subView isKindOfClass:[SDPieProgressView class]]) {
                    [subView removeFromSuperview];
                }
            }
//            });
        }];
    }
}
//开始下载
- (void)startDownload{
    _loadBackView.hidden = NO;
    [_indicatorView startAnimating];
}
//停止下载
- (void)stopDownload{
    _loadBackView.hidden = YES;
    [_indicatorView stopAnimating];
}
@end
