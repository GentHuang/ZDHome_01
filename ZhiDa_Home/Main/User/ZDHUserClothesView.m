//
//  ZDHUserClothesView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHUserClothesView.h"
#import "ZDHClothesTopView.h"
#import "ZDHClothedCell.h"
//ViewModel
#import "ZDHUserClothesViewViewModel.h"
#import "ZDUserClothesPlateView.h"
//Lib
#import "Masonry.h"
#import "MBProgressHUD.h"
@interface ZDHUserClothesView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (assign, nonatomic) BOOL isSearch;
@property (assign, nonatomic) BOOL isFirst;
@property (assign, nonatomic) BOOL isFirstPage;
@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSString *tid;
@property (assign, nonatomic) int lastTopIndex;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) ZDHClothesTopView *topView;
@property (strong, nonatomic) NSArray *cellNameArray;
@property (strong, nonatomic) NSArray *cellIDArray;
@property (strong, nonatomic) NSArray *cellImageArray;
@property (strong, nonatomic) UIView *waitBackView;
@property (strong, nonatomic) MBProgressHUD *progressHud;
@property (strong, nonatomic) ZDHUserClothesViewViewModel *vcViewModel;
@property (strong, nonatomic) NSString *selectedString;
//
@property (strong, nonatomic) ZDUserClothesPlateView *ClothPlateView;
@end
@implementation ZDHUserClothesView

- (void)initData{
    _vcViewModel = [[ZDHUserClothesViewViewModel alloc] init];
    _lastTopIndex = 0;
}
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
        //添加通知
