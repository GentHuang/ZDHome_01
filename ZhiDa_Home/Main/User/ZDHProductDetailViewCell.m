//
//  ZDHProductDetailViewCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductDetailViewCell.h"
//Lib
#import "Masonry.h"
//Macros
#define kTopLineHeight 27
#define kOtherLineHeight 30
#define kBigLineHeight 44
#define kOtherCellHeight 37
#define kLastCellHeight 32.5
#define kLastCellLeftWidth  135
#define kLastCellRightWidth 135

#define kLabelHeight 30
#define kLeftLabelWidth 80
#define kRightLabelWidth 100
#define kLabelFont 20
#define kLabelTag 30000

#define kBaseLabelTag 31000
#define kExpressLabelTag 32000
#define kFurnitureTag 33000
#define kOtherTag 34000
@interface ZDHProductDetailViewCell()
@property (strong, nonatomic) UIImageView *firstBackImageView;
@property (strong, nonatomic) UILabel *firstTopNumberLabel;
@property (strong, nonatomic) UILabel *firstNumberLabel;
@property (strong, nonatomic) UILabel *firstStyleNumberLabel;
@property (strong, nonatomic) UIImageView *firstImageView;
@property (strong, nonatomic) UILabel *firstImageLabel;
@property (strong, nonatomic) UILabel *firstNameLabel;
@property (strong, nonatomic) UILabel *firstTypeLabel;
@property (strong, nonatomic) UILabel *firstSizeLabel;
@property (strong, nonatomic) UILabel *firstCountLabel;
@property (strong, nonatomic) UILabel *firstUnitLabel;
@property (strong, nonatomic) UILabel *firstModeLabel;
@property (strong, nonatomic) UILabel *firstRemarkLabel;
@property (strong, nonatomic) UILabel *firstRemarkContentLabel;

@property (strong, nonatomic) UIImageView *furnitureBackView;

@property (strong, nonatomic) UIImageView *otherBackImageView;
@property (strong, nonatomic) NSMutableArray *otherNameArray;
//-------------------变成公开的属性------------------
//@property (strong, nonatomic) UIView *lastBackView;
//@property (strong, nonatomic) NSMutableArray *lastNameArray;

@property (strong, nonatomic) UIView *logiticsBackView;
@property (strong, nonatomic) NSArray *logiticsArray;

@property (strong, nonatomic) NSArray *widthArray;

//测试
@property (strong, nonatomic) NSArray *testArray;
@end

