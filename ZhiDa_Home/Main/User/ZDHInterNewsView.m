//
//  ZDHInTerNewsView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHInterNewsView.h"
#import "ZDHInterNewsCell.h"
//ViewModel
#import "ZDHNewsViewControllerViewModel.h"
//Model
#import "ZDHNewsViewControllerInfoListModel.h"
#import "ZDHNewsViewControllerDetailNewsModel.h"
//Lib
#import "Masonry.h"
//Macro
#define kButtonWidth 60
#define kButtonHeight 76
#define kButtonTag 13000
#define UnSelectedColor [UIColor colorWithRed:186/256.0 green:186/256.0 blue:186/256.0 alpha:1]
@interface ZDHInterNewsView()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) UIScrollView *bigView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) UIImageView *shadowImageView;
@property (strong, nonatomic) ZDHNewsViewControllerViewModel *vcViewModel;
@property (assign, nonatomic) int lastButtonIndex;
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) NSMutableArray *tempArr;

@end

@implementation ZDHInterNewsView
//--------添加中间数组------------
-(NSMutableArray *)tempArr {
    if (!_tempArr) {
        _tempArr = [NSMutableArray array];
    }
    return _tempArr;
}
//-------------------------------

#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHNewsViewControllerViewModel alloc] init];
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
    _lastButtonIndex = 0;
    _selectedIndex = 0;
    __block ZDHInterNewsView *selfView = self;
    //背景
    _bigView = [[UIScrollView alloc] init];
    _bigView.backgroundColor = WHITE;
//    _bigView.backgroundColor = [UIColor orangeColor];
    _bigView.showsVerticalScrollIndicator = NO;
    [self addSubview:_bigView];
    //ContentView
    _contentView = [[UIView alloc] init];
//    _contentView.backgroundColor = [UIColor greenColor];
    [_bigView addSubview:_contentView];
    //新闻标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:82/2];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];
    //日期标签
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont systemFontOfSize:24/2];
    _dateLabel.textColor = [UIColor colorWithRed:166/256.0 green:166/256.0 blue:166/256.0 alpha:1];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
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
    [_tableView registerClass:[ZDHInterNewsCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:_tableView];
    //下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfView getDataWithTid:selfView.tid];
    }];
    //阴影
    _shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_img_shadow"]];
    [self addSubview:_shadowImageView];
    //等待下载
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.hidden = YES;
    [self addSubview:_indicatorView];
    [self creatWbebView];
}
- (void)setSubViewLayout{
    //BigView
    [_bigView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.and.left.and.bottom.equalTo(0);
        make.top.bottom.equalTo(0);
        make.left.equalTo(self.mas_left).offset(80/2);
//        make.right.equalTo(-(4*kButtonWidth));
        make.right.equalTo(self.mas_right).offset(-((4*kButtonWidth)+80/2));
    }];
    //ContentView
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bigView);
        make.width.equalTo(_bigView);

    }];
    //新闻标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.left.equalTo(0);
//        make.height.equalTo(55);
        make.top.equalTo(67/2);
    }];
    //日期标签
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
         make.left.equalTo(10);
        make.height.equalTo(20);
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(40/2);
    }];
    //WebView
