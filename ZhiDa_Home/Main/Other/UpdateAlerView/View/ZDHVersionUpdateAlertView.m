//
//  ZDHVersionUpdateAlertView.m
//  
//
//  Created by apple on 16/4/8.
//
//

#import "ZDHVersionUpdateAlertView.h"
#import "Masonry.h"

@interface ZDHVersionUpdateAlertView()<UIWebViewDelegate>
// 版本更新标题
@property (strong, nonatomic) UILabel  *lableTitle;
// 升级提醒
@property (strong, nonatomic) UILabel  *lableSubHead;
// 升级按钮
@property (strong, nonatomic) UIButton *buttonUpdate;
// 第三级title
@property (strong, nonatomic) UILabel *thirdLableTitle;
// 当前UIview
@property (strong, nonatomic) UIView *currenView;
// 上分割线
@property (strong, nonatomic) UILabel *labelUpSeparateLine;
// 下分割线
@property (strong, nonatomic) UILabel *labelDownSeparateLine;
// 介绍
@property (strong, nonatomic) UIView *viewIntroduce;
// 显示更新概要
@property (strong, nonatomic) UIWebView *webViewIntroduc;
// 更新版本
@property (copy, nonatomic) NSString *versionTitle;
// html contents
@property (copy, nonatomic) NSString *htmlString;

@end

@implementation ZDHVersionUpdateAlertView
-(instancetype)initWithTitle:(NSString *)title
               updateContent:(NSString *)message
                    delegate:(id)delegate{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6];
        self.hidden = NO;
        self.frame =[UIScreen mainScreen].bounds;
        self.delegate = delegate;
        self.versionTitle = title;
        self.htmlString = message;
        [self createUI];
        [self createAutolayout];
    }
    return self;
}

- (void) createUI{
    
    self.currenView = [[UIView alloc]init];
    self.currenView.layer.cornerRadius = 5.0;
    self.currenView.backgroundColor = [UIColor colorWithRed:236/256.0 green:244/256.0 blue:246/256.0 alpha:1];
    [self addSubview: self.currenView];
    
    self.lableTitle = [[UILabel alloc]init];
    self.lableTitle.layer.cornerRadius = 6.0;
    self.lableTitle.textAlignment = NSTextAlignmentCenter;
    self.lableTitle.text = self.versionTitle;
    self.lableTitle.font = [UIFont boldSystemFontOfSize:18];
    self.lableTitle.textColor = [UIColor grayColor];
    [self.currenView addSubview:self.lableTitle];
    
    self.lableSubHead = [[UILabel alloc]init];
    self.lableSubHead.textAlignment = NSTextAlignmentCenter;
    self.lableSubHead.text = @"升级提醒";
    self.lableSubHead.textColor = [UIColor grayColor];
    self.lableSubHead.font = [UIFont boldSystemFontOfSize:20];
    [self.currenView addSubview:self.lableSubHead];
    
    
    self.labelUpSeparateLine = [[UILabel alloc]init];
    self.labelUpSeparateLine.textAlignment = NSTextAlignmentCenter;
    self.labelUpSeparateLine.backgroundColor = [UIColor grayColor];
    [self.currenView addSubview:self.labelUpSeparateLine];
    
    self.labelDownSeparateLine = [[UILabel alloc]init];
    self.labelDownSeparateLine.textAlignment = NSTextAlignmentCenter;
    self.labelDownSeparateLine.backgroundColor = [UIColor grayColor];
    [self.currenView addSubview:self.labelDownSeparateLine];
    
    self.buttonUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonUpdate setTitle:@"下载升级" forState:0];
    [self.buttonUpdate setTitleColor:[UIColor colorWithRed:207/256.0 green:0/256.0 blue:92/256.0 alpha:1] forState:0];
    [self.buttonUpdate addTarget:self action:@selector(buttonUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.currenView addSubview:self.buttonUpdate];
    
    self.viewIntroduce = [[UIView alloc]init];
    self.viewIntroduce.backgroundColor = [UIColor colorWithRed:236/256.0 green:244/256.0 blue:246/256.0 alpha:1];
    [self.currenView addSubview:self.viewIntroduce];
    
    _webViewIntroduc = [[UIWebView alloc] init];
    _webViewIntroduc.backgroundColor = [UIColor yellowColor];
    _webViewIntroduc.scrollView.scrollEnabled = NO;
    _webViewIntroduc.delegate = self;
    [_viewIntroduce addSubview:_webViewIntroduc];
}

- (void) createAutolayout{
    __weak __typeof(self) weaks = self;
    [_currenView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerX.equalTo(weaks.mas_centerX);
        make.centerY.equalTo(weaks.mas_centerY);
        make.width.mas_equalTo(300);
        make.bottom.equalTo(_buttonUpdate.mas_bottom).offset(0);
    }];
    
    [_lableTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_currenView.mas_top).offset(10);
        make.left.right.equalTo(_currenView).offset(0);
        make.height.mas_equalTo(35);
    }];
    
    [_lableSubHead mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.right.left.equalTo(_currenView).offset(0);
        make.top.equalTo(_lableTitle.mas_bottom).offset(0);
        make.height.mas_equalTo(35);
    }];
    
    [_labelUpSeparateLine mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.right.left.equalTo(_currenView).offset(0);
        make.top.equalTo(_lableSubHead.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [_viewIntroduce mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.top.equalTo(_labelUpSeparateLine.mas_bottom).offset(0);
        make.left.right.equalTo(_currenView).offset(0);
    }];
    
    [_webViewIntroduc mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.left.right.top.bottom.equalTo(_viewIntroduce);
    }];
    
    [_labelDownSeparateLine mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.right.left.equalTo(_currenView).offset(0);
        make.top.equalTo(_viewIntroduce.mas_bottom).offset(0);
        make.height.mas_equalTo(1);
    }];

    [_buttonUpdate mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.left.right.equalTo(_currenView).offset(0);
        make.top.equalTo(_labelDownSeparateLine.mas_bottom).offset(0);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(_currenView.mas_bottom).offset(0);
    }];
    
     [_webViewIntroduc loadHTMLString:self.htmlString baseURL:[NSURL URLWithString:TESTIMGURL]];
}

- (void) buttonUpdateClick:(UIButton *)btn{
    self.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(alertViewToAppStoreUpdateApp)]) {
        
        [self.delegate alertViewToAppStoreUpdateApp];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取web内容高度
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_webViewIntroduc.mas_top).with.offset(height);
    }];  
}

/**
 *  显示alertView
 */
- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = ((UIWindow *)[[UIApplication sharedApplication] windows][0]);
        [window addSubview:self];
        [window endEditing:YES];
    });
}

@end