@implementation ZDHProductDetailViewCell
#pragma mark - Init methods
- (void)initData{
    //其他类型Cell
    _otherNameArray = [NSMutableArray arrayWithArray:@[@"序号",@"商品图片",@"型号",@"尺寸",@"规格",@"数量",@"单位",@"备注信息"]];
    //订单基本信息Cell
    _lastNameArray = [NSMutableArray arrayWithArray:@[@"订单编号:",@"下单人:",@"门店:",@"期待出货日期:",@"下单日期:",@"订单备注:",@"货期反馈:",@"跟单员:",@"审核日期:",@"审单员:",@"审核日期:"]];
    //物流Cell
    _logiticsArray = @[@"Erp单号:",@"承运商:",@"运单号:",@"发货日期:",@"件数:",@"运费:",@"联系电话:",@""];
    //指定长度数组
    _widthArray = @[@59,@114,@160,@90,@67,@94];
    
    //测试
    _testArray = @[@"测试",@"1",@"2",@"3",@"4",@"5"];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = WHITE;
    //窗帘
    //背景
    _firstBackImageView = [[UIImageView alloc] init];
    _firstBackImageView.hidden = YES;
    [self.contentView addSubview:_firstBackImageView];
    //序列号
    _firstTopNumberLabel = [[UILabel alloc] init];
    _firstTopNumberLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstTopNumberLabel.layer.borderWidth = 0.5;
    _firstTopNumberLabel.text = @"序号";
    _firstTopNumberLabel.textAlignment = NSTextAlignmentCenter;
    [_firstBackImageView addSubview:_firstTopNumberLabel];
    //
    _firstNumberLabel = [[UILabel alloc] init];
    _firstNumberLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstNumberLabel.layer.borderWidth = 0.5;
    _firstNumberLabel.text = @"1";
    _firstNumberLabel.textAlignment = NSTextAlignmentCenter;
    [_firstBackImageView addSubview:_firstNumberLabel];
    //款式编号
    _firstStyleNumberLabel = [[UILabel alloc] init];
    _firstStyleNumberLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstStyleNumberLabel.layer.borderWidth = 0.5;
    _firstStyleNumberLabel.text = @"款式编号";
    _firstStyleNumberLabel.textAlignment = NSTextAlignmentCenter;
    [_firstBackImageView addSubview:_firstStyleNumberLabel];
    //图片
    _firstImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"420_600"]];
    [_firstBackImageView addSubview:_firstImageView];
    //图片下文字
    _firstImageLabel = [[UILabel alloc] init];
    _firstImageLabel.text = @"ZZ3009";
    _firstImageLabel.textAlignment = NSTextAlignmentCenter;
    [_firstBackImageView addSubview:_firstImageLabel];
    //名称
    _firstNameLabel = [[UILabel alloc] init];
    _firstNameLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstNameLabel.layer.borderWidth = 0.5;
    _firstNameLabel.text = @"名称";
    _firstNameLabel.textAlignment = NSTextAlignmentCenter;
    [_firstBackImageView addSubview:_firstNameLabel];
    //货名/型号
    _firstTypeLabel = [[UILabel alloc] init];
    _firstTypeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstTypeLabel.layer.borderWidth = 0.5;
    _firstTypeLabel.text = @"货名/型号";
    _firstTypeLabel.textAlignment = NSTextAlignmentCenter;
    [_firstBackImageView addSubview:_firstTypeLabel];
    //成品尺寸(宽*高)
    _firstSizeLabel = [[UILabel alloc] init];
    _firstSizeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstSizeLabel.layer.borderWidth = 0.5;
    _firstSizeLabel.textAlignment = NSTextAlignmentCenter;
    _firstSizeLabel.text = @"成品尺寸(宽*高)";
    [_firstBackImageView addSubview:_firstSizeLabel];
    //开料数量
    _firstCountLabel = [[UILabel alloc] init];
    _firstCountLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstCountLabel.layer.borderWidth = 0.5;
    _firstCountLabel.text = @"开料数量";
    _firstCountLabel.textAlignment = NSTextAlignmentCenter;
    [_firstBackImageView addSubview:_firstCountLabel];
    //单位
    _firstUnitLabel = [[UILabel alloc] init];
    _firstUnitLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstUnitLabel.layer.borderWidth = 0.5;
    _firstUnitLabel.textAlignment = NSTextAlignmentCenter;
    _firstUnitLabel.text = @"单位";
    [_firstBackImageView addSubview:_firstUnitLabel];
    //窗帘形式
    _firstModeLabel = [[UILabel alloc] init];
    _firstModeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstModeLabel.layer.borderWidth = 0.5;
    _firstModeLabel.text = @"窗帘形式";
    _firstModeLabel.textAlignment = NSTextAlignmentCenter;
    [_firstBackImageView addSubview:_firstModeLabel];
    //备注
    _firstRemarkLabel = [[UILabel alloc] init];
    _firstRemarkLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstRemarkLabel.layer.borderWidth = 0.5;
    _firstRemarkLabel.textAlignment = NSTextAlignmentCenter;
    _firstRemarkLabel.text = @"备注";
    [_firstBackImageView addSubview:_firstRemarkLabel];
    //备注内容
    _firstRemarkContentLabel = [[UILabel alloc] init];
    _firstRemarkContentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstRemarkContentLabel.layer.borderWidth = 0.5;
    _firstRemarkContentLabel.numberOfLines = 0;
    _firstRemarkContentLabel.textAlignment = NSTextAlignmentCenter;
    _firstRemarkContentLabel.backgroundColor = CLEAR;
    [_firstBackImageView addSubview:_firstRemarkContentLabel];
    
    //家具类型Cell
    //    _furnitureBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_pro_table2"]];
    _furnitureBackView = [[UIImageView alloc]initWithImage:nil];
    _furnitureBackView.hidden = YES;
    [self.contentView addSubview:_furnitureBackView];
    //创建表格
    UIView *lastView;
    for (int i = 0; i < _otherNameArray.count; i ++) {
        //名称标签
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = _otherNameArray[i];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.layer.borderWidth = 0.3;
        nameLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_furnitureBackView addSubview:nameLabel];
        if (i == 0) {
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(0);
                make.width.equalTo(84/2);
            }];
        }else if(i==1){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(252/2);//272/2
            }];
        }else if (i==2){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(365/2);//425/2
            }];
        }else if (i==3){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(197/2);//210/2
            }];
        }else if (i==4){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(198/2);//105/2
            }];
        }else if (i==5){//添加
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(145/2);//185/2
            }];
        }else if (i==6){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(145/2);//185/2
            }];
        }else if (i==7){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(236/2);//256/2
            }];
        }
        lastView = nameLabel;
        //内容标签
        if (i!=1) {
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.tag = i + kFurnitureTag;
            contentLabel.textAlignment = NSTextAlignmentCenter;
            contentLabel.layer.borderWidth = 0.3;
            contentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [_furnitureBackView addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(nameLabel);
                make.bottom.equalTo(0);
                make.top.equalTo(nameLabel.mas_bottom);
            }];
        }else{
            UIImageView *contentImageView = [[UIImageView alloc] init];
            contentImageView.tag = i + kFurnitureTag;
            [_furnitureBackView addSubview:contentImageView];
            [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(65);//65
                make.width.equalTo(80);
                make.centerX.equalTo(nameLabel.mas_centerX);
                make.top.equalTo(nameLabel.mas_bottom).with.offset(1);
            }];
            //--------------添加图片底部的划线--------------
            UILabel *linelabel = [[UILabel alloc]init];
            linelabel.backgroundColor = [UIColor lightGrayColor];
            [contentImageView addSubview:linelabel];
            [linelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(contentImageView.mas_bottom).offset(0);
                make.centerX.equalTo(contentImageView.mas_centerX);
                make.width.equalTo(nameLabel.mas_width);
                make.height.equalTo(0.5);
            }];
        }
    }
    //其他类型的Cell
    //背景
    _otherBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_pro_table2"]];
    _otherBackImageView.hidden = YES;
    [self.contentView addSubview:_otherBackImageView];
    //创建表格
    for (int i = 0; i < _otherNameArray.count; i ++) {
        //名称标签
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = _otherNameArray[i];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [_otherBackImageView addSubview:nameLabel];
        if (i == 0) {
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(0);
                make.width.equalTo(84/2);
            }];
        }else if(i==1){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(272/2);
            }];
        }else if (i==2){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(425/2);
            }];
        }else if (i==3){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(210/2);
            }];
        }else if (i==4){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(185/2);
            }];
        }else if (i==5){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(185/2);
            }];
        }else if (i==6){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.height.equalTo(kOtherCellHeight);
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(256/2);
            }];
        }
        lastView = nameLabel;
        //内容标签
        if (i!=1) {
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.tag = i + kOtherTag;
            contentLabel.textAlignment = NSTextAlignmentCenter;
            [_otherBackImageView addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(nameLabel);
                make.bottom.equalTo(0);
                make.top.equalTo(nameLabel.mas_bottom);
            }];
        }else{
            UIImageView *contentImageView = [[UIImageView alloc] init];
            contentImageView.tag = i + kOtherTag;
            [_otherBackImageView addSubview:contentImageView];
            [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(50);
                make.width.equalTo(80);
                make.centerX.equalTo(nameLabel.mas_centerX);
                make.top.equalTo(nameLabel.mas_bottom).with.offset(12);
                
            }];
        }
    }
    //订单基本信息Cell
    //背景
    _lastBackView = [[UIView alloc] init];
    _lastBackView.hidden = YES;
    _lastBackView.backgroundColor = WHITE;
    [self.contentView addSubview:_lastBackView];
    //创建表格
    UIView *lastLeftView;
    UIView *lastRightView;
    for (int i = 0; i < _lastNameArray.count; i ++) {
        //名称标签
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = FONTSIZES(kLabelFont);
        nameLabel.text = _lastNameArray[i];
        nameLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        nameLabel.textAlignment = NSTextAlignmentRight;
        [_lastBackView addSubview:nameLabel];
        //内容标签
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.tag = i + kBaseLabelTag;
        contentLabel.font = FONTSIZES(17.5);
        contentLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        [_lastBackView addSubview:contentLabel];
        //        if (i<=4) {
        if (i==0) {
            //名称标签
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(0);
                make.height.equalTo(kLastCellHeight);
                make.width.equalTo(kLastCellLeftWidth);
            }];
            lastLeftView = nameLabel;
            //内容标签
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastLeftView.mas_right);
                make.top.equalTo(lastLeftView.mas_top);
                make.height.equalTo(lastLeftView.mas_height);
                make.right.equalTo(0);
            }];
        }else if (i%2!=0){
            //名称标签
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(lastLeftView.mas_bottom).with.offset(8);
                make.height.equalTo(kLastCellHeight);
                make.width.equalTo(kLastCellLeftWidth);
            }];
            lastLeftView = nameLabel;
            //内容标签
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastLeftView.mas_right);
                make.top.equalTo(lastLeftView.mas_top);
                make.height.equalTo(lastLeftView.mas_height);
                make.right.equalTo(-417);
            }];
        }else{
            //名称标签
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(419);
                make.top.equalTo(lastLeftView.mas_top);
                make.height.equalTo(kLastCellHeight);
                make.width.equalTo(kLastCellRightWidth);
            }];
            lastRightView = nameLabel;
            //内容标签
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastRightView.mas_right);
                make.top.equalTo(lastRightView.mas_top);
                make.height.equalTo(lastRightView.mas_height);
                make.right.equalTo(0);
            }];
        }
        //        }else{
        //            if (i==5) {
        //                //名称标签
        //                [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //                    make.left.equalTo(0);
        //                    make.top.equalTo(lastLeftView.mas_bottom).with.offset(8);
        //                    make.height.equalTo(kLastCellHeight);
        //                    make.width.equalTo(kLastCellLeftWidth);
        //                }];
        //                lastLeftView = nameLabel;
        //                //内容标签
        //                [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //                    make.left.equalTo(lastLeftView.mas_right);
        //                    make.top.equalTo(lastLeftView.mas_top);
        //                    make.height.equalTo(lastLeftView.mas_height);
        //                    make.right.equalTo(0);
        //                }];
        //            }else if (i%2==0){
        //                //名称标签
        //                [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //                    make.left.equalTo(0);
        //                    make.top.equalTo(lastLeftView.mas_bottom).with.offset(8);
        //                    make.height.equalTo(kLastCellHeight);
        //                    make.width.equalTo(kLastCellLeftWidth);
        //                }];
        //                lastLeftView = nameLabel;
        //                //内容标签
        //                [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //                    make.left.equalTo(lastLeftView.mas_right);
        //                    make.top.equalTo(lastLeftView.mas_top);
        //                    make.height.equalTo(lastLeftView.mas_height);
        //                    make.right.equalTo(-417);
        //                }];
        //            }else{
        //                //名称标签
        //                [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //                    make.left.equalTo(419);
        //                    make.top.equalTo(lastLeftView.mas_top);
        //                    make.height.equalTo(kLastCellHeight);
        //                    make.width.equalTo(kLastCellRightWidth);
        //                }];
        //                lastRightView = nameLabel;
        //                //内容标签
        //                [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //                    make.left.equalTo(lastRightView.mas_right);
        //                    make.top.equalTo(lastRightView.mas_top);
        //                    make.height.equalTo(lastRightView.mas_height);
        //                    make.right.equalTo(0);
        //                }];
        //            }
        //
        //        }
        
    }
    //物流Cell
    //背景
    _logiticsBackView = [[UIView alloc] init];
    _logiticsBackView.hidden = YES;
    _logiticsBackView.backgroundColor = WHITE;
    [self.contentView addSubview:_logiticsBackView];
    //创建表格
    for (int i = 0; i < _logiticsArray.count; i ++) {
        //标题
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.text = _logiticsArray[i];
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        leftLabel.font = FONTSIZES(kLabelFont);
        [_logiticsBackView addSubview:leftLabel];
        if(i==0){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(kLeftLabelWidth+20);
                make.top.equalTo(0);
            }];
            lastLeftView = leftLabel;
        }else if(i%2==0){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.height.equalTo(kLabelHeight);
                make.width.equalTo(kLeftLabelWidth+20);
                make.top.equalTo(lastLeftView.mas_bottom).with.offset(9);
            }];
            lastLeftView = leftLabel;
        }
        else{
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(419);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(@kRightLabelWidth);
                make.top.equalTo(lastLeftView.mas_top);
            }];
            lastRightView = leftLabel;
        }
        //内容标签
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.tag = i+kExpressLabelTag;
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        contentLabel.font = FONTSIZES(17.5);
        [_logiticsBackView addSubview:contentLabel];
        if (i%2==0) {
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLabel.mas_right);
                make.height.equalTo(@kLabelHeight);
                make.right.equalTo(-417);
                make.top.equalTo(lastLeftView.mas_top);
            }];
        }else{
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastRightView.mas_right);
                make.height.equalTo(@kLabelHeight);
                make.right.equalTo(0);
                make.top.equalTo(lastRightView.mas_top);
            }];
        }
    }
    
    
}
//创建物流cell
- (void)createExpressInfo:(NSArray*)array {
    
    
}
- (void)setSubViewLayout{
    //窗帘
    //背景
    [_firstBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12);
        make.top.equalTo(0);
        make.right.equalTo(-20);
        make.height.equalTo(372/2);
    }];
    //序列号
    [_firstTopNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.width.equalTo(40);
        make.height.equalTo(kTopLineHeight);
        make.top.equalTo(0);
    }];
    [_firstNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstTopNumberLabel.mas_top).with.offset(-0.5);
        make.left.equalTo(0);
        make.width.equalTo(_firstTopNumberLabel.mas_width);
    }];
    //款式编号
    [_firstStyleNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstNumberLabel.mas_right).with.offset(-0.5);
        make.top.equalTo(0);
        make.height.equalTo(kTopLineHeight);
        make.width.equalTo(110);
    }];
    //图片
    [_firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstStyleNumberLabel.mas_bottom);
        make.left.equalTo(_firstNumberLabel.mas_right);
        make.right.equalTo(_firstStyleNumberLabel.mas_right).with.offset(-3);
        make.height.equalTo(232/2);
    }];
    //图片下文字
    [_firstImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstImageView.mas_left);
        make.right.equalTo(_firstImageView.mas_right);
    }];
    //名称
    [_firstNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(kTopLineHeight);
        make.left.equalTo(_firstStyleNumberLabel.mas_right).with.offset(-0.5);
        make.width.equalTo(118/2);
    }];
    //货名/型号
    [_firstTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(kTopLineHeight);
        make.left.equalTo(_firstNameLabel.mas_right).with.offset(-0.5);
        make.width.equalTo(228/2);
    }];
    //成品尺寸(宽*高)
    [_firstSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(_firstTypeLabel.mas_right).with.offset(-0.5);
        make.height.equalTo(kTopLineHeight);
        make.width.equalTo(320/2);
    }];
    //开料数量
    [_firstCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(kTopLineHeight);
        make.left.equalTo(_firstSizeLabel.mas_right).with.offset(-0.5);
        make.width.equalTo(180/2);
    }];
    //单位
    [_firstUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(kTopLineHeight);
        make.left.equalTo(_firstCountLabel.mas_right).with.offset(-0.5);
        make.width.equalTo(135/2);
    }];
    //窗帘形式
    [_firstModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(kTopLineHeight);
        make.left.equalTo(_firstUnitLabel.mas_right).with.offset(-0.5);
        make.width.equalTo(188/2);
    }];
    //备注
    [_firstRemarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(kTopLineHeight);
        make.left.equalTo(_firstModeLabel.mas_right).with.offset(-0.5);
        make.width.equalTo(148/2);
    }];
    //备注内容
    [_firstRemarkContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstRemarkLabel.mas_bottom).with.offset(-0.5);
        make.left.and.right.equalTo(_firstRemarkLabel);
    }];
    //家具类型的Cell
    [_furnitureBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12);
        make.top.equalTo(0);
        make.right.equalTo(-20);
        make.height.equalTo(206/2);
    }];
    //其他类型的Cell
    //背景
    [_otherBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12);
        make.top.equalTo(0);
        make.right.equalTo(-20);
        make.height.equalTo(206/2);
    }];
    //最后一种Cell
    //背景
    [_lastBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12);
        make.top.equalTo(0);
        make.right.equalTo(-20);
        make.height.equalTo(465/2);
    }];
    //物流Cell
    //背景
    [_logiticsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12);
        make.top.equalTo(0);
        make.right.equalTo(-20);
        make.height.equalTo(300/2);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//选择Cell的模式
