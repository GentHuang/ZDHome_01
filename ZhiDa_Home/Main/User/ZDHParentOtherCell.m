//
//  ZDHParentOtherCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHParentOtherCell.h"
//Libs
#import "Masonry.h"
@interface ZDHParentOtherCell()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIView *blackLine;
@end
@implementation ZDHParentOtherCell
#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self setSubViewLayout];
        //创建通知
        
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = LIGHTGRAY;
    //BlackLine
    _blackLine = [[UIView alloc] init];
    _blackLine.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_blackLine];
    //nameLabel
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"你的账号";
    _nameLabel.font = [UIFont systemFontOfSize:20];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
}
- (void)setSubViewLayout{
    //nameLabel
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(20);
    }];
    //黑色下划线
    [_blackLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(0.5);
        make.width.equalTo(self);
        make.height.equalTo(0.5);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新Cell
- (void)reloadCellWithName:(NSString *)name{
//    NSLog(@"8888------>%@",name);
    _nameLabel.text = name;
}
//创建一个提示view
- (void)creatUpdateImageView {
    _promptImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_promptImage];
    _promptImage.backgroundColor = [UIColor redColor];
    _promptImage.hidden = YES;
    _promptImage.layer.cornerRadius = 7;
    //添加约束
    [_promptImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.size.equalTo(14);
    }];
    //创建通知
    [self createnotification];
}
//监听是否有更新信息
- (void)createnotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadUpdatemessage:) name:@"更新下载" object:nil];
}
- (void)downloadUpdatemessage:(NSNotification*)noti {
    if ([noti.name isEqualToString:@"更新下载"]) {
        
        NSArray *array = noti.userInfo[@"更新"];
        if (array >0) {
            for (NSString *string in array) {
                if ([@"yes" isEqualToString:string]) {
                    _promptImage.hidden = NO;
                    return;
                }
            }
            _promptImage.hidden = YES;
        }
    }
}
@end
