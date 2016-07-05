//
//  ZDHHomePageViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

//Controller
#import "ZDHHomePageViewController.h"
#import "ZDHProductDetailViewController.h"
#import "ZDHOrderViewController.h"
#import "ZDHGroupViewController.h"
#import "ZDHDIYListViewController.h"
#import "ZDHDIYDetailViewController.h"
#import "ZDHBrandViewController.h"
#import "ZDHNewsViewController.h"
#import "ZDHProductListViewController.h"
#import "ZDHHomepageAdvertismentController.h"
// 布的详情
#import "ZDHClothDetailViewController.h"
//临时
#import "ZDHUser.h"
// push的界面
#import "ZDHProductCenterViewController.h"
#import "ZDHUserViewController.h"
#import "ZDHConfigViewController.h"
// 二维码扫描
#import "TTCScanViewController.h"

//View
#import "ZDHHomePageHeaderViewCell.h"
#import "ZDHHomePageSectionHeaderView.h"
#import "ZDHHomePageDIYCell.h"
#import "ZDHHomePageHotSellCell.h"
#import "ZDHHomePageNewsCell.h"
#import "ZDHHomePageOrderCell.h"
#import "ZDHHomePageGroupCell.h"
//ViewModel
#import "ZDHHomePageViewControllerViewModel.h"
//Lib
#import "Masonry.h"

//Macro
#define kHeaderViewCellHeight 328
#define kSectionNum 6
#define kDIYCellHeight 242
#define kHotSellCellHeight 500
#define kNewsCellHeight 160
//Macros
#define kRightButtonTag 2000
#define kButtonWidth 64

@interface ZDHHomePageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSString *groupID;
@property (strong, nonatomic) UITableView *homePageTabelView;
@property (assign, nonatomic) BOOL isLoaded;
@property (strong, nonatomic) NSArray *headerNameArray;
@property (strong, nonatomic) ZDHHomePageViewControllerViewModel *vcViewModel;
//临时使用的数据
@property (strong, nonatomic) NSMutableArray *headerViewDataArray;
//换一换
@property (strong, nonatomic) NSMutableArray *changedataHotIDArray;

// 扫描获取到的布的id
@property(copy, nonatomic) NSString *clothId;
// 获取布以后，确认是否是登录
@property(assign, nonatomic) BOOL isThisControllerLog;
//临时
@property (strong, nonatomic) ZDHUser *user;
@end

@implementation ZDHHomePageViewController

#pragma mark - Init methods
//- (NSMutableArray*)changedataHotIDArray{
//    if (!_changedataHotIDArray) {
//        _changedataHotIDArray = [NSMutableArray array];
//    }
//    return _changedataHotIDArray;
//}

- (void)initData{
    //Cell Header
    _headerViewDataArray = [NSMutableArray array];
    //临时
    _user = [ZDHUser getCurrUser];
    _isThisControllerLog = NO;
    for (int i = 0; i < 4; i ++) {
        UIImage *im = [UIImage imageNamed:@"tmp_header"];
        [_headerViewDataArray addObject:im];
    }
    _headerNameArray = @[@"热门DIY场景",@"家具配套流程",@"",@"热门产品",@""];
    //vcViewModel
    _vcViewModel = [[ZDHHomePageViewControllerViewModel alloc] init];
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self createUI];
    [self setSubViewsLayout];
    [self notificationRecieve];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationController];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Getters and setters
