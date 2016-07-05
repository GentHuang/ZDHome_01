//
//  ZDHProductDetailDescCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/15.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHProductDetailDescCell.h"
//Libs
#import "Masonry.h"
@interface ZDHProductDetailDescCell()
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *scrollContentView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIImage *lineImage;
@end
@implementation ZDHProductDetailDescCell
#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creaeUI];
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
- (void)creaeUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    //ScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_scrollView];
    //ScrollContentView
    _scrollContentView = [[UIView alloc] init];
    [_scrollView addSubview:_scrollContentView];
    //下划线
    _lineImage = [UIImage imageNamed:@"product_img_line"];
    _lineImageView = [[UIImageView alloc] initWithImage:_lineImage];
    [self.contentView addSubview:_lineImageView];
    //产品描述
    _topLabel = [[UILabel alloc] init];
    _topLabel.text = @"产品描述:";
    _topLabel.font = FONTSIZESBOLD(20);
    [self.contentView addSubview:_topLabel];
}
- (void)setSubViewsLayout{
    //下划线
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(8);
        make.size.equalTo(_lineImage.size);
        make.bottom.equalTo(0);
    }];
    //产品描述
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineImageView.mas_left);
        make.top.equalTo(12);
        make.right.equalTo(_lineImageView.mas_right);
        make.height.equalTo(20);
    }];
    //ScrollView
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLabel.mas_bottom);
        make.left.equalTo(_lineImageView.mas_left);
        make.right.equalTo(-30);
        make.bottom.equalTo(@-15);
    }];
    //ScrollContentView
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
}
- (void)reloadDescCellWithWidth:(CGFloat)width content:(NSString *)content{
    //清空旧数据
    [self deleteSubViews:_scrollContentView];
    //添加新数据
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.text = content;
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:18];
    [_scrollContentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollContentView);
    }];
    NSDictionary *dic = @{NSFontAttributeName:_contentLabel.font};
    CGRect bounds = [content boundingRectWithSize:CGSizeMake(width-42.5,3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    [_scrollContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(bounds.size.height);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//删除子View
- (void)deleteSubViews:(UIView *)view{
    for (UIView *subView in [view subviews]) {
        [subView removeFromSuperview];
    }
}

@end
