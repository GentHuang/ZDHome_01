//
//  ZDHHomePageNewsCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

//Views
#import "ZDHHomePageNewsCell.h"
#import "ZDHHomePageNewsCellView.h"
//Libs
#import "Masonry.h"
//Macros
#define kOffsetBetweenViews 15
#define kImageViewTag 14000
@implementation ZDHHomePageNewsCell
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
    //左边视图
    ZDHHomePageNewsCellView *leftView = [[ZDHHomePageNewsCellView alloc] init];
    leftView.userInteractionEnabled = YES;
    [leftView setTag:(0+kImageViewTag)];
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressed:)];
    [leftView addGestureRecognizer:leftTap];
    [leftView reloadPhotoView:[UIImage imageNamed:@"temp_home_bottom_left"]];
    [leftView reloadTypeName:@"公司资讯" name:@"【志达家居】" desc:@"共筑“龙江梦 展示“劳动美””"];
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kHomePageFrontGap);
        make.top.equalTo(@0);
    }];
    //右边视图
    ZDHHomePageNewsCellView *rightView = [[ZDHHomePageNewsCellView alloc] init];
    rightView.userInteractionEnabled = YES;
    [rightView setTag:(1+kImageViewTag)];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressed:)];
    [rightView addGestureRecognizer:rightTap];
    [rightView reloadPhotoView:[UIImage imageNamed:@"temp_home_bottom_right"]];
    [rightView reloadTypeName:@"品牌实力" name:@"【志达集团】" desc:@"集团公司产供销一体化"];
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).with.offset(@kOffsetBetweenViews);
        make.top.equalTo(@0);
    }];
}
#pragma mark - Event response
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//点击视图
- (void)imageViewPressed:(UITapGestureRecognizer *)tap{
    UIImageView *selectedView = (UIImageView *)[tap view];
    int selectedIndex = (int)(selectedView.tag-kImageViewTag);
     NSDictionary *dic = @{@"selectedIndex":[NSNumber numberWithInt:selectedIndex]};
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHHomePageNewsCell" object:self userInfo:dic];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods







@end