- (void)setNavigationController{
    [self setTabBar];
//    [self.currNavigationController setNavigationBarMode:kNavigationBarNormalMode];
}
- (void)setTabBar{
    [self.currNavigationController showNavigationBar];
    [self.appDelegate.tabBarVC hideTabBar];
}
- (void)createUI{
    _groupID = @"";
    _isLoaded = NO;
    __block ZDHHomePageViewController *selfVC = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //TableView
    _homePageTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _homePageTabelView.delegate = self;
    _homePageTabelView.dataSource = self;
    _homePageTabelView.backgroundColor = WHITE;
    _homePageTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_homePageTabelView registerClass:[ZDHHomePageHeaderViewCell class] forCellReuseIdentifier:@"HeaderCell"];
    [_homePageTabelView registerClass:[ZDHHomePageDIYCell class] forCellReuseIdentifier:@"DIYCell"];
    [_homePageTabelView registerClass:[ZDHHomePageOrderCell class] forCellReuseIdentifier:@"OrderCell"];
    [_homePageTabelView registerClass:[ZDHHomePageHotSellCell class] forCellReuseIdentifier:@"HotSellCell"];
    [_homePageTabelView registerClass:[ZDHHomePageNewsCell class] forCellReuseIdentifier:@"NewsCell"];
    [_homePageTabelView registerClass:[ZDHHomePageGroupCell class] forCellReuseIdentifier:@"GroupCell"];
    [_homePageTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_homePageTabelView];
    //下拉刷新
    _homePageTabelView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfVC getData];
    }];
    [_homePageTabelView.header beginRefreshing];
    [super createSuperUI];
}
- (void)setSubViewsLayout{
    [super setSuperSubViewLayout];
    //TableView
    [_homePageTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAV_HEIGHT+STA_HEIGHT));
        make.bottom.equalTo(@0);
        make.width.equalTo(@SCREEN_MAX_WIDTH);
    }];
}
#pragma mark - Event response
//换一批
- (void)changeProductButtonPressed{
    __block ZDHHomePageHotSellCell *hotCell = (ZDHHomePageHotSellCell *)[_homePageTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    [hotCell startLoading];
    _groupID = _vcViewModel.groupID;
    //获取热门产品
    __block ZDHHomePageViewController *selfVC = self;
    __block ZDHHomePageViewControllerViewModel *SelfvcViewModel = _vcViewModel;
    [_vcViewModel getHotDataWithGroupID:_groupID success:^(NSMutableArray *resultArray) {
        //获取成功
        [hotCell stopLoading];
        _changedataHotIDArray = SelfvcViewModel.dataHotIDArray;
        [selfVC.homePageTabelView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:4]] withRowAnimation:UITableViewRowAnimationFade];
    } fail:^(NSError *error) {
        //获取失败
        [hotCell stopLoading];
        [selfVC.homePageTabelView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:4]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}
//接收通知
- (void)notificationRecieve{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"ZDHHomePageDIYCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"ZDHHomePageHotSellCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"ZDHHomePageOrderCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"ZDHHomePageGroupCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"ZDHHomePageNewsCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"ZDHHomePageSectionHeaderViewDIY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"ZDHHomePageSectionHeaderViewProduct" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"TwoDimensionCode" object:nil];
    //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"LoginSuccess" object:nil];
    // 点击广告AdvertismentClick
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"AdvertismentClick" object:nil];
}
//通知反馈
- (void)notificationAction:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"AdvertismentClick"]) {
        
        NSInteger index = [[notification.userInfo valueForKey:@"index"] integerValue];
        if (_vcViewModel.dataHearScrollUrlArray.count == _vcViewModel.dataHearScrollImageArray.count) {
        
            NSString *urlString = _vcViewModel.dataHearScrollUrlArray[index];
            NSUInteger len = urlString.length;
            if (len > 7) {
            
                ZDHHomepageAdvertismentController *advertismentController = [[ZDHHomepageAdvertismentController alloc]init];
                advertismentController.currNavigationController = self.currNavigationController;
                advertismentController.webViewUrl = _vcViewModel.dataHearScrollUrlArray[index];
                [self.currNavigationController pushViewController:advertismentController animated:YES];
            }
        }
    }else if([notification.name isEqualToString:@"ZDHHomePageHotSellCell"]) {
        int index = [[notification.userInfo valueForKey:@"selectedIndex"] intValue]-1;
        //热销产品
        if (index <_vcViewModel.dataHotIDArray.count ) {//_changedataHotIDArray_vcViewModel.dataHotIDArray.count
            ZDHProductDetailViewController *detailVC = [[ZDHProductDetailViewController alloc] init];
            detailVC.currNavigationController = self.currNavigationController;
            detailVC.appDelegate = self.appDelegate;
            detailVC.pid = _changedataHotIDArray[index];
            detailVC.pid = _vcViewModel.dataHotIDArray[index];

            [self.currNavigationController pushViewController:detailVC animated:YES];
        }
    }else if([notification.name isEqualToString:@"ZDHHomePageOrderCell"]){
        //家具配套流程
        ZDHOrderViewController *orderVC = [[ZDHOrderViewController alloc] init];
        orderVC.currNavigationController = self.currNavigationController;
        orderVC.appDelegate = self.appDelegate;
        [self.currNavigationController pushViewController:orderVC animated:YES];
    }else if([notification.name isEqualToString:@"ZDHHomePageGroupCell"]){
        //设计团队
        ZDHGroupViewController *groupVC = [[ZDHGroupViewController alloc] init];
        groupVC.currNavigationController = self.currNavigationController;
        groupVC.appDelegate = self.appDelegate;
        [self.currNavigationController pushViewController:groupVC animated:YES];
    }else if([notification.name isEqualToString:@"ZDHHomePageDIYCell"]){
        //DIY
        int selectedIndex = [[notification.userInfo valueForKey:@"selectedIndex"] intValue];
        
        NSString *ID = _vcViewModel.dataDIYIDArray[selectedIndex];
        ZDHDIYDetailViewController *detailVC = [[ZDHDIYDetailViewController alloc] init];
        detailVC.currNavigationController = self.currNavigationController;
        detailVC.appDelegate = self.appDelegate;
        detailVC.ID = ID;
        detailVC.DIYNaviTitle = _vcViewModel.dataDIYNameArray[selectedIndex];
        [self.currNavigationController pushViewController:detailVC animated:YES];
    }else if([notification.name isEqualToString:@"ZDHHomePageNewsCell"]){
        int selectedIndex = [[notification.userInfo valueForKey:@"selectedIndex"] intValue];
        if (selectedIndex == 0) {
            //公司资讯
            ZDHNewsViewController *newsVC = [[ZDHNewsViewController alloc] init];
            newsVC.currNavigationController = self.currNavigationController;
            newsVC.appDelegate = self.appDelegate;
            [self.currNavigationController pushViewController:newsVC animated:YES];
        }else{
            //品牌实力
            ZDHBrandViewController *brandVC = [[ZDHBrandViewController alloc] init];
            brandVC.currNavigationController = self.currNavigationController;
            brandVC.appDelegate = self.appDelegate;
            [self.currNavigationController pushViewController:brandVC animated:YES];
        }
    }else if([notification.name isEqualToString:@"ZDHHomePageSectionHeaderViewDIY"]){
        //查看更多
        ZDHDIYListViewController *listVC = [[ZDHDIYListViewController alloc] init];
        listVC.currNavigationController = self.currNavigationController;
        listVC.appDelegate = self.appDelegate;
        [self.currNavigationController pushViewController:listVC animated:YES];
    }else if([notification.name isEqualToString:@"ZDHHomePageSectionHeaderViewProduct"]){
        //换一换
        [self changeProductButtonPressed];
    }
    // 二维码扫描
    else if([notification.name isEqualToString:@"TwoDimensionCode"]){
        [self.appDelegate.tabBarVC hideTabBar];
        TTCScanViewController *scan = [[TTCScanViewController alloc]init];
        [self presentViewController:scan animated:YES completion:nil];
        __block ZDHHomePageViewController *selfVC = self;
        scan.SYQRCodeSuncessBlock  = ^(NSString *IDString,NSString *classifyId){
            
            if ([classifyId isEqualToString:@"clothid"]) {
                
                selfVC.clothId = IDString;
                NSString *islog = [selfVC.user.logStatus valueForKey:@"isLogin"];
                if ([islog isEqualToString:@"NO"]||islog ==nil) {
                    
                    selfVC.isThisControllerLog = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginRequest" object:self userInfo:nil];
                    
                }else{
                    
                    ZDHUserViewController *userViewController = nil;
                    BOOL isFirstClass = NO;
                    NSMutableArray *vcsArray =  [NSMutableArray arrayWithArray:selfVC.navigationController.viewControllers];
                    for (NSInteger i = 0; i < vcsArray.count; i ++) {
                        
                        if ([vcsArray[i] isKindOfClass:[ZDHUserViewController class]]) {
                            userViewController = vcsArray[i];
                            isFirstClass = YES;
                        }
                    }
                    if (userViewController != nil) {
                        
                        if (![[vcsArray lastObject] isKindOfClass:[ZDHUserViewController class]]) {
                            
                            [userViewController.navigationController popToViewController:userViewController animated:YES];
                        }
                    }else{
                        
                        userViewController = [[ZDHUserViewController alloc]init];
                        userViewController.currNavigationController = selfVC.currNavigationController;
                        [selfVC.currNavigationController pushViewController:userViewController animated:YES];
                    }
                    
                    ZDHClothDetailViewController *clothDetailController = [[ZDHClothDetailViewController alloc]init];
                    clothDetailController.currNavigationController = selfVC.currNavigationController;
                    clothDetailController.cid = @"";
                    clothDetailController.clothid = self.clothId;
                    [userViewController.currNavigationController pushViewController:clothDetailController animated:YES];
                }
            }else{
                
                ZDHProductDetailViewController *detailVC = [[ZDHProductDetailViewController alloc] init];
                detailVC.currNavigationController = selfVC.currNavigationController;
                detailVC.pid = IDString;
                detailVC.appDelegate = selfVC.appDelegate;
                [selfVC.currNavigationController pushViewController:detailVC animated:YES];
            }
        };
    }
