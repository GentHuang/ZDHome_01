//
//  ZDHUserSuggestView.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserSuggestView.h"
//ViewModel
#import "ZDHUserSuggestViewViewModel.h"
//Libs
#import "Masonry.h"
@interface ZDHUserSuggestView()<UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSArray *headNameArray;
@property (strong, nonatomic) ZDHUserSuggestViewViewModel *vcViewModel;
@end
@implementation ZDHUserSuggestView
#pragma mark - Init methods
- (void)initData{
    //标题头部
    _headNameArray = @[@"时间",@"提出者",@"日志内容"];
    //vcViewModel
    _vcViewModel = [[ZDHUserSuggestViewViewModel alloc] init];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
        [self addObserver];
    }
    return self;
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"orderID"];
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    //BackView
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = LIGHTGRAY;
    [self addSubview:_backView];
    //cancelButton
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_backView addSubview:_cancelButton];
    //ScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = WHITE;
    [_backView addSubview:_scrollView];
    //ContentView
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = WHITE;
    [_scrollView addSubview:_contentView];
}
- (void)setSubViewLayout{
    //BackView
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(560);
        make.height.equalTo(601);
    }];
    //cancelButton
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(16);
        make.width.equalTo(50);
        make.height.equalTo(20);
    }];
    //ScrollView
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(56);
        make.centerX.equalTo(_backView.mas_centerX);
        make.width.equalTo(1062/2);
        make.bottom.equalTo(-15);
    }];
    //ContentView
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
}
#pragma mark - Event response
//点击按钮
- (void)buttonPressed:(UIButton *)button{
    NSString *name;
    if (button == _cancelButton) {
        name = @"ZDHUserSuggestViewCancel";
    }
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:nil];
}
//观察者
- (void)addObserver{
    //观察是否可以请求日志
    [self addObserver:self forKeyPath:@"orderID" options:NSKeyValueObservingOptionNew context:nil];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"orderID"]) {
        //观察是否可以请求日志
        if (_orderID.length > 0) {
            [self getLogInfoWithOrderID:_orderID];
        }
    }
}
#pragma mark - Network request
//根据orderID获取日志消息
- (void)getLogInfoWithOrderID:(NSString *)orderID{
    __block ZDHUserSuggestView *selfView = self;
    __block ZDHUserSuggestViewViewModel *selfViewModel = _vcViewModel;
    [_vcViewModel getDataWithOrderID:_orderID success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfView reloadDataWithTimeArray:selfViewModel.dataOpinionTimeArray nameArray:selfViewModel.dataOpinionNameArray contentArray:selfViewModel.dataOpinionContentArray];
    } fail:^(NSError *error) {
        //获取失败
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"中途意见为空哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alView show];
    }];
}
#pragma mark - Protocol methods
//UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //中途意见为空
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHUserSuggestViewCancel" object:self userInfo:nil];
    }
}
#pragma mark - Other methods
//刷新数据
- (void)reloadDataWithTimeArray:(NSArray *)timeArray nameArray:(NSArray *)nameArray contentArray:(NSArray *)contentArray{
    //清空旧数据
    [self deleteSubView:_contentView];
    //标题头部
    UILabel *lastLabel;
    for (int i = 0; i < _headNameArray.count; i ++) {
        UILabel *headLabel = [[UILabel alloc] init];
        headLabel.textAlignment = NSTextAlignmentCenter;
        headLabel.backgroundColor = [UIColor colorWithRed:153/256.0 green:153/256.0 blue:153/256.0 alpha:1];
        headLabel.text = _headNameArray[i];
        headLabel.layer.borderColor = [[UIColor blackColor] CGColor];
        headLabel.layer.borderWidth = 0.5;
        [_contentView addSubview:headLabel];
        if (i == 0) {
            [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.equalTo(0);
                make.height.equalTo(25);
                make.width.equalTo(100);
            }];
        }else if (i == 1){
            [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.equalTo(lastLabel.mas_right).with.offset(-0.5);
                make.height.equalTo(lastLabel.mas_height);
                make.width.equalTo(100);
            }];
        }else{
            [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.equalTo(lastLabel.mas_right).with.offset(-0.5);
                make.height.equalTo(lastLabel.mas_height);
                make.right.equalTo(_contentView.mas_right);
            }];
        }
        lastLabel = headLabel;
    }
    //加载数据
    UIView *lastView;
    for (int i = 0; i < timeArray.count; i ++) {
        //背景
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor redColor];
        [_contentView addSubview:backView];
        if (i == 0) {
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(25);
                make.left.right.equalTo(0);
            }];
        }else{
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(-0.5);
                make.left.right.equalTo(0);
            }];
        }
        //时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.backgroundColor = WHITE;
        timeLabel.numberOfLines = 0;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.layer.borderColor = [[UIColor blackColor] CGColor];
        timeLabel.layer.borderWidth = 0.5;
        timeLabel.text = timeArray[i];
        [backView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.width.equalTo(100);
            make.top.bottom.mas_equalTo(0);
        }];
        //计算时间高度
        NSDictionary *dic = @{NSFontAttributeName:timeLabel.font};
        CGRect timeBounds = [timeArray[i] boundingRectWithSize:CGSizeMake(100, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        //名称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = WHITE;
        nameLabel.numberOfLines = 0;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.layer.borderColor = [[UIColor blackColor] CGColor];
        nameLabel.layer.borderWidth = 0.5;
        nameLabel.text = nameArray[i];
        [backView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.equalTo(timeLabel.mas_right).with.offset(-0.5);
            make.width.equalTo(100);
        }];
        //内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.backgroundColor = WHITE;
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.layer.borderColor = [[UIColor blackColor] CGColor];
        contentLabel.layer.borderWidth = 0.5;
        contentLabel.text = contentArray[i];
        [backView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.equalTo(nameLabel.mas_right).with.offset(-0.5);
            make.right.equalTo(0);
        }];
        //计算内容高度
        CGRect contentBounds = [timeArray[i] boundingRectWithSize:CGSizeMake(331, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        //获取背景高度
        if (timeBounds.size.height >= contentBounds.size.height) {
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(timeLabel.mas_height);
            }];
        }else{
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentLabel.mas_height);
            }];
        }
        lastView = backView;
    }
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom);
    }];
}
//删除子View
- (void)deleteSubView:(UIView *)view{
    for (UIView *subView in view.subviews) {
        [subView removeFromSuperview];
    }
}
@end
