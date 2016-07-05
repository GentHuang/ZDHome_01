//
//  ZDHProductListViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controller
#import "ZDHProductListViewController.h"
#import "ZDHProductDetailViewController.h"
//View
#import "ZDHProductListCell.h"
// 顶部按钮栏
#import "ZDHTopClassifyView.h"
// 下拉View
#import "ZDHSearchDropdownMenuView.h"
#import "ZDHProductCenterSearchScreenView.h"
// 二维码扫描
#import "TTCScanViewController.h"
//ViewMidel
#import "ZDHProductListViewControllerViewModel.h"
//Lib
#import "Masonry.h"
//Model
#import "ZDHProductListViewControllerSearchProductModel.h"
#define TOPBUTTONTAG 50000

@interface ZDHProductListViewController()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (assign, nonatomic) BOOL isSearch;
@property (strong, nonatomic) ZDHProductListViewControllerViewModel *vcViewModel;
@property (strong, nonatomic) ZDHTopClassifyView *topClassifyView;
// 左边下拉
@property (strong, nonatomic) ZDHSearchDropdownMenuView *dropDownMenuView;
// 右边下拉
@property (strong, nonatomic) ZDHProductCenterSearchScreenView *viewScreenBar;
// 筛选按钮的下拉
@property (assign, nonatomic) BOOL isDragedRight;

// 下拉菜单背景
@property (strong, nonatomic) UIView *pullDownViewBack;
// 下拉菜单的标志
@property (copy, nonatomic) NSString *leftRightViewFlag;

@end
@implementation ZDHProductListViewController

/**
 三级分类： http://183.238.196.216:8088/search.ashx?m=search_product&brand=&style=&space=&type=101001021001&secondtype=&keyword=
 搜索： http://183.238.196.216:8088/search.ashx?m=search_product&brand=&style=&space=&type=&keyword=ddd
 综合、人气、新品：http://183.238.196.216:8088/search.ashx?m=search_product&brand=&style=&space=&type=101001021001&keyword=&order=new
 
 */
