//
//  ZDHHomePageHotCellCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHHomePageHotSellCell.h"
#import "ZDHHomePageHotSellCellView.h"
//Libs
#import "Masonry.h"
//Macros
#define kHotSellBackViewWidth 1024-20
#define kHotSellCellHeight 500
#define kOffsetBetweenViews 0.5
#define kHotSellTag 6000

@interface ZDHHomePageHotSellCell()
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation ZDHHomePageHotSellCell
#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)awakeFromNib {
}
#pragma mark - Life circle
#pragma mark - Getters and setters
//初始化UI
- (void)createUI{
    //背景图片
    UIImageView *backView = [[UIImageView alloc] init];
    backView.userInteractionEnabled = YES;
    UIImage *backImage = [UIImage imageNamed:@"home_img_product"];
    backView.image = backImage;
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(backImage.size);
        make.left.equalTo(@kHomePageFrontGap);
        make.top.equalTo(@0);
    }];
    CGFloat imageWidth = backImage.size.width;
    CGFloat imageHeight = backImage.size.height;
    //大图
    ZDHHomePageHotSellCellView *bigView = [[ZDHHomePageHotSellCellView alloc] init];
//    [bigView reloadPhotoView:[UIImage imageNamed:@"temp_home_product_1"]];
//    [bigView reloadTitle:@"现代组合沙发" desc:@"艳丽的色彩搭配"];
    [bigView setViewSize:0];
    [bigView setTag:(1+kHotSellTag)];
    UITapGestureRecognizer *bigViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [bigView addGestureRecognizer:bigViewTap];
    [backView addSubview:bigView];
    [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(imageWidth/2);
        make.height.equalTo(imageHeight/2);
    }];
    //第一个中图
    ZDHHomePageHotSellCellView *firstMidView = [[ZDHHomePageHotSellCellView alloc] init];
//    [firstMidView reloadPhotoView:[UIImage imageNamed:@"temp_home_product_2"]];
    [firstMidView setViewSize:kMidSize];
    [firstMidView setTag:(2+kHotSellTag)];
    UITapGestureRecognizer *firstMidViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [firstMidView addGestureRecognizer:firstMidViewTap];
    [backView addSubview:firstMidView];
    [firstMidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bigView.mas_right);
        make.top.equalTo(@0);
        make.width.equalTo(imageWidth/4);
        make.height.equalTo(imageHeight/2);
    }];
    //第一个小右图
    ZDHHomePageHotSellCellView *firstSmallRightView = [[ZDHHomePageHotSellCellView alloc] init];
//    [firstSmallRightView reloadPhotoView:[UIImage imageNamed:@"temp_home_product_3"]];
    [firstSmallRightView setViewSize:kSmallRightSize];
    [firstSmallRightView setTag:(3+kHotSellTag)];
    UITapGestureRecognizer *firstSmallRightViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [firstSmallRightView addGestureRecognizer:firstSmallRightViewTap];
    [backView addSubview:firstSmallRightView];
    [firstSmallRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstMidView.mas_right);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(imageWidth/4);
        make.height.mas_equalTo(imageHeight/4);
    }];
    //第二个小右图
    ZDHHomePageHotSellCellView *secondSmallRightView = [[ZDHHomePageHotSellCellView alloc] init];
//    [secondSmallRightView reloadPhotoView:[UIImage imageNamed:@"temp_home_product_4"]];
    [secondSmallRightView setViewSize:kSmallRightSize];
    [secondSmallRightView setTag:(4+kHotSellTag)];
    UITapGestureRecognizer *secondSmallRightViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [secondSmallRightView addGestureRecognizer:secondSmallRightViewTap];
    [backView addSubview:secondSmallRightView];
    [secondSmallRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstSmallRightView.mas_left);
        make.top.equalTo(firstSmallRightView.mas_bottom);
        make.width.equalTo(firstSmallRightView.mas_width);
        make.height.equalTo(firstSmallRightView.mas_height);
    }];
    //第一个小左图
    ZDHHomePageHotSellCellView *firstSmallLeftView = [[ZDHHomePageHotSellCellView alloc] init];
//    [firstSmallLeftView reloadPhotoView:[UIImage imageNamed:@"temp_home_product_5"]];
    [firstSmallLeftView setViewSize:kSmallLeftSize];
    [firstSmallLeftView setTag:(5+kHotSellTag)];
    UITapGestureRecognizer *firstSmallLeftViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [firstSmallLeftView addGestureRecognizer:firstSmallLeftViewTap];
    [backView addSubview:firstSmallLeftView];
    [firstSmallLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bigView.mas_left);
        make.top.equalTo(bigView.mas_bottom);
        make.width.equalTo(imageWidth/4);
        make.height.equalTo(imageHeight/4);
    }];
    //第二个小左图
    ZDHHomePageHotSellCellView *secondSmallLeftView = [[ZDHHomePageHotSellCellView alloc] init];
