//
//  ZDHConfigDownCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHConfigDownCell.h"
//Libs
#import "Masonry.h"
@interface ZDHConfigDownCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *versionLabel;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UIView *lineView;
@end
@implementation ZDHConfigDownCell
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
    //RightImageView
    _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"config_btn_selected"]];
    [self.contentView addSubview:_rightImageView];
    //LineView
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LIGHTGRAY;
    [self.contentView addSubview:_lineView];
    //VersionLabel
    _versionLabel = [[UILabel alloc] init];
    _versionLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_versionLabel];
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
    //RightImageView
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(17);
        make.height.equalTo(20);
        make.right.equalTo(_lineView.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
    //VersionLabel
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50);
        make.height.equalTo(20);
        make.right.equalTo(_lineView.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//设置Title
- (void)setTitle:(NSString *)name{
    _titleLabel.text = name;
}
//设置VersionLabel
- (void)setVersionLabelWithString:(NSString *)version{
    _versionLabel.text = version;
}
//设置模式
- (void)setCellMode:(CellMode)mode{
    switch (mode) {
        case 0:
            [self imageMode];
            break;
        case 1:
            [self labelMode];
            break;
        default:
            break;
    }
}
- (void)imageMode{
    _rightImageView.hidden = NO;
    _versionLabel.hidden = YES;
}
- (void)labelMode{
    _rightImageView.hidden = YES;
    _versionLabel.hidden = NO;
}

@end
