//
//  ZDHProductCenterBrandRightScrollView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHProductCenterBrandBottomScrollView.h"
#import "ZDHProductCenterBrandBottomImageView.h"
//Libs
#import "Masonry.h"
//Macros
#define kBackWidth 194
#define kPicHeight 129
#define kPicWidth 168
#define kRightImageViewX 10
#define kRightImageViewY 10
#define kRightImageTag 4000
@interface ZDHProductCenterBrandBottomScrollView()
@property (assign, nonatomic) int imageCount;
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation ZDHProductCenterBrandBottomScrollView
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.userInteractionEnabled = YES;
    //滚动视图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = WHITE;
    _scrollView.userInteractionEnabled = YES;
    [self addSubview:_scrollView];
    //填充视图
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.userInteractionEnabled = YES;
    [_scrollView addSubview:_contentView];
}
- (void)setSubViewLayout{
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(SCREEN_MAX_WIDTH);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self);
    }];
 
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_scrollView);
        make.right.equalTo(_scrollView);
        make.top.equalTo(_scrollView);
        make.bottom.equalTo(_scrollView);
        make.height.mas_equalTo(_scrollView);
    }];
    
}
//加载图片
- (void)reloadRightScrollViewWithArray:(NSArray *)array index:(int)selectedIndex{
    //清空旧数据
    [self deleteAllSubViews:_contentView];
    //添加图片
    if (array.count > 0) {
        _imageCount = (int)array.count;
        _selectedIndex = 0;
        UIView *lastView = nil;// 修改
        for (int i = 0; i < _imageCount; i ++) {
            //背景
            UIView *backView = [[UIView alloc] init];
            backView.backgroundColor = [UIColor whiteColor];
            backView.userInteractionEnabled = YES;
            [_contentView addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.and.bottom.mas_equalTo(0);
                make.left.mas_equalTo(i*kBackWidth);
                make.width.mas_equalTo(kBackWidth);
            }];
            lastView = backView;
            //图片
            ZDHProductCenterBrandBottomImageView *rightImageView = [[ZDHProductCenterBrandBottomImageView alloc] initWithImage:nil];
            //加载图片
            if ([array[i] isKindOfClass:[UIImage class]]) {
                //已经离线下载
                rightImageView.image = array[i];
            }else{
                //网络下载
            __block SDPieProgressView *pv;
            [rightImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,array[i]]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //下载图片开始
                //加载进度条
                if (!pv) {
                   
                    pv = [[SDPieProgressView alloc] init];
                    [rightImageView addSubview:pv];
                    [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.center.mas_equalTo(rightImageView);
                        make.width.height.mas_equalTo(50);
                    }];
                }
                pv.progress = (float)receivedSize/(float)expectedSize;
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //下载完成
                for (UIView *subView in rightImageView.subviews) {
                    
                    if ([subView isKindOfClass:[SDPieProgressView class]]) {
                        
                        [subView removeFromSuperview];
                    }
                }
            }];
            }
            if (i == selectedIndex) {
                
                [rightImageView setIsSelected:YES];
            }else{
                [rightImageView setIsSelected:NO];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [tap addTarget:self action:@selector(rightImagePressed:)];
            rightImageView.tag = i+kRightImageTag;
            [rightImageView addGestureRecognizer:tap];
            [backView addSubview:rightImageView];
            [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(backView);
                make.width.mas_equalTo(kPicWidth);
                make.height.mas_equalTo(kPicHeight);
            }];
        }
      
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(lastView.mas_right);
        }];
    }
}
#pragma mark - Event response
- (void)rightImagePressed:(UITapGestureRecognizer *)tap{
    
    ZDHProductCenterBrandBottomImageView *tapImageView = (ZDHProductCenterBrandBottomImageView *)[tap view];
    self.selectedIndex = (int)tapImageView.tag - kRightImageTag;
    
    for(int i = 0;i < _imageCount;i ++){
        
        ZDHProductCenterBrandBottomImageView *allImage = (ZDHProductCenterBrandBottomImageView *)[self viewWithTag:i+kRightImageTag];
        [allImage setIsSelected:NO];
    }
    [tapImageView setIsSelected:YES];
    
    CGFloat maxX = _contentView.frame.size.width - _scrollView.frame.size.width;
    CGFloat movedX = (self.selectedIndex - 2) * kBackWidth;
    if (maxX <= 0){
        movedX = 0;
    }else if (movedX >= maxX) {
        
        movedX = maxX;
    }else if (self.selectedIndex <= 2){
        
        movedX = 0;
    }
    
    [_scrollView setContentOffset:CGPointMake(movedX, 0) animated:YES];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//清空子View
- (void)deleteAllSubViews:(UIView *)view{
    
    for (UIView *subView in [view subviews]) {
        
        [subView removeFromSuperview];
    }
}


@end
