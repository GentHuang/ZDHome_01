//
//  ZDHClothDetailLeftBigImageView.m
//  ZhiDa_Home
//
//  Created by apple on 16/3/13.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDHClothDetailLeftBigImageView.h"
#import <Masonry.h>
#import "ZDHProductCommonBigImageView.h"
#define kRightTableViewWidht 365
#define KSCrollWitdh 659

@interface ZDHClothDetailLeftBigImageView()<UIScrollViewDelegate,UIPageViewControllerDelegate>


@property (strong, nonatomic) UIPageControl *pageController;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *scrollContentView;
@property (strong, nonatomic) UIImageView *defaultView;
@property (assign, nonatomic) int pageCount;
//宽度
//@property (strong, nonatomic) ZDHProductCommonBigImageView *bigImageView;
@property (strong, nonatomic) UIImageView *bigImageView;


@end

@implementation ZDHClothDetailLeftBigImageView
#pragma mark - Init methods
- (instancetype)init {
    if (self = [super init]) {
        [self creatBaseUI];
        [self setSubViewlayout];
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
    [self addSubview:_scrollView];
    //ContentView
    _scrollContentView = [[UIView alloc] init];
    [_scrollView addSubview:_scrollContentView];
    //PageCounter
    _pageController = [[UIPageControl alloc] init];
    _pageController.currentPageIndicatorTintColor = CurrentPageIndicatorTintColor;
    _pageController.pageIndicatorTintColor = WHITE;
    [_pageController addTarget:self action:@selector(pageControllerPressed:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageController];
}
- (void)setSubViewlayout{
    //ScrollView
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(self);
//        make.top.equalTo(10);
//        make.left.equalTo(10);
//        make.bottom.equalTo(10);
//        make.height.width.equalTo(KSCrollWitdh);
        
    }];
    //ContentView
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    //PageCounter
    [_pageController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-12);
        make.centerX.equalTo(self);
        make.width.equalTo(50);
        make.height.equalTo(20);
    }];
}
//刷新ScrollView的图片
- (void)reloadCellWithArray:(NSArray *)imageArray{
    
//    NSLog(@"==== %@",imageArray);
    //删除子视图
    [self deleteAllSubView];
    
    int count = 0;
    BOOL isFirstPage = YES;
    BOOL isSecondPage = YES;
    
    if(![imageArray[0] isEqualToString:@""]){
        
        isFirstPage = NO;
        count ++;
    }
    
    if (![imageArray[1] isEqualToString:@""]) {
        isSecondPage = NO;
        count ++;
    }
    if (isFirstPage == NO && isSecondPage == YES) {
        
        _pageController.hidden = YES;
    }
    _pageCount = count;
    _pageController.numberOfPages = _pageCount;
    UIImageView *lastView;
    if (_pageCount == 0) {
        
        _pageController.hidden = YES;
        _defaultView = [[UIImageView alloc] init];
        _defaultView.image = [UIImage imageNamed:@"600_600_2"];
        [_scrollContentView addSubview:_defaultView];
        [_defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width);
            make.height.equalTo(_scrollView.mas_height);
        }];
        lastView = _defaultView;
    }else {
        for (int i = 0; i < _pageCount; i ++) {
            
            _bigImageView = [[ZDHProductCommonBigImageView alloc]init];

            _bigImageView.clipsToBounds = YES;
            _bigImageView.layer.borderWidth = 0.1;
            _bigImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _bigImageView.backgroundColor = [UIColor whiteColor];
            //------------添加图片合适模式 不拉伸不压缩------------------------
            _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
            //-------------------------------------------------------------
            [_scrollContentView addSubview:_bigImageView];
            [_bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(0);
                make.left.equalTo(@(i*(KSCrollWitdh)));
                make.width.equalTo(KSCrollWitdh);
                make.height.equalTo(KSCrollWitdh);//_scrollView.mas_height
            }];
            lastView = _bigImageView;
            if (![imageArray[i] isEqualToString:@""]) {
                
            //添加网络图片
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,imageArray[i]]];
            [_bigImageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    SDPieProgressView *pv = [[SDPieProgressView alloc] init];
                    [_bigImageView addSubview:pv];
                    [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(_bigImageView);
                        make.width.height.mas_equalTo(50);
                    }];
                    pv.progress = (float)receivedSize/(float)expectedSize;
                });
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //下载完成
                for (UIView *subView in _bigImageView.subviews) {
                    if ([subView isKindOfClass:[SDPieProgressView class]]) {
                        [subView removeFromSuperview];
                    }
                }
            }];
            }
            else{
                
                _bigImageView.image = [UIImage imageNamed:@"600_600_2"];
            }
        }
    }
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
}
//加载本地图片
- (void)reloadCellLocalWithImage:(id)image {
    NSLog(@"---->%@",image);
    [self deleteAllSubView];
    if([image isKindOfClass:[UIImage class]]){
        _bigImageView = [[ZDHProductCommonBigImageView alloc]init];
        [_scrollContentView addSubview:_bigImageView];
        _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(0);
            make.left.equalTo(0);
            make.width.equalTo(KSCrollWitdh);
            make.height.equalTo(KSCrollWitdh);//_scrollView.mas_height
        }];
        
        _bigImageView.image = image;
    }
    else{
        
        _bigImageView = [[ZDHProductCommonBigImageView alloc]init];
        [_scrollContentView addSubview:_bigImageView];
        _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(0);
            make.left.equalTo(0);
            make.width.equalTo(KSCrollWitdh);
            make.height.equalTo(KSCrollWitdh);//_scrollView.mas_height
        }];
        
        _bigImageView.image = [UIImage imageNamed:@"600_600_2"];
        _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bigImageView.mas_right);
    }];

}
#pragma mark - Event response
//点击PageCounter
- (void)pageControllerPressed:(UIPageControl *)pageController{
    
    [_scrollView setContentOffset:CGPointMake(pageController.currentPage * KSCrollWitdh, 0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageController.currentPage = _scrollView.contentOffset.x/KSCrollWitdh;
}
//删除原来的子视图
- (void)deleteAllSubView {
    for (ZDHProductCommonBigImageView *Imageview in [_scrollContentView subviews]) {
        [Imageview removeFromSuperview];
    }
}
//重新设置视图适合显示
- (void)reloadImageContentModeScaleAspectFit {
    for (ZDHProductCommonBigImageView *Imageview in [_scrollContentView subviews]) {
        Imageview.contentMode = UIViewContentModeScaleAspectFit;
    }
    
}


#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods

@end
