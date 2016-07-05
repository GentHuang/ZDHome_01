//
//  ZDHLogView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHLogView.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHLogViewViewModel.h"
@interface ZDHLogView()<UITextFieldDelegate,UIAlertViewDelegate>
@property (assign, nonatomic) BOOL canSend;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) ZDHLogViewViewModel *vcViewModel;
@property (strong, nonatomic) UIActivityIndicatorView *activity;

@end
@implementation ZDHLogView
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHLogViewViewModel alloc] init];
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
    _canSend = NO;
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
    
    //活动指示器
    _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activity startAnimating];
    [_scrollView addSubview:_activity];
    
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
    
    [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(_scrollView);
        
    }];
}
#pragma mark - Event response
//点击按钮
- (void)buttonPressed:(UIButton *)button{
    NSString *name;
    if (button == _cancelButton) {
        name = @"ZDHLogViewCancel";
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
    __block ZDHLogView *selfView = self;
    __block ZDHLogViewViewModel *selfViewModel = _vcViewModel;
    [_vcViewModel getLogInfoWithOrderID:_orderID success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfView reloadDataWithArray:selfViewModel.dataLogNameArray operationArray:selfViewModel.dataLogOperationArray dateArray:selfViewModel.dataLogDateArray];
        [_activity stopAnimating];
    } fail:^(NSError *error) {
        [_activity stopAnimating];
        //获取失败
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"日志为空哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alView show];
    }];
}
#pragma mark - Protocol methods
//UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //若日志为空，则发出取消通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHLogViewCancel" object:self userInfo:nil];
    }
}
#pragma mark - Other methods
//刷新姓名，操作，日期
- (void)reloadDataWithArray:(NSArray *)nameArray operationArray:(NSArray *)operationArray dateArray:(NSArray *)dateArray{
    //清空子View
    [self deleteSubViews:_contentView];
    //加载数据
    UIView *lastView;
    for (int i = 0; i < nameArray.count; i ++) {
        //背景
        UIView *backView = [[UIView alloc] init];
        [_contentView addSubview:backView];
        if (i == 0) {
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo((i*30)+17.5);
                make.left.equalTo(0);
                make.right.mas_equalTo(0);
            }];
        }else{
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(10);
                make.left.equalTo(0);
                make.right.mas_equalTo(0);
            }];
        }
        //姓名
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = nameArray[i];
        nameLabel.numberOfLines = 0;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(backView.mas_centerY);
            make.left.equalTo(10);
            make.width.mas_equalTo(206/2);
        }];
        
        //操作
        UILabel *operationLabel = [[UILabel alloc] init];
        operationLabel.text = operationArray[i];
        operationLabel.numberOfLines = 0;
        operationLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:operationLabel];
        [operationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.left.mas_equalTo(nameLabel.mas_right).with.offset(10);
            make.width.mas_equalTo(546/2);
        }];
        //计算操作高度
        NSDictionary *dic = @{NSFontAttributeName:operationLabel.font};
        CGRect operationBounds = [operationArray[i] boundingRectWithSize:CGSizeMake(546/2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        //日期
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.text = dateArray[i];
        dateLabel.numberOfLines = 0;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.left.mas_equalTo(operationLabel.mas_right).with.offset(10);
            make.right.mas_equalTo(0);
        }];
        //计算日期高度
        CGRect dateBounds = [dateArray[i] boundingRectWithSize:CGSizeMake(135, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        //调整背景高度
        if (operationBounds.size.height >= dateBounds.size.height) {
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(operationLabel.mas_height);
            }];
        }else{
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(dateLabel.mas_height);
            }];
        }
        lastView = backView;
    }
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lastView.mas_bottom);
    }];
}
//清空子View
- (void)deleteSubViews:(UIView *)view{
    for (UIView *subView in view.subviews) {
        [subView removeFromSuperview];
    }
}
@end