#pragma mark - Init methods
- (void)initData{
    
    _goodsArray = [NSMutableArray array];
    _productArray = [NSMutableArray array];
    //vcViewModel
    _vcViewModel = [[ZDHProductListViewControllerViewModel alloc] init];
    // 筛选下拉
    _isDragedRight = NO;
    //搜索数组
    _searchArray = [NSMutableArray array];
    _leftRightViewFlag = @"";
    
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    [self setSubViewLayout];
    [self notificationRecieve];
    [self addObserver];
    // 改变顶部左边button的title
    [self loadTopLeftButtonTitile];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
    [self.appDelegate.tabBarVC hideTabBar];
    [self getListData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)dealloc{
     NSLog(@"列表对象已经被释放~~~~~");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)createUI{
    _isSearch = NO;
//    __block ZDHProductListViewController *selfVC = self;
    self.view.backgroundColor = WHITE;
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改item大小
    layout.itemSize = CGSizeMake(467/2, 640/2);
    //上下左右偏移
    layout.sectionInset = UIEdgeInsetsMake(15, 19, 0, 17);
    //左右两个item的最小间距
    layout.minimumInteritemSpacing = 15;
    //上下两个item的最小间距
    layout.minimumLineSpacing = 44;
    //滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //CollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ZDHProductListCell class] forCellWithReuseIdentifier:@"ListCell"];
    [self.view addSubview:_collectionView];
    [super createSuperUI];
    //下拉刷新
    __weak __typeof(self) weakSelf = self;
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([weakSelf.clothTitle isEqualToString:@""] || weakSelf.clothTitle == nil) {
            weakSelf.clothTitle = @"";
            if ([weakSelf.keyword isEqualToString:@""]) {
            
                [weakSelf getLeftViewThirdSelectedData];
            }else{
            
                [weakSelf getData];
            }
        }else{
            [weakSelf getTopData];

        }
    }];
    [_collectionView.header beginRefreshing];
    _topClassifyView  = [[ZDHTopClassifyView alloc]init];
    [self.view addSubview:_topClassifyView];
    
    _dropDownMenuView.menuArray = self.productArray;
    // 筛选下拉
    _viewScreenBar = [[ZDHProductCenterSearchScreenView alloc]init];
    _viewScreenBar.layer.cornerRadius = 5.0;
    _viewScreenBar.layer.masksToBounds = YES;
    [self.view addSubview:_viewScreenBar];
    // 左边下拉
    _dropDownMenuView = [[ZDHSearchDropdownMenuView alloc]init];
    _dropDownMenuView.layer .cornerRadius = 5.0;
    [self.view addSubview:_dropDownMenuView];

}
- (void)setSubViewLayout{
    
    [super setSuperSubViewLayout];
    [_topClassifyView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(self.view.mas_top).offset(STA_HEIGHT+NAV_HEIGHT);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.mas_equalTo(50);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topClassifyView.mas_bottom).offset(-STA_HEIGHT);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    __weak typeof (self) weaks = self;
    [_dropDownMenuView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(weaks.topClassifyView.mas_top).offset(43);
        make.width.mas_equalTo(250);
        make.left.mas_equalTo(weaks.view.mas_left).offset(20);
        make.height.mas_equalTo(0);
    }];
    [_viewScreenBar mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.top.equalTo(weaks.topClassifyView.mas_top).offset(43);
        make.width.mas_equalTo(400);
        make.right.mas_equalTo(weaks.view.mas_right).offset(-20);
        make.height.mas_equalTo(0);
    }];
    // 顶部button的响应
    [self topViewButtonEventRespond];
}
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationSearchListMode];
    [self.currNavigationController setDetailTitleLabelWithString:@""];
}
#pragma mark - Event response
- (void)getData{
    
    __block ZDHProductListViewController *selfVC = self;
    [_vcViewModel getProductListWithKeyWord:_keyword
                                      brand:_brand
                                       type:_type
                                      space:_space
                                      style:_style
                                    success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfVC.collectionView reloadData];
        [selfVC.collectionView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        [selfVC.collectionView reloadData];
        [selfVC.collectionView.header endRefreshing];
    }];
}
// 获取顶部分类按钮数据
- (void) getTopData{
    
    __block ZDHProductListViewController *selfVC = self;
    [_vcViewModel getProductListWithKeyWord:_keyword
                                      brand:_brand
                                       type:_type
                                      space:_space
                                      style:_style
                                      order:_order
                                      clothid:_clothTitle
                                    success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfVC.collectionView reloadData];
        [selfVC.collectionView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        [selfVC.collectionView reloadData];
        [selfVC.collectionView.header endRefreshing];
    }];
}
// 触发左边下拉第三级cell选择接口
- (void) getLeftViewThirdSelectedData{
    __block ZDHProductListViewController *selfVC = self;
    [_vcViewModel getProductListWithKeyWord:_keyword
                                      brand:_brand
                                       type:_type
                                      space:_space
                                      style:_style
                                 secondtype:_secondType
                                    success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfVC.collectionView reloadData];
        [selfVC.collectionView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        [selfVC.collectionView reloadData];
        [selfVC.collectionView.header endRefreshing];
    }];
}
// 获取下拉列表的数据
//获取搜索列表信息
- (void)getListData{
    __block ZDHProductListViewControllerViewModel *selfViewModel = _vcViewModel;
    __block ZDHProductListViewController *selfView = self;
    //获取产品分类
    [_vcViewModel getSearchListSuccess:^(NSMutableArray *resultArray) {
        //获取商品分类
        [selfViewModel getSearchPruductCategorySuccess:^(NSMutableArray *resultArray) {
            //获取成功
            selfView.productArray = selfViewModel.dataProdutArray;
            selfView.goodsArray = selfViewModel.dataListArray;
        } fail:^(NSError *error) {
            
        }];
    } fail:^(NSError *error) {
    
    }];
}
// 获取搜索分类
#define NetWorkRequest
//接收通知
- (void)notificationRecieve{
    //全局下拉分类菜单搜索框监视关键字输入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"关键字" object:nil];
    // 监听分类按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHTopClassifyView" object:nil];
    // 监听右边下拉列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"SearchScreenView" object:nil];
    // 监听左边下拉列表cellcell的通知ZDHSearchDropdownMenuTableViewCell
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHSearchDropdownMenuTableViewCell" object:nil];
    // 全局下拉分类框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHNaviClassifyTableviewCell" object:nil];
}
//通知反馈
- (void)notificationResponse:(NSNotification *)notification{
    if ([notification.name isEqualToString:@"关键字"]){
        [_topClassifyView recoverSettingButtonSelected];
        [_topClassifyView loadLeftButtonTitleWithString:@""];
        self.type = @"";
        [_dropDownMenuView showMenuBarWithFlag:YES withArray:self.productArray withID:self.type];
        [self.viewScreenBar openSearchClassifyWithFlag:NO];
        [self.viewScreenBar cleanAllTheSelectedTitle];
        [self backgroundViewHidden];
        NSMutableArray *productArray = [notification.userInfo valueForKey:@"dataProdutArray"];
        NSMutableArray *listArray = [notification.userInfo valueForKey:@"dataListArray"];
        NSString *keyWord = [notification.userInfo valueForKey:@"keyword"];
        _keyword = keyWord;
        _brand = @"";
        _style = @"";
        _space = @"";
        _type  = @"";
        if(listArray.count > 0){
            
            _productArray = [[NSMutableArray alloc]initWithArray:productArray];
            _goodsArray = [[NSMutableArray alloc]initWithArray:listArray];
        }
        [_collectionView.header endRefreshing];
//        __block ZDHProductListViewController *selfVC = self;
        __weak __typeof(self) weakSelf = self;
        _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getData];
        }];
         [_collectionView.header beginRefreshing];
    }
    else if ([notification.name isEqualToString:@"ZDHTopClassifyView"]){

        
    }
    // 右边品牌下拉分类 列表
    else if ([notification.name isEqualToString:@"SearchScreenView"]){
        _keyword = @"";
        _brand = @"";
        _style = @"";
        _space = @"";
        _clothTitle = @"";
        NSDictionary *dic = notification.userInfo;
        _brand = [dic valueForKey:@"brandIdString"];
        _space = [dic valueForKey:@"spaceIdString"];
        _style = [dic valueForKey:@"styleIdString"];
        
        [self.collectionView.header endRefreshing];
//        __block ZDHProductListViewController *selfVC = self;
        //下拉刷新
        __weak __typeof(self) weakSelf = self;
        _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getData];
        }];
        [_collectionView.header beginRefreshing];
    }
    // 左边下拉分类列表
    else if([notification.name isEqualToString:@"ZDHSearchDropdownMenuTableViewCell"]){

        NSDictionary *dic = notification.userInfo;
        [self.collectionView.header endRefreshing];
        _secondType  = dic[@"typeid"];
//        __block ZDHProductListViewController *selfVC = self;
        __weak __typeof(self) weakSelf = self;
        _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getLeftViewThirdSelectedData];
        }];
        [_collectionView.header beginRefreshing];
    }
    else if ([notification.name isEqualToString:@"ZDHNaviClassifyTableviewCell"]){
        [_dropDownMenuView showMenuBarWithFlag:YES withArray:self.productArray withID:self.type];
        [self backgroundViewHidden];
        NSMutableArray *productArray = [notification.userInfo valueForKey:@"dataProdutArray"];
        NSMutableArray *listArray = [notification.userInfo valueForKey:@"dataListArray"];
        // 获取三级分类的分类
        NSString * thirdClassifyID = [notification.userInfo valueForKey:@"typeID"];
        // 获取名称
        NSString *titileName = [notification.userInfo valueForKey:@"titleName"];
        // 获取二级分类的id
        NSString *type = [notification.userInfo valueForKey:@"sectionID"];
        _keyword = @"";
        _brand   = @"";
        _type    = type;
        _space   = @"";
        _style   = @"";
        _clothTitle = @"";
        _secondType = thirdClassifyID;
        _leftButtonTitle = titileName;
        _productArray = [[NSMutableArray alloc]initWithArray:productArray];
        _goodsArray = [[NSMutableArray alloc]initWithArray:listArray];
        // 更新顶部做拉视图的标题
        [_topClassifyView loadLeftButtonTitleWithString:_leftButtonTitle];
        //下拉刷新
        [_collectionView.header endRefreshing];
//        __block ZDHProductListViewController *selfVC = self;
        __weak __typeof(self) weakSelf = self;
        _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if ([weakSelf.keyword isEqualToString:@""]) {
                [weakSelf getLeftViewThirdSelectedData];
            }else{
                [weakSelf getData];
            }
        }];
        [_collectionView.header beginRefreshing];
    }
}
// 顶部按钮的事件响应
- (void) topViewButtonEventRespond{
    // button回调
    __block ZDHSearchDropdownMenuView *menuView = _dropDownMenuView;
    __block ZDHProductListViewController *selfVC = self;
    __weak __typeof(self) weakSelf = self;
    _topClassifyView.pressButton = ^(UIButton  *button){
        
        int index = (int)(button.tag - TOPBUTTONTAG);
        switch (index) {
            case 0:
                [menuView showMenuBarWithFlag:NO withArray:weakSelf.productArray withID:weakSelf.type];
                [weakSelf createPullDownView];
                weakSelf.leftRightViewFlag = @"1";
                break;
            case 1:
                weakSelf.order = @"default";
                [weakSelf.collectionView.header endRefreshing];
                weakSelf.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                     [selfVC getTopData];
                }];
                [weakSelf.collectionView.header beginRefreshing];
                break;
            case 2:
                weakSelf.order = @"new";
                [weakSelf.collectionView.header endRefreshing];
                weakSelf.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [selfVC getTopData];
                }];
                [weakSelf.collectionView.header beginRefreshing];
                break;
            case 3:
                weakSelf.order = @"hot";
                [weakSelf.collectionView.header endRefreshing];
                weakSelf.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [selfVC getTopData];
                }];
                [weakSelf.collectionView.header beginRefreshing];
    
                break;
            case 4:
                if (weakSelf.goodsArray.count > 0) {
                   // 展开右边下拉列表
                    [weakSelf.viewScreenBar openSearchClassifyWithFlag:YES];
                    [weakSelf.viewScreenBar loadClassifyViewWithDataArray:weakSelf.goodsArray selectedArray:weakSelf.selectedIdArray];
                    [weakSelf createPullDownView];
                    weakSelf.leftRightViewFlag = @"2";
                }
                break;
            default:
                break;
        }
    };
}

