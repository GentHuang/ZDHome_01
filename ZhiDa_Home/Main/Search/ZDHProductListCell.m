//
//  ZDHProductListCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductListCell.h"
#import "SDPieProgressView.h"
//Libs
#import "Masonry.h"
//Macro
#define kContentTag 25000
@interface ZDHProductListCell()
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *photoImageView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImage *backImage;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSArray *nameArray;
@end

@implementation ZDHProductListCell
#pragma mark - Init methods
- (void)initData{
    _nameArray = @[@"品牌:",@"名称:",@"编号:"];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.layer.shadowOffset = CGSizeMake(4, 4);
    self.layer.shadowRadius = 4;
    self.layer.shadowColor = [[UIColor colorWithRed:212/256.0 green:212/256.0 blue:212/256.0 alpha:1] CGColor];
    self.layer.shadowOpacity = 0.8;
    self.backgroundColor = WHITE;
    //背景
    _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_img_bg"]];
    [self addSubview:_backImageView];
    //图片
    _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DIY_img_1"]];
    _photoImageView.contentMode  =  UIViewContentModeScaleAspectFit;
    [_backImageView addSubview:_photoImageView];
    //下划线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:212/256.0 green:212/256.0 blue:212/256.0 alpha:1];
    [_backImageView addSubview:_lineView];
    
}
- (void)setSubViewLayout{
    //背景
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //图片
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(1);
        make.right.equalTo(-6);
        make.height.equalTo(420/2);
    }];
    //下划线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_photoImageView.mas_bottom).with.offset(2);
        make.left.equalTo(11);
        make.right.equalTo(-11);
        make.height.equalTo(1);
    }];
    //创建列表
    UIView *lastLeftView;
    for (int i = 0, j=0; i < 6; i ++) {
        if(i%2==0){
            //名称标签
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.font = [UIFont systemFontOfSize:18];
            nameLabel.text = _nameArray[j];
            [_backImageView addSubview:nameLabel];
            if (i==0) {
                [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(42/2);
                    make.width.equalTo(92/2);
                    make.top.equalTo(_lineView.mas_bottom).with.offset(24);
                    make.height.equalTo(18);
                }];
            }else{
                [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(42/2);
                    make.width.equalTo(92/2);
                    make.top.equalTo(lastLeftView.mas_bottom).with.offset(9);
                    make.height.equalTo(lastLeftView.mas_height);
                }];
            }
            j++;
            lastLeftView = nameLabel;
        }else{
            //内容标签
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.textAlignment = NSTextAlignmentLeft;
            contentLabel.tag = j+kContentTag;
            contentLabel.text = @"aaa";
            [_backImageView addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastLeftView.mas_right);
                make.right.equalTo(0);
                make.height.equalTo(lastLeftView.mas_height);
                make.top.equalTo(lastLeftView.mas_top);
            }];
        }

    }
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新图片
- (void)reloadImageView:(NSString *)image{
//    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMGURL,image]]];
    
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMGURL,image]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize){
    
//        dispatch_async(dispatch_get_main_queue(), ^{
//    
//            SDPieProgressView *pv = [[SDPieProgressView alloc]init];
//            [_photoImageView addSubview:pv];
//            [pv mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.equalTo(_photoImageView);
//                make.width.height.mas_equalTo(50);
//            }];
//            pv.progress = (float)receivedSize/(float)expectedSize;
//        });
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //下载完成,删除加载动画
//        dispatch_async(dispatch_get_main_queue(), ^{
//        for (UIView *subView in _photoImageView.subviews) {
//            if ([subView isKindOfClass:[SDPieProgressView class]]) {
//                [subView removeFromSuperview];
//            }
//        }
//        });
    }];
//    NSLog(@"中心%@",[NSString stringWithFormat:IMGURL,image]);
}
//刷新标题
- (void)reloadTitle:(NSArray *)dataArray{
    for (int i = 0; i < dataArray.count; i ++) {
        UILabel *contentLabel = (UILabel *)[self viewWithTag:(i+kContentTag)];
        contentLabel.text = dataArray[i];
    }
}
//刷新品牌
- (void)reloadBrand:(NSString *)dataString{
    UILabel *contentLabel = (UILabel *)[self viewWithTag:(1+kContentTag)];
    contentLabel.text = dataString;
}
//刷新名称
- (void)reloadName:(NSString *)dataString{
    UILabel *contentLabel = (UILabel *)[self viewWithTag:(2+kContentTag)];
    contentLabel.text = dataString;
}
//刷新编号
- (void)reloadNum:(NSString *)dataString{
    UILabel *contentLabel = (UILabel *)[self viewWithTag:(3+kContentTag)];
    contentLabel.text = dataString;
}
@end
