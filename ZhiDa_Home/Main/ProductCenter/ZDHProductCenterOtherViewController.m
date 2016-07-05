//
//  ZDHProductCenterOtherViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controller
#import "ZDHProductCenterOtherViewController.h"
#import "ZDHProductDetailViewController.h"
//View
#import "ZDHProductCenterSingleRightView.h"
#import "ZDHProductCommonTopScrollView.h"
#import "ZDHProductCommonBigImageView.h"
#import "ZDHProductCenterBrandBottomScrollView.h"
#import "ZDHProductCenterBrandBottomCollectionView.h"
#import "ZDHProductCommonBigImageScrollerView.h"
//add
#import "ZDHProductCenterBrandBigImageView.h"
//ViewModel
#import "ZDHProductCenterOtherViewControllerViewModel.h"
//myMethod-------------------------
#import "ZDHProductCenterOtherViewControllerAddNewViewModel.h"
#import "ZDHProductCenterOtherViewControllerSpaceModel.h"
//---------------------------------
//Model
#import "ZDHProductCenterOtherViewControllerSpaceItemModel.h"
#import "ZDHProductCenterOtherViewControllerListModel.h"
#import "ZDHProductCenterOtherViewControllerListProductModel.h"
//Lib
#import "Masonry.h"
#import "MBProgressHUD.h"
@interface ZDHProductCenterOtherViewController ()
@property (assign, nonatomic) int lastTopIndex;
@property (assign, nonatomic) int lastBottomIndex;
//头部视图
@property (strong, nonatomic) ZDHProductCommonTopScrollView *topScrollView;
//中间的大图
@property (strong, nonatomic) ZDHProductCenterBrandBigImageView *bigImageScrollerView;
//底部滚动图
@property (strong, nonatomic) ZDHProductCenterBrandBottomCollectionView *collectionView;
//右侧滚动视图
@property (strong, nonatomic) ZDHProductCenterSingleRightView *singleRightUpView;
@property (strong, nonatomic) ZDHProductCenterSingleRightView *singleRightDownView;

//数据获取
@property (strong, nonatomic) ZDHProductCenterOtherViewControllerViewModel *vcViewModel;
//加载等待动画
@property (strong, nonatomic) MBProgressHUD *progressHud;
@property (strong, nonatomic) UIView *progressBackView;

//添加
@property (strong, nonatomic) ZDHProductCenterOtherViewControllerAddNewViewModel *myVcViewModel;
@end

