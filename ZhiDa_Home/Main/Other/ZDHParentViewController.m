//
//  ZDHParentViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHParentViewController.h"
//Libs
#import "Masonry.h"

@interface ZDHParentViewController ()
@property (strong, nonatomic) UIImageView *shadowImageView;
@property (strong, nonatomic) UIImage *shadowImage;
@end
@implementation ZDHParentViewController
#pragma mark - Init methods
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)createSuperUI{
    _shadowImageView = [[UIImageView alloc] init];
    _shadowImage = [UIImage imageNamed:@"nav_bg_shadow"];
    _shadowImageView.image = _shadowImage;
    [self.view addSubview:_shadowImageView];
}
- (void)setSuperSubViewLayout{
    [_shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_shadowImage.size);
        make.top.equalTo(@(STA_HEIGHT+NAV_HEIGHT));
        make.left.equalTo(@0);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods

@end
