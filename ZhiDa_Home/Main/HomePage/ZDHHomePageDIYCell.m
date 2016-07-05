//
//  ZDHHomePageDIYCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHHomePageDIYCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kDIYBackViewWidth 317
#define kfabricsViewTag 100
@implementation ZDHHomePageDIYCell
#pragma mark - Init methods
- (void)awakeFromNib {
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    for (int i = 0; i < 3; i ++) {
        //背景
        UIImageView *backView = [[UIImageView alloc] init];
        backView.userInteractionEnabled = YES;
        backView.image = [UIImage imageNamed:@"home_img_secen"];
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.width.equalTo(@(kDIYBackViewWidth));
            make.bottom.equalTo(@0);
            make.left.equalTo(@(i*(kDIYBackViewWidth+kHomePageFrontGap)+kHomePageFrontGap));
        }];
        //DIY图片
        UIImageView *fabricsView = [[UIImageView alloc] init];
        fabricsView.userInteractionEnabled = YES;
        fabricsView.tag = i + kfabricsViewTag;
        UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressed:)];
        [fabricsView addGestureRecognizer:imageViewTap];
        [backView addSubview:fabricsView];
        [fabricsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@10);
            make.size.equalTo(backView).with.offset(-20);
        }];
    }
}
//刷新Cell
- (void)reloadFabricsViewWithArray:(NSArray *)array{
    for (int i = 0; i < array.count; i ++) {
        UIImageView *fabricsView = (UIImageView *)[self viewWithTag:i + kfabricsViewTag];
//        [fabricsView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,array[i]]]];
        __block SDPieProgressView *pv;
        [fabricsView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,array[i]]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            if (!pv) {
                pv = [[SDPieProgressView alloc] init];
                [fabricsView addSubview:pv];
                [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.center.mas_equalTo(fabricsView);
                    make.width.height.mas_equalTo(50);
                }];
            }
            pv.progress = (float)receivedSize/(float)expectedSize;
            });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            for (UIView *subView in fabricsView.subviews) {
                if ([subView isKindOfClass:[SDPieProgressView class]]) {
                    
                    [subView removeFromSuperview];
                }
            }
        }];
    }
}
#pragma mark - Event response
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//点击图片
- (void)imageViewPressed:(UITapGestureRecognizer *)tap{
    UIImageView *selectedView = (UIImageView *)[tap view];
    //发出通知
    NSDictionary *dic = @{@"selectedIndex":[NSNumber numberWithInt:(int)(selectedView.tag-kfabricsViewTag)]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHHomePageDIYCell" object:self userInfo:dic];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods

@end