@implementation ZDHProductCenterOtherViewController
#pragma mark - Init methods
- (void)initData{
    _lastTopIndex = 0;
    _lastBottomIndex = 0;
    //-------add 修改JSON格式后添加的------------
    _myVcViewModel = [[ZDHProductCenterOtherViewControllerAddNewViewModel alloc]init];
    //----------------------------------------
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    //视图初始化
    [self createUI];
    [self setSubViewLayout];
    [self addObserver];
    [self notificationRecieve];
    [self startDownload];
    [self getAllData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
//    [_bottomScrollView removeObserver:self forKeyPath:@"selectedIndex"];
    [_collectionView removeObserver:self forKeyPath:@"selectedIndex"];
    [_topScrollView removeObserver:self forKeyPath:@"selectedIndex"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_bigImageScrollerView removeObserver:self forKeyPath:@"scrollerIndex"];
}
#pragma mark - Getters and setters
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
    [self.currNavigationController setDetailTitleLabelWithString:_titleName];
}
- (void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WHITE;
    //顶部滚动
    _topScrollView = [[ZDHProductCommonTopScrollView alloc] init];
    [self.view addSubview:_topScrollView];
    // 滚动大图
    _bigImageScrollerView = [[ZDHProductCenterBrandBigImageView alloc]init];
    [self.view addSubview:_bigImageScrollerView];
    // 底部滚动collectionView
    _collectionView  = [[ZDHProductCenterBrandBottomCollectionView alloc]init];
    [self.view addSubview:_collectionView];
    //右边视图(上)
    _singleRightUpView = [[ZDHProductCenterSingleRightView alloc] init];
    [_singleRightUpView setSingleRightViewType:kSingleRightUpType];
    [self.view addSubview:_singleRightUpView];
    //右边视图(下)
    _singleRightDownView = [[ZDHProductCenterSingleRightView alloc] init];
    [_singleRightDownView setSingleRightViewType:kSingleRightDownType];
    [self.view addSubview:_singleRightDownView];
    [super createSuperUI];
    //下载等待背景
    _progressBackView = [[UIView alloc] init];
    _progressBackView.backgroundColor = WHITE;
    _progressBackView.hidden = YES;
    [self.view addSubview:_progressBackView];
    //下载等待
    _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    [_progressHud show:NO];
    _progressHud.dimBackground = NO;
    [_progressBackView addSubview:_progressHud];
    
}
- (void)setSubViewLayout{
    [super setSuperSubViewLayout];
    //顶部滚动
    [_topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(@(NAV_HEIGHT+STA_HEIGHT));
        make.left.mas_equalTo(0);
    }];
    // 滚动大图_bigImageScrollerView
    [_bigImageScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_topScrollView.mas_bottom);
        make.height.mas_equalTo(501);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_bigImageScrollerView.mas_bottom);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
    }];
        //右边视图(上)
    [_singleRightUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(308-36);
        make.height.mas_equalTo(80);
        make.top.equalTo(_bigImageScrollerView.mas_top).with.offset(204);
    }];
    //右边视图(下)
    [_singleRightDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(450-36);
        make.height.mas_equalTo(80);
        make.top.equalTo(_bigImageScrollerView.mas_top).with.offset(350);
    }];
    //下载等待背景
    [_progressBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    //下载等待
    [_progressHud mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(_progressBackView);
    }];
}
#pragma mark - Event response
//添加观察者
- (void)addObserver{
    [_collectionView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //观察顶部滚动视图
    [_topScrollView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    // 滚动大图的索引变量的变化
    [_bigImageScrollerView addObserver:self forKeyPath:@"scrollerIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //观察顶部ScrollView
    if (object == _topScrollView) {
        
        NSString *selectedIndexString = [change valueForKey:@"new"];
        int selectedIndex = [selectedIndexString intValue];
        _lastTopIndex = selectedIndex;
        _lastBottomIndex = 0;
        [self getDataWithTitleSelectIndex:selectedIndex BottomScrollIndex:_lastBottomIndex];
       
    }else if (object ==_bigImageScrollerView) { //观察大图滚动
        NSString *selectedIndexString = [change valueForKey:@"new"];
         int selectedIndex = [selectedIndexString intValue];
        _lastBottomIndex = selectedIndex;
        [_collectionView scrollWithIndex:selectedIndexString];
        //刷新右边视图内容
        [self reloadSingleViewContent];
    }else if (object == _collectionView ) {//观察底部ScrollView
        NSString *selectedIndexString = [change valueForKey:@"new"];
        int selectedIndex = [selectedIndexString intValue];
        _lastBottomIndex = selectedIndex;
        //滚动大图时，滚动小图
        [_bigImageScrollerView scrollWithIndex:selectedIndexString];
        //刷新右边视图内容
        [self reloadSingleViewContent];
    }
}
//根据监听刷新右边视图及内容
- (void)reloadSingleViewContent {
    if(_myVcViewModel.dataScrollLocalImageArray.count>0){
        //右边小视图
        if (_lastBottomIndex < _myVcViewModel.dataLocalIDArray.count) {
            [_myVcViewModel getLocalDataWithPID:_myVcViewModel.dataLocalIDArray[_lastBottomIndex]];
        }
        [self.singleRightDownView reloadDownViewWithArray:_myVcViewModel.dataSingleImageArray];
        
    }else{
        //网络获取
        __block ZDHProductCenterOtherViewController *selfVC = self;
        __block ZDHProductCenterOtherViewControllerAddNewViewModel *selfMyviewModel = _myVcViewModel;
        //加载简介
        if(_lastBottomIndex < _myVcViewModel.dataProductIntroArray.count){
            [self.singleRightUpView reloadUpViewWithString:_myVcViewModel.dataProductIntroArray[_lastBottomIndex]];
        }
        //加载单品
        [_myVcViewModel getSingleRightViewWithScrollSelectedIndex:_lastBottomIndex success:^(NSMutableArray *resultArray) {
            //刷新小图
            [selfVC.singleRightDownView reloadDownViewWithArray:selfMyviewModel.dataSingleImageArray];
            [selfVC stopDownload];
        } fail:^(NSError *error) {
            //失败也刷新小图
            [selfVC.singleRightDownView reloadDownViewWithArray:selfMyviewModel.dataSingleImageArray];
            [selfVC stopDownload];
        }];
    }
}

//接收通知
- (void)notificationRecieve{
    //进入产品详情
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"ZDHProductCenterSingleRightView" object:nil];
}
//通知反馈
- (void)notificationAction:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"ZDHProductCenterSingleRightView"]) {
        
        int selectedIndex = [[notification.userInfo valueForKey:@"selectedIndex"] intValue];
        ZDHProductDetailViewController *detailVC  = [[ZDHProductDetailViewController alloc]init];
        detailVC.currNavigationController = self.currNavigationController;
        detailVC.appDelegate = self.appDelegate;
        if (_myVcViewModel.dataSmallScollModelArray.count>0) {
            
            ZDHProductCenterOtherViewControllerListProductModel *productModel= _myVcViewModel.dataSmallScollModelArray[selectedIndex];
            detailVC.pid = productModel.id_conflict;
        }else if (_myVcViewModel.dataSingleLocalIDaray.count>0){
            
            detailVC.pid = _myVcViewModel.dataSingleLocalIDaray[selectedIndex];
        }
        [self.currNavigationController pushViewController:detailVC animated:YES];
    }
}
#pragma mark - Network request
//获取所有数据
- (void)getAllData{
    
    __block ZDHProductCenterOtherViewController *selfmyVC = self;
    __block ZDHProductCenterOtherViewControllerAddNewViewModel *selfViewMyModel = _myVcViewModel;
    [_myVcViewModel getAllTitleDataWith:_tid success:^(NSMutableArray *resultArray) {
        //获取成功
        //加载顶部标题
        [selfmyVC.topScrollView reloadTopScrollViewWithArray:selfViewMyModel.dataTitileArray withIndex:_lastTopIndex];
        //根据title加载底部视图以及右边小视图
        [selfmyVC getDataWithTitleSelectIndex:_lastTopIndex BottomScrollIndex:_lastBottomIndex];
        //停止加载
        [selfmyVC stopDownload];
    } fail:^(NSError *error) {
        //停止加载
        [selfmyVC stopDownload];
    } ];
}

