//
//  ZDHUserViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controller
#import "ZDHUserViewController.h"
#import "ZDHDesignMethodsViewController.h"
#import "ZDHProductCenterZhiDaViewController.h"
#import "ZDHClothDetailViewController.h"
//View
#import "ZDHUserClothesView.h"
#import "ZDHMyOrderView.h"
#import "ZDHInterNewsView.h"
#import "ZDHDownloadView.h"
//Lib
#import "Masonry.h"
//ViewMode
typedef enum{
    kClothesViewMode =1,
    kMyOrderViewMode,
    kInterNewsMode,
    kDownloadViewMode
}ViewMode;
@interface ZDHUserViewController ()
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) ZDHUserClothesView *clothesView;
@property (strong, nonatomic) ZDHMyOrderView *myOrderView;
@property (strong, nonatomic) ZDHInterNewsView *interNewsView;
@property (strong, nonatomic) ZDHDownLoadView *downloadView;
@property (assign, nonatomic) BOOL isShowBrandReturnButton;
@end
@implementation ZDHUserViewController
#pragma mark - Init methods
#pragma mark - Life circle

- (instancetype) init{
    
    if(self = [super init]){
        [self notificationRecieve];
        [self createUI];
        [self setSubViewLayout];
        //默认使用电子布板
        [self setViewMode:kClothesViewMode];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createUI];
//    [self setSubViewLayout];
//    [self addObserver];
//    [self notificationRecieve];
   
    _isShowBrandReturnButton = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)createUI{
    _topViewIndex = 0;
    self.view.backgroundColor = WHITE;
    //右边背景
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = WHITE;
    [self.view addSubview:_backView];
    //电子布板
    _clothesView = [[ZDHUserClothesView alloc] init];
    _clothesView.hidden = YES;
    [_backView addSubview:_clothesView];
    [_clothesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backView);
    }];
    
    //我的工单
    //MyOrderView
    _myOrderView = [[ZDHMyOrderView alloc] init];
    _myOrderView.hidden = YES;
    [_backView addSubview:_myOrderView];
    [_myOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backView);
    }];
    //内部资讯
    _interNewsView = [[ZDHInterNewsView alloc] init];
    _interNewsView.hidden = YES;
    [_backView addSubview:_interNewsView];
    [_interNewsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backView);
    }];
    //离线下载
    _downloadView = [[ZDHDownLoadView alloc] init];
    _downloadView.hidden = YES;
    [_backView addSubview:_downloadView];
    [_downloadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backView);
    }];
    [super createUI];
}
- (void)setSubViewLayout{
    [super setSubViewLayout];
    //右边背景
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAV_HEIGHT+STA_HEIGHT));
        make.left.equalTo(self.leftTableView.mas_right);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
}
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDIYMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"电子布板"];
    if (_isShowBrandReturnButton) {
        
        [self.currNavigationController showBrandBackButtonWithFlag:YES];
    }
}
#pragma mark - Event response
//添加观察者
- (void)addObserver{
    //左侧选择栏
    [super addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    //定位布料列表
    [super addObserver:self forKeyPath:@"topViewIndex" options:NSKeyValueObservingOptionNew context:nil];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        
        //左侧选择栏
        int selectedIndex = [[change valueForKey:@"new"] intValue];
        
        [self setViewMode:selectedIndex];
    }else{
        //定位布料列表
        [_clothesView getDataWithIndex:[[change valueForKey:@"new"] intValue]];
    }
}
//接收通知
- (void)notificationRecieve{
    //DesignCell
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHDesignCellCase" object:nil];
    //布料详情
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHUserClothesView" object:nil];
    //点击设计方案图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHDesignDetailDownCell" object:nil];
    //用户登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"LoginSuccess" object:nil];
    // 父类左边栏的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHUserParentViewController" object:nil];
    //隐藏左边返回按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"hiddenBrandReturnButton" object:nil];
    //获取搜索关键字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"搜索布料" object:nil];
}
//通知反馈
- (void)notificationResponse:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"ZDHDesignCellCase"] || [notification.name isEqualToString:@"ZDHDesignDetailDownCell"]) {
        //设计方案空间
        ZDHDesignMethodsViewController *dmVC = [[ZDHDesignMethodsViewController alloc] init];
        dmVC.currNavigationController = self.currNavigationController;
        dmVC.appDelegate = self.appDelegate;
        dmVC.planID = [notification.userInfo valueForKey:@"planID"];
        [self.currNavigationController pushViewController:dmVC animated:YES];
    }else if([notification.name isEqualToString:@"ZDHUserClothesView"]){
        _isShowBrandReturnButton = YES;
        //进入布料详情
        NSString *cid = [notification.userInfo valueForKey:@"cid"];
        NSString *clothid = [notification.userInfo valueForKey:@"clothid"];
        NSString *titileName = [notification.userInfo valueForKey:@"Titlename"];

        ZDHClothDetailViewController *dmVC = [[ZDHClothDetailViewController alloc] init];
        dmVC.currNavigationController = self.currNavigationController;
        dmVC.appDelegate = self.appDelegate;
        dmVC.cid = cid;
        dmVC.clothid = clothid;
        dmVC.titileName =titileName;
        [self.currNavigationController pushViewController:dmVC animated:YES];
    }else if ([notification.name isEqualToString:@"LoginSuccess"]) {
        [self reloadData];
    }
    else if ([notification.name isEqualToString:@"ZDHUserParentViewController"]){
         _isShowBrandReturnButton = NO;
        // 显示返回按钮，隐藏返回电子布按钮
        [self.currNavigationController showBrandBackButtonWithFlag:NO];
        int selectedIndex = (int)[[notification.userInfo valueForKey:@"selectedIndex"] integerValue];
        [self setViewMode:selectedIndex];
    }
    else if ([notification.name isEqualToString:@"hiddenBrandReturnButton"]){
        // 隐藏返回按钮，显示返回电子布按钮
        [self.currNavigationController showBrandBackButtonWithFlag:YES];
    }
    else if ([notification.name isEqualToString:@"搜索布料"]){
        
        NSString *keyWord = [notification.userInfo valueForKey:@"keyword"];
        [_clothesView addClothPlateViewWithKey:keyWord];
    }
}

