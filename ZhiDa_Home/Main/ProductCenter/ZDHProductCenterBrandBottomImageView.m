//
//  ZDHProductCenterBrandRightImageView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHProductCenterBrandBottomImageView.h"
//Libs
#import "Masonry.h"
@interface ZDHProductCenterBrandBottomImageView()
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) UIImage *selectedImage;
@end

@implementation ZDHProductCenterBrandBottomImageView
#pragma mark - Init methods
-(instancetype)initWithImage:(UIImage *)image{
    if (self = [super initWithImage:image]) {
        [self createUI];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.userInteractionEnabled = YES;
    _isSelected = NO;
    //SelectedView
    _selectedImage = [UIImage imageNamed:@"com_img_sel"];
    _selectedImageView = [[UIImageView alloc] initWithImage:_selectedImage];
    [self addSubview:_selectedImageView];
    [_selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_selectedImage.size);
        make.right.equalTo(0);
        make.top.equalTo(0);
    }];
}
#pragma mark - Event response
- (void)setIsSelected:(BOOL)selected{
    _isSelected = selected;
    if (_isSelected == YES) {
        _selectedImageView.hidden = NO;
    }else{
        _selectedImageView.hidden = YES;
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
@end