- (void)selectCellType:(CellType)type{
    switch (type) {
        case 0:
            [self firstCellType];
            break;
        case 1:
            [self otherCellType];
            break;
        case 2:
            [self baseCellType];
            break;
        case 3:
            [self logiticsCellType];
            break;
        case 4:
            [self furnitureCellType];
            break;
        default:
            break;
    }
}
//大Cell
- (void)firstCellType{
    _firstBackImageView.hidden = NO;
    _otherBackImageView.hidden = YES;
    _lastBackView.hidden = YES;
    _logiticsBackView.hidden = YES;
    _furnitureBackView.hidden = YES;
}
//其他Cell
- (void)otherCellType{
    _firstBackImageView.hidden = YES;
    _otherBackImageView.hidden = NO;
    _lastBackView.hidden = YES;
    _logiticsBackView.hidden = YES;
    _furnitureBackView.hidden = YES;
}
//订单基本信息Cell
- (void)baseCellType{
    _firstBackImageView.hidden = YES;
    _otherBackImageView.hidden = YES;
    _lastBackView.hidden = NO;
    _logiticsBackView.hidden = YES;
    _furnitureBackView.hidden = YES;
}
//物流Cell
- (void)logiticsCellType{
    _firstBackImageView.hidden = YES;
    _otherBackImageView.hidden = YES;
    _lastBackView.hidden = YES;
    _logiticsBackView.hidden = NO;
    _furnitureBackView.hidden = YES;
}
//家具Cell
- (void)furnitureCellType{
    _firstBackImageView.hidden = YES;
    _otherBackImageView.hidden = YES;
    _lastBackView.hidden = YES;
    _logiticsBackView.hidden = YES;
    _furnitureBackView.hidden = NO;
}
//载入基本信息
- (void)loadBaseInfoWithDataArray:(NSArray *)dataArray{
    for (int i = 0; i < dataArray.count; i ++) {
        UILabel *allLabel = (UILabel *)[self viewWithTag:i+kBaseLabelTag];
        allLabel.text = dataArray[i];
    }
}
//载入物流信息
- (void)loadExpressInfoWithDataArray:(NSArray *)dataArray{
    for (int i = 0; i < dataArray.count; i ++) {
        UILabel *allLabel = (UILabel *)[self viewWithTag:i+kExpressLabelTag];
        allLabel.text = dataArray[i];
        
    }
}
//载入窗帘信息
- (void)loadCurtainDetailWithDataArray:(NSArray *)dataOrginArray index:(NSInteger)index image:(NSString *)imageString name:(NSString *)name remark:(NSString *)remark{
    
    //判断返回的数据是否是6的整数倍,如果不是则补全为整数倍
     NSMutableArray *dataArray = [NSMutableArray arrayWithArray:dataOrginArray];
    int remainderData = dataOrginArray.count%6;
    if (remainderData !=0) {
        for (int k =0; k<(6-remainderData); k++) {
            [dataArray addObject:@" "];
        }
    }
    
    
    float maxHeight = 40.0;
    UIView *lastTopView;
    UIView *lastLeftView;
    for (int i = 0; i < dataArray.count; i ++) {
        if (i%6 == 0) {
            //每隔6个计算一次行高
            maxHeight = 40.0;
            for (int j = 0; j < 6; j ++) {
                
                if ((j+i)<dataArray.count) {
                    
                    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:kLabelFont]};
                    CGRect bounds = [dataArray[i+j] boundingRectWithSize:CGSizeMake([_widthArray[j] floatValue], 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
                    
                    if (bounds.size.height >= maxHeight) {
                        maxHeight = bounds.size.height;
                    }
                }
            }
        }
        UILabel *allLabel = [[UILabel alloc] init];
        allLabel.numberOfLines = 0;
        allLabel.text = dataArray[i];
        allLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        allLabel.layer.borderWidth = 0.5;
        allLabel.textAlignment = NSTextAlignmentCenter;
        [_firstBackImageView addSubview:allLabel];
        if (i == 0) {
            //首行
            [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_firstNameLabel.mas_bottom).with.offset(-0.5);
                make.left.mas_equalTo(_firstNameLabel.mas_left);
                make.width.mas_equalTo([_widthArray firstObject]);
                make.height.mas_equalTo(maxHeight);
            }];
            lastTopView = allLabel;
            lastLeftView = allLabel;
        }else if (i%6 == 0) {
            //换行
            [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastTopView.mas_bottom).with.offset(-0.5);
                make.left.mas_equalTo(_firstNameLabel.mas_left);
                make.width.mas_equalTo([_widthArray firstObject]);
                make.height.mas_equalTo(maxHeight);
            }];
            lastTopView = allLabel;
            lastLeftView = allLabel;
        }else{
            [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastLeftView.mas_top);
                make.left.mas_equalTo(lastLeftView.mas_right).with.offset(-0.5);
                make.width.mas_equalTo(_widthArray[i%6]);
                make.height.mas_equalTo(maxHeight);
            }];
            lastLeftView = allLabel;
        }
    }
    //序号
    _firstNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)index];
    [_firstNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lastTopView.mas_bottom);
    }];
    //备注
    _firstRemarkContentLabel.text = remark;
    [_firstRemarkContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lastTopView.mas_bottom);
    }];
    //名称
    _firstImageLabel.text = name;
    [_firstImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lastTopView.mas_bottom);
    }];
    //图片
    [_firstImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,imageString]]];
    //下划线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_firstImageLabel addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(2);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
    //    //添加多一行显示窗帘信息
    //    for (int i = 0; i < 9; i++) {
    //
    //        UILabel *allLabel = [[UILabel alloc] init];
    //        allLabel.numberOfLines = 0;
    //        allLabel.text = dataArray[i];
    //        allLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //        allLabel.layer.borderWidth = 0.5;
    //        allLabel.textAlignment = NSTextAlignmentCenter;
    //        [_firstBackImageView addSubview:allLabel];
    //
    //
    //    }
    
}
//载入家具信息
- (void)loadFurnitureInfoWithDataArray:(NSArray *)dataArray{
    __block SDPieProgressView *pv;
    __block ZDHProductDetailViewCell *selfView = self;
    for (int i = 0; i < dataArray.count; i ++) {
        if (i == 1) {
            UIImageView *allImageView = (UIImageView *)[self viewWithTag:i+kFurnitureTag];
            //            [allImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGURL,dataArray[i]]]];
            //添加加载提示
            [allImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,dataArray[i]]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //下载图片开始
                //加载进度条
                if (!pv) {
                    pv = [[SDPieProgressView alloc] init];
                    pv.backgroundColor = WHITE;
                    [selfView addSubview:pv];
                    [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(allImageView);
                        make.width.height.mas_equalTo(50);
                    }];
                }
                pv.progress = (float)receivedSize/(float)expectedSize;
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //下载完成
                for (UIView *subView in selfView.subviews) {
                    if ([subView isKindOfClass:[SDPieProgressView class]]) {
                        [subView removeFromSuperview];
                    }
                }
            }];
            
        }else{
            UILabel *allLabel = (UILabel *)[self viewWithTag:i+kFurnitureTag];
            allLabel.text = dataArray[i];
        }
    }
}
//载入其他信息
- (void)loadOtherInfoWithDataArray:(NSArray *)dataArray{
    for (int i = 0; i < dataArray.count; i ++) {
        if (i == 1) {
            UIImageView *allImageView = (UIImageView *)[self viewWithTag:i+kOtherTag];
            //      [allImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGURL,dataArray[i]]]];
            __block SDPieProgressView *pv;
            __block UIImageView  *selfView = allImageView;
            [allImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,dataArray[i]]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //下载图片开始
                //加载进度条
                if (!pv) {
                    pv = [[SDPieProgressView alloc] init];
                    pv.backgroundColor = WHITE;
                    [selfView addSubview:pv];
                    [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(allImageView);
                        make.width.height.mas_equalTo(50);
                    }];
                }
                pv.progress = (float)receivedSize/(float)expectedSize;
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //下载完成
                for (UIView *subView in selfView.subviews) {
                    if ([subView isKindOfClass:[SDPieProgressView class]]) {
                        [subView removeFromSuperview];
                    }
                }
            }];
            
        }else{
            UILabel *allLabel = (UILabel *)[self viewWithTag:i+kOtherTag];
            allLabel.text = dataArray[i];
            
        }
    }
}

@end
