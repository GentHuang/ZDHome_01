//
//  ZDHProductCenterBrandBottomView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHProductCenterSingleRightView.h"
//ViewModel
//#import "ZDHProductCenterSingleRightViewViewModel.h"
//Libs
#import "Masonry.h"
//Macros
#define kSingleViewUpWidth 308
#define kSingleViewDownWidth 450
#define kSingleViewHeight 124
#define kLabelFontSize 20
#define kBackViewWidth 124
#define kImageViewWidth 104
#define kImageViewHeight 104
#define kImageViewTag 7000
#define kProgressViewTag 9000
@interface ZDHProductCenterSingleRightView()
@property (assign, nonatomic) BOOL isDraged;
@property (assign, nonatomic) CGFloat selfWidth;
@property (strong, nonatomic) UIImage *packUpImage;
@property (strong, nonatomic) UIButton *packUpButton;
@property (strong, nonatomic) UIScrollView *upScrollView;
@property (strong, nonatomic) UIView *upContentView;
@property (strong, nonatomic) UIScrollView *downScrollView;
@property (strong, nonatomic) UIView *downContentView;

//@property (strong, nonatomic) ZDHProductCenterSingleRightViewViewModel *viewModel;
@end
@implementation ZDHProductCenterSingleRightView
#pragma mark - Init methods
- (void)initData{
    //ViewModel
    //    _viewModel = [[ZDHProductCenterSingleRightViewViewModel alloc] init];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self creatUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)creatUI{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    _isDraged = YES;
    //收起按钮
    _packUpImage = [UIImage imageNamed:@"pro_btn_pack"];
    _packUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_packUpButton setBackgroundImage:_packUpImage forState:UIControlStateSelected];
    [_packUpButton addTarget:self action:@selector(packUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_packUpButton];
    //UpScrollView
    _upScrollView = [[UIScrollView alloc] init];
    _upScrollView.showsVerticalScrollIndicator = NO;
    _upScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_upScrollView];
    //UpContentView
    _upContentView = [[UIView alloc] init];
    _upContentView.backgroundColor = [UIColor clearColor];
    [_upScrollView addSubview:_upContentView];
    //DownScrollView
    _downScrollView = [[UIScrollView alloc] init];
    _downScrollView.showsHorizontalScrollIndicator = NO;
    _downScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_downScrollView];
    //DownContentView
    _downContentView = [[UIView alloc] init];
    _downContentView.backgroundColor = [UIColor clearColor];
    [_downScrollView addSubview:_downContentView];
}
- (void)setSubViewLayout{
    //收起按钮
    [_packUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(36);
        make.height.equalTo(80);
        make.top.equalTo(0);
        make.left.equalTo(0);
    }];
    //UpView的ScrollView
    [_upScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.equalTo(_packUpButton.mas_right).with.offset(8);
        make.right.equalTo(-22);
        make.bottom.equalTo(0);
    }];
    //UpcontentView
    [_upContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_upScrollView);
        make.width.equalTo(_upScrollView);
    }];
    //DownScrollView
    [_downScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_packUpButton.mas_right).with.offset(10);
        make.bottom.and.top.equalTo(0);
        make.right.equalTo(0);
    }];
    //DownContentView
    [_downContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_downScrollView);
        make.height.equalTo(_downScrollView);
    }];
}
#pragma mark - Event response
//收起按钮
- (void)packUpButtonPressed:(UITapGestureRecognizer *)tap{
    if (_isDraged) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(0);
                make.height.equalTo(@kSingleViewHeight);
            }];
            [self layoutIfNeeded];
        }];
        [UIView commitAnimations];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_selfWidth-36);
                make.height.equalTo(80);
            }];
            [self layoutIfNeeded];
        }];
        [UIView commitAnimations];
    }
    _isDraged = !_isDraged;
    _packUpButton.selected = !_packUpButton.selected;
}

