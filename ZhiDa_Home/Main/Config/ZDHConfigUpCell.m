//
//  ZDHConfigUpCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHConfigUpCell.h"
//Libs
#import "Masonry.h"

@interface ZDHConfigUpCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *sizeLabel;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UIView *lineView;
@end

@implementation ZDHConfigUpCell
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
    //TitleLabel
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"清空图片缓存";
    _titleLabel.font = FONTSIZES(23);
    [self.contentView addSubview:_titleLabel];
    //SizeLabel
    _sizeLabel = [[UILabel alloc] init];
    _sizeLabel.text = @"120.29MB";
    _sizeLabel.textColor = PINK;
    _sizeLabel.font = FONTSIZES(21);
    [self.contentView addSubview:_sizeLabel];
    //RightImageView
    _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"config_btn_selected"]];
    [self.contentView addSubview:_rightImageView];
    //LineView
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LIGHTGRAY;
    
    [self.contentView addSubview:_lineView];
}
- (void)setSubViewLayout{
    //LineView
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.right.equalTo(-20);
        make.bottom.equalTo(-1);
        make.height.equalTo(1);
    }];
    //TitleLabel
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_lineView.mas_top).with.offset(-15);
        make.left.equalTo(_lineView.mas_left);
        make.width.equalTo(150);
        make.height.equalTo(20);
    }];
    //SizeLabel
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right);
        make.bottom.equalTo(_titleLabel.mas_bottom);
        make.height.equalTo(18);
    }];
    //RightImageView
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(17);
        make.height.equalTo(20);
        make.right.equalTo(_lineView.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新缓存大小
- (void)reloadSizeLabel:(NSString *)size{
    _sizeLabel.text = [NSString stringWithFormat:@"%@MB",size];
}
@end