//添加观察者
- (void)addObserver{
    
    //观察左边下拉列表的结果
    [_dropDownMenuView addObserver:self forKeyPath:@"typeIdString" options:NSKeyValueObservingOptionNew context:nil];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (object == _dropDownMenuView) {
        _brand = @"";
        _style = @"";
        _space = @"";
        _type  = @"";
        _keyword = @"";
        _type = [change valueForKey:@"new"];
        [self.collectionView.header endRefreshing]; 
        __weak __typeof(self) weakSelf = self;
        //下拉刷新
        _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf getData];
        }];
        [_collectionView.header beginRefreshing];
    }
}
// 改变左边的顶部button标题
- (void) loadTopLeftButtonTitile{
    
    [_topClassifyView loadLeftButtonTitleWithString:_leftButtonTitle];
}

- (void) createPullDownView{
//    if (_pullDownViewBack) {
//        
//        [_pullDownViewBack removeFromSuperview];
//        _pullDownViewBack = nil;
//    }
    _pullDownViewBack = [[UIView alloc]init];
    _pullDownViewBack.backgroundColor =  [UIColor grayColor];
    _pullDownViewBack.alpha = 0.4;
    [_pullDownViewBack addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewHidden)]];
    [self.view addSubview:_pullDownViewBack];
    [self.view insertSubview:_pullDownViewBack belowSubview:_dropDownMenuView];
    [self.view insertSubview:_pullDownViewBack belowSubview:_viewScreenBar];
    __weak typeof (self) weaks = self;
    [_pullDownViewBack mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(weaks.view.mas_top).offset(STA_HEIGHT+NAV_HEIGHT);
        make.left.right.bottom.equalTo(weaks.view);
    }];
}
// 手势
- (void) backgroundViewHidden{
    
    if ([_leftRightViewFlag isEqualToString:@"1"]) {
        
        [_dropDownMenuView showMenuBarWithFlag:YES withArray:self.productArray withID:self.type];
    }
    else if ([_leftRightViewFlag isEqualToString:@"2"]){
        // 收起右边的筛选下拉View
        [self.viewScreenBar openSearchClassifyWithFlag:NO];
        UIButton *btn = (UIButton *)[_topClassifyView viewWithTag:TOPBUTTONTAG + 4];
        btn.selected = NO;
    }
    _leftRightViewFlag = @"";
    [_pullDownViewBack removeFromSuperview];
    _pullDownViewBack = nil;
}