//        [self notificationRecieve];
        [self initData];
        [self createUI];
        [self setSubViewLayout];
        //添加观察者
        [self addObserver];
    }
    return self;
}
#pragma mark - Life circle
- (void)dealloc{
    [_topView removeObserver:self forKeyPath:@"selectedIndex"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Getters and setters
- (void)createUI{
    __block ZDHUserClothesViewViewModel *selfViewModel = _vcViewModel;
    __block ZDHUserClothesView *selfView = self;
    //    _isSearch = NO;
    _selectedString = @"";
    _isFirst = YES;
    _isFirstPage = YES;
    self.backgroundColor = [UIColor whiteColor];
    //TopView
    _topView = [[ZDHClothesTopView alloc] init];
    // 显示顶部的滚动按钮
    [_topView showClothTitleLabelScrollerViewModel:kTopViewShowScrollerButtonModel];
    [self addSubview:_topView];
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改item大小
    layout.itemSize = CGSizeMake(230,356);
    //上下左右偏移
    layout.sectionInset = UIEdgeInsetsMake(20, 47, 20, 54);
    //左右两个item的最小间距
    layout.minimumInteritemSpacing = 15;
    //上下两个item的最小间距
    layout.minimumLineSpacing = 40;
    //滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //CollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeOnDrag;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ZDHClothedCell class] forCellWithReuseIdentifier:@"ZhiDaCell"];
    [self addSubview:_collectionView];
    
    __block ZDHClothesTopView *topVIEW = _topView;
    __weak __typeof(self) weakSelf = self;
    //下拉刷新
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //移除视图
        [weakSelf.ClothPlateView removeFromSuperview];
        //清除空
        [weakSelf.topView cleanSearchText];
        
        if(![weakSelf.selectedString isEqualToString:@""]&&weakSelf.selectedString!=nil){
            [weakSelf.vcViewModel getClothInfoWithYear:weakSelf.selectedString Success:^(NSMutableArray *resultArray) {
                _cellIDArray = selfViewModel.dataClothListIDArray;
                _cellImageArray = selfViewModel.dataClothListImageArray;
                _cellNameArray = selfViewModel.dataClothListNameArray;
                [selfView.collectionView reloadData];
                [selfView.collectionView.header endRefreshing];
                //有网络
                [selfView.topView IshidenSearchView:NO];
            } fail:^(NSError *error) {
                //断网情况下隐藏搜索栏
                [selfView.topView IshidenSearchView:YES];
            }];
            
        }else {
            //请求首页的数据
            [selfViewModel getClothFirstPageSuccess:^(NSMutableArray *resultArray) {
                //获取成功
                _cellIDArray = selfViewModel.dataClothListIDArray;
                _cellImageArray = selfViewModel.dataClothListImageArray;
                _cellNameArray = selfViewModel.dataClothListNameArray;
                [selfView.collectionView reloadData];
                [selfView.collectionView.header endRefreshing];
                //有网络
                [selfView.topView IshidenSearchView:NO];
            } fail:^(NSError *error) {
                //获取失败
                _cellIDArray = selfViewModel.dataClothListIDArray;
                _cellImageArray = selfViewModel.dataClothListImageArray;
                _cellNameArray = selfViewModel.dataClothListNameArray;
                [selfView stopDownload];
                [selfView.collectionView reloadData];
                [selfView.collectionView.header endRefreshing];
                //断网情况下隐藏搜索栏
                [selfView.topView IshidenSearchView:YES];
            }];
            
            //下拉刷新的时候选择第一个按钮
            [topVIEW selectWithIndex:0];
        }
        //        }
    }];
    //等待下载
    _waitBackView = [[UIView alloc] init];
    _waitBackView.backgroundColor = WHITE;
    [self addSubview:_waitBackView];
    //
    _progressHud = [[MBProgressHUD alloc] initWithView:_waitBackView];
    [_waitBackView addSubview:_progressHud];
    
    //布板
    //    _ClothPlateView = [[ZDUserClothesPlateView alloc]init];
    //    _ClothPlateView.hidden= YES;
    //    [self addSubview:_ClothPlateView];
}
- (void)setSubViewLayout{
    //TopView
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(50);
    }];
    //CollectionView
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    //等待下载
    [_waitBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //
    [_progressHud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_waitBackView);
    }];
}
#pragma mark - Event response
//添加观察者
- (void)addObserver{
    //观察头部
    [_topView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == _topView) {
        
        _keyword = @"";
        int selectedIndex = [[change valueForKey:@"new"] intValue];
        _isFirstPage = NO;
        //移除视图
        [_ClothPlateView removeFromSuperview];
        __block ZDHUserClothesView *selfView = self;
        __block ZDHUserClothesViewViewModel *selfViewModel = _vcViewModel;
        //        [_collectionView.header beginRefreshing];
        if (selectedIndex == 0) {
            // 获取所有布板
            _selectedString = @"";
            [_collectionView.header beginRefreshing];
        }
        else{
            NSMutableArray *dataClothTitileArray = (NSMutableArray *)[[_vcViewModel.dataClothTitleArray reverseObjectEnumerator] allObjects];
            //选择年份
            _selectedString = dataClothTitileArray[selectedIndex-1];
            //根据年份获取信息
            [_vcViewModel getClothInfoWithYear:dataClothTitileArray[selectedIndex-1] Success:^(NSMutableArray *resultArray) {
                
                _cellIDArray = selfViewModel.dataClothListIDArray;
                _cellImageArray = selfViewModel.dataClothListImageArray;
                _cellNameArray = selfViewModel.dataClothListNameArray;
                //              [selfView.collectionView reloadData];
                [selfView.collectionView.header beginRefreshing];
                
            } fail:^(NSError *error) {
                
            }];
        }
    }
}
//添加通知
- (void)notificationRecieve{
    //获取搜索关键字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"搜索布料" object:nil];
}
//通知反馈
- (void)notificationResponse:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"搜索布料"]) {
        _keyword = [notification.userInfo valueForKey:@"keyword"];
        if (_keyword.length > 0) {
            
            if(_ClothPlateView){
                
                [_ClothPlateView removeFromSuperview];
                _ClothPlateView = nil;
            }
            [self CreatClothPlateView];
            _isSearch = YES;
            _ClothPlateView.isSearch = YES;
            _ClothPlateView.keyword = _keyword;
            _ClothPlateView.ClothID = @"";
            _ClothPlateView.titleName = @"";
            [_ClothPlateView searchViewWithKeyword:_keyword isSearch:YES];
            [_topView showClothTitleLabelScrollerViewModel:kTopViewShowScrollerButtonModel];
            
        }else{
            _isSearch = NO;
        }
    }
}
#pragma mark - Network request
//获取首页数据
- (void)getData{
    [_topView showClothTitleLabelScrollerViewModel:kTopViewShowScrollerButtonModel];
    _isFirstPage = YES;
    __block ZDHUserClothesViewViewModel *selfViewModel = _vcViewModel;
    __block ZDHUserClothesView *selfView = self;
    if (_isFirst) {
        [self startDownload];
    }
    _selectedString =@"";
    [_collectionView.header beginRefreshing];
    //获取头部数据
    [_vcViewModel getClothTitleSuccess:^(NSMutableArray *resultArray) {
        //获取成功
        selfView.isFirst = YES;
        [selfView stopDownload];
        //刷新头部数据
        // 将获取到的顶部年份进行逆序
        NSMutableArray *titleArray = [NSMutableArray arrayWithArray:selfViewModel.dataClothTitleArray];
        titleArray = (NSMutableArray *)[[titleArray reverseObjectEnumerator] allObjects];
        [titleArray insertObject:@"全部布板" atIndex:0];
        [selfView.topView reloadScrollViewWithButtonArray:titleArray];
        //        [selfView.topView reloadScrollViewWithArray:titleArray];
        //获取首页数据
        //        [selfView.collectionView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        selfView.isFirst = NO;
        [selfView stopDownload];
        [selfView.collectionView reloadData];
        [selfView.collectionView.header endRefreshing];
    }];
}
//根据头部Index获取数据(用以点击返回时候，定位布料列表位置)
- (void)getDataWithIndex:(int)index{
    _isFirstPage = NO;
    _selectedString = @"";
    _tid = _vcViewModel.dataClothIDArray[index];
    [_collectionView.header beginRefreshing];
}
#pragma mark - Protocol methods
//UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_cellNameArray.count > 0) {
        return _cellNameArray.count;
    }else{
        
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZDHClothedCell *clothesCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZhiDaCell" forIndexPath:indexPath];
    
    if (_cellNameArray.count > 0) {//_cellImageArray.count > 0
        [clothesCell reloadNameWithString:_cellNameArray[indexPath.item]];
        
        if ([_vcViewModel.ImageAllDict valueForKey:_cellIDArray[indexPath.item]]) {
            
            [clothesCell reloadImageWithImage:[_vcViewModel.ImageAllDict valueForKey:_cellIDArray[indexPath.item]]];
            
        }else if (_cellImageArray.count>0){
            
            [clothesCell reloadImageWithImage:_cellImageArray[indexPath.item]];
            
        }else {
            
            //没有图片传空图
            [clothesCell reloadImageWithImage:[UIImage imageNamed:@"420_600"]];
        }
    }
    return clothesCell;
}
//UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenBrandReturnButton" object:nil];
    // 布板跳转到布板列表
    [self CreatClothPlateView];
    _ClothPlateView.titleName = _cellNameArray[indexPath.row];
    _ClothPlateView.isSearch = NO;
    [_topView showClothTitleLabelScrollerViewModel:kTopViewShowtitleLableModel];
    [_topView reflashClothTitle:_cellNameArray[indexPath.row]];
    [_ClothPlateView getDataWithClothID:_cellIDArray[indexPath.row]];
}
- (void)CreatClothPlateView {
    
    _ClothPlateView = [[ZDUserClothesPlateView alloc]init];
    [self addSubview:_ClothPlateView];
    [self insertSubview:_ClothPlateView aboveSubview:self];
    //布板
    [_ClothPlateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
}
// 加载布分类列表
- (void) addClothPlateViewWithKey:(NSString *)keyWord{
    _keyword = keyWord;
    if (_keyword.length > 0) {
        
        if(_ClothPlateView){
            
            [_ClothPlateView removeFromSuperview];
            _ClothPlateView = nil;
        }
        [self CreatClothPlateView];
        _isSearch = YES;
        _ClothPlateView.isSearch = YES;
        _ClothPlateView.keyword = _keyword;
        
        _ClothPlateView.ClothID = @"";
        _ClothPlateView.titleName = @"";
        [_ClothPlateView searchViewWithKeyword:_keyword isSearch:YES];
        [_topView showClothTitleLabelScrollerViewModel:kTopViewShowScrollerButtonModel];
        
    }else{
        _isSearch = NO;
    }
}

// 获取布的数据
#pragma mark - Network request

#pragma mark - Other methods
//开始下载
- (void)startDownload{
    _waitBackView.hidden = NO;
    [_progressHud show:YES];
}
//停止下载
- (void)stopDownload{
    _waitBackView.hidden = YES;
    [_progressHud show:NO];
}

@end
