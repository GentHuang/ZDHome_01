//
//  ZDHUserProductListCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserProductListCell.h"
//Lib
#import "Masonry.h"
//Macros
#define kUpLabelFont 20
#define kDownLabelFont 15
#define kUpLabelTag 30000
#define kDownLabelTag 31000
@interface ZDHUserProductListCell()
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIImageView *photoImageView;
@property (strong, nonatomic) NSArray *upContentArray;
@property (strong, nonatomic) NSArray *downNameArray;
@end


@implementation ZDHUserProductListCell
#pragma mark - Init methods
- (void)initData{
    _upContentArray = @[@"现代沙发",@"￥10000",@"1(件)",@"￥10000"];
    _downNameArray = @[@"型号:",@"规格:"];
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
    //背景
    _backView = [[UIView alloc] init];
    [self.contentView addSubview:_backView];
    //图片
    _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp_home_product_8"]];
    [_backView addSubview:_photoImageView];
}
- (void)setSubViewLayout{
    //背景
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(63/2);
        make.right.equalTo(-51/2);
        make.bottom.equalTo(0);
    }];
    //图片
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20/2);
        make.left.equalTo(0);
        make.height.equalTo(163/2);
        make.width.equalTo(170/2);
    }];
    //创建上部列表
    for (int i = 0; i < _upContentArray.count; i ++) {
        UILabel *upLabel = [[UILabel alloc] init];
        upLabel.tag = i + kUpLabelFont;
        upLabel.font = FONTSIZES(kUpLabelFont);
        upLabel.text = _upContentArray[i];
        [_backView addSubview:upLabel];
        if (i == 0) {
            upLabel.textAlignment = NSTextAlignmentLeft;
            [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(35/2);
                make.left.equalTo(267/2);
                make.width.equalTo(550/2);
            }];
        }
        if (i == 1) {
            upLabel.textAlignment = NSTextAlignmentCenter;
            [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(35/2);
                make.centerX.mas_equalTo(-38);
                make.width.mas_equalTo(200);
            }];
        }
        if (i == 2) {
            upLabel.textAlignment = NSTextAlignmentCenter;
            [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(35/2);
                make.centerX.mas_equalTo(158);
                make.width.mas_equalTo(200);
            }];
        }
        if (i == 3){
            upLabel.textAlignment = NSTextAlignmentRight;
            [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(35/2);
                make.right.equalTo(0);
                make.width.equalTo(200);
            }];
        }
    }
    //创建下部表格
    for (int i = 0; i < _downNameArray.count; i ++) {
        //名称
        UILabel *downLabel = [[UILabel alloc] init];
        downLabel.font = FONTSIZES(kDownLabelFont);
        downLabel.text = _downNameArray[i];
        [_backView addSubview:downLabel];
        [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(35/2+kUpLabelFont+i*(kDownLabelFont+6)+6);
            make.left.equalTo(267/2);
            make.width.equalTo(90/2);
            make.height.equalTo(kDownLabelFont);
        }];
        //内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = FONTSIZES(kDownLabelFont);
        contentLabel.tag = i + kDownLabelFont;
        [_backView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(downLabel.mas_top);
            make.left.equalTo(downLabel.mas_right);
            make.right.equalTo(0);
            make.height.equalTo(downLabel.mas_height);
        }];
    }
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//加载名称，单价，数量，价格
- (void)loadUpContentWithDataArray:(NSArray *)dataArray{
    for (int i = 0; i < dataArray.count; i ++) {
        UILabel *upLabel = (UILabel *)[self viewWithTag:i+kUpLabelFont];
        upLabel.text = dataArray[i];
    }
}
//加载型号，规格
- (void)loadDownContentWithDataArray:(NSArray *)dataArray{
    for (int i = 0; i < dataArray.count; i ++) {
        UILabel *downLabel = (UILabel *)[self viewWithTag:i+kDownLabelFont];
        downLabel.text = dataArray[i];
    }
}
//加载图片
- (void)loadImageWithImage:(NSString *)imageString{
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,imageString]]];
//  NSLog(@"产品缩略图地址~~~%@",[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,imageString]]);
}
@end