//    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(0);
//        make.top.equalTo(_dateLabel.mas_bottom).with.offset(40/2);
//    }];
    //TableView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kButtonHeight);
        make.left.equalTo(_bigView.mas_right).offset(80/2);
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
        make.center.mas_equalTo(self);
    }];
}
//obsevr
#pragma mark - Event response
//点击按钮
- (void)topButtonPressed:(UIButton *)button{
    for (int i = 0; i < _titleArray.count; i ++) {
        UIButton *allButton = (UIButton *)[self viewWithTag:(i+kButtonTag)];
        allButton.selected = NO;
        [allButton setBackgroundColor:UnSelectedColor];
    }
    _lastButtonIndex = (int)(button.tag - kButtonTag);
    button.selected = YES;
    button.backgroundColor = LIGHTGRAY;
    //刷新内容
    [_webView loadHTMLString:@"" baseURL:[NSURL URLWithString:NEWSIMGURL]];
    //刷新标题
    _titleLabel.text = @"";
    //刷新日期
    _dateLabel.text = @"";
    //刷新新闻简介
//    _tid = _vcViewModel.dataTitleIDArray[button.tag - kButtonTag];//闪退崩溃在这里
//----------添加临时变量数组----------
    _tid = _tempArr[button.tag -kButtonTag];
//--------------------------------
    [_tableView.header beginRefreshing];
    //
    [_webView removeFromSuperview];
    [self creatWbebView];
}
#pragma mark - Network request
//获取信息
- (void)getData{
    __block ZDHInterNewsView *selfView = self;
    __block ZDHNewsViewControllerViewModel *selfViewModel = _vcViewModel;
    //清空旧数据
    //刷新标题
    _titleLabel.text = @"";
    //刷新日期
    _dateLabel.text = @"";
    //刷新WebView
    [_webView loadHTMLString:@"" baseURL:[NSURL URLWithString:NEWSIMGURL]];
    //获取标题
    [self startDownload];
    [_vcViewModel getIntetNewsTitleSuccess:^(NSMutableArray *resultArray) {
        //获取成功
        //创建资讯按钮
        selfView.titleArray = selfViewModel.dataTitleArray;
        [selfView createButton];
        //请求资讯列表
        selfView.tid = selfViewModel.dataTitleIDArray[_lastButtonIndex];
//----------------------
        _tempArr =_vcViewModel.dataTitleIDArray;
//----------------------
        [selfView.tableView.header beginRefreshing];
        [selfView stopDownload];
    } fail:^(NSError *error) {
        //获取失败
        [selfView stopDownload];
        [selfView.tableView reloadData];
    }];
}
//通过资讯TID获取信息
- (void)getDataWithTid:(NSString *)tid{
    __block ZDHInterNewsView *selfView = self;
    __block ZDHNewsViewControllerViewModel *selfViewModel = _vcViewModel;
    //刷新重新置零
    _selectedIndex = 0;
    //获取咨询列表
    [_vcViewModel getNewsInfoWithTID:tid success:^(NSMutableArray *resultArray) {        
        //请求成功
        [selfView stopDownload];
        //请求该资讯列表中的所有新闻详情
        [selfViewModel getNewsDetailWithNIDArray:selfViewModel.dataNewsNIDArray];
        selfViewModel.detailSuccess = ^(NSMutableArray *dataArray){
            //详情请求成功
            //寻找对应的资讯详情
            ZDHNewsViewControllerDetailNewsModel *detailModel;
            for (ZDHNewsViewControllerDetailNewsModel *tmpModel in _vcViewModel.dataNewsDetailArray) {
                if (tmpModel.newsIndex == 0) {
                    detailModel = tmpModel;
                    break;
                }
            }
            //刷新标题
            _titleLabel.text = detailModel.title;
            //刷新日期
            _dateLabel.text = detailModel.pubdate;
            //添加一个修改字体的
            //刷新WebView
            [_webView loadHTMLString:detailModel.content baseURL:[NSURL URLWithString:TESTIMGURL]];
            //刷新
            [selfView.tableView reloadData];
            [selfView.tableView.header endRefreshing];
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        };
    } fail:^(NSError *error) {
        //请求失败
        [selfView stopDownload];
        [selfView.tableView reloadData];
        [selfView.tableView.header endRefreshing];
    }];
}
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_vcViewModel.dataNewsInfoArray.count > 0) {
        return _vcViewModel.dataNewsInfoArray.count;
    }else{
        return 20;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDHInterNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
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
//创建按钮
- (void)createButton{
    //清除旧Button
    [self deleteTopButton];
    //创建新按钮
    for (int i = 0; i < _titleArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:(i+kButtonTag)];
        [button addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setBackgroundColor:UnSelectedColor];
        if (i == _lastButtonIndex) {
            button.selected = YES;
            [button setBackgroundColor:LIGHTGRAY];
        }
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.bottom.equalTo(_tableView.mas_top);
            make.right.equalTo((i*kButtonWidth)-(3*kButtonWidth));
            make.width.equalTo(kButtonWidth);
        }];
    }
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
//清理按钮
- (void)deleteTopButton{
    for (int i = 0; i < _titleArray.count; i ++) {
        UIButton *allButton = (UIButton *)[self viewWithTag:i+kButtonTag];
        [allButton removeFromSuperview];
    }
}
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
