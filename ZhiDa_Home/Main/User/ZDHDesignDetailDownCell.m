//
//  ZDHDesignDetailDownCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHDesignDetailDownCell.h"
//Libs
#import "Masonry.h"

@interface ZDHDesignDetailDownCell()
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UIImageView *photoImageView;
@property (strong, nonatomic) UIButton *suggestButton;
@end

@implementation ZDHDesignDetailDownCell

#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
- (void)awakeFromNib {
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = WHITE;
    //设计方案
    _topLabel = [[UILabel alloc] init];
    _topLabel.backgroundColor = WHITE;
    _topLabel.font = FONTSIZESBOLD(20);
    _topLabel.text = @"设计方案:";
    [self.contentView addSubview:_topLabel];
    //图片
    _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chuanglian"]];
    _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    _photoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
    [_photoImageView addGestureRecognizer:tap];
    [self.contentView addSubview:_photoImageView];
    //按钮
    _suggestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _suggestButton.layer.masksToBounds = YES;
    _suggestButton.layer.cornerRadius = 3;
    _suggestButton.layer.borderWidth = 1;
    _suggestButton.layer.borderColor = [[UIColor colorWithRed:166/256.0 green:166/256.0 blue:166/256.0 alpha:1] CGColor];
    [_suggestButton setTitle:@"中途意见>>" forState:UIControlStateNormal];
    [_suggestButton setTitleColor:[UIColor colorWithRed:91/256.0 green:91/256.0 blue:91/256.0 alpha:1] forState:UIControlStateNormal];
    [_suggestButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_suggestButton];
}
- (void)setSubViewLayout{
    //设计方案
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(18);
        make.top.equalTo(0);
        make.width.equalTo(110);
        make.height.equalTo(20);
    }];
    //图片
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLabel.mas_top);
        make.left.equalTo(_topLabel.mas_right);
        make.width.equalTo(192);
        make.height.equalTo(192);
    }];
    //按钮
    [_suggestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_photoImageView.mas_right).with.offset(78);
        make.top.equalTo(_topLabel.mas_top);
        make.width.equalTo(150);
        make.height.equalTo(40);
    }];
}
#pragma mark - Event response
//点击按钮
- (void)buttonPressed:(UIButton *)button{
    //中途意见
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHUserSuggestView" object:self userInfo:@{@"orderID":_orderID}];
}
//点击设计方案图片
- (void)imagePressed:(UITapGestureRecognizer *)tap{
    if (_planID.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHDesignDetailDownCell" object:self userInfo:@{@"planID":_planID}];
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新图片
- (void)reloadCellWithImage:(NSString *)imageString{
    //若没有图片时
    _photoImageView.image = [UIImage imageNamed:@"600_600_2"];
    if (imageString.length > 0) {
        __block SDPieProgressView *pv;
        __block ZDHDesignDetailDownCell *selfView = self;
        [_photoImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,imageString]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //下载图片开始
            //加载进度条
            if (!pv) {
                pv = [[SDPieProgressView alloc] init];
                [selfView addSubview:pv];
                [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(selfView.photoImageView);
                    make.width.height.mas_equalTo(50);
                }];
            }
            pv.progress = (float)receivedSize/(float)expectedSize;
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
@end
