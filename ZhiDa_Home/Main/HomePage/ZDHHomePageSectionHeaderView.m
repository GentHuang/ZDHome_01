//
//  ZDHHomePageSectionHeaderView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHHomePageSectionHeaderView.h"
//Libs
#import "Masonry.h"
//Macros
#define kFrontGap 18
@interface ZDHHomePageSectionHeaderView()
@property (strong, nonatomic) UILabel *headerNameLabel;
@property (strong, nonatomic) UIButton *productButton;
@property (strong, nonatomic) UIButton *DIYButton;
@end

@implementation ZDHHomePageSectionHeaderView
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
    //标题
    _headerNameLabel = [[UILabel alloc] init];
    _headerNameLabel.font = FONTSIZESBOLD(20);
    _headerNameLabel.text = @"";
    [self addSubview:_headerNameLabel];
    //热门产品按钮
    _productButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _productButton.hidden = YES;
    UIImage *changeProductButtonImage = [UIImage imageNamed:@"home_btn_change"];
    [_productButton setImage:changeProductButtonImage forState:UIControlStateNormal];
    [_productButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_productButton];
    //查看更多按钮
    _DIYButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _DIYButton.hidden = YES;
    [_DIYButton setTitle:@"查看更多    >" forState:UIControlStateNormal];
    [_DIYButton setTitleColor:[UIColor colorWithRed:215/256.0 green:102/256.0 blue:134/256.0 alpha:1] forState:UIControlStateNormal];
    _DIYButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _DIYButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_DIYButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_DIYButton];
}
- (void)setSubViewLayout{
    //标题
    [_headerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kFrontGap);
        make.right.equalTo(0);
        make.bottom.equalTo(-5);
    }];
    //热门产品按钮
    UIImage *changeProductButtonImage = [UIImage imageNamed:@"home_btn_change"];
    [_productButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(changeProductButtonImage.size);
        make.right.equalTo(-19);
        make.bottom.equalTo(_headerNameLabel.mas_bottom).with.offset(-5);
    }];
    //查看更多按钮
    [_DIYButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(18);
        make.width.equalTo(150);
        make.right.equalTo(0);
        make.bottom.equalTo(_headerNameLabel.mas_bottom);
    }];

}
- (void)reloadSectionHeaderViewWithName:(NSString *)name{
    _headerNameLabel.text = name;
}
#pragma mark - Event response
//点击按钮
- (void)buttonPressed:(UIButton *)button{
    NSString *name;
    if (button == _DIYButton) {
        name = @"ZDHHomePageSectionHeaderViewDIY";
    }else{
        name = @"ZDHHomePageSectionHeaderViewProduct";
    }
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:nil];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//选择HeaderView模式
- (void)selectHeaderViewType:(ViewType)type{
    switch (type) {
        case 0:
            [self selectDIYViewType];
            break;
        case 1:
            [self selectProductViewType];
            break;
        case 2:
            [self selectOtherViewType];
            break;
        default:
            break;
    }
}
//DIY模式
- (void)selectDIYViewType{
    _DIYButton.hidden = NO;
    _productButton.hidden = YES;
}
//热门产品模式
- (void)selectProductViewType{
    _DIYButton.hidden = YES;
    _productButton.hidden = NO;
    
}
//其他模式
- (void)selectOtherViewType{
    _DIYButton.hidden = YES;
    _productButton.hidden = YES;
}





@end
