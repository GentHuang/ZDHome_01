//
//  ZDHUserProductListFooter.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserProductListFooter.h"
//Lib
#import "Masonry.h"
//Macro
#define kNameFont 20

@interface ZDHUserProductListFooter()
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *backButton;
//@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UILabel *discountLabel;
@property (strong, nonatomic) UILabel *discountContentLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@end

@implementation ZDHUserProductListFooter
#pragma mark - Init methods
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    //背景
    _backView = [[UIView alloc] init];//WithFrame:CGRectMake(63/2, 0, 967, 200)];
    [self addSubview:_backView];
    //下划线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:164/256.0 green:164/256.0 blue:164/256.0 alpha:1];
    [_backView addSubview:_lineView];
    //返回
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setTitle:@"返回 >>" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _backButton.backgroundColor = [UIColor whiteColor];
    _backButton.layer.borderColor = [UIColor colorWithRed:143/256.0 green:143/256.0 blue:143/256.0 alpha:1].CGColor;
    _backButton.layer.borderWidth = 1;
    _backButton.layer.masksToBounds = YES;
    _backButton.layer.cornerRadius = 4;
    [_backView addSubview:_backButton];
    //说明
    //    _descLabel = [[UILabel alloc] init];
    //    _descLabel.text = @"(不包含运费)";
    //    _descLabel.textAlignment = NSTextAlignmentRight;
    //    _descLabel.font = [UIFont systemFontOfSize:20];
    //    [_backView addSubview:_descLabel];
    //总计
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"总计";
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.font = [UIFont boldSystemFontOfSize:20];
    _nameLabel.textColor = [UIColor whiteColor];
    [_backView addSubview:_nameLabel];
    //价钱
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.text = @"￥0";
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = [UIFont boldSystemFontOfSize:20];//30
    _priceLabel.textColor = [UIColor whiteColor];
    [_backView addSubview:_priceLabel];
    //折后价
    _discountLabel = [[UILabel alloc] init];
    _discountLabel.text = @"折后价";
    _discountLabel.textAlignment = NSTextAlignmentRight;
    _discountLabel.font = [UIFont boldSystemFontOfSize:20];
    _discountLabel.textColor = [UIColor whiteColor];
    [_backView addSubview:_discountLabel];
    //折后价内容
    _discountContentLabel = [[UILabel alloc] init];
    _discountContentLabel.text = @"￥0";
    _discountContentLabel.textAlignment = NSTextAlignmentRight;
    _discountContentLabel.font = [UIFont boldSystemFontOfSize:20];//30
    _discountContentLabel.textColor = [UIColor whiteColor];
    [_backView addSubview:_discountContentLabel];
}
- (void)setSubViewLayout{
    //背景
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(63/2);
        make.right.equalTo(-51/2);
        make.bottom.equalTo(0);
    }];
    //下划线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(116/2);
        make.top.equalTo(_backView);
        make.left.and.right.equalTo(0);
        make.height.equalTo(1);
    }];
    //返回按钮
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_lineView.mas_bottom).with.offset(50/2);
        make.centerY.equalTo(_backView);
        make.left.equalTo(0);
        make.width.equalTo(295/2);
        make.height.equalTo(40);
    }];
    //说明
    //    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.equalTo(20);
    //        make.left.equalTo(500);
    //        make.right.equalTo(-400/2);
    //        make.bottom.equalTo(_backButton.mas_bottom);
    //    }];
    //总计内容
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_lineView.mas_bottom).with.offset(10);
    }];
    //总计
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_priceLabel.mas_left).with.offset(-10);
        make.top.mas_equalTo(_lineView.mas_bottom).with.offset(15);
    }];
    //折后价
    [_discountContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(10/2);
        make.right.mas_equalTo(0);
    }];
    //折后价
    [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_discountContentLabel.mas_left).with.offset(-10);
        make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(10/2);
    }];
}
#pragma mark - Event response
//点击回退
- (void)buttonPressed:(UIButton *)button{
    self.buttonBlock(button);
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新总价
- (void)reloadTotalPrice:(NSString *)totalPrice{
    _priceLabel.text = totalPrice;
}
//刷新折后价
- (void)reloadDiscountPrice:(NSString *)discountPrice{
    _discountContentLabel.text = discountPrice;
}
@end
