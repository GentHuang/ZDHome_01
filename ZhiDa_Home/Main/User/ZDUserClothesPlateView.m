//
//  ZDUserClothesPlateView.m
//  ZhiDa_Home
//
//  Created by apple on 16/3/13.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDUserClothesPlateView.h"
#import "ZDHUserClothesView.h"
#import "ZDHClothesTopView.h"
#import "ZDHClothedCell.h"
//ViewModel
#import "ZDHUserClothesViewViewModel.h"
//Lib
#import "Masonry.h"
#import "MBProgressHUD.h"
@interface ZDUserClothesPlateView()<UICollectionViewDataSource,UICollectionViewDelegate>

//@property (assign, nonatomic) BOOL isSearch;
@property (assign, nonatomic) BOOL isFirst;
@property (assign, nonatomic) BOOL isFirstPage;
//@property (strong, nonatomic) NSString *keyword;
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

//布版的ID
@property (strong, nonatomic) NSString *clothPlateID;
@end
@implementation ZDUserClothesPlateView

- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHUserClothesViewViewModel alloc] init];
    //
    _lastTopIndex = 0;
    
}
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Getters and setters
- (void)createUI{

    self.backgroundColor = [UIColor whiteColor];
    
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
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeOnDrag;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ZDHClothedCell class] forCellWithReuseIdentifier:@"ZhiDaCell"];
    [self addSubview:_collectionView];
    //下拉刷新
    __block ZDUserClothesPlateView *selfVC = self;
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        // 如果是搜索，就刷新搜索的数据
        if (_isSearch) {
            
            [self getDataWithKeyWord:_keyword];
        }else{
            // 如果是从布板跳转，就直接加载布的数据
           [selfVC getDataWithClothID];
        }
    }];
    [_collectionView.header beginRefreshing];
}
- (void)setSubViewLayout{
    //CollectionView
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);

    }];
//    //等待下载
//    [_waitBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//    //
//    [_progressHud mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(_waitBackView);
//    }];
}
#pragma mark - Network request
//根据ID获取数据
- (void)getDataWithClothID{
    
    __block ZDUserClothesPlateView *selfView = self;
    [_vcViewModel getDataWithTypeID:_ClothID withTitleName:_titleName success:^(NSMutableArray *resultArray) {
        //获取成功
        _cellImageArray = _vcViewModel.dataClothListImageArray;
        _cellNameArray = _vcViewModel.dataClothListNameArray;
        _cellIDArray = _vcViewModel.dataClothListIDArray;
        [selfView.collectionView reloadData];
        [selfView.collectionView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        _cellImageArray = _vcViewModel.dataClothListImageArray;
        _cellNameArray = _vcViewModel.dataClothListNameArray;
        [selfView.collectionView reloadData];
        [selfView.collectionView.header endRefreshing];
    }];
}
//刷新获取布的数据
- (void)getDataWithClothID:(NSString*)stringID {
    _isSearch = NO;
    _ClothID = stringID;
    __block ZDUserClothesPlateView *selfView = self;
     [_vcViewModel getDataWithTypeID:stringID withTitleName:_titleName success:^(NSMutableArray *resultArray) {
        //获取成功
        _cellImageArray = _vcViewModel.dataClothListImageArray;
        _cellNameArray = _vcViewModel.dataClothListNameArray;
        _cellIDArray = _vcViewModel.dataClothListIDArray;
        [selfView.collectionView reloadData];
        [selfView.collectionView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        _cellImageArray = _vcViewModel.dataClothListImageArray;
        _cellNameArray = _vcViewModel.dataClothListNameArray;
        [selfView.collectionView reloadData];
        [selfView.collectionView.header endRefreshing];
    }];
}
#pragma mark - Protocol methods
//UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_cellImageArray.count > 0) {
        
        return _cellImageArray.count;
    }else{
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZDHClothedCell *clothesCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZhiDaCell" forIndexPath:indexPath];
    if (_cellImageArray.count > 0) {
        [clothesCell reloadImageWithImage:_cellImageArray[indexPath.item]];
    }
    if(_cellNameArray.count>0 ){
        [clothesCell reloadNameWithString:_cellNameArray[indexPath.item]];
    }
    return clothesCell;
}
//UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击进入布料详情
    NSString *cid = _cellIDArray[indexPath.row];
    if (_isSearch) {
        
        _titleName = _cellNameArray[indexPath.row];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHUserClothesView" object:self userInfo:@{@"cid":_ClothID,@"clothid":cid,@"Titlename":_titleName}];
}
// 搜索框搜索后获取数据
- (void) searchViewWithKeyword:(NSString *) keyWord isSearch:(BOOL)isSearch{
    _isSearch = isSearch;
    __block ZDUserClothesPlateView *selfVC = self;
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 如果是搜索，就刷新搜索的数据
        if (_isSearch) {
            
            [selfVC getDataWithKeyWord:_keyword];
        }else{
            // 如果是从布板跳转，就直接加载布的数据
            [selfVC getDataWithClothID];
        }
    }];
    [_collectionView.header beginRefreshing];
}

//根据关键字进行搜索
- (void)getDataWithKeyWord:(NSString *)keyword{
    
    __block ZDHUserClothesViewViewModel *selfViewModel = _vcViewModel;
    __block ZDUserClothesPlateView *selfView = self;
    [_vcViewModel getClothSearchListWithKeyword:keyword success:^(NSMutableArray *resultArray) {
        
        //获取成功
        _cellIDArray = selfViewModel.dataClothListIDArray;
        _cellImageArray = selfViewModel.dataClothListImageArray;
        _cellNameArray = selfViewModel.dataClothListNameArray;
        [selfView.collectionView reloadData];
        [selfView.collectionView.header endRefreshing];
    } fail:^(NSError *error) {
        //请求失败
        _cellIDArray = selfViewModel.dataClothListIDArray;
        _cellImageArray = selfViewModel.dataClothListImageArray;
        _cellNameArray = selfViewModel.dataClothListNameArray;
        [selfView.collectionView reloadData];
        [selfView.collectionView.header endRefreshing];
    }];
}
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
