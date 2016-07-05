//
//  ZDHInterNewsCell.m
//  ZhiDa_Home
//
//  Created by 曾梓麟 on 15/9/4.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHInterNewsCell.h"
//Lib
#import "Masonry.h"
@interface ZDHInterNewsCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *pubdateLabel;
@end
@implementation ZDHInterNewsCell
#pragma mark - Init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
- (void)awakeFromNib {
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = LIGHTGRAY;
    //标题标签
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    //发布日期标签
    _pubdateLabel = [[UILabel alloc] init];
    _pubdateLabel.font = [UIFont systemFontOfSize:15];
    _pubdateLabel.textColor = [UIColor colorWithRed:166/256.0 green:166/256.0 blue:166/256.0 alpha:1];
    [self.contentView addSubview:_pubdateLabel];
}
- (void)setSubViewLayout{
    //标题标签
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(46/2);
        make.left.equalTo(15);
        make.right.equalTo(0);
        make.height.equalTo(50);
    }];
    //发布日期标签
    [_pubdateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-15);
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(0);
        make.height.equalTo(15);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新标题
- (void)reloadTitle:(NSString *)title{
    _titleLabel.text = title;
}
//刷新日期
- (void)reloadPubdate:(NSString *)date{
    _pubdateLabel.text = date;
}
@end
