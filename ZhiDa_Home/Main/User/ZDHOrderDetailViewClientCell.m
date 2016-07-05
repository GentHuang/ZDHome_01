//
//  ZDHOrderDetailViewClientCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHOrderDetailViewClientCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kOtherLabelHeight 33
#define kTopLabelHeight 72
#define kLabelWidth 134
#define kLabelFont 20
#define kLabelTag 22000
@interface ZDHOrderDetailViewClientCell()
@property (strong, nonatomic) NSArray *nameArray;
@end
@implementation ZDHOrderDetailViewClientCell

#pragma mark - Init methods
- (void)initData{
//    _nameArray = @[@"客服备注信息:",@"预约终止反馈:",@"客户反馈信息:"];
     _nameArray = @[@"客服备注信息:",@"客户反馈信息:"];
}
#pragma mark - Life circle
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initData];
        [self createUI];
    }
    return self;
}
- (void)awakeFromNib {
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - Getters and setters
- (void)createUI{
    UILabel *lastLabel;
    for (int i = 0; i < _nameArray.count; i ++) {
        //标题
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = _nameArray[i];
        nameLabel.font = [UIFont systemFontOfSize:kLabelFont];
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        [self.contentView addSubview:nameLabel];
        if(i == 0){
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.height.equalTo(@kTopLabelHeight);
                make.width.equalTo(@kLabelWidth);
                make.top.equalTo(0);
            }];
        }else{
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.height.equalTo(@kOtherLabelHeight);
                make.width.equalTo(@kLabelWidth);
                make.top.equalTo(lastLabel.mas_bottom).with.offset(9);
            }];
        }
        lastLabel = nameLabel;
        //内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.tag = i+kLabelTag;
        contentLabel.numberOfLines = 2;
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = FONTSIZES(17.5);
        contentLabel.text = @"";
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        [self.contentView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right);
            make.top.equalTo(nameLabel.mas_top);
            make.right.equalTo(-20);
            make.height.equalTo(nameLabel.mas_height);
        }];
    }
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新列表
- (void)reloadCellWithArray:(NSArray *)dataArray{
    if (dataArray.count > 0) {
        for (int i = 0; i < dataArray.count; i ++) {
            UILabel *allLabel = (UILabel *)[self viewWithTag:(i+kLabelTag)];
            allLabel.text = dataArray[i];
        }
    }
}
@end
