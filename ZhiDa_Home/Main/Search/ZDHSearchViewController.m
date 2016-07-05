//
//  ZDHSearchViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controller
#import "ZDHSearchViewController.h"
#import "ZDHProductListViewController.h"
#import "ZDHProductDetailViewController.h"
//Views
#import "ZDHSearchRightView.h"
#import "ZDHLeftViewCell.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHSearchViewControllerViewModel.h"
//Model
#import "ZDHSearchViewControllerListNewsSearchModel.h"
#import "ZDHSearchViewControllerListNewsSearchSearchTModel.h"
#import "ZDHSearchViewControllerHotWordHotsearchWordModel.h"
#import "ZDHSearchViewControllerNewListProtypelistModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel.h"



@interface ZDHSearchViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) ZDHSearchViewControllerViewModel *vcViewModel;
@property (strong, nonatomic) UITableView *leftView;
@property (strong, nonatomic) ZDHSearchRightView *rightView;
@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *style;
@property (strong, nonatomic) NSString *space;
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSMutableArray *selectedArray;
@end
@implementation ZDHSearchViewController

#pragma mark - Init methods
- (void)initData{
    
    //vcViewModel
    _vcViewModel = [[ZDHSearchViewControllerViewModel alloc] init];
    _selectedArray = [[NSMutableArray alloc]initWithArray:@[@"",@"",@""]];
    _keyword = @"";
    _brand = @"";
    _style = @"";
    _space = @"";
    _type = @"";
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    [self setSubViewLayout];
    //    [self notificationRecieve];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
    //------------通知创建放在视图显示的时候------------------
    [self notificationRecieve];
    //---------------------------------------------------
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)dealloc{
    NSLog(@"对象已经被释放~~~~~");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)createUI{
    __block ZDHSearchViewController *selfVC = self;
    self.view.backgroundColor = WHITE;
    //左边视图
    _leftView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _leftView.backgroundColor = LIGHTGRAY;
    _leftView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive;
    _leftView.delegate = self;
    _leftView.dataSource = self;
    _leftView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftView registerClass:[ZDHLeftViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_leftView];
    //热门搜索下拉刷新
    _leftView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfVC getHotData];
    }];
    [_leftView.header beginRefreshing];
    //右边视图
    _rightView = [[ZDHSearchRightView alloc] init];
    _rightView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:_rightView];
    //搜索列表下拉刷新
    _rightView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfVC getListData];
    }];
    [_rightView.header beginRefreshing];
    
    [super createSuperUI];
}
- (void)setSubViewLayout{
    [super setSuperSubViewLayout];
    //左边视图
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAV_HEIGHT));
        make.left.equalTo(0);
        make.bottom.equalTo(0);
        make.width.mas_equalTo(350);
    }];
    //右边视图
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAV_HEIGHT+20);
        make.left.equalTo(_leftView.mas_right);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
}
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationProductListModel];
    [self.currNavigationController setDetailTitleLabelWithString:@"搜索"];
}
#pragma mark - Event response
//接收通知
- (void)notificationRecieve{
    //监视右视图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHSearchRightView" object:nil];
    //监视选择品牌
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"品牌" object:nil];
    //监视选择商品
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"商品" object:nil];
    //监视选择空间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"空间" object:nil];
    //监视选择风格
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"风格" object:nil];
    //监视关键字输入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"关键字" object:nil];
}
//通知反馈
- (void)notificationResponse:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"ZDHSearchRightView"]) {
       
        [self switchToNextController];
    }else if([notification.name isEqualToString:@"品牌"]){
        NSInteger index = [[notification.userInfo valueForKey:@"index"] integerValue];
        //获取成功
        ZDHSearchViewControllerListNewsSearchModel *searchModel = _vcViewModel.dataListArray[0];
        ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = searchModel.search_t[index];
        if ([_brand isEqualToString:tModel.tytypeid]) {
            _brand = @"";
        }else{
            _brand = tModel.tytypeid;
        }
        [_selectedArray replaceObjectAtIndex:0 withObject:_brand];
    }else if([notification.name isEqualToString:@"商品"]){
        NSString *titleName = [notification.userInfo valueForKey:@"titleName"];
        //获取成功
        [_vcViewModel transfromProductTypeWithTypeString:titleName];
        _type = _vcViewModel.dataProdutIDString;
    }else if([notification.name isEqualToString:@"空间"]){
        NSInteger index = [[notification.userInfo valueForKey:@"index"] integerValue];
        //获取成功
        ZDHSearchViewControllerListNewsSearchModel *searchModel = _vcViewModel.dataListArray[2];
        ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = searchModel.search_t[index];
        if ([_space isEqualToString:tModel.tytypeid]) {
            _space = @"";
        }else{
            _space = tModel.tytypeid;
        }
        [_selectedArray replaceObjectAtIndex:1 withObject:_space];
    }else if([notification.name isEqualToString:@"风格"]){
        NSInteger index = [[notification.userInfo valueForKey:@"index"] integerValue];
        //获取成功
        ZDHSearchViewControllerListNewsSearchModel *searchModel = _vcViewModel.dataListArray[3];
        ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = searchModel.search_t[index];
        if ([_style isEqualToString:tModel.tytypeid]) {
            _style = @"";
        }else{
            _style = tModel.tytypeid;
        }
        
        [_selectedArray replaceObjectAtIndex:2 withObject:_style];
    }else if ([notification.name isEqualToString:@"关键字"]){
        
        _keyword = [notification.userInfo valueForKey:@"keyword"];
        
        ZDHProductListViewController *listVC = [[ZDHProductListViewController alloc] init];
        listVC.currNavigationController = self.currNavigationController;
        listVC.appDelegate = self.appDelegate;
        listVC.keyword = _keyword;
        listVC.brand = @"";
        listVC.type = @"";
        listVC.space = @"";
        listVC.style = @"";
        listVC.productArray = [[NSMutableArray alloc]initWithArray:_vcViewModel.dataProdutArray];
        listVC.goodsArray = [[NSMutableArray alloc]initWithArray:_vcViewModel.dataListArray];
        listVC.selectedIdArray = [[NSMutableArray alloc]initWithArray:_selectedArray];
        [self.currNavigationController pushViewController:listVC animated:YES];
//        NSLog(@"000000---->%@",_keyword);
    }

}


