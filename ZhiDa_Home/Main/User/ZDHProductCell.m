//
//  ZDHProductCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kLabelHeight 30
#define kLeftLabelWidth 100
#define kRightLabelWidth 110
#define kLabelFont 20
#define kLabelTag 25000
@interface ZDHProductCell()
@property (strong, nonatomic) UIView *backImageView;
@property (strong, nonatomic) UIButton *detailButton;
@property (strong, nonatomic) NSArray *nameArray;
@end

@implementation ZDHProductCell
#pragma mark - Init methods
- (void)initData{
    _nameArray = @[@"订单编号:",@"订单状态:",@"下单日期:",@"下单人:",@"订单分类:",@"门店:"];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
        
        [self reloadCellWithArray:_nameArray];
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
    self.backgroundColor = WHITE;
    //BackImageView
    _backImageView = [[UIView alloc] init];
    _backImageView.layer.borderColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1].CGColor;
    _backImageView.layer.borderWidth = 1;
    _backImageView.backgroundColor = WHITE;
    [self.contentView addSubview:_backImageView];
    //DetailButton
    _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_detailButton setBackgroundImage:[UIImage imageNamed:@"vip_order_dt"] forState:UIControlStateNormal];
    [_detailButton addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:_detailButton];
    //创建列表
    UIView *lastLeftView;
    UIView *lastRightView;
    for (int i = 0; i < _nameArray.count; i ++) {
        //标题
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.text = _nameArray[i];
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        leftLabel.font = FONTSIZES(kLabelFont);
        [_backImageView addSubview:leftLabel];
        if(i==0){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_detailButton.mas_bottom).with.offset(10);
                make.left.equalTo(12);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(@kLeftLabelWidth);
            }];
            lastLeftView = leftLabel;
        }else if(i == 5){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastLeftView.mas_bottom).with.offset(9);
                make.left.equalTo(12);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(@kLeftLabelWidth);
            }];
            lastLeftView = leftLabel;
        }else if(i%2!=0){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(12);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(@kLeftLabelWidth);
                make.top.equalTo(lastLeftView.mas_bottom).with.offset(9);
            }];
            lastLeftView = leftLabel;
        }
        else{
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(394);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(@kRightLabelWidth);
                make.top.equalTo(lastLeftView.mas_top);
            }];
            lastRightView = leftLabel;
        }
        //内容标签
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.tag = i+kLabelTag;
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = FONTSIZES(17.5);
        contentLabel.text = @"";
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        [_backImageView addSubview:contentLabel];
        if(i==0 || i==5){
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastLeftView.mas_top);
                make.left.equalTo(lastLeftView.mas_right);
                make.right.equalTo(-12);
                make.height.equalTo(@kLabelHeight);
            }];
        }else if(i%2!=0) {
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLabel.mas_right);
                make.height.equalTo(@kLabelHeight);
                make.right.equalTo(-439);
                make.top.equalTo(lastLeftView.mas_top);
            }];
        }else{
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastRightView.mas_right);
                make.height.equalTo(@kLabelHeight);
                make.right.equalTo(-12);
                make.top.equalTo(lastRightView.mas_top);
            }];
        }
    }
}
- (void)setSubViewLayout{
    //BackImageView
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(11);
        make.right.equalTo(-20);
        make.bottom.equalTo(-15);
    }];
    
    //DetailButton
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(150);
        make.height.equalTo(40);
        make.top.equalTo(10);
        make.right.equalTo(-13);
    }];
}
#pragma mark - Event response
//点击按钮
- (void)cellButtonPressed:(UIButton *)button{
    NSString *name;
    if (button == _detailButton) {
        name = @"ZDHProductCellDetail";
    }
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:@{@"orderID":_orderID}];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新列表
- (void)reloadCellWithArray:(NSArray *)dataArray{
    if (dataArray.count > 1) {
        for (int i = 0; i < dataArray.count; i ++) {
            UILabel *allLabel = (UILabel *)[self viewWithTag:(i+kLabelTag)];
            allLabel.text = dataArray[i];
        }
    }
}
@end
