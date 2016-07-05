//
//  ZDHProductCommonBigImageView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHProductCommonBigImageView.h"
//Libs
#import "Masonry.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
@interface ZDHProductCommonBigImageView()<UIViewControllerTransitioningDelegate>

@property (assign, nonatomic) CGRect currFrame;
@property (assign, nonatomic) CGRect bigFrame;
@property (strong, nonatomic) SDPieProgressView *pv;

@end

@implementation ZDHProductCommonBigImageView
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
    //图片自定义
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    self.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer *bigViewTap = [[UITapGestureRecognizer alloc] init];
    [bigViewTap setNumberOfTapsRequired:2];
    [bigViewTap addTarget:self action:@selector(bigViewTapPressed:)];
    [self addGestureRecognizer:bigViewTap];
}

- (void)setSubViewLayout{
}
#pragma mark - Event response
//点击变成大图
- (void)bigViewTapPressed:(UITapGestureRecognizer *)tap{
    
    TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:self.image];
    viewController.transitioningDelegate = self;
//------------------重新设置显示模式，恢复默认值，避免崩溃---------------
    self.contentMode = UIViewContentModeScaleToFill;
    [[self viewController] presentViewController:viewController animated:YES completion:nil];
}
#pragma mark - Network request
#pragma mark - Protocol methods
//UIViewControllerTransitioningDelegate Methods
- (id)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self];
    }
    return nil;
}
- (id)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self];
    }
    return nil;
}
#pragma mark - Other methods
//获取当前controller
- (UIViewController *)viewController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]]){
            return (UIViewController *)responder;
        }
    return nil;
}

//获取图片1
- (void)reloadImageView:(id)image{
    // 临时添加
    if (self.pv) {
  
       [self.pv removeFromSuperview];
        self.pv = nil;
    }
    if ([image isKindOfClass:[UIImage class]]) {
        //已经离线下载
        self.image = image;
    }else{
        //网络下载
        //若没有图片时
        NSString *imageString = image;
        if ([imageString isEqualToString:@""]) {
            
            self.image = [UIImage imageNamed:@"600_600_2"];
        }else{
            __block SDPieProgressView *pv;
            [self sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,imageString]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {

            dispatch_async(dispatch_get_main_queue(), ^{
                if (!pv) {
                    pv = [[SDPieProgressView alloc] init];
                    [self addSubview:pv];
                    [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.center.mas_equalTo(self);
                        make.width.height.mas_equalTo(50);
                    }];
                }
                pv.progress = (float)receivedSize/(float)expectedSize;
             });
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                for (UIView *subView in self.subviews) {
                    if ([subView isKindOfClass:[SDPieProgressView class]]) {
                        
                        [subView removeFromSuperview];
                    }
                }
            }];
        }
    }
    
}
//获取图片(设计方案)
- (void)reloadDesignImageView:(NSString *)imageString{
    // 临时添加
    for (UIView *subView in self.subviews) {
        
        if ([subView isKindOfClass:[SDPieProgressView class]]) {
            [subView removeFromSuperview];
        }
    }
    //若没有图片时
    if ([imageString isEqualToString:@""]) {
        self.image = [UIImage imageNamed:@"600_600_2"];
    }else{
        __block SDPieProgressView *pv;
        __block ZDHProductCommonBigImageView *selfView = self;
        [self sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,imageString]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //下载图片开始
            //加载进度条
            if (!pv) {
                pv = [[SDPieProgressView alloc] init];
                [selfView addSubview:pv];
                [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(selfView);
                    make.width.height.mas_equalTo(200);
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
