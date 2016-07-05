//
//  ZDHHomePageNewsCellView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

//Views
#import "ZDHHomePageNewsCellView.h"
//Libs
#import "Masonry.h"
@implementation ZDHHomePageNewsCellView
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
//初始化UI
- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    UIImage *backImage = [UIImage imageNamed:@"home_news"];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(backImage.size);
    }];
    
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:backImage];
    [self addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //新闻类型标题
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.text = @"品牌实力";
    _typeLabel.font = FONTSIZESBOLD(20);
    [backImageView addSubview:_typeLabel];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@13);
        make.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    //图片
    _photoView = [[UIImageView alloc] init];
    _photoView.image = [UIImage imageNamed:@"app3-3.jpg"];
    [backImageView addSubview:_photoView];
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeLabel.mas_left);
        make.top.equalTo(_typeLabel.mas_bottom).with.offset(@20);
        make.right.equalTo(@-340);
        make.bottom.equalTo(@-10);
    }];
    //公司名称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"志达集团";
    _nameLabel.font = FONTSIZES(15);
    [backImageView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_photoView.mas_right).with.offset(@16);
        make.top.equalTo(_photoView.mas_top);
        make.right.equalTo(self);
        make.height.equalTo(@15);
    }];
    //详细介绍
    _descLabel = [[UILabel alloc] init];
    _descLabel.text = @"集团公司产供销一体化";
    _descLabel.font = FONTSIZES(15);
    _descLabel.textColor = [UIColor darkGrayColor];
    [backImageView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(@14);
        make.right.equalTo(self);
        make.height.equalTo(@15);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新图片
- (void)reloadPhotoView:(UIImage *)photoImage{
    _photoView.image = photoImage;
}
//刷新文字
- (void)reloadTypeName:(NSString *)typeName name:(NSString *)name desc:(NSString *)desc{
    _typeLabel.text = typeName;
    _nameLabel.text = name;
    _descLabel.text = desc;
}

@end
