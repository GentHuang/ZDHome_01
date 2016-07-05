//
//  ZDHBrandViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHBrandViewController.h"
//Libs
#import "Masonry.h"
@interface ZDHBrandViewController ()

@end

@implementation ZDHBrandViewController
#pragma mark - Init methods
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSubViewLayout];    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"品牌实力"];
}
- (void)createUI{
    UIScrollView *sc = [[UIScrollView alloc] init];
    sc.backgroundColor = WHITE;
    [self.view addSubview:sc];
    [sc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@NAV_HEIGHT);
        make.left.equalTo(0);
        make.bottom.equalTo(0);
        make.right.equalTo(0);
    }];
    
    
    UIImage *backImage = [UIImage imageNamed:@"brand_img"];
    sc.contentSize = backImage.size;
    
    UIImageView *backView = [[UIImageView alloc] initWithImage:backImage];
    [sc addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(backImage.size);
        make.top.equalTo(0);
        make.left.equalTo(0);
    }];
}
- (void)setSubViewLayout{
    
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods

@end