//点击单品
- (void)tapPressed:(UITapGestureRecognizer *)tap{
    UIImageView *selectedImageView = (UIImageView *)[tap view];
    int selectedIndex = (int)(selectedImageView.tag - kImageViewTag);
    NSDictionary *dic = @{@"selectedIndex":[NSNumber numberWithInt:selectedIndex]};
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHProductCenterSingleRightView" object:self userInfo:dic];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新UpView的数据
- (void)reloadUpViewWithString:(NSString *)contentString{
    //删除旧数据
    [self deleteAllSubView:_upContentView];
    if (contentString.length > 0) {
        UILabel *contenLabel = [[UILabel alloc] init];
        contenLabel.textAlignment = NSTextAlignmentJustified;
        contenLabel.text = contentString;
        contenLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
        contenLabel.textColor = WHITE;
        contenLabel.numberOfLines = 0;
        [_upContentView addSubview:contenLabel];
        [contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0);
            make.width.mas_equalTo(_upContentView.mas_width);
        }];
        [_upContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(contenLabel.mas_bottom);
        }];
    }
}
//刷新DownView的数据
- (void)reloadDownViewWithArray:(NSArray *)array{
    //删除旧数据
    [self deleteAllSubView:_downContentView];
    if (array.count > 0) {
        
        UIView *lastView;
        for (int i = 0;  i < array.count; i ++) {
            UIView *backView = [[UIView alloc] init];
            backView.backgroundColor = [UIColor clearColor];
            [_downContentView addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.bottom.equalTo(0);
                make.left.equalTo(i*kBackViewWidth);
                make.width.equalTo(kBackViewWidth);
            }];
            lastView = backView;
            
            UIImageView *backImageView = [[UIImageView alloc] init];
          
            
            //加载图片
            if ([array[i] isKindOfClass:[UIImage class]]) {
                //已经离线下载
                backImageView.image = array[i];
            }else{
                
                //网络下载
                [backImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,array[i]]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    //下载图片开始
                    //加载进度条
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SDPieProgressView *pv;
                        if (!pv) {
                            pv = [[SDPieProgressView alloc]init];
                            [backImageView addSubview:pv];
                            [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.center.equalTo(backImageView);
                                make.width.height.mas_equalTo(50);
                            }];
                        }
                        pv.progress = (float)receivedSize/(float)expectedSize;
                    });

                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    //下载完成,删除加载动画
                     dispatch_async(dispatch_get_main_queue(), ^{
                         for (UIView *subView in backImageView.subviews) {
                             if ([subView isKindOfClass:[SDPieProgressView class]]) {
                                 [subView removeFromSuperview];
                             }
                         }
                     });
                }];
            }
            //其他设置
            backImageView.userInteractionEnabled = YES;
            backImageView.backgroundColor = WHITE;
            [backImageView setTag:(i+kImageViewTag)];
            UITapGestureRecognizer *backImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
            [backImageView addGestureRecognizer:backImageViewTap];
            [backView addSubview:backImageView];
            [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(backView);
                make.width.equalTo(@kImageViewWidth);
                make.height.equalTo(@kImageViewHeight);
            }];
        };
        [_downContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.mas_right);
        }];
    }
}
//选择模式
- (void)setSingleRightViewType:(SingleRightType)type{
    switch (type) {
        case 0:
            [self setSingleRightViewUpType];
            break;
        case 1:
            [self setSingleRightViewDownType];
            break;
        default:
            break;
    }
}
//上方模式
- (void)setSingleRightViewUpType{
    _selfWidth = kSingleViewUpWidth;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_selfWidth);
    }];
    [_packUpButton setBackgroundImage:[UIImage imageNamed:@"pro_btn_intro"] forState:UIControlStateNormal];
    _upScrollView.hidden = NO;
    _upContentView.hidden = NO;
    _downScrollView.hidden = YES;
    _downScrollView.hidden = YES;
}
//下方模式
- (void)setSingleRightViewDownType{
    _selfWidth = kSingleViewDownWidth;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_selfWidth);
    }];
    [_packUpButton setBackgroundImage:[UIImage imageNamed:@"pro_btn_single"] forState:UIControlStateNormal];
    _upScrollView.hidden = YES;
    _upContentView.hidden = YES;
    _downScrollView.hidden = NO;
    _downScrollView.hidden = NO;
}
//删除子View
- (void)deleteAllSubView:(UIView *)view{
    
    for (UIView *subView in [view subviews]) {
        [subView removeFromSuperview];
    }
}
@end