//     登录成功后
    else if ([notification.name isEqualToString:@"LoginSuccess"]){
        
        if (_isThisControllerLog) {
            _isThisControllerLog = NO;
            
            ZDHUserViewController *userViewController = nil;
            BOOL isFirstClass = NO;
            NSMutableArray *vcsArray =  [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            for (NSInteger i = 0; i < vcsArray.count; i ++) {
                
                if ([vcsArray[i] isKindOfClass:[ZDHUserViewController class]]) {
                    userViewController = vcsArray[i];
                    isFirstClass = YES;
                }
            }
            if (userViewController != nil) {
                
                if (![[vcsArray lastObject] isKindOfClass:[ZDHUserViewController class]]) {
                    
                    [userViewController.navigationController popToViewController:userViewController animated:YES];
                }
            }else{
                
                userViewController = [[ZDHUserViewController alloc]init];
                userViewController.currNavigationController = self.currNavigationController;
                [self.currNavigationController pushViewController:userViewController animated:YES];
            }
            
            ZDHClothDetailViewController *clothDetailController = [[ZDHClothDetailViewController alloc]init];
            clothDetailController.currNavigationController = self.currNavigationController;
            clothDetailController.cid = @"";
            clothDetailController.clothid = self.clothId;
            [userViewController.currNavigationController pushViewController:clothDetailController animated:YES];
        }
    }
}
#pragma mark - Network request
//获取数据
- (void)getData{
    _groupID = @"";
    __block ZDHHomePageViewController *selfVC = self;
    __block BOOL isDIY = NO;
    __block BOOL isDesigner = NO;
    __block BOOL isHot = NO;
    //获取DIY信息
    [_vcViewModel getDIYDataSuccess:^(NSMutableArray *resultArray) {
        isDIY = YES;
        if (isDIY && isDesigner && isHot) {
            //获取成功
            selfVC.isLoaded = YES;
            [selfVC.homePageTabelView.header endRefreshing];
            [selfVC.homePageTabelView reloadData];
        }
    } fail:^(NSError *error) {
        isDIY = YES;
        if (isDIY && isDesigner && isHot) {
            //获取失败
            selfVC.isLoaded = YES;
            [selfVC.homePageTabelView.header endRefreshing];
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络开小差了哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alView show];
        }
    }];
    //获取设计师信息
    [_vcViewModel getDesignerDataSuccess:^(NSMutableArray *resultArray) {
        isDesigner = YES;
        if (isDIY && isDesigner && isHot) {
            //获取成功
            selfVC.isLoaded = YES;
            [selfVC.homePageTabelView.header endRefreshing];
            [selfVC.homePageTabelView reloadData];
        }
    } fail:^(NSError *error) {
        isDesigner = YES;
        if (isDIY && isDesigner && isHot) {
            //获取失败
            selfVC.isLoaded = YES;
            [selfVC.homePageTabelView.header endRefreshing];
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络开小差了哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alView show];
        }
    }];
    __block ZDHHomePageViewControllerViewModel *SelfvcViewModel = _vcViewModel;

    //获取热门产品
    [_vcViewModel getHotDataWithGroupID:_groupID success:^(NSMutableArray *resultArray) {
        isHot = YES;
        if (isDIY && isDesigner && isHot) {
            //获取成功
            selfVC.isLoaded = YES;
            [selfVC.homePageTabelView.header endRefreshing];
            [selfVC.homePageTabelView reloadData];
            
            _changedataHotIDArray = SelfvcViewModel.dataHotIDArray;
        }
    } fail:^(NSError *error) {
        isHot = YES;
        if (isDIY && isDesigner && isHot) {
            //获取失败
            selfVC.isLoaded = YES;
            [selfVC.homePageTabelView.header endRefreshing];
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络开小差了哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alView show];
        }
    }];
    //获取头部滚动广告视图
    [_vcViewModel getHearScrollImageDataSuccess:^(NSMutableArray *resultArray) {
        [selfVC.homePageTabelView.header endRefreshing];
        [selfVC.homePageTabelView reloadData];
        
    } fail:^(NSError *error) {
        [selfVC.homePageTabelView.header endRefreshing];
        [selfVC.homePageTabelView reloadData];
    }];
}
#pragma mark - Protocol methods
//TableView Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isLoaded) {
        return kSectionNum;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell;
    switch (indexPath.section) {
        case 0:{
            //Banner
            ZDHHomePageHeaderViewCell *HeaderCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
            if (_vcViewModel.dataHearScrollImageArray.count > 0) {
                [HeaderCell reloadCellWithArray:_vcViewModel.dataHearScrollImageArray];
            }
            returnCell = HeaderCell;
        }
            break;
        case 1:{
            //DIY
            ZDHHomePageDIYCell *DIYCell = [tableView dequeueReusableCellWithIdentifier:@"DIYCell"];
            if (_vcViewModel.dataDIYImageArray.count > 0) {
                //加载DIY信息
                [DIYCell reloadFabricsViewWithArray:_vcViewModel.dataDIYImageArray];
            }
            returnCell = DIYCell;
        }
            break;
        case 2:{
            ZDHHomePageOrderCell *OrderCell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
            returnCell = OrderCell;
        }
            break;
        case 3:{
            //设计团队
            ZDHHomePageGroupCell *GroupCell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
            if (_vcViewModel.dataDesignerImageArray.count > 0) {
                //加载设计师信息
                [GroupCell reloadImageWithImageArray:_vcViewModel.dataDesignerImageArray];
                [GroupCell reloadNameWithNameArray:_vcViewModel.dataDesignerNameArray introArray:_vcViewModel.dataDesignerIntroArray];
            }
            returnCell = GroupCell;
        }
            break;
        case 4:{
            //热门产品
            ZDHHomePageHotSellCell *HotSellCell = [tableView dequeueReusableCellWithIdentifier:@"HotSellCell"];
            if (_vcViewModel.dataHotImageArray.count > 0) {
                //加载数据
                [HotSellCell reloadImageView:_vcViewModel.dataHotImageArray];
                [HotSellCell reloadTitle:_vcViewModel.dataHotTitleArray desc:_vcViewModel.dataHotDescArray];
            }
            returnCell = HotSellCell;
        }
            break;
        case 5:{
            ZDHHomePageNewsCell *NewsCell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
            returnCell = NewsCell;
        }
            break;
        default:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            returnCell = cell;
        }
            break;
    }
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCell;
}
//TableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:
        case 2:{
            return 80;
        }
            break;
        case 3:{
            return 60;
        }
            break;
        case 4:{
            return 80;
        }
            break;
        case 5:{
            return 60;
        }
        default:{
            return 0;
        }
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 5) {
        return 4;
    }else{
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return kHeaderViewCellHeight;
        }
            break;
        case 1:{
            return [UIImage imageNamed:@"home_img_secen"].size.height;
        }
            break;
        case 2:{
            return ([UIImage imageNamed:@"home_img_order"].size.height+20);
        }
            break;
        case 3:{
            return [UIImage imageNamed:@"home_img_design"].size.height;
        }
            break;
        case 4:{
            return [UIImage imageNamed:@"home_img_product"].size.height;
        }
            break;
        case 5:{
            return [UIImage imageNamed:@"home_news"].size.height;
        }
            break;
        default:{
            return 0;
        }
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZDHHomePageSectionHeaderView *sectionHeaderView = [[ZDHHomePageSectionHeaderView alloc] init];
    if (_headerNameArray.count > 0 && section > 0) {
        //标题头部
        [sectionHeaderView reloadSectionHeaderViewWithName:_headerNameArray[section-1]];
        //空白头部
        UIView *spaceView = [[UIView alloc] init];
        //选择头部
        switch (section) {
            case 0:{
                return spaceView;
            }
                break;
            case 1:{
                [sectionHeaderView selectHeaderViewType:kDIYViewType];
                return sectionHeaderView;
            }
                break;
            case 2:{
                [sectionHeaderView selectHeaderViewType:kOtherViewType];
                return sectionHeaderView;
            }
                break;
            case 3:{
                return spaceView;
            }
                break;
            case 4:{
                [sectionHeaderView selectHeaderViewType:kProductViewType];
                return sectionHeaderView;
            }
                break;
            case 5:{
                return spaceView;
            }
                break;
            default:
                break;
        }
    }
    return sectionHeaderView;
}
#pragma mark - Other methods


@end
