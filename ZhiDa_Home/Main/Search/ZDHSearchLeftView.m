//
//  ZDHSearchLeftView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHSearchLeftView.h"
#import "ZDHLeftViewCell.h"
//Libs
#import "Masonry.h"
@interface ZDHSearchLeftView()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
//临时
@property (strong, nonatomic) NSArray *titleArray;
@end
@implementation ZDHSearchLeftView
#pragma mark - Init methods
- (void)initData{
    _titleArray = @[@"MS1201",@"单人沙发",@"实木茶几"];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = LIGHTGRAY;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ZDHLeftViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:_tableView];
}
- (void)setSubViewLayout{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(350);
    }];
    //TableView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(self);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDHLeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell reloadCell:_titleArray[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 156/2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//UITableViewDelegate Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //背景
    UIView *backView = [[UIView alloc] init];
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:200/256.0 green:200/256.0 blue:200/256.0 alpha:1];
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-1);
        make.left.and.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    //热门搜索
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:25];
    nameLabel.backgroundColor = LIGHTGRAY;
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-20);
        make.left.equalTo(20);
        make.right.equalTo(-20);
        make.height.equalTo(50);
    }];
    nameLabel.text = @"热门搜索";
    return backView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHSearchLeftView" object:self userInfo:nil];
}

#pragma mark - Other methods
@end
