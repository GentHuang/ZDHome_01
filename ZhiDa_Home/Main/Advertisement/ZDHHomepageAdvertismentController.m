//
//  ZDHHomepageAdvertismentController.m
//  
//
//  Created by apple on 16/4/15.
//
//

#import "ZDHHomepageAdvertismentController.h"
//Libs
#import "Masonry.h"

@interface ZDHHomepageAdvertismentController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@end

@implementation ZDHHomepageAdvertismentController
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
    [self.currNavigationController setNavigationBarMode:useNavigationBarADVModel];
    [self.currNavigationController setDetailTitleLabelWithString:@""];
}
- (void)createUI{
    //--------调整了一下啊顺序--------
    _webView = [[UIWebView alloc] init];
    _webView.scrollView.scrollEnabled = YES;
    _webView.backgroundColor = WHITE;
    _webView.opaque = NO;
    [_webView sizeToFit];
    //    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"APPH5/index.html" withExtension:nil];
    NSURL *filePath =[NSURL URLWithString: _webViewUrl];
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

@end
