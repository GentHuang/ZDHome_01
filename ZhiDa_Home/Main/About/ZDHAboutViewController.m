//
//  ZDHAboutViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHAboutViewController.h"
//ViewModel
#import "ZDHAboutViewControllerViewModel.h"
//Model
#import "ZDHAboutViewControllerModel.h"
//Libs
#import "Masonry.h"
@interface ZDHAboutViewController ()
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) ZDHAboutViewControllerViewModel *vcViewModel;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@end
@implementation ZDHAboutViewController
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHAboutViewControllerViewModel alloc] init];
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    [self setSubViewLayout];
    [self getData];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"关于志达"];
}
- (void)createUI{
    self.view.backgroundColor = WHITE;
    //webView
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = WHITE;
    _webView.opaque = NO;
    [self.view addSubview:_webView];
    //加载等待
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)setSubViewLayout{
    //webView
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAV_HEIGHT);
        make.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
//获取关于志达信息
- (void)getData{
    __block ZDHAboutViewController *selfVC = self;
    __block ZDHAboutViewControllerViewModel *selfViewModel = _vcViewModel;
    self.progressHUD.hidden = NO;
    [_vcViewModel getAboutSuccess:^(NSMutableArray *resultArray) {
       //获取成功
        ZDHAboutViewControllerModel *vcModel = [selfViewModel.dataAboutArray firstObject];
        self.progressHUD.hidden = YES;
        [selfVC.webView loadHTMLString:vcModel.aboutinfo baseURL:[NSURL URLWithString:TESTIMGURL]];
    } fail:^(NSError *error) {
        //获取失败
        self.progressHUD.hidden = YES;
        [selfVC.progressHUD show:NO];
    }];
}
#pragma mark - Protocol methods
#pragma mark - Other methods

@end
