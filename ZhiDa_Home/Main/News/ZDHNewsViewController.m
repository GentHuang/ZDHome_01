//
//  ZDHNewsViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controllers
#import "ZDHNewsViewController.h"
//View
#import "ZDHNewsCell.h"
//ViewModel
#import "ZDHNewsViewControllerViewModel.h"
//Lib
#import "Masonry.h"
//Model
#import "ZDHNewsViewControllerInfoListModel.h"
#import "ZDHNewsViewControllerDetailNewsModel.h"
//Macro
#define UnSelectedColor [UIColor colorWithRed:186/256.0 green:186/256.0 blue:186/256.0 alpha:1]
@interface ZDHNewsViewController()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (strong, nonatomic) UIScrollView *bigView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *shadowImageView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) ZDHNewsViewControllerViewModel *vcViewModel;
@property (assign, nonatomic) int selectedIndex;
@end
@implementation ZDHNewsViewController
#pragma mark - Init methods
- (void)initData{
    //ViewModel
    _vcViewModel = [[ZDHNewsViewControllerViewModel alloc] init];
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
- (void) dealloc{
    
    NSLog(@"----->对象被释放");
}
#pragma mark - Getters and setters
- (void)createUI{
    _selectedIndex = 0;
    __block ZDHNewsViewControllerViewModel *selfViewModel = _vcViewModel;
    self.view.backgroundColor = WHITE;
    //背景
    _bigView = [[UIScrollView alloc] init];
    _bigView.backgroundColor = WHITE;
    _bigView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bigView];
    //ContentView
    _contentView = [[UIView alloc] init];
    [_bigView addSubview:_contentView];
    //新闻标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:80/2];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];
    //日期标签
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont systemFontOfSize:24/2];
    _dateLabel.textColor = [UIColor colorWithRed:166/256.0 green:166/256.0 blue:166/256.0 alpha:1];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_dateLabel];
    //WebView
//    _webView = [[UIWebView alloc] init];
//    _webView.backgroundColor = WHITE;
//    _webView.scrollView.scrollEnabled = NO;
//    _webView.delegate = self;
//    [_contentView addSubview:_webView];
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = LIGHTGRAY;
    [_tableView registerClass:[ZDHNewsCell class] forCellReuseIdentifier:@"cell"];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.view addSubview:_tableView];
    //下拉刷新
    __weak __typeof(self) weakSelf = self;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getDataWithTid:selfViewModel.newsID];
    }];
    //阴影
    _shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_img_shadow"]];
    [self.view addSubview:_shadowImageView];
    [super createSuperUI];
    //等待下载
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.hidden = YES;
    [self.view addSubview:_indicatorView];
    [self creatWbebView];
}
- (void)setSubViewLayout{
    [super setSuperSubViewLayout];
    //BigView
    [_bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NAV_HEIGHT+STA_HEIGHT);
        make.bottom.equalTo(0);
        make.left.equalTo(self.view.mas_left).offset(80/2);
//        make.right.equalTo(-760/2);
        make.right.equalTo(self.view.mas_right).offset(-(760+40)/2);
        
//        make.left.and.bottom.equalTo(0);
//        make.top.equalTo(NAV_HEIGHT+STA_HEIGHT);
//        make.right.equalTo(-760/2);
    }];
    //ContentView
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bigView);
        make.width.equalTo(_bigView);
    }];
    //新闻标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(0);
//        make.height.equalTo(55);
        make.top.equalTo(67/2);
    }];
    //日期标签
//    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(0);
//        make.height.equalTo(20);
//        make.top.equalTo(_titleLabel.mas_bottom).with.offset(40/2);
//    }];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.left.equalTo(10);
        make.height.equalTo(20);
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(40/2);
    }];
    
