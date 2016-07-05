//
//  ZDHOrderCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHOrderCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kLabelHeight 30
#define kLeftLabelWidth 90
#define kRightLabelWidth 130
#define kLabelFont 20
#define kLabelTag 20000
@interface ZDHOrderCell()
@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) UIView *backImageView;
@property (strong, nonatomic) UIButton *responseButton;
@property (strong, nonatomic) UIButton *detailButton;
@property (strong, nonatomic) NSArray *labelArray;
@end

@implementation ZDHOrderCell
#pragma mark - Init methods
- (void)initData{
    _labelArray = @[@"预约编号:",@"预约状态:",@"预约提交日期:",@"所属城市:",@"联系电话:",@"所属楼盘:",@"预约上门日期:"];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initData];
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
    self.backgroundColor = WHITE;
    //BackImageView
    _backImageView = [[UIView alloc] init];
    _backImageView.layer.borderColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1].CGColor;
    _backImageView.layer.borderWidth = 1;
    _backImageView.backgroundColor = WHITE;
    [self.contentView addSubview:_backImageView];
    //ResponseButton
    _responseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_responseButton setBackgroundImage:[UIImage imageNamed:@"vip_feekback"] forState:UIControlStateNormal];
    [_responseButton addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:_responseButton];
//----------------------------------------------------
    //客户要求在“已接收”状态情况下才显示这个按钮(添加)
    _responseButton.enabled = NO;
//----------------------------------------------------
    //DetailButton
    _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_detailButton setBackgroundImage:[UIImage imageNamed:@"vip_booking"] forState:UIControlStateNormal];
    [_detailButton addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:_detailButton];
    //创建栏目
    UIView *lastLeftView;
    UIView *lastRightView;
    
    UIView *lastContentView;
    for (int i = 0; i < _labelArray.count; i++) {
        //前标题
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.text = _labelArray[i];
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        leftLabel.font = FONTSIZES(kLabelFont);
        [_backImageView addSubview:leftLabel];
        if (i == 0) {
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_responseButton.mas_bottom).with.offset(10);
                make.left.equalTo(12);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(@kLeftLabelWidth);
            }];
            lastLeftView = leftLabel;
        }else if(i%2!=0){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastLeftView.mas_left);
                make.right.equalTo(lastLeftView.mas_right);
                make.top.equalTo(lastLeftView.mas_bottom).with.offset(8);
                make.height.equalTo(kLabelHeight);
            }];
            lastLeftView = leftLabel;
        }else{
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_backImageView.mas_right).with.offset(-422);
                make.width.equalTo(@kRightLabelWidth);
                make.top.equalTo(lastLeftView.mas_top);
                make.height.equalTo(@kLabelHeight);
            }];
            lastRightView = leftLabel;
        }
        //内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.tag = (i+kLabelTag);
        contentLabel.text = @"";
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        contentLabel.font = FONTSIZES(17.5);
        [_backImageView addSubview:contentLabel];
        if (i == 0) {
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastLeftView.mas_top);
                make.left.equalTo(lastLeftView.mas_right);
                make.right.equalTo(-12);
                make.height.equalTo(@kLabelHeight);
            }];
            lastContentView = contentLabel;
        }else if(i%2!=0){
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastLeftView.mas_right);
                make.top.equalTo(lastLeftView.mas_top);
                make.right.equalTo(-440);
                make.height.equalTo(@kLabelHeight);
            }];
        }else{
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastRightView.mas_right);
                make.right.equalTo(lastContentView.mas_right);
                make.top.equalTo(lastRightView.mas_top);
                make.height.equalTo(@kLabelHeight);
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
    //ResponseButton
    [_responseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.width.equalTo(150);
        make.height.equalTo(40);
        make.left.equalTo(475);
    }];
    //DetailButton
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_responseButton);
        make.left.equalTo(_responseButton.mas_right).with.offset(25);
        make.top.equalTo(_responseButton.mas_top);
    }];
}
#pragma mark - Event response
- (void)cellButtonPressed:(UIButton *)button{
    NSString *notificationName;
    if (button == _detailButton) {
        //预约单详情
        notificationName = @"ZDHOrderCellDetail";
    }else{
        //客户反馈
        notificationName = @"ZDHResponseView";
    }
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:@{@"orderID":_orderID}];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新Cell
- (void)loadCellWithDataArray:(NSArray *)dataArray{
    if (dataArray.count > 1) {
        for (int i = 0; i < dataArray.count; i ++) {
            if (i == 0) {
                //预约单号
                _orderID = dataArray[i];
            }
            UILabel *allLabel = (UILabel *)[self viewWithTag:(i+kLabelTag)];
            allLabel.text = dataArray[i];
//----------------------------------------------------
            //取出模型中客户状态(添加)
            _responseButton.enabled = NO;
            if ([dataArray[1] isEqualToString:@"已接收"]) {
                _responseButton.enabled = YES;
            }
//----------------------------------------------------
        }
    }
}
@end
