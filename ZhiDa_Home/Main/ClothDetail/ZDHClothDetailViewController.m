//
//  ZDHClothDetailViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controller
#import "ZDHClothDetailViewController.h"
#import "ZDHUserViewController.h"
#import "ZDHProductListViewController.h"
//Lib
#import "Masonry.h"
#import "MBProgressHUD.h"
//ViewModel
#import "ZDHClothDetailViewControllerViewModel.h"
//View
#import "ZDHClothesTopView.h"
#import "ZDHProductCommonBigImageView.h"
#import "ZDHClothDetailHeaderCell.h"
#import "ZDHClothDetailRecommendCell.h"
#import "ZDHClothDetailTypeCell.h"
//add
#import "ZDHClothDetailLeftBigImageView.h"
//Model
#import "ZDHClothDetailViewControllerClothModel.h"
//Macro
#define kTopScrollViewHeight 50
#define kRightTableViewWidht 365
#define kHeaderViewHeight 44
#define kDescCellHeight 133
#define kTypeCellHeight 310
#define kRecommendCellHeight 270
@interface ZDHClothDetailViewController()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) ZDHClothesTopView *topView;
@property (strong, nonatomic) ZDHClothDetailLeftBigImageView *bigImageView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ZDHClothDetailViewControllerViewModel *vcViewModel;
@property (strong, nonatomic) UIView *waitBackView;
@property (strong, nonatomic) MBProgressHUD *progressHud;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) ZDHClothDetailViewControllerClothModel *clothModel;
@end
@implementation ZDHClothDetailViewController
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHClothDetailViewControllerViewModel alloc] init];
}
- (instancetype)init{
    if (self = [super init]) {
        
        [self initData];
    }
    return self;
}
#pragma mark - Life circle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self createUI];
    [self setSubViewLayout];
    [self notificationRecieve];
    [self addObserver];
    [self startDownload];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
    //------------视图返回的时候重新设置显示模式------------------------
    if (_bigImageView) {
        [_bigImageView reloadImageContentModeScaleAspectFit];
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_topView removeObserver:self forKeyPath:@"selectedIndex"];
}
#pragma mark - Getters and setters
- (void)createUI{
    self.view.backgroundColor = WHITE;
    //顶部滚动条
    _topView = [[ZDHClothesTopView alloc] init];
    if (_titleArray.count > 0) {

        [_topView reloadScrollViewWithArray:_titleArray];
    }
    [self.view addSubview:_topView];
    //大图
    _bigImageView = [[ZDHClothDetailLeftBigImageView alloc] init];

    _bigImageView.clipsToBounds = YES;
    _bigImageView.layer.borderWidth = 1;
    _bigImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _bigImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bigImageView];
    
    //右边TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _tableView.backgroundColor = WHITE;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[ZDHClothDetailHeaderCell class] forCellReuseIdentifier:@"HeaderCell"];
    [_tableView registerClass:[ZDHClothDetailTypeCell class] forCellReuseIdentifier:@"TypeCell"];
    [_tableView registerClass:[ZDHClothDetailRecommendCell class] forCellReuseIdentifier:@"RecommendCell"];
    [self.view addSubview:_tableView];
    [super createSuperUI];
    //等待下载
    _waitBackView = [[UIView alloc] init];
    _waitBackView.backgroundColor = WHITE;
    [self.view addSubview:_waitBackView];
    //等待下载
    _progressHud = [[MBProgressHUD alloc] initWithView:_waitBackView];
    [_waitBackView addSubview:_progressHud];
    //转换等待
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.hidden = YES;
    [_bigImageView addSubview:_indicatorView];
}
- (void)setSubViewLayout{
    [super setSuperSubViewLayout];
    //顶部滚动条
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(STA_HEIGHT+NAV_HEIGHT);
        make.left.right.equalTo(0);
        make.height.equalTo(50);
    }];
    //右边TableView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.bottom.equalTo(@0);
        make.width.equalTo(@kRightTableViewWidht);
        make.right.equalTo(@0);
    }];
    //大图
    [_bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(_tableView.mas_left);
        make.bottom.equalTo(@0);
    }];
    //等待下载
    [_waitBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    //等待下载
    [_progressHud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_waitBackView);
    }];
    //转换等待
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_bigImageView.center);
    }];
}
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
}
#pragma mark - Event response
//点击RecommmendCell
- (void)recommmendCellPressed:(NSString *)ID{
    [self changeWait];
    _cid = ID;
    [self getDataWithCID:ID];
}
//接收通知
- (void)notificationRecieve{
    //观察TypeCell
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"ZDHClothDetailTypeCell" object:nil];
    //观察搜索栏(用作回退)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"回退到布料列表" object:nil];
}
//通知反馈
- (void)notificationAction:(NSNotification *)notification{
    //点击TypeCell
    if ([notification.name isEqualToString:@"ZDHClothDetailTypeCell"]) {
        NSString *ID = [notification.userInfo valueForKey:@"selectedIndex"];
        _cid = ID;
        //布料详情
        __block ZDHClothDetailViewControllerViewModel *selfViewModel = _vcViewModel;
        __block ZDHClothDetailViewController *selfVC = self;
        [self changeWait];
        [_vcViewModel getDataWithCID:_cid success:^(NSMutableArray *resultArray) {
            //获取成功
            //刷新大图
            ZDHClothDetailViewControllerClothModel *clothModel = [selfViewModel.dataDetailArray firstObject];
            //            [selfVC.bigImageView reloadCellWithArray:@[clothModel.cloth_img,clothModel.recoilsize_img]];
            if(_vcViewModel.LocalAllImageDict.count>0){
                UIImage *image = (UIImage*)[_vcViewModel.LocalAllImageDict objectForKey:clothModel.id_conflict];
                [selfVC.bigImageView reloadCellLocalWithImage:image];
            }else {
                [selfVC.bigImageView reloadCellWithArray:@[clothModel.cloth_img,clothModel.recoilsize_img]];
            }
            
            [selfVC.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [selfVC stopChangeWait];
        } fail:^(NSError *error) {
            //获取失败
            [selfVC changeWait];
        }];
    }else if([notification.name isEqualToString:@"回退到布料列表"]){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) buttonPress:(UIButton *)btn{
    ZDHClothDetailViewControllerClothModel *clothModel = [_vcViewModel.dataDetailArray firstObject];
    if (clothModel) {
        
        self.clothModel = clothModel;
    }
    ZDHProductListViewController *searchListController = [[ZDHProductListViewController alloc]init];
    searchListController.currNavigationController = self.currNavigationController;
    searchListController.clothTitle = self.clothModel.name;
    searchListController.keyword    = @"";
    searchListController.brand      = @"";
    searchListController.style      = @"";
    searchListController.space      = @"";
    searchListController.type       = @"";
    searchListController.order      = @"";
    [self.currNavigationController pushViewController:searchListController animated:YES];
}
//添加观察者
- (void)addObserver{
    //观察头部
    [_topView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == _topView) {
        //观察头部
        [self.currNavigationController popToRootViewControllerAnimated:YES];
        NSArray *vcArray = [self.currNavigationController viewControllers];
        ZDHUserViewController *lastVC = (ZDHUserViewController *)vcArray[0];
        lastVC.topViewIndex = (int)[[change valueForKey:@"new"] intValue];
    }
}
#pragma mark - Network request
//获取数据
- (void)getData{
    __block ZDHClothDetailViewController *selfVC = self;
        //首页布料列表详情
        [_vcViewModel getFirstPageDataWithCID:_cid  withTitleName:_titileName success:^(NSMutableArray *resultArray) {
            //获取成功
            //默认获取第一个布料详情
            [selfVC getDataWithCID:_clothid];
            //刷新
            [selfVC.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        } fail:^(NSError *error) {
            //获取失败
            [selfVC stopDownload];
            [selfVC.tableView reloadData];
        }];
}
//根据CID获取布料详情
- (void)getDataWithCID:(NSString *)CID{
    __block ZDHClothDetailViewControllerViewModel *selfViewModel = _vcViewModel;
    __block ZDHClothDetailViewController *selfVC = self;
    //布料详情
    [_vcViewModel getDataWithCID:CID success:^(NSMutableArray *resultArray) {
        //获取成功
        //刷新大图
        ZDHClothDetailViewControllerClothModel *clothModel = [selfViewModel.dataDetailArray firstObject];
        if(_vcViewModel.LocalAllImageDict.count>0){
            
            UIImage *image = (UIImage*)[_vcViewModel.LocalAllImageDict objectForKey:clothModel.id_conflict];
            [selfVC.bigImageView reloadCellLocalWithImage:image];
        }else {
            [selfVC.bigImageView reloadCellWithArray:@[clothModel.cloth_img,clothModel.recoilsize_img]];
        }
        
        [selfViewModel getClothUseIconWithClothId:CID success:^(NSMutableArray *array){
            
            [selfVC getClothIntroducWithId:CID];
        } fail:^(NSError *error){
        
            [selfVC getClothIntroducWithId:CID];
        }];
    } fail:^(NSError *error) {
        //获取失败
        [selfVC stopDownload];
        [selfVC.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
// 获取布的说明介绍
- (void) getClothIntroducWithId:(NSString *)clothId{
    
    //获取相关布料列表
//    __block ZDHClothDetailViewControllerViewModel *selfViewModel = _vcViewModel;
    __block ZDHClothDetailViewController *selfVC = self;
    [_vcViewModel getAboutClothWithCID:clothId success:^(NSMutableArray *resultArray) {
                //获取成功
        [selfVC stopDownload];
        [selfVC stopChangeWait];
                //刷新
        [selfVC.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
     } fail:^(NSError *error) {
        //获取失败
        //刷新
        [selfVC stopDownload];
        [selfVC stopChangeWait];
        [selfVC.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell;
    ZDHClothDetailViewControllerClothModel *clothModel = [_vcViewModel.dataDetailArray firstObject];
    [_topView topViewShowClothTitleModel];
   
    switch (indexPath.row) {
        case 0:{
             [self.currNavigationController setDetailTitleLabelWithString:clothModel.name];
            //布料名称
            ZDHClothDetailHeaderCell *HeaderCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
            if (clothModel.name.length > 0) {
                [HeaderCell reloadCellWithString:clothModel.name with:@""];
            }
            returnCell = HeaderCell;
        }
            break;
        case 1:{
            // 标题
            ZDHClothDetailTypeCell *typeCell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell"];
            [typeCell reloadDistributeWithLableTitle:clothModel.cloth_bandname?clothModel.cloth_bandname:@" "];
            //add
            //布料详情文字
            [typeCell reloadDescLabelWithArray:@[clothModel.part?clothModel.part:@" ",clothModel.cloth_width?clothModel.cloth_width:@" ",clothModel.cloth_direction?clothModel.cloth_direction:@" ",clothModel.cloth_way?clothModel.cloth_way:@" ",clothModel.cloth_number?clothModel.cloth_number:@" ",clothModel.cloth_status?clothModel.cloth_status:@" ",clothModel.cloth_use?clothModel.cloth_use:@" "]];
            [typeCell reflashClothUseWithArray:_vcViewModel.dataUseIconArray];
            __weak __typeof(self) weakSelf = self;
            typeCell.useIconButton = ^(UIButton *btn){
                
                [weakSelf buttonPress:btn];
            };
            if (_vcViewModel.dataAboutImageArray.count > 0) {
                //相关布料列表
                [typeCell reloadCellImageView:_vcViewModel.dataAboutImageArray idArray:_vcViewModel.dataAboutIDArray selectedID:_cid];
            }
            returnCell = typeCell;
        }
            break;
        case 2:{
            
            ZDHClothDetailRecommendCell *RecommendCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCell"];
            __weak __typeof(self) weakSelf = self;
            RecommendCell.pressedBlock = ^(NSString *string){
                [weakSelf recommmendCellPressed:string];
            };
            //组合与推荐
            if (_vcViewModel.dataFirstPageImageArray.count > 0) {
                //只有首页点击才有
                [RecommendCell reloadCellImageView:_vcViewModel.dataFirstPageImageArray idArray:_vcViewModel.dataFirstPageIDArray selectedID:_cid];
            }
            returnCell = RecommendCell;
        }
            break;
        default:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            returnCell = cell;
        }
            break;
    }
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCell;
}
//UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            return kHeaderViewHeight;
        }
            break;
        case 1:{
            return kTypeCellHeight;
        }
            break;
        case 2:{
            return kRecommendCellHeight;
        }
            break;
        default:{
            return 0;
        }
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
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
//转换等待
- (void)changeWait{
    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];
}
//停止等待
- (void)stopChangeWait{
    _indicatorView.hidden = YES;
    [_indicatorView stopAnimating];
}
@end
