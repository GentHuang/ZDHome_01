//
//  ZDHResponseView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHResponseView.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHResponseViewViewModel.h"
@interface ZDHResponseView()<UIAlertViewDelegate,UITextViewDelegate>
@property (assign, nonatomic) BOOL canSend;
@property (strong, nonatomic) NSString *notificationName;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *commitButton;
@property (strong, nonatomic) UIImageView *tmpImageView;
@property (strong, nonatomic) ZDHResponseViewViewModel *vcViewModel;
//打叉button
@property (strong, nonatomic) UIButton *bigcancelButton;
@end
@implementation ZDHResponseView
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHResponseViewViewModel alloc] init];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
        [self notificationRecieve];
        [self addObserver];
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"orderID"];
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    _canSend = NO;
   
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    //背景
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = LIGHTGRAY;
    [self addSubview:_backView];
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"客户反馈录入";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:22];
    [_backView addSubview:_titleLabel];
    //取消按钮
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [_cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_cancelButton];
    //发送按钮
    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitButton setTitle:@"发送" forState:UIControlStateNormal];
    [_commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:22];
    _commitButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_commitButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_commitButton];
    //输入框
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = WHITE;
    _textView.font = [UIFont systemFontOfSize:24];
    _textView.delegate = self;
    [_backView addSubview:_textView];
}
- (void)setSubViewLayout{
    //背景
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(460/2);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-460/2);
    }];
    //标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView.mas_centerX);
        make.top.equalTo(25);
        make.left.and.right.equalTo(0);
        make.height.equalTo(22);
    }];
    //取消按钮
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(53);
        make.left.equalTo(83/2);
        make.width.equalTo(50);
        make.height.equalTo(22);
    }];
    //发送按钮
    [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cancelButton.mas_top);
        make.right.equalTo(-83/2);
        make.width.equalTo(50);
        make.height.equalTo(22);
    }];
    //输入框
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(160/2);
        make.left.equalTo(83/2);
        make.right.equalTo(-83/2);
        make.height.equalTo(250/2);
    }];
    [self performSelector:@selector(showView) withObject:self afterDelay:0.1];
}
#pragma mark - Event response
//点击按钮
- (void)buttonPressed:(UIButton *)button{
    if (button == _cancelButton) {
        //取消
        _notificationName = @"ZDHResponseViewCancel";
        [self hideView];
    }else if(button == _commitButton){
        _notificationName = @"ZDHResponseViewCommit";
        __block ZDHResponseView *selfView = self;
        __block ZDHResponseViewViewModel *selfViewModel = _vcViewModel;
        if ([_textView.text isEqualToString:@""]) {
            //检测反馈是否为空
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写反馈哦" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alView show];
        }else if(_canSend) {
            //可以发送反馈
            //发送反馈
            [_vcViewModel sendResponseWithSellManID:[ZDHSellMan shareInstance].sellManID orderID:_orderID remarks:_textView.text success:^(NSMutableArray *resultArray) {
                //发送成功
                //发送失败
                UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"反馈发送成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alView.delegate = selfView;
                [alView show];
                [selfView hideView];
            } fail:^(NSError *error) {
                //发送失败
                NSString *msg = @"反馈发送失败";
                if (selfViewModel.dataMSGString.length > 0) {
                    msg = selfViewModel.dataMSGString;
                }
                UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alView show];
            }];
        }else{
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发送反馈，请检查您的网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alView show];
        }
    }
}
//弹出 delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
//    if ([alertView.message isEqualToString:@"反馈发送成功"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"反馈成功刷新界面" object:self];
//    }
}

//添加通知
- (void)notificationRecieve{
    //通知弹出键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    //通知收起键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillHideNotification object:nil];
}
//观察者
- (void)addObserver{
    //观察是否可以发送反馈
    [self addObserver:self forKeyPath:@"orderID" options:NSKeyValueObservingOptionNew context:nil];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"orderID"]) {
        //观察是否可以发送反馈
        if (_orderID.length > 0) {
            _canSend = YES;
        }
    }
}


#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//通知弹出或收起键盘
- (void)changeContentViewPoint:(NSNotification *)notification{
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        //弹出键盘
        NSDictionary *userInfo = [notification userInfo];
        NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
        
        NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        // 添加移动动画，使视图跟随键盘移动
        [UIView animateWithDuration:duration.doubleValue animations:^{
            [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.mas_bottom).with.offset(-keyBoardEndY-25*2);
            }];
            [self layoutIfNeeded];
        }];
        [UIView commitAnimations];
    }else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]){
        //收起键盘
        NSDictionary *userInfo = [notification userInfo];
        NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        // 添加移动动画，使视图跟随键盘移动
        [UIView animateWithDuration:duration.doubleValue animations:^{
            [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).with.offset(460/2);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            //收起键盘
            //add 修改一个bug
            [self performSelector:@selector(packUpkeyboard) withObject:self afterDelay:duration.doubleValue];
        }];
        [UIView commitAnimations];
    }
}
- (void)notificationSend{
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:nil];
}
//展示界面
- (void)showView{
    [_textView becomeFirstResponder];
}
//隐藏界面
- (void)hideView{
    [_textView resignFirstResponder];
    [self removeFromSuperview];
}
- (void)packUpkeyboard {
    [self removeFromSuperview];
}
@end