//根据标题和Index获取数据
- (void)getDataWithTitleSelectIndex:(int)TitleIndex BottomScrollIndex:(int)Scrollindex {
    
    __block ZDHProductCenterOtherViewController *selfVC = self;
    __block ZDHProductCenterOtherViewControllerAddNewViewModel *selfMyviewModel = _myVcViewModel;
    
    if (_myVcViewModel.dataTitileArray.count>0) {
        //加载本地的
        NSString *titleName = _myVcViewModel.dataTitileArray[TitleIndex];
        //获取底部滚动视图
        [_myVcViewModel getLocalDataWithTitle:titleName];
    }
    if (_myVcViewModel.dataScrollLocalImageArray.count>0||_myVcViewModel.dataLocalIDArray.count>0) {//本地获取
        //加载滚动视图
        [self.collectionView reloadRightScrollViewWithArray:_myVcViewModel.dataScrollLocalImageArray index:(int)Scrollindex];
        //加载大图
        [self.bigImageScrollerView loadBigImageWithImageArray:selfMyviewModel.dataScrollLocalImageArray];
        //加载简介
        [selfVC.singleRightUpView reloadUpViewWithString:selfMyviewModel.dataProductIntroArray[Scrollindex]];
        //右边小视图
        [_myVcViewModel getLocalDataWithPID:selfMyviewModel.dataLocalIDArray[Scrollindex]];
        [self.singleRightDownView reloadDownViewWithArray:_myVcViewModel.dataSingleImageArray];
        
    }else if(_myVcViewModel.dataTitleModelArray.count>0){
        
        //网络获取
        [_myVcViewModel getBottomScrollImageWithTitleSelectedIndex:TitleIndex success:^(NSMutableArray *resultArray) {
            //加载滚动视图
            [self.collectionView reloadRightScrollViewWithArray:_myVcViewModel.dataScrollImageArray index:(int)Scrollindex];
            //加载大图
            [self.bigImageScrollerView loadBigImageWithImageArray:selfMyviewModel.dataScrollImageArray];
            //加载简介
            [selfVC.singleRightUpView reloadUpViewWithString:selfMyviewModel.dataProductIntroArray[Scrollindex]];
            //加载单品
            [_myVcViewModel getSingleRightViewWithScrollSelectedIndex:Scrollindex success:^(NSMutableArray *resultArray) {
                //刷新小图
                [selfVC.singleRightDownView reloadDownViewWithArray:selfMyviewModel.dataSingleImageArray];
                [selfVC stopDownload];
            } fail:^(NSError *error) {
                //失败也刷新小图
                [selfVC.singleRightDownView reloadDownViewWithArray:selfMyviewModel.dataSingleImageArray];
                [selfVC stopDownload];
            }];
            
        } fail:^(NSError *error) {
            [selfVC stopDownload];
        }];
    }
}
#pragma mark - Protocol methods
#pragma mark - Other methods
//开始下载
- (void)startDownload{
    _progressBackView.hidden = NO;
    [_progressHud show:YES];
}
//停止下载
- (void)stopDownload{
    _progressBackView.hidden = YES;
    [_progressHud show:NO];
}
@end
