//
//  ZDHAboutPopUpView.m
//  
//
//  Created by apple on 16/3/31.
//
//

#import "ZDHAboutPopUpView.h"
#import "ZDHAboutViewControllerViewModel.h"
//Model
#import "ZDHAboutViewControllerModel.h"
//Libs
#import "Masonry.h"

@interface ZDHAboutPopUpView()<UIWebViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) ZDHAboutViewControllerViewModel *vcViewModel;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *returnButton;
@property (strong, nonatomic) UILabel *separateLine;
@property (strong, nonatomic) UIView *backGroundView;
@end

@implementation ZDHAboutPopUpView

- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHAboutViewControllerViewModel alloc] init];
    [self getData];
}
- (instancetype) init{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        [self initData];
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = WHITE;
    //webView
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = WHITE;
    _webView.opaque = NO;
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_webView];
    //加载等待
//    _progressHUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _returnButton.hidden = YES;
    [_returnButton setTitle:@"返回" forState:0];
    [_returnButton setTitleColor:[UIColor colorWithRed:204/256.0 green:45/256.0 blue:255/256.0 alpha:1] forState:0];
    [_returnButton addTarget:self action:@selector(PackUpViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_returnButton];
    
    _titleLabel = [[UILabel alloc]init];
//    _titleLabel.hidden = YES;
    _titleLabel.text = @"关于志达";
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _separateLine = [[UILabel alloc]init];
//    _separateLine.hidden = YES;
    _separateLine.backgroundColor = [UIColor grayColor];
    [self addSubview:_separateLine];
}
- (void)setSubViewLayout{
    [_returnButton mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_returnButton.mas_top).offset(0);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.height.mas_equalTo(_returnButton.mas_height);
    }];

    [_separateLine mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self).offset(0);
        make.top.equalTo(_titleLabel.mas_bottom).offset(0);
    }];
    //webView
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_separateLine.mas_bottom).offset(20);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
}
// 收起View
- (void) PackUpViewButtonClick:(UIButton *)btn{
    [_backGroundView removeFromSuperview];
    self.hidden = YES;
}
//获取关于志达信息
- (void)getData{
    __block ZDHAboutPopUpView *selfVC = self;
    __block ZDHAboutViewControllerViewModel *selfViewModel = _vcViewModel;
    self.progressHUD.hidden = NO;
    [_vcViewModel getAboutSuccess:^(NSMutableArray *resultArray) {
        //获取成功
        ZDHAboutViewControllerModel *vcModel = [selfViewModel.dataAboutArray firstObject];
        [selfVC.webView loadHTMLString:vcModel.aboutinfo baseURL:[NSURL URLWithString:TESTIMGURL]];
    } fail:^(NSError *error) {

    }];
}

- (void) popUpViewAboutZDHWithBackGroundView:(UIView *)backGroundView{
    
    _backGroundView = backGroundView;
    _returnButton.hidden = NO;
    _titleLabel.hidden = NO;
    _separateLine.hidden = NO;
}

// 改变字体的大小
- (void)webViewDidFinishLoad:(UIWebView *)webView

{
//    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
//    [webView stringByEvaluatingJavaScriptFromString:str];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.x > 0) {
        scrollView.contentOffset = CGPointMake(0, point.y);
    }
}

@end
