//
//  ZDHHomePageHeaderView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHHomePageHeaderViewCell.h"
//Libs
#import "Masonry.h"

#define kAdvertismentTag 41000

@interface ZDHHomePageHeaderViewCell()<UIScrollViewDelegate,UIPageViewControllerDelegate>{
    NSTimer *_timer;
}
@property (strong, nonatomic) UIPageControl *pageController;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *scrollContentView;
@property (strong, nonatomic) UIImageView *defaultView;
@property (assign, nonatomic) int pageCount;
@end
@implementation ZDHHomePageHeaderViewCell
#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatBaseUI];
        [self setSubViewlayout];
        [self startRolling];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
//初始化ScrollView
- (void)creatBaseUI{
    _pageCount = 1;
    //ScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = WHITE;
    [self.contentView addSubview:_scrollView];
    //ContentView
    _scrollContentView = [[UIView alloc] init];
    [_scrollView addSubview:_scrollContentView];
    //PageCounter
    _pageController = [[UIPageControl alloc] init];
    _pageController.currentPageIndicatorTintColor = CurrentPageIndicatorTintColor;
    _pageController.pageIndicatorTintColor = WHITE;
    [_pageController addTarget:self action:@selector(pageControllerPressed:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_pageController];
}
- (void)setSubViewlayout{
    //ScrollView
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(self);
    }];
    //ContentView
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    //PageCounter
    [_pageController mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(-12);
        make.right.equalTo(-10);
        make.width.equalTo(120);
        make.height.equalTo(20);
    }];
}
//刷新ScrollView的图片
- (void)reloadCellWithArray:(NSArray *)imageArray{
    
    _pageCount = (int)imageArray.count;
    _pageController.numberOfPages = _pageCount;
    UIImageView *lastView;
    if (_pageCount == 0) {
        _defaultView = [[UIImageView alloc] init];
        _defaultView.image = [UIImage imageNamed:@"600_345.jpg"];
        [_scrollContentView addSubview:_defaultView];
        [_defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@SCREEN_MAX_WIDTH);
            make.height.equalTo(_scrollView.mas_height);
        }];
        lastView = _defaultView;
    }else{
        [_defaultView removeFromSuperview];
        for (int i = 0; i < _pageCount; i ++) {
            UIImageView *defaultView = [[UIImageView alloc] init];
            defaultView.tag = kAdvertismentTag + i;
            defaultView.userInteractionEnabled = YES;
            [defaultView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(advertismentClickTap:)]];
            [_scrollContentView addSubview:defaultView];
            [defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@SCREEN_MAX_WIDTH);
                make.height.equalTo(_scrollView.mas_height);
                make.top.equalTo(0);
                make.left.equalTo(@(i*SCREEN_MAX_WIDTH));
            }];
            lastView = defaultView;
            //添加网络图片
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,imageArray[i]]];
//            网络下载
            __block SDPieProgressView *pv;
            
            [defaultView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
               
                dispatch_async(dispatch_get_main_queue(), ^{ 
                if (!pv) {
                    pv = [[SDPieProgressView alloc] init];
                    [defaultView addSubview:pv];
                    [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.center.mas_equalTo(defaultView);
                        make.width.height.mas_equalTo(50);
                    }];
                }
                pv.progress = (float)receivedSize/(float)expectedSize;
                });
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                for (UIView *subView in defaultView.subviews) {
                    if ([subView isKindOfClass:[SDPieProgressView class]]) {
                        
                        [subView removeFromSuperview];
                    }
                }
            }];
        }
    }
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(lastView.mas_right);
    }];
}
#pragma mark - Event response
//点击PageCounter
- (void)pageControllerPressed:(UIPageControl *)pageController{
    [_scrollView setContentOffset:CGPointMake(pageController.currentPage * SCREEN_MAX_WIDTH, 0) animated:YES];
}
// 广告的点击
- (void)advertismentClickTap:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)[tap view];
    NSInteger index = imageView.tag - kAdvertismentTag;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AdvertismentClick" object:self userInfo:@{@"index":[NSNumber numberWithInteger:index]}];
    NSLog(@"广告点击%ld",index);
}
#pragma mark - Network request
#pragma mark - Protocol methods
//ScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageController.currentPage = _scrollView.contentOffset.x/SCREEN_MAX_WIDTH;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self pauseRolling];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self resumeTimerAfterTimeInterval:3];
}
#pragma mark - Other methods
//开始滚动
- (void)startRolling{
    if (_pageCount >= 1) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollViewScroll) userInfo:nil repeats:YES];
    }
}
//暂停滚动
- (void)pauseRolling{
    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:[NSDate distantFuture]];
}
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval{
    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}
//每次滚动
- (void)scrollViewScroll{
    NSInteger currX = _scrollView.contentOffset.x/SCREEN_MAX_WIDTH;
    if (currX == _pageCount-1){
        currX = 0;
    }else{
        currX ++;
    }
    [_scrollView setContentOffset:CGPointMake(currX*SCREEN_MAX_WIDTH, 0) animated:YES];
}
@end
