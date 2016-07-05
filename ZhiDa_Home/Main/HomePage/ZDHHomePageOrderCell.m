//
//  ZDHHomePageOrderCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHHomePageOrderCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kImageViewTag 8000
@implementation ZDHHomePageOrderCell
#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
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
    UIImage *backImage = [UIImage imageNamed:@"home_img_order"];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:backImage];
    backImageView.userInteractionEnabled = YES;
    backImageView.tag = kImageViewTag;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [backImageView addGestureRecognizer:tap];
    [self.contentView addSubview:backImageView];
   
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@0);
        make.size.equalTo(backImage.size);
    }];
//     NSLog(@"图片的大小----->%@",backImageView);
}
#pragma mark - Event response
//点击图片
- (void)tapPressed:(UITapGestureRecognizer *)tap{
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHHomePageOrderCell" object:self];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods

@end