//跳转到布板页面
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//选择视图模式
- (void)setViewMode:(ViewMode)mode{
    //切换视图就取消下载
    [_downloadView cancelAllDownload];
    switch (mode) {
        case 1:
            [self setClothesViewMode];
            break;
        case 2:
            [self setMyOrderViewMode];
            break;
        case 3:
            [self setInterNewsViewMode];
            break;
        case 4:
            [self setdownloadViewMode];
            break;
        default:
            break;
    }
}
//布艺模式
- (void)setClothesViewMode{
    [_clothesView getData];
    _clothesView.hidden = NO;
    _myOrderView.hidden = YES;
    _interNewsView.hidden = YES;
    _downloadView.hidden = YES;
    [self.currNavigationController setDetailTitleLabelWithString:@"电子布板"];
}
//我的工单模式
- (void)setMyOrderViewMode{
    _clothesView.hidden = YES;
    _myOrderView.hidden = NO;
    _interNewsView.hidden = YES;
    _downloadView.hidden = YES;
    [self.currNavigationController setDetailTitleLabelWithString:@"我的工单"];
}
//内部资讯模式
- (void)setInterNewsViewMode{
    [_interNewsView getData];
    _clothesView.hidden = YES;
    _myOrderView.hidden = YES;
    _interNewsView.hidden = NO;
    _downloadView.hidden = YES;
    [self.currNavigationController setDetailTitleLabelWithString:@"内部资讯"];
}
//离线下载
- (void)setdownloadViewMode{
    _clothesView.hidden = YES;
    _myOrderView.hidden = YES;
    _interNewsView.hidden = YES;
    _downloadView.hidden = NO;
    [self.currNavigationController setDetailTitleLabelWithString:@"离线下载"];
}
//删除控件上的子View
- (void)deleteAllSubView:(UIView *)view{
    
    for (UIView *subView in [view subviews]) {
        [subView removeFromSuperview];
    }
}

@end
