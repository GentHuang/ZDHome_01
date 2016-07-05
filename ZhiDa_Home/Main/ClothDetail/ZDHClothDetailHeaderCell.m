//
//  ZDHClothDetailHeaderCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHClothDetailHeaderCell.h"
//Lisb
#import "Masonry.h"
#define kLabelHeight 0

@interface ZDHClothDetailHeaderCell()
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIImage *lineImage;
//add
@property (strong, nonatomic) UILabel *titleLabel;

@end
@implementation ZDHClothDetailHeaderCell
#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self setSubViewsLayout];
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
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = FONTSIZESBOLD(20);
    [self.contentView addSubview:_titleLabel];
    
    _headerLabel = [[UILabel alloc] init];
    _headerLabel.font = FONTSIZESBOLD(20);
    [self.contentView addSubview:_headerLabel];
    
    _lineImage = [UIImage imageNamed:@"product_img_line"];
    _lineImageView = [[UIImageView alloc] initWithImage:_lineImage];
    [self.contentView addSubview:_lineImageView];
    
    
    
}
- (void)setSubViewsLayout{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mas_centerY);
        make.top.mas_equalTo(self.mas_top).offset(10);
//        make.height.equalTo(self.mas_height);
        make.height.equalTo(kLabelHeight);
        make.width.lessThanOrEqualTo(self.mas_width);
        make.left.equalTo(12.5);
    }];
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
//        make.top.equalTo(_titleLabel.mas_bottom).offset(2);
        make.height.equalTo(30);
        make.width.lessThanOrEqualTo(self.mas_width);
        make.left.equalTo(12.5);
    }];
    
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(8);
        make.size.equalTo(_lineImage.size);
        make.bottom.equalTo(0);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新Cell
- (void)reloadCellWithString:(NSString *)string with:(NSString*)titleString{
    _headerLabel.text = [NSString stringWithFormat:@"【%@】",string];
//    _titleLabel.text = [NSString stringWithFormat:@"所属布板:%@",titleString];
}
//刷新Cell
- (void)reloadCellWithString:(NSString *)string{
    _headerLabel.text = [NSString stringWithFormat:@"【%@】",string];
}
@end