//    //WebView
//    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(0);
//        make.top.equalTo(_dateLabel.mas_bottom).with.offset(40/2);
//    }];
    //TableView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NAV_HEIGHT+STA_HEIGHT);
         make.left.equalTo(_bigView.mas_right).with.offset(40);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    //阴影
    [_shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(_tableView.mas_left);
        make.bottom.equalTo(0);
        make.width.equalTo(18);
    }];
    //等待下载
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(self.view);
    }];
}
//创建webView
- (void)creatWbebView {
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = WHITE;
    _webView.scrollView.scrollEnabled = NO;
    _webView.delegate = self;
    [_contentView addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(0);
        make.top.equalTo(_dateLabel.mas_bottom).with.offset(40/2);
    }];
}
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"资讯中心"];
}
#pragma mark - Event response
#pragma mark - Network request
//获取信息
- (void)getData{
//    __block ZDHNewsViewController *selfVC = self;
    __weak __typeof(self) weakSelf = self;
    //清空旧数据
    //刷新标题
    _titleLabel.text = @"";
    //刷新日期
    _dateLabel.text = @"";
    //刷新WebView
    [_webView loadHTMLString:@"" baseURL:[NSURL URLWithString:TESTIMGURL]];
    //获取标题
    [self startDownload];
    [_vcViewModel getIntetNewsTitleSuccess:^(NSMutableArray *resultArray) {
        //获取成功
        //请求资讯列表
        [weakSelf.tableView.header beginRefreshing];
        [weakSelf stopDownload];
    } fail:^(NSError *error) {
        //获取失败
        [weakSelf stopDownload];
        [weakSelf.tableView reloadData];
    }];
}
//通过资讯TID获取信息
- (void)getDataWithTid:(NSString *)tid{
//    __block ZDHNewsViewController *selfVC = self;
    __weak __typeof(self) weakSelf = self;
    __block ZDHNewsViewControllerViewModel *selfViewModel = _vcViewModel;
    //获取咨询列表
    [_vcViewModel getNewsInfoWithTID:tid success:^(NSMutableArray *resultArray) {
        //请求成功
        [weakSelf stopDownload];
        //请求该资讯列表中的所有新闻详情
        [selfViewModel getNewsDetailWithNIDArray:selfViewModel.dataNewsNIDArray];
        
        selfViewModel.detailSuccess = ^(NSMutableArray *dataArray){
            //详情请求成功
            //寻找对应的资讯详情
            ZDHNewsViewControllerDetailNewsModel *detailModel;
            for (ZDHNewsViewControllerDetailNewsModel *tmpModel in weakSelf.vcViewModel.dataNewsDetailArray) {
                if (tmpModel.newsIndex == 0) {
                    detailModel = tmpModel;
                    break;
                }
            }
            //刷新标题
            weakSelf.titleLabel.text = detailModel.title;
            //刷新日期
            weakSelf.dateLabel.text = detailModel.pubdate;
            //刷新WebView
            [weakSelf.webView loadHTMLString:detailModel.content baseURL:[NSURL URLWithString:TESTIMGURL]];
            //刷新
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.header endRefreshing];
            [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        };
    } fail:^(NSError *error) {
        //请求失败
        [weakSelf stopDownload];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.header endRefreshing];
    }];
}
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_vcViewModel.dataNewsInfoArray.count > 0) {
        return _vcViewModel.dataNewsInfoArray.count;
    }else{
        return 10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDHNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (_vcViewModel.dataNewsInfoArray.count > 0) {
        //若数据存在，载入数据
        ZDHNewsViewControllerInfoListModel *listModel = _vcViewModel.dataNewsInfoArray[indexPath.row];
        [cell reloadPubdate:listModel.pubdate];
        [cell reloadTitle:listModel.title];
    }else{
        //若数据不存在，载入空数据
        [cell reloadTitle:@""];
        [cell reloadPubdate:@""];
    }
    return cell;
}
//UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedIndex != indexPath.row) {
        _selectedIndex = (int)indexPath.row;
        //寻找对应的资讯详情
        ZDHNewsViewControllerDetailNewsModel *detailModel;
        for (ZDHNewsViewControllerDetailNewsModel *tmpModel in _vcViewModel.dataNewsDetailArray) {
            if (tmpModel.newsIndex == indexPath.row) {
                detailModel = tmpModel;
                break;
            }
        }
        //先移除再创建
        [_webView removeFromSuperview];
        [self creatWbebView];
        //刷新标题
        _titleLabel.text = detailModel.title;
        //刷新日期
        _dateLabel.text = detailModel.pubdate;
        //刷新WebView
        [_webView loadHTMLString:detailModel.content baseURL:[NSURL URLWithString:TESTIMGURL]];
    }
}
//UIWebViewDelegate Methods
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    //通过Html内容获取高度
//    CGRect frame = webView.frame;
//    frame.size.width = 768;
//    frame.size.height = 1;
//    webView.frame = frame;
//    frame.size.height = webView.scrollView.contentSize.height;
//    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_webView.mas_top).with.offset(frame.size.height+100);
//    }];
//    //修改ContentView高度
//    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_webView.mas_top).with.offset(frame.size.height+100);
//    }];
//}
//UIWebViewDelegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取web内容高度
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_webView.mas_top).with.offset(height);
    }];
    //修改ContentView高度
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_webView.mas_top).with.offset(height);
    }];
    //webView图标自适应
    NSString *script = [NSString stringWithFormat:
                        @"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function ResizeImages() { "
                        "var img;"
                        "var maxwidth=%f;"
                        "for(i=0;i <document.images.length;i++){"
                        "img = document.images[i];"
                        "if(img.width > maxwidth){"
                        "img.width = maxwidth;"
                        "}"
                        "}"
                        "}\";"
                        "document.getElementsByTagName('head')[0].appendChild(script);", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString: script];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}
#pragma mark - Other methods
//开始下载
- (void)startDownload{
    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];
}
//停止下载
- (void)stopDownload{
    _indicatorView.hidden = YES;
    [_indicatorView stopAnimating];
}
@end
