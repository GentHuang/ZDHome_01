//
//  ZDHProductCenterZhiDaViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controller
#import "ZDHProductCenterZhiDaViewController.h"
#import "ZDHProductCenterOtherViewController.h"
//View
#import "ZDHProductCenterZhiDaCell.h"
#import "ZDHProductCommonTopScrollView.h"
//ViewModel
#import "ZDHProductCenterZhiDaViewControllerViewModel.h"
//Model
#import "ZDHProductCenterZhiDaViewThemeimgThemeModel.h"
//Lib
#import "Masonry.h"
#import "MBProgressHUD.h"
@interface ZDHProductCenterZhiDaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (assign, nonatomic) int lastTopIndex;
@property (strong, nonatomic) NSString *selectedString;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *progressBackView;
@property (strong, nonatomic) ZDHProductCommonTopScrollView *topScrollView;
@property (strong, nonatomic) ZDHProductCenterZhiDaViewControllerViewModel *vcViewModel;
@property (strong, nonatomic) MBProgressHUD *progressHud;
@end

@implementation ZDHProductCenterZhiDaViewController
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHProductCenterZhiDaViewControllerViewModel alloc] init];
    _lastTopIndex = 0;
    _selectedString = @"所有";
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    [self setSubViewLayout];
    [self addObserver];
    [self getData];
    [_collectionView.header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    [_topScrollView removeObserver:self forKeyPath:@"selectedIndex"];
    NSLog(@"对象被销毁");
}
#pragma mark - Getters and setters
- (void)setNavigationBar{
    
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"志达家居布艺"];
}
- (void)createUI{
    
    self.view.backgroundColor = [UIColor colorWithRed:234/256.0 green:234/256.0 blue:234/256.0 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //顶部ScrollView
    _topScrollView = [[ZDHProductCommonTopScrollView alloc] init];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_topScrollView];
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改item大小
    layout.itemSize = CGSizeMake(313, 291);
    //上下左右偏移
    layout.sectionInset = UIEdgeInsetsMake(20, 27, 20, 27);
    //左右两个item的最小间距
    layout.minimumInteritemSpacing = 15;
    //上下两个item的最小间距
    layout.minimumLineSpacing = 20;
    //滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //CollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.layer.borderWidth = 1;
    _collectionView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ZDHProductCenterZhiDaCell class] forCellWithReuseIdentifier:@"ZhiDaCell"];
    [self.view addSubview:_collectionView];
    //下拉刷新
//    __block ZDHProductCenterZhiDaViewController *selfVC = self;
    __weak typeof(self) weaks = self;
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //默认加载所有
        [weaks getDetailDataWithYear:weaks.selectedString];
    }];
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
    [super createSuperUI];
}

- (void)setSubViewLayout{
    [super setSuperSubViewLayout];
     __weak typeof(self) weaks = self;
    //顶部ScrollView
    [_topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAV_HEIGHT+STA_HEIGHT));
        make.left.equalTo(0);
    }];
    //CollectionView
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weaks.topScrollView.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    //下载等待背景
    [_progressBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weaks.view);
    }];
    //下载等待
    [_progressHud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weaks.progressBackView);
    }];
}
#pragma mark - Event response
//添加观察者
- (void)addObserver{
    //点击顶部按钮
    [_topScrollView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //观察顶部ScrollView
    if (object == _topScrollView) {
        
        [_collectionView.header endRefreshing];
        int selectedIndex = [[change valueForKey:@"new"] intValue];
        _lastTopIndex = selectedIndex;
        if (selectedIndex == 0) {
            _selectedString = @"所有";// _selectedString = @"";
        }else{
            _selectedString = _vcViewModel.dataTypeIdArray[selectedIndex];
        }
        [_collectionView.header beginRefreshing];
    }
}
#pragma mark - Network request
//获取顶部数据
- (void)getData{
    
    [self startDownload];
    __block ZDHProductCenterZhiDaViewControllerViewModel *selfViewModel = _vcViewModel;
    __block ZDHProductCenterZhiDaViewController *selfVC = self;
    //获取年份
    [_vcViewModel getYearListSuccess:^(NSMutableArray *resultArray) {
        //获取成功
        [selfVC stopDownload];
        [selfVC.topScrollView reloadTopScrollViewWithArray:selfViewModel.dataTypeTextArray withIndex:_lastTopIndex];
    } fail:^(NSError *error) {
        //获取失败
        [selfVC stopDownload];
    }];
}
//根据年份获取图片详情
- (void)getDetailDataWithYear:(NSString *)year{
    __block ZDHProductCenterZhiDaViewController *selfVC = self;
    //默认加载所有
    [_vcViewModel getDataWithYear:year success:^(NSMutableArray *resultArray) {
        //加载成功
        [selfVC.collectionView reloadData];
        [selfVC.collectionView.header endRefreshing];
    } fail:^(NSError *error) {
        //加载失败
        [selfVC.collectionView reloadData];
        [selfVC.collectionView.header endRefreshing];
    }];
}
#pragma mark - Protocol methods
//UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_vcViewModel.dataThemeImageArray.count > 0) {
        
        return _vcViewModel.dataThemeImageArray.count;
    }else{
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZDHProductCenterZhiDaCell *ZhiDaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZhiDaCell" forIndexPath:indexPath];
    if (_vcViewModel.dataThemeImageArray.count > 0) {
        //加载数据
        [ZhiDaCell reloadCellWithTitleName:_vcViewModel.dataThemeTitleArray[indexPath.row]];
        [ZhiDaCell reloadCellWithImage:_vcViewModel.dataThemeImageArray[indexPath.row]];
    }
    return ZhiDaCell;
}
//UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_vcViewModel.dataThemeIDArray.count > 0) {
        
        ZDHProductCenterOtherViewController *otherVC = [[ZDHProductCenterOtherViewController alloc] init];
        otherVC.currNavigationController = self.currNavigationController;
        otherVC.appDelegate = self.appDelegate;
        otherVC.tid = _vcViewModel.dataThemeIDArray[indexPath.row];
        otherVC.titleName = _vcViewModel.dataThemeTitleArray[indexPath.row];
        [self.currNavigationController pushViewController:otherVC animated:YES];
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        
    }else{
        
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络开小差" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alView show];
        //优化，不需要用户点击确认即可取出弹窗。
//        [alView dismissWithClickedButtonIndex:0 animated:YES];
    }
}
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
