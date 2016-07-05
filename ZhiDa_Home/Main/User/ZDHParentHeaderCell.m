//
//  ZDHParentHeaderView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHParentHeaderCell.h"
//Libs
#import "Masonry.h"
//Macros

@interface ZDHParentHeaderCell()
//@property (strong, nonatomic) UIImageView *avatarImageView;
//@property (strong, nonatomic) UILabel *nameLabel;
@end
@implementation ZDHParentHeaderCell
#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = LIGHTGRAY;
    //头像
    _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_img_default"]];
    [self.contentView addSubview:_avatarImageView];
    //nameLabel
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"你的账号";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
}
- (void)setSubViewLayout{
    //头像
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(6);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(67);
        make.height.equalTo(67);
    }];
    //nameLabel
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-10);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
}

#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods

@end
