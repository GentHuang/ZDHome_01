//
//  ZDHLeftViewCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHLeftViewCell.h"
//Libs
#import "Masonry.h"

@interface ZDHLeftViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@end
@implementation ZDHLeftViewCell
#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
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
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONTSIZES(20);
    _titleLabel.text = @"热门搜索";
    [self.contentView addSubview:_titleLabel];
}
- (void)setSubViewLayout{
    //标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(22);
        make.right.equalTo(0);
        make.height.equalTo(40);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新
- (void)reloadCell:(NSString *)title{
    _titleLabel.text = title;
}
@end
