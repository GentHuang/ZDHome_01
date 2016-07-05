//
//  ZDHProductCenterViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

//Controllers
#import "ZDHProductCenterViewController.h"
#import "ZDHProductCenterZhiDaViewController.h"
#import "ZDHProductCenterOtherViewController.h"
//Views
#import "ZDHProductCenterBrandView.h"
//Libs
#import "Masonry.h"
//Macros
#define kTopImageViewWidth 200
#define kTopImageViewHeight 100
#define kBrandViewGap 30
#define kBrandViewWidth 299
#define kBrandViewHeight 518
#define kBrandImageViewTag 1000
@interface ZDHProductCenterViewController ()
@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) NSArray *imageArray;
@end

@implementation ZDHProductCenterViewController
#pragma mark - Init methods
- (void)initData{
    _imageArray = @[[UIImage imageNamed:@"brand_img_ZhiDa"],[UIImage imageNamed:@"brand_img_LuoLanDe"],[UIImage imageNamed:@"brand_img_MaQiDuo"]];
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    [self setSubViewLayout];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationController];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)setNavigationController{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDIYMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"品牌中心"];
}
- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    _topImageView = [[UIImageView alloc] init];
    _topImageView.image = [UIImage imageNamed:@"brand_img_top"];
    [self.view addSubview:_topImageView];
    [super createSuperUI];
}
- (void)setSubViewLayout{
    [super setSuperSubViewLayout];
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAV_HEIGHT+44));
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.equalTo([UIImage imageNamed:@"brand_img_top"].size);
    }];
    
    for (int i = 0; i < 3; i ++) {
        UIImage *brandImage = _imageArray[i];
        UIImageView *brandImageView = [[UIImageView alloc] initWithImage:brandImage];
        [self.view addSubview:brandImageView];
        brandImageView.userInteractionEnabled = YES;
        [brandImageView setTag:kBrandImageViewTag+i];
        UITapGestureRecognizer *brandViewTap = [[UITapGestureRecognizer alloc] init];
        [brandViewTap addTarget:self action:@selector(brandViewTapPressed:)];
        [brandImageView addGestureRecognizer:brandViewTap];
        [brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@180);
            make.left.equalTo((24+i*(brandImage.size.width+30)));
            make.size.equalTo(brandImage.size);
        }];
    }
}
#pragma mark - Event response
//选择品牌
- (void)brandViewTapPressed:(UITapGestureRecognizer *)tap{
    UIImageView *selectedImageView = (UIImageView *)[tap view];
    int tag = (int)selectedImageView.tag - kBrandImageViewTag;
    switch (tag) {
        case 0:{
            ZDHProductCenterZhiDaViewController *ZhiDaVC = [[ZDHProductCenterZhiDaViewController alloc] init];
            ZhiDaVC.currNavigationController = self.currNavigationController;
            ZhiDaVC.appDelegate = self.appDelegate;
            [self.currNavigationController pushViewController:ZhiDaVC animated:YES];
        }
            break;
        case 1:
        case 2:{
            ZDHProductCenterOtherViewController *otherVC = [[ZDHProductCenterOtherViewController alloc] init];
            otherVC.currNavigationController = self.currNavigationController;
            otherVC.appDelegate = self.appDelegate;
            NSString *encodedString;
            if (tag == 1) {
                otherVC.titleName = @"罗兰德";
                encodedString = @"luolande";
            }else{
                otherVC.titleName = @"玛奇朵";
                encodedString = @"maqiduo";
            }
            otherVC.tid = encodedString;
            [self.currNavigationController pushViewController:otherVC animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
@end