#pragma mark - Network request
#pragma mark - Protocol methods
//UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_isSearch) {
        //搜索
        return _searchArray.count;
    }else{
        if (_vcViewModel.dataProListArray.count > 0) {
            return _vcViewModel.dataProListArray.count;
        }else{
            return 0;
        }
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZDHProductListCell *listCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
    if(_isSearch){
        //搜索
        if (_searchArray.count > 0) {
            //加载数据
            ZDHProductListViewControllerSearchProductModel *proModel = _searchArray[indexPath.item];
            [listCell reloadImageView:proModel.proimg];
            [listCell reloadName:proModel.proname];
            [listCell reloadNum:proModel.pronumber];
            [listCell reloadBrand:proModel.brand];
        }
    }else{
        if (_vcViewModel.dataProListArray.count > 0) {
            //加载数据
            ZDHProductListViewControllerSearchProductModel *proModel = _vcViewModel.dataProListArray[indexPath.item];
            [listCell reloadImageView:proModel.proimg];
            [listCell reloadName:proModel.proname];
            [listCell reloadNum:proModel.pronumber];
            [listCell reloadBrand:proModel.brand];
        }
    }
    return listCell;
}
//UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDHProductDetailViewController *detailVC = [[ZDHProductDetailViewController alloc] init];
    detailVC.currNavigationController = self.currNavigationController;
    detailVC.appDelegate = self.appDelegate;
    
    if (_isSearch) {
        //搜索
        ZDHProductListViewControllerSearchProductModel *proModel = _searchArray[indexPath.item];
        detailVC.pid = proModel.id_conflict;
    }else{
        ZDHProductListViewControllerSearchProductModel *proModel = _vcViewModel.dataProListArray[indexPath.item];
        detailVC.pid = proModel.id_conflict;
    }
    [self.currNavigationController pushViewController:detailVC animated:YES];
}
//-------------添加手势回收键盘 -----------
#pragma mark  pack up keyboard
#pragma mark - Other methods
@end