//    [secondSmallLeftView reloadPhotoView:[UIImage imageNamed:@"temp_home_product_6"]];
    [secondSmallLeftView setViewSize:kSmallLeftSize];
    [secondSmallLeftView setTag:(6+kHotSellTag)];
    UITapGestureRecognizer *secondSmallLeftViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [secondSmallLeftView addGestureRecognizer:secondSmallLeftViewTap];
    [backView addSubview:secondSmallLeftView];
    [secondSmallLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bigView.mas_left);
        make.top.equalTo(firstSmallLeftView.mas_bottom);
        make.width.equalTo(imageWidth/4);
        make.height.equalTo(imageHeight/4);
    }];
    //第二个中图
    ZDHHomePageHotSellCellView *secondMidView = [[ZDHHomePageHotSellCellView alloc] init];
//    [secondMidView reloadPhotoView:[UIImage imageNamed:@"temp_home_product_7"]];
    [secondMidView setViewSize:kMidSize];
    [secondMidView setTag:(7+kHotSellTag)];
    UITapGestureRecognizer *secondMidViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [secondMidView addGestureRecognizer:secondMidViewTap];
    [backView addSubview:secondMidView];
    [secondMidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstSmallLeftView.mas_right);
        make.top.equalTo(firstMidView.mas_bottom);
        make.width.equalTo(firstMidView.mas_width);
        make.height.equalTo(firstMidView.mas_height);
    }];
    //第三个中图
    ZDHHomePageHotSellCellView *thirdMidView = [[ZDHHomePageHotSellCellView alloc] init];
//    [thirdMidView reloadPhotoView:[UIImage imageNamed:@"temp_home_product_8" ]];
    [thirdMidView setViewSize:kMidSize];
    [thirdMidView setTag:(8+kHotSellTag)];
    UITapGestureRecognizer *thirdMidViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [thirdMidView addGestureRecognizer:thirdMidViewTap];
    [backView addSubview:thirdMidView];
    [thirdMidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondMidView.mas_right);
        make.top.equalTo(firstMidView.mas_bottom);
        make.width.equalTo(firstMidView.mas_width);
        make.height.equalTo(firstMidView.mas_height);
    }];
    //第四个中图
    ZDHHomePageHotSellCellView *fourthMidView = [[ZDHHomePageHotSellCellView alloc] init];
//    [fourthMidView reloadPhotoView:[UIImage imageNamed:@"temp_home_product_9" ]];
    [fourthMidView setViewSize:kMidSize];
    [fourthMidView setTag:(9+kHotSellTag)];
    UITapGestureRecognizer *fourthMidViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [fourthMidView addGestureRecognizer:fourthMidViewTap];
    [backView addSubview:fourthMidView];
    [fourthMidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdMidView.mas_right);
        make.top.equalTo(secondSmallRightView.mas_bottom);
        make.width.equalTo(firstMidView.mas_width);
        make.height.equalTo(firstMidView.mas_height);
    }];
    //等待下载
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:_indicatorView];
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}
#pragma mark - Event response
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//点击事件
- (void)tapPressed:(UITapGestureRecognizer *)tap{
    
    ZDHHomePageHotSellCellView *selectedImageView = (ZDHHomePageHotSellCellView *)[tap view];
    int selectedIndex = (int)(selectedImageView.tag - kHotSellTag);
    NSDictionary *dic;
    switch (selectedIndex) {
        case 1:{
            dic = @{@"selectedIndex":[NSNumber numberWithInt:selectedIndex]};
        }
            break;
        case 2:{
            dic = @{@"selectedIndex":[NSNumber numberWithInt:selectedIndex]};
        }
            break;
        case 3:{
                dic = @{@"selectedIndex":[NSNumber numberWithInt:selectedIndex]};
            }
            break;
        case 4:{
                dic = @{@"selectedIndex":[NSNumber numberWithInt:selectedIndex]};
            }
            break;
        case 5:{
                dic = @{@"selectedIndex":[NSNumber numberWithInt:selectedIndex]};
            }
            break;
        case 6:{
                dic = @{@"selectedIndex":[NSNumber numberWithInt:selectedIndex]};
            }
            break;
        case 7:{
                dic = @{@"selectedIndex":[NSNumber numberWithInt:selectedIndex]};
            }
            break;
        case 8:{
                dic = @{@"selectedIndex":[NSNumber numberWithInt:selectedIndex]};
            }
            break;
        case 9:{
            dic = @{@"selectedIndex":[NSNumber numberWithInt:selectedIndex]};
        }
            break;
        default:
            break;
    }
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHHomePageHotSellCell" object:self userInfo:dic];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//获取view的controller
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
//刷新图片
- (void)reloadImageView:(NSArray *)imageArray{
    for (int i = 0; i < imageArray.count; i ++) {
        ZDHHomePageHotSellCellView *allView = (ZDHHomePageHotSellCellView *)[self viewWithTag:(i+1+kHotSellTag)];
        [allView reloadPhotoView:imageArray[i]];
        
    }
}
//刷新标题和简介
- (void)reloadTitle:(NSArray *)title desc:(NSArray *)desc{
    for (int i = 0; i < title.count; i ++) {
        ZDHHomePageHotSellCellView *allView = (ZDHHomePageHotSellCellView *)[self viewWithTag:(i+1+kHotSellTag)];
        [allView reloadTitle:title[i] desc:desc[i]];
    }
}
//开始读取
- (void)startLoading{
    [_indicatorView startAnimating];
}
//读取结束
- (void)stopLoading{
    [_indicatorView stopAnimating];
}

@end
