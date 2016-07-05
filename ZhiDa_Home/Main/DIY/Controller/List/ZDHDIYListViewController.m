//
//  ZDHDIYListViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controller
#import "ZDHDIYListViewController.h"
#import "ZDHDIYDetailViewController.h"
//View
#import "ZDHDIYTopView.h"
#import "ZDHDIYCollectionViewCell.h"
//ViewModel
#import "ZDHDIYListViewControllerViewModel.h"
//Model
#import "ZDHDIYListViewControllerListDiyListModel.h"
//Lib
#import "Masonry.h"
@interface ZDHDIYListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) ZDHDIYTopView *topView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) ZDHDIYListViewControllerViewModel *vcViewModel;
@property (strong, nonatomic) UIView *progressBackView;
@property (strong, nonatomic) MBProgressHUD *progressView;
@property (assign, nonatomic) int leftTitleSelectedIndex;
@property (assign, nonatomic) int rightTitleSelectedIndex;
//@property (strong, nonatomic)
@end

@implementation ZDHDIYListViewController
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHDIYListViewControllerViewModel alloc] init];
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    [self setSubViewLayout];
    [self startDownload];
    [self addNotification];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
    [self getTitleData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"家居DIY"];
    [self.appDelegate.tabBarVC showTabBar];
}
- (void)createUI{
    _leftTitleSelectedIndex = 9999;
    _rightTitleSelectedIndex = 9999;
    self.view.backgroundColor = WHITE;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.userInteractionEnabled = YES;
    //顶部View
    _topView = [[ZDHDIYTopView alloc] init];
    _topView.hidden = YES;
    [self.view addSubview:_topView];
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //定义底部的大小
    [layout setFooterReferenceSize:CGSizeMake(_collectionView.frame.size.width,120)];
    //修改item大小
    layout.itemSize = CGSizeMake(303, 220);
    //上下左右偏移
    layout.sectionInset = UIEdgeInsetsMake(37, 30, 0, 22);
    //左右两个item的最小间距
    layout.minimumInteritemSpacing = 15;
    //上下两个item的最小间距
    layout.minimumLineSpacing = 44;
    //滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //CollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ZDHDIYCollectionViewCell class] forCellWithReuseIdentifier:@"DIYCell"];
    // 设置底部视图
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self.view addSubview:_collectionView];
    __block ZDHDIYListViewControllerViewModel *selfViewModel = _vcViewModel;
    __weak typeof(self) weaks = self;
    //下拉刷新
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进行列表请求
        [selfViewModel getListWithSpaceIndex:weaks.leftTitleSelectedIndex styleIndex:weaks.rightTitleSelectedIndex success:^(NSMutableArray *resultArray) {
            
            //请求成功
            [weaks.collectionView.header endRefreshing];
            if (selfViewModel.dataListArray.count > 0) {
                
                [weaks.collectionView reloadData];
            }
        } fail:^(NSError *error) {
            
            //请求失败
            [weaks.collectionView reloadData];
            [weaks.collectionView.header endRefreshing];
        }];
    }];
    [_collectionView.header beginRefreshing];
    //等待下载
    _progressBackView = [[UIView alloc] init];
    _progressBackView.hidden = YES;
    _progressBackView.backgroundColor = WHITE;
    [self.view addSubview:_progressBackView];
    //等待下载
    _progressView = [[MBProgressHUD alloc] initWithView:_progressBackView];
    _progressView.hidden = NO;
    [_progressView show:NO];
    [_progressBackView addSubview:_progressView];
    [super createSuperUI];
}
- (void)setSubViewLayout{
    [super setSuperSubViewLayout];
    //顶部View
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(NAV_HEIGHT+STA_HEIGHT));
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(0);// 隐藏顶部分类
    }];
    //CollectionView
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    //等待下载
    [_progressBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    //等待下载
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_progressBackView);
    }];
}
#pragma mark - Event response
//添加通知
- (void)addNotification{
    //选择空间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"请选择空间" object:nil];
    //选择风格
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"请选择风格" object:nil];
}
//通知反馈
- (void)notificationResponse:(NSNotification *)notification{
    if ([notification.name isEqualToString:@"请选择空间"]) {
        //选择空间
        NSArray *leftArray = [notification.userInfo valueForKey:@"空间"];
        if (leftArray.count > 0) {
            _leftTitleSelectedIndex = [[leftArray firstObject] intValue];
        }else{
            _leftTitleSelectedIndex = 9999;
        }
    }else if([notification.name isEqualToString:@"请选择风格"]){
        //选择风格
        NSArray *rightArray = [notification.userInfo valueForKey:@"风格"];
        _rightTitleSelectedIndex = [[rightArray firstObject] intValue];
        if (rightArray.count > 0) {
            _rightTitleSelectedIndex = [[rightArray firstObject] intValue];
        }else{
            _rightTitleSelectedIndex = 9999;
        }
    }
    //列表请求
    [_collectionView.header beginRefreshing];
}
#pragma mark - Network request
//获取头部信息
- (void)getTitleData{
//    __block ZDHDIYListViewController *selfVC = self;
    __block ZDHDIYListViewControllerViewModel *selfViewModel = _vcViewModel;
    __block BOOL isSpaceTitle = NO;
    __block BOOL isStyleTitle = NO;
    __weak typeof(self) weaks = self;
    //获取空间头部信息
    [_vcViewModel getSpaceTitleSuccess:^(NSMutableArray *resultArray) {
        __strong __typeof(weaks) sself = weaks; // 强引用一次
        //获取成功
        isSpaceTitle = YES;
        [weaks.topView creatSpaceTitleButtonWithArray:selfViewModel.dataSpaceTitleArray];
        if (isSpaceTitle && isStyleTitle) {
            [sself stopDownload];
        }
    } fail:^(NSError *error) {
        //获取失败
    }];
    //获取风格头部信息
    [_vcViewModel getStyleTitleSuccess:^(NSMutableArray *resultArray) {
        __strong __typeof(weaks) sself = weaks; // 强引用一次
        //获取成功
        isStyleTitle = YES;
        [weaks.topView creatStyleTitleButtonWithArray:selfViewModel.dataStyleTitleArray];
        if (isSpaceTitle && isStyleTitle) {
            [sself stopDownload];
        }
    } fail:^(NSError *error) {
        //获取失败
    }];
}
#pragma mark - Protocol methods
//UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_vcViewModel.dataListArray.count > 0) {
        
        return _vcViewModel.dataListArray.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDHDIYCollectionViewCell *DIYCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DIYCell" forIndexPath:indexPath];
    
    if (_vcViewModel.dataListArray > 0) {
    ZDHDIYListViewControllerListDiyListModel *listModel = _vcViewModel.dataListArray[indexPath.item];
    //加载信息
    [DIYCell reloadImageView:listModel.smallimg];
    [DIYCell reloadTitle:listModel.title];
        
    }
    return DIYCell;
}
//UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击进入DIY详情
    ZDHDIYDetailViewController *detailVC = [[ZDHDIYDetailViewController alloc] init];
    detailVC.currNavigationController = self.currNavigationController;
    detailVC.appDelegate = self.appDelegate;
    ZDHDIYListViewControllerListDiyListModel *listModel = _vcViewModel.dataListArray[indexPath.item];
    detailVC.ID = listModel.id_conflict;
    detailVC.DIYNaviTitle = listModel.title;
    [self.currNavigationController pushViewController:detailVC animated:YES];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

// 设置底部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  
    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    footerView.backgroundColor =[UIColor whiteColor];
    
    UIView *backGroundView = [[UIView alloc]init];
    backGroundView.backgroundColor =  [UIColor colorWithRed:248/256.0 green:248/256.0 blue:248/256.0 alpha:1];
    backGroundView.layer.cornerRadius = 8.0f;
    [footerView addSubview:backGroundView];
    
    [backGroundView mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.right.mas_equalTo(footerView.mas_right).offset(-20);
        make.left.mas_equalTo(footerView.mas_left).offset(20);
        make.centerX.centerY.equalTo(footerView);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无更多，敬请期待...";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [footerView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.right.mas_equalTo(backGroundView.mas_right).offset(0);
        make.left.mas_equalTo(backGroundView.mas_left).offset(0);
        make.centerX.centerY.equalTo(footerView);
        make.top.bottom.equalTo(backGroundView);
    }];
    
    return footerView;
}

#pragma mark - Other methods
//开始加载
- (void)startDownload{
    _progressBackView.hidden = NO;
    [_progressView show:YES];
}
//停止加载
- (void)stopDownload{
    _progressBackView.hidden = YES;
    [_progressView show:NO];
}
@end
