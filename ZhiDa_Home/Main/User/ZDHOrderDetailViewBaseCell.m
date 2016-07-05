//
//  ZDHOrderDetailViewBaseCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHOrderDetailViewBaseCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kLabelHeight 30
#define kLeftLabelWidth 100
#define kRightLabelWidth 130
#define kLabelFont 20
#define kLabelTag 21000
@interface ZDHOrderDetailViewBaseCell()
@property (strong, nonatomic) NSArray *leftNameArray;
@property (strong, nonatomic) NSArray *leftContentArray;
@property (strong, nonatomic) NSArray *rightNameArray;
@property (strong, nonatomic) NSArray *rightContentArray;
@property (strong, nonatomic) NSArray *labelArray;
@end

@implementation ZDHOrderDetailViewBaseCell
#pragma mark - Init methods
- (void)initData{
    _labelArray = @[@"户型:",@"房屋类型:",@"建筑面积:",@"装修状况:",@"预约编号:",@"预约提交日期:",@"预约人:",@"联系电话:",@"预约渠道:",@"预约上门日期:",@"所属城市:",@"派单门店:",@"审核人:",@"上门方式:",@"所属楼盘:"];
    _leftContentArray = @[@"一居室",@"70m",@"20150319826",@"林某",@"网站/微信",@"广东省佛山市",@"李某（客服）",@"金碧世纪家园"];
    _rightContentArray = @[@"平层楼房",@"未装修",@"2015/3/20 17:00",@"13800138000",@"2015/3/20 17:00",@"珠海志达布艺",@"店员上门/业主到店"];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initData];
        [self createUI];
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
    //创建列表
    UIView *lastLeftView;
    UIView *lastRightView;
    for (int i = 0; i < _labelArray.count; i ++) {
        //标题
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.text = _labelArray[i];
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        leftLabel.font = FONTSIZES(kLabelFont);
        [self.contentView addSubview:leftLabel];
        if(i==0){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(@kLeftLabelWidth);
                make.top.equalTo(0);
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
        contentLabel.tag = i+kLabelTag;
        contentLabel.text = @"";
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = FONTSIZES(17.5);
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        [self.contentView addSubview:contentLabel];
        if (i%2==0) {
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLabel.mas_right);
                make.height.equalTo(@kLabelHeight);
                make.right.equalTo(-469);
                make.top.equalTo(lastLeftView.mas_top);
            }];
        }else{
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastRightView.mas_right);
                make.height.equalTo(@kLabelHeight);
                make.right.equalTo(-20);
                make.top.equalTo(lastRightView.mas_top);
            }];
        }
    }
}
#pragma mark - Event response
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
