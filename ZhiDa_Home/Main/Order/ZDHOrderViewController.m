//
//  ZDHOrderViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controller
#import "ZDHOrderViewController.h"
//Libs
#import "Masonry.h"
@interface ZDHOrderViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation ZDHOrderViewController
#pragma mark - Init methods
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self createUI];
//    [self setSubViewLayout];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSubViewLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"家居配套流程"];
}
- (void)createUI{
    //WebView
    _webView = [[UIWebView alloc] init];
    _webView.scrollView.scrollEnabled = NO;
    _webView.backgroundColor = WHITE;
    _webView.opaque = NO;
    [_webView sizeToFit];
    //    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"APPH5/index.html" withExtension:nil];
//    NSURL *filePath =[NSURL URLWithString: TESTIMGURL@"online.html"];
    NSURL *filePath = [NSURL URLWithString:TESTIMGURL@"onlineapp/index.aspx"];
    
//    NSURL *filePath = [NSURL URLWithString:TESTURL@"onlineapp/index.aspx"];// 测试接口
    NSLog(@"网页地址~~~~`filePath==%@",filePath);
    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    _webView.delegate =self;
    [super createSuperUI];
}
- (void)setSubViewLayout{
    //WebView
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAV_HEIGHT);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(50);
        make.right.mas_equalTo(0);
    }];
    [super setSuperSubViewLayout];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
//UIWebViewDelegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [webView stringByEvaluatingJavaScriptFromString:@"rewrite();"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        NSString *urlString = [NSString stringWithFormat:@"%@",request.URL];
        if ([urlString isEqualToString: TESTIMGURL@"index.aspx"]) {
            //点击返回首页
            [self.currNavigationController popToRootViewControllerAnimated:YES];
            return NO;
        }else if([urlString isEqualToString: TESTIMGURL@"store.html"]){
            //点击附件门店跳转到网页
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:TESTIMGURL@"store.html"]];
        }
        return NO;
    }
    //提交成功后 不做任何处理
    if (navigationType == UIWebViewNavigationTypeOther) {
        if ([[NSString stringWithFormat:@"%@",request.URL] isEqualToString: TESTIMGURL@"index.html"]) {
            //点击返回首页
            return NO;
            //点击确定返回APP首页
        }else if ([[NSString stringWithFormat:@"%@",request.URL] isEqualToString: TESTIMGURL@"index.aspx"]){
            //点击返回首页
            [self.currNavigationController popToRootViewControllerAnimated:YES];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Other methods
//- (void)keyboardWillShow:(NSNotification *)notification {
////    NSDictionary *userInfo = [notification userInfo];
////    NSValue* value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
////    CGRect keyboardRect = [value CGRectValue]; // 这里得到了键盘的frame
////    // 你的操作，如键盘出现，控制视图上移等
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        _webView.scrollView.contentOffset = CGPointMake(0, 100);
//    }];
//    [UIView commitAnimations];
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification {
//    // 获取info同上面的方法
//    // 你的操作，如键盘移除，控制视图还原等
//    [UIView animateWithDuration:0.5 animations:^{
//        _webView.scrollView.contentOffset = CGPointMake(0, -100);
//    }];
//    [UIView commitAnimations];
//}
@end
