//
//  ZDHDesignCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDesignCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kLabelHeight 30
#define kLeftLabelWidth 110
#define kRightLabelWidth 110
#define kLabelFont 20
#define kDesignListLabelTag 23000
#define kMethodListLabelTag 24000
@interface ZDHDesignCell()
@property (strong, nonatomic) UIView *backImageView;
@property (strong, nonatomic) UIButton *caseButton;
@property (strong, nonatomic) UIButton *detailButton;
@property (strong, nonatomic) NSArray *nameArray;
@property (strong, nonatomic) UIView *secondBackView;
@property (strong, nonatomic) NSArray *secondNameArray;
@property (strong, nonatomic) UIButton *secondCaseButton;
@property (strong, nonatomic) NSString *statusString;
@end

@implementation ZDHDesignCell
#pragma mark - Init methods
- (void)initData{
    _nameArray = @[@"设计单编号:",@"跟进人:",@"设计单状态:",@"提交日期:",@"客户名称:",@"联系电话:",@"所属门店:",@"价格:"];
    _secondNameArray = @[@"方案编号:",@"提交时间:",@"上传人:",@"价格:",@"方案所属门店:",@"电话:"];
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
    //第一种Cell
    //BackImageView
    _backImageView = [[UIView alloc] init];
    _backImageView.layer.borderColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1].CGColor;
    _backImageView.layer.borderWidth = 1;
    _backImageView.backgroundColor = WHITE;
    [self.contentView addSubview:_backImageView];
    //caseButton
    _caseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_caseButton setBackgroundImage:[UIImage imageNamed:@"vip_design_case"] forState:UIControlStateNormal];
    [_caseButton addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:_caseButton];
    //DetailButton
    _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_detailButton setBackgroundImage:[UIImage imageNamed:@"vip_design_order"] forState:UIControlStateNormal];
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
                make.left.equalTo(10);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(@kLeftLabelWidth);
                make.top.equalTo(_caseButton.mas_bottom).with.offset(10);
            }];
            lastLeftView = leftLabel;
        }else if(i%2==0){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
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
        contentLabel.tag = i+kDesignListLabelTag;
        contentLabel.text = @"";
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = FONTSIZES(17.5);
        [_backImageView addSubview:contentLabel];
        if (i%2==0) {
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
    //第二种Cell
    //背景
    _secondBackView = [[UIView alloc] init];
    _secondBackView.layer.borderColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1].CGColor;
    _secondBackView.layer.borderWidth = 1;
    _secondBackView.backgroundColor = WHITE;
    [self.contentView addSubview:_secondBackView];
    //设计方案按钮
    _secondCaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_secondCaseButton setBackgroundImage:[UIImage imageNamed:@"vip_design_case"] forState:UIControlStateNormal];
    [_secondCaseButton addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_secondBackView addSubview:_secondCaseButton];
    //创建表格
    for (int i = 0; i < _secondNameArray.count; i ++) {
        //标题
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.text = _secondNameArray[i];
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        leftLabel.font = FONTSIZES(kLabelFont);
        [_secondBackView addSubview:leftLabel];
        if(i==0){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(kLeftLabelWidth+20);
                make.top.equalTo(_caseButton.mas_bottom).with.offset(10);
            }];
            lastLeftView = leftLabel;
        }else if(i%2==0){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.height.equalTo(kLabelHeight);
                make.width.equalTo(kLeftLabelWidth+20);
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
        contentLabel.tag = i+kMethodListLabelTag;
        contentLabel.text = @"";
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = FONTSIZES(17.5);
        [_secondBackView addSubview:contentLabel];
        if (i%2==0) {
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
    //第一种Cell
    //BackImageView
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(11);
        make.right.equalTo(-20);
        make.bottom.equalTo(-15);
    }];
    //caseButton
    [_caseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.width.equalTo(150);
        make.height.equalTo(40);
        make.left.equalTo(475);
    }];
    //DetailButton
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_caseButton);
        make.left.equalTo(_caseButton.mas_right).with.offset(25);
        make.top.equalTo(_caseButton.mas_top);

    }];
    //第二种Cell
    //背景
    [_secondBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(11);
        make.right.equalTo(-20);
        make.bottom.equalTo(-15);
    }];
    //设计方案按钮
    [_secondCaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_caseButton);
        make.left.equalTo(_caseButton.mas_right).with.offset(25);
        make.top.equalTo(_caseButton.mas_top);
    }];
}
#pragma mark - Event response
//点击Button
- (void)cellButtonPressed:(UIButton *)button{
    NSString *name;
    if (button == _detailButton) {
        //设计单详情
        name = @"ZDHDesignCellDetail";
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:@{@"orderID":_orderID,@"status":_statusString}];
    }else{
        //设计方案
        name = @"ZDHDesignCellCase";
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:@{@"planID":_planID}];
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新设计单列表
- (void)reloadDesignListCellWithArray:(NSArray *)dataArray{
    if (dataArray.count > 1) {
        for (int i = 0; i < dataArray.count; i ++) {
            UILabel *allLabel = (UILabel *)[self viewWithTag:(i+kDesignListLabelTag)];
            allLabel.text = dataArray[i];
            if (i == 2) {
                _statusString = dataArray[i];
            }
        }
    }
}
//刷新设计方案列表
- (void)reloadMethodListCellWithArray:(NSArray *)dataArray{
    if (dataArray.count > 1) {
        for (int i = 0; i < dataArray.count; i ++) {
            UILabel *allLabel = (UILabel *)[self viewWithTag:(i+kMethodListLabelTag)];
            allLabel.text = dataArray[i];
        }
    }
}
//是否存在设计方案
- (void)enableCaseButton:(BOOL)isEnable{
    _caseButton.enabled = isEnable;
}
//选择CellType
- (void)selectCellType:(CellType)type{
    switch (type) {
        case 0:
            [self firstCellType];
            break;
        case 1:
            [self secondCellType];
            break;
        default:
            break;
    }
}
//选择全部
- (void)firstCellType{
    _backImageView.hidden = NO;
    _secondBackView.hidden = YES;
}
//选择设计方案
- (void)secondCellType{
    _backImageView.hidden = YES;
    _secondBackView.hidden = NO;
}
@end