- (void) switchToNextController{
    
    ZDHProductListViewController *listVC = [[ZDHProductListViewController alloc] init];
    listVC.currNavigationController = self.currNavigationController;
    listVC.keyword = @"";
    listVC.brand = _brand;
    listVC.type = _type;
    listVC.space = _space;
    listVC.style = _style;
    listVC.appDelegate = self.appDelegate;
    listVC.productArray = [[NSMutableArray alloc]initWithArray:_vcViewModel.dataProdutArray];
    listVC.goodsArray = [[NSMutableArray alloc]initWithArray:_vcViewModel.dataListArray];
    listVC.selectedIdArray = [[NSMutableArray alloc]initWithArray:_selectedArray];
    
    for (ZDHSearchViewControllerNewListProtypelistModel *listModel  in _vcViewModel.dataProdutArray) {
        
        for (ZDHSearchViewControllerNewListProtypelistChindtypeModel *protypeModel in listModel.chindtype) {
            
            if ([self.type isEqualToString:protypeModel.typeid_conflict]) {
                
                listVC.leftButtonTitle = protypeModel.typename_conflict;
            }
        }
    }
    [self.currNavigationController pushViewController:listVC animated:YES];
    
}
#pragma mark - Network request
//获取搜索列表信息
- (void)getListData{
    __block ZDHSearchViewController *selfVC = self;
    __block ZDHSearchViewControllerViewModel *selfViewModel = _vcViewModel;
    //获取产品分类
    [_vcViewModel getSearchListSuccess:^(NSMutableArray *resultArray) {
        //获取商品分类
        [selfViewModel getSearchPruductCategorySuccess:^(NSMutableArray *resultArray) {
            //获取成功
            for (int i = 0; i < selfViewModel.dataListArray.count; i ++) {
                ZDHSearchViewControllerListNewsSearchModel *searchModel = selfViewModel.dataListArray[i];
                NSMutableArray *dataArray = [NSMutableArray array];
                for (ZDHSearchViewControllerListNewsSearchSearchTModel *tModel in searchModel.search_t) {
                    [dataArray addObject:tModel.title];
                }
                switch (i) {
                    case 0:
                        selfVC.rightView.firstArray = dataArray;
                        break;
                    case 1:
                        selfVC.rightView.secondArray = dataArray;
                        break;
                    case 2:
                        selfVC.rightView.thirdArray = dataArray;
            
                        break;
                    case 3:
                        selfVC.rightView.fourthArray = dataArray;
                    
                        break;
                    default:
                        break;
                }
            }
            [selfVC.rightView reloadScrollView];
            //获取成功
            [selfVC.rightView reloadProductWithArray:selfViewModel.dataProdutArray];
            
            [selfVC.rightView.header endRefreshing];
        } fail:^(NSError *error) {
            //获取失败
            [selfVC.rightView.header endRefreshing];
        }];
    } fail:^(NSError *error) {
        //获取失败
        [selfVC.rightView.header endRefreshing];
    }];
}
//获取热门搜索
- (void)getHotData{
    
    __block ZDHSearchViewController *selfVC = self;
    [_vcViewModel getHotWordSuccess:^(NSMutableArray *resultArray) {
        //获取成功
        [selfVC.leftView reloadData];
        [selfVC.leftView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        [selfVC.leftView reloadData];
        [selfVC.leftView.header endRefreshing];
    }];
}
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_vcViewModel.dataHotArray.count > 0) {
        return _vcViewModel.dataHotArray.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDHLeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (_vcViewModel.dataHotArray.count > 0) {
        //加载数据
        ZDHSearchViewControllerHotWordHotsearchWordModel *hotModel = _vcViewModel.dataHotArray[indexPath.row];
        [cell reloadCell:hotModel.word];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 156/2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//UITableViewDelegate Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //背景
    UIView *backView = [[UIView alloc] init];
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:200/256.0 green:200/256.0 blue:200/256.0 alpha:1];
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-1);
        make.left.and.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    //热门搜索
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:25];
    nameLabel.backgroundColor = LIGHTGRAY;
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-20);
        make.left.equalTo(20);
        make.right.equalTo(-20);
        make.height.equalTo(50);
    }];
    nameLabel.text = @"热门搜索";
    return backView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDHSearchViewControllerHotWordHotsearchWordModel *wordModel = _vcViewModel.dataHotArray[indexPath.row];
    ZDHProductListViewController *listVC = [[ZDHProductListViewController alloc] init];
    listVC.currNavigationController = self.currNavigationController;
    NSArray *dataArray = [wordModel.word componentsSeparatedByString:@" "];
    _keyword = [dataArray lastObject];
    listVC.keyword = _keyword;
    listVC.brand = @"";
    listVC.type = @"";
    listVC.space = @"";
    listVC.style = @"";
    listVC.appDelegate = self.appDelegate;
    [self.currNavigationController pushViewController:listVC animated:YES];
}
//-------------添加手势回收键盘 -----------
#pragma mark  pack up keyboard

#pragma mark - Other methods

@end
