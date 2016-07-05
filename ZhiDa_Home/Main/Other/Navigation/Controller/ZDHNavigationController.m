//
//  ZDHNavigationController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

//Controllers
#import "ZDHNavigationController.h"
#import "ZDHSearchViewController.h"
// 直接跳到搜索界面
#import "ZDHProductListViewController.h"
// view
#import "ZDHNavigationHomePullView.h"
#import "ZDHNavigationClassifyPullView.h"
#import "ZDHNavHomePageView.h"
// model
#import "ZDHSearchViewControllerNewListProtypelistModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeModel.h"
//Libs
#import "Masonry.h"
// 临时
#import "ZDHUser.h"
// 品牌
#import "ZDHProductCenterViewController.h"
// 用户
#import "ZDHUserViewController.h"
// 设置
#import "ZDHConfigViewController.h"
// Appdelegate
#import "AppDelegate.h"

//Macros
#define kRightButtonTag 2000
#define kButtonWidth 64
#define kScanButtonTag 9000
#define  kHomeViewButtonTag 60000


@interface ZDHNavigationController ()<UITextFieldDelegate>
@property (strong, nonatomic) UINavigationItem *item;
// 标题图片
@property (strong, nonatomic) UIImageView *titleView;
@property (strong, nonatomic) UIImageView *searchImageView;
//@property (strong, nonatomic) UITextField *searchTextField;
//@property (strong, nonatomic) UITextField *productTextField;
// 二维码或者条形码扫描按钮
@property (strong, nonatomic) UIButton *scanButton;
@property (strong, nonatomic) UIButton *searchScanButton;
@property (strong, nonatomic) UIImageView *labelImageView;
@property (strong, nonatomic) UIButton *listBackButton;
@property (strong, nonatomic) UILabel *detailTitleLabel;

//tabar部分的内容
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) NSArray *buttonNorName;
@property (strong, nonatomic) NSArray *buttonSelName;
//临时
@property (strong, nonatomic) ZDHUser *user;

// 下拉分类以及下拉返回主页按钮
@property (strong, nonatomic) UIButton *classifyDropDownButton;
@property (strong, nonatomic) UIButton *homeDropDownButton;
// 主页下拉View
@property (strong, nonatomic) ZDHNavigationHomePullView *homePullView;
// 分类下拉界面
@property (strong, nonatomic) ZDHNavigationClassifyPullView *classifyPullView;
@property (strong, nonatomic) AppDelegate *appDelegate;
// 主页导航栏
@property (strong, nonatomic) ZDHNavHomePageView *homepPageView;
// 防止登陆成功两次接收到通知
@property (assign, nonatomic) BOOL isFirst;


@end
@implementation ZDHNavigationController

- (void) initData{
    _user = [ZDHUser getCurrUser];
    _isFirst = NO;
    // 收起分类下拉列表
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
#pragma mark - Init methods
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    
    if (self = [super initWithRootViewController:rootViewController]) {
        [self initData];
        [self notification];
        [self createNavigationBar];
        [self setSubViewLayout];
    }
    return self;
}

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Getters and setters
//自定义NavigationBar
- (void)createNavigationBar{
    
    [self setNavigationBarHidden:YES];
    //NavigationBar
    _bar = [[UINavigationBar alloc] init];
    [_bar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:_bar];
    
    //背景
    UIView *blackView = [[UIView alloc] init];
    blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    [self.view addSubview:blackView];
    
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.width.equalTo(@SCREEN_MAX_WIDTH);
        make.height.equalTo(@STA_HEIGHT);
    }];
    //NavigationItem
    _item = [[UINavigationItem alloc] initWithTitle:nil];
    [_bar pushNavigationItem:_item animated:NO];
    //标题
    _titleView = [[UIImageView alloc] init];
    _titleView.image = [UIImage imageNamed:@"nav_title"];
    _item.titleView = _titleView;
    CGFloat titleWidth = [UIImage imageNamed:@"nav_title"].size.width;
    CGFloat titleHeight = [UIImage imageNamed:@"nav_title"].size.height;
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bar);
        make.width.equalTo(titleWidth);
        make.height.equalTo(titleHeight);
    }];
    
    //放大镜
    UIImage *searchImage = [UIImage imageNamed:@"nav_search"];
    _searchImageView = [[UIImageView alloc] initWithImage:searchImage];
    [_bar addSubview:_searchImageView];
    [_searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(searchImage.size);
        make.centerY.equalTo(_bar.mas_centerY);
        make.left.equalTo(@19);
    }];
    //搜索条
    _searchTextField = [[UITextField alloc] init];
    _searchTextField.backgroundColor = WHITE;
    _searchTextField.placeholder = @"产品查找";
    _searchTextField.delegate = self;
    [_bar addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bar.mas_centerY);
        make.left.equalTo(_searchImageView.mas_right);
        make.height.equalTo(searchImage.size.height);
        make.width.equalTo(154);
    }];
    //产品搜索条
    _productTextField = [[UITextField alloc] init];
    _productTextField.backgroundColor = WHITE;
    _productTextField.placeholder = @"产品查找...";
    _productTextField.delegate = self;
    _productTextField.returnKeyType = UIReturnKeySearch;
    [_bar addSubview:_productTextField];
    [_productTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_bar.mas_centerY);
        make.height.equalTo(searchImage.size.height);
        make.left.equalTo(_searchImageView.mas_right);
        make.width.equalTo(654/2);
    }];
    
    //搜索的二维码
    _searchScanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchScanButton setImage:[UIImage imageNamed:@"nav_scan"] forState:UIControlStateNormal];
    _searchScanButton.tag = kScanButtonTag + 2;
    [_searchScanButton addTarget:self action:@selector(scanTowDimensionCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bar addSubview:_searchScanButton];
    [_searchScanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo([UIImage imageNamed:@"nav_scan"].size);
        make.left.equalTo(_productTextField.mas_right).with.offset(@27);
        make.centerY.equalTo(_bar.mas_centerY);
    }];
    
    //二维码
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanButton.tag = kScanButtonTag + 1;
    [_scanButton setImage:[UIImage imageNamed:@"nav_scan"] forState:UIControlStateNormal];
    [_scanButton addTarget:self action:@selector(scanTowDimensionCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:_scanButton];
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo([UIImage imageNamed:@"nav_scan"].size);
        make.left.equalTo(_searchTextField.mas_right).with.offset(@27);
        make.centerY.equalTo(_bar.mas_centerY);
    }];
    
    //产品列表后退按钮
    _listBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_listBackButton setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    _listBackButton.tag = 5001;
    [_listBackButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:_listBackButton];
    
    // 电子布板返回按钮
    _brandReturnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_brandReturnButton setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    _brandReturnButton.tag = 5002;
    [_brandReturnButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:_brandReturnButton];
    
    //文字标题
    _detailTitleLabel = [[UILabel alloc] init];
    _detailTitleLabel.font = [UIFont systemFontOfSize:30];
    _detailTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_bar addSubview:_detailTitleLabel];
    [_detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bar);
        make.height.equalTo(@40);
        make.width.equalTo(500);
    }];
    
    // 下拉home按钮
    _homeDropDownButton = [[UIButton alloc]init];
    _homeDropDownButton.tag = kScanButtonTag + 3;
    _homeDropDownButton.selected = NO;
    [_homeDropDownButton setTitleColor:[UIColor blackColor] forState:0];
    [_homeDropDownButton addTarget:self action:@selector(dropDownClick:) forControlEvents:UIControlEventTouchUpInside];
    [_homeDropDownButton setImage:[UIImage imageNamed:@"nav_right_pullmenu"] forState:0];
    [_bar addSubview:_homeDropDownButton];
    [_homeDropDownButton mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.right.mas_equalTo(_bar.mas_right).offset(-10);
        make.centerY.equalTo(_bar.mas_centerY);
        make.height.width.mas_equalTo(64);
    }];
    
    // 下拉分类按钮
    _classifyDropDownButton = [[UIButton alloc]init];
    _classifyDropDownButton.tag = kScanButtonTag + 4;
    _classifyDropDownButton.selected = NO;
    [_classifyDropDownButton setImage:[UIImage imageNamed:@"nav_classify_pull"] forState:0];
    [_classifyDropDownButton setTitleColor:[UIColor blackColor] forState:0];
    [_classifyDropDownButton addTarget:self action:@selector(dropDownClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:_classifyDropDownButton];
    [_classifyDropDownButton mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.right.mas_equalTo(_homeDropDownButton.mas_left).offset(-5);
        make.centerY.equalTo(_bar.mas_centerY);
        make.height.width.mas_equalTo(64);
    }];
    
   // 主页下拉View
    _homePullView = [[ZDHNavigationHomePullView alloc]init];
    _homePullView.hidden = YES;
    [self.view addSubview:_homePullView];
    [_homePullView mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.right.equalTo(_bar.mas_right).offset(0);
        make.top.equalTo(_bar.mas_bottom).offset(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44*4);
    }];
    
    // 分类界面的下拉
    _classifyPullView = [[ZDHNavigationClassifyPullView alloc]init];
    [self.view addSubview:_classifyPullView];
    
    [_classifyPullView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(_bar.mas_top).offset(-STA_HEIGHT);
        make.height.mas_equalTo(SCREEN_MAX_Height);
    }];
    //标题图片
    _labelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_title"]];
    [_bar addSubview:_labelImageView];
    
    // homePage
    _homepPageView = [[ZDHNavHomePageView alloc]init];
    [_bar addSubview:_homepPageView];
    [_homepPageView mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.top.bottom.right.equalTo(_bar).offset(0);
        make.height.equalTo(_bar.mas_height);
        make.width.mas_equalTo(kButtonWidth * 4);
    }];
}
- (void)setSubViewLayout{
    [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@STA_HEIGHT);
        make.left.equalTo(0);
        make.width.equalTo(@SCREEN_MAX_WIDTH);
        make.height.equalTo(@(NAV_HEIGHT));
    }];
    //列表后退按钮
    [_listBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.centerY.equalTo(_bar.mas_centerY);
        make.width.equalTo(60);
        make.height.equalTo(62);
    }];
    
    // 返回电子布主页
    [_brandReturnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.centerY.equalTo(_bar.mas_centerY);
        make.width.equalTo(60);
        make.height.equalTo(62);
    }];
    //标题图片
    [_labelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(12);
        make.left.equalTo(_listBackButton.mas_right);
        make.width.equalTo(335/2);
        make.height.equalTo(66/2);
    }];
    
}
// 注册通知监听
- (void) notification{
    
     // 收起下拉分类列表ZDHTabBarViewController
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"packUpViewButtonClick" object:nil];
    // tabar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"ZDHNavHomePageView" object:nil];
    // 搜索框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"关键字" object:nil];
    // 选择分类
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"ZDHNaviClassifyTableviewCell" object:nil];
    // 返回ZDHNavigationHomePullView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"ZDHNavigationHomePullView" object:nil];
    //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"LoginSuccess" object:nil];
    // 无网络情况下，下拉搜索框提示网络异常UIAlertView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"UIAlertView" object:nil];
    // 修改密码成功以后取消登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"LoginCancel" object:nil];
}

// 通知反馈
- (void) notification:(NSNotification *) notification{
// 收起分类下拉列表
    if ([notification.name isEqualToString:@"packUpViewButtonClick"]) {
        
//        _classifyDropDownButton.selected = NO;
        [self pullDownPackUpWtih:NO];
    }
    else if ([notification.name isEqualToString:@"ZDHNavHomePageView"]){
        
        UIButton *button = [notification.userInfo valueForKey:@"selectedButton"];
        if (button.tag == 0 + kRightButtonTag) {
            
            [_classifyPullView getListData];
            [self pullDownPackUpWtih:YES];
        }
    }
    // 搜索框输入完成后跳转到分类搜索详细界面
    else if ([notification.name isEqualToString:@"关键字"]){
        
        [self packUpHomeDropdoenButtonPressWithFlag:YES];
        NSMutableArray *productArray = [notification.userInfo valueForKey:@"dataProdutArray"];
        NSMutableArray *listArray = [notification.userInfo valueForKey:@"dataListArray"];
        NSString *keyWord = [notification.userInfo valueForKey:@"keyword"];
        BOOL isFirstClass = YES;
        int index = 0;
        ZDHProductListViewController *listVC = nil;
        NSMutableArray *vcsArray =  [NSMutableArray arrayWithArray:self.viewControllers];
        /**
         *   获取已经存在的控制器
         */
        for (NSInteger i = 0; i < vcsArray.count; i ++) {
            
            if ([vcsArray[i] isKindOfClass:[ZDHProductListViewController class]]) {
                
                listVC = vcsArray[i];
                index = (int)i;
                isFirstClass = YES;
            }
        }
        // 是否存在该控制器
        if (listVC != nil) {
            
            if (![[vcsArray lastObject] isKindOfClass:[ZDHProductListViewController class]]) {
                
                [vcsArray removeObjectAtIndex:index];
                self.viewControllers = vcsArray;
                ZDHProductListViewController *listVC = [[ZDHProductListViewController alloc] init];
                listVC.currNavigationController = self;
                listVC.keyword = keyWord;
                listVC.brand = @"";
                listVC.style = @"";
                listVC.space = @"";
                listVC.type  = @"";
                listVC.productArray = [[NSMutableArray alloc]initWithArray:productArray];
                listVC.goodsArray = [[NSMutableArray alloc]initWithArray:listArray];
                listVC.appDelegate = _appDelegate;
                [self pushViewController:listVC animated:YES];
            }
        }
        else{
            // 若不存在，创建新的控制器
            ZDHProductListViewController *listVC = [[ZDHProductListViewController alloc] init];
            listVC.currNavigationController = self;
            listVC.keyword = keyWord;
            listVC.brand = @"";
            listVC.style = @"";
            listVC.space = @"";
            listVC.type  = @"";
            listVC.productArray = [[NSMutableArray alloc]initWithArray:productArray];
            listVC.goodsArray = [[NSMutableArray alloc]initWithArray:listArray];
            listVC.appDelegate = _appDelegate;
            [self pushViewController:listVC animated:YES];
        }
    }
    else if ([notification.name isEqualToString:@"ZDHNaviClassifyTableviewCell"]){
       [self packUpHomeDropdoenButtonPressWithFlag:YES];
        
        // 若不存在，创建新的控制器
        NSMutableArray *productArray = [notification.userInfo valueForKey:@"dataProdutArray"];
        NSMutableArray *listArray = [notification.userInfo valueForKey:@"dataListArray"];
        // 获取三级分类的分类
        NSString * thirdClassifyID = [notification.userInfo valueForKey:@"typeID"];
        // 获取名称
        NSString *titileName = [notification.userInfo valueForKey:@"titleName"];
        // 获取二级分类的id
        NSString *type = [notification.userInfo valueForKey:@"sectionID"];
        int index = 0;
        [self pullDownPackUpWtih:NO];
        BOOL isFirstClass = NO;
        ZDHProductListViewController *listVC = nil;
        NSMutableArray *vcsArray =  [NSMutableArray arrayWithArray:self.viewControllers];
        /**
         *   获取已经存在的控制器
         */
        for (NSInteger i = 0; i < vcsArray.count; i ++) {
            if ([vcsArray[i] isKindOfClass:[ZDHProductListViewController class]]) {
                index = (int)i;
                listVC = vcsArray[i];
                isFirstClass = YES;
            }
        }
        // 是否存在该控制器
        if (listVC != nil) {
        
            if (![[vcsArray lastObject] isKindOfClass:[ZDHProductListViewController class]]) {
                [vcsArray removeObjectAtIndex:index];
                self.viewControllers = vcsArray;
                listVC = [[ZDHProductListViewController alloc] init];
                listVC.currNavigationController = self;
                listVC.keyword = @"";
                listVC.brand   = @"";
                listVC.type    = type;
                listVC.space   = @"";
                listVC.style   = @"";
                listVC.secondType = thirdClassifyID;
                listVC.leftButtonTitle = titileName;
                listVC.productArray = [[NSMutableArray alloc]initWithArray:productArray];
                listVC.goodsArray = [[NSMutableArray alloc]initWithArray:listArray];
                [self pushViewController:listVC animated:YES];
            }
        }
        else{
            listVC = [[ZDHProductListViewController alloc] init];
            listVC.currNavigationController = self;
            listVC.keyword = @"";
            listVC.brand   = @"";
            listVC.type    = type;
            listVC.space   = @"";
            listVC.style   = @"";
            listVC.secondType = thirdClassifyID;
            listVC.leftButtonTitle = titileName;
            listVC.productArray = [[NSMutableArray alloc]initWithArray:productArray];
            listVC.goodsArray = [[NSMutableArray alloc]initWithArray:listArray];
            [self pushViewController:listVC animated:YES];
        }
    }
    // 跳转到不同主页
    else if ([notification.name isEqualToString:@"ZDHNavigationHomePullView"]){

        UIButton *btn = [notification.userInfo valueForKey:@"selectedButton"];
        NSString *naviStyle = [notification.userInfo valueForKey:@"naviStyle"];
        int index = (int)(btn.tag - kHomeViewButtonTag);
        // 返回跟控制器
        if (index == 0) {
            if ([naviStyle isEqualToString:@"1"]) {
                
                [_classifyPullView getListData];
                [self pullDownPackUpWtih:YES];
            }
            else if ([naviStyle isEqualToString:@"2"]){
                
               [self packUpHomeDropdoenButtonPressWithFlag:YES];
               [self popViewController];
            }
        }else if (index == 1){
            
            [self packUpHomeDropdoenButtonPressWithFlag:YES];
            ZDHProductCenterViewController *productCenterViewController = nil;
            BOOL isFirstClass = NO;
            NSMutableArray *vcsArray =  [NSMutableArray arrayWithArray:self.viewControllers];
            for (NSInteger i = 0; i < vcsArray.count; i ++) {
                
               if ([vcsArray[i] isKindOfClass:[ZDHProductCenterViewController class]]) {
                   productCenterViewController = vcsArray[i];
                    isFirstClass = YES;
               }
            }
            if (productCenterViewController != nil) {
                
                if (![[vcsArray lastObject] isKindOfClass:[ZDHProductCenterViewController class]]) {
                    
                    [self popToViewController:productCenterViewController animated:YES];
                }
            }else{
                productCenterViewController = [[ZDHProductCenterViewController alloc]init];
                productCenterViewController.currNavigationController = self;
                [self pushViewController:productCenterViewController animated:YES];
            }
        }
        
        else if (index == 2 ){
            
            NSString *islog = [_user.logStatus valueForKey:@"isLogin"];
            if ([islog isEqualToString:@"NO"]||islog == nil) {
                
                _isFirst = YES;
                //添加首次安装的时候，要跳转登陆
                //发出登录通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginRequest" object:self userInfo:nil];
            }
            else{
                
                [self packUpHomeDropdoenButtonPressWithFlag:YES];
                
                ZDHUserViewController *userViewController = nil;
                BOOL isFirstClass = NO;
                NSMutableArray *vcsArray =  [NSMutableArray arrayWithArray:self.viewControllers];
                for (NSInteger i = 0; i < vcsArray.count; i ++) {
                    
                    if ([vcsArray[i] isKindOfClass:[ZDHUserViewController class]]) {
                        userViewController = vcsArray[i];
                        isFirstClass = YES;
                    }
                }
                if (userViewController != nil) {
                    
                    if (![[vcsArray lastObject] isKindOfClass:[ZDHUserViewController class]]) {
                        
                        [self popToViewController:userViewController animated:YES];
                    }
                }else{
                
                    userViewController = [[ZDHUserViewController alloc]init];
                    userViewController.currNavigationController = self;
                   [self pushViewController:userViewController animated:YES];
                }
            }
        }
        else if (index == 3){

            [self packUpHomeDropdoenButtonPressWithFlag:YES];
            ZDHConfigViewController *configViewController = nil;
            NSMutableArray *vcsArray =  [NSMutableArray arrayWithArray:self.viewControllers];
            for (NSInteger i = 0; i < vcsArray.count; i ++) {
                
                if ([vcsArray[i] isKindOfClass:[ZDHConfigViewController class]]) {
                    configViewController = vcsArray[i];
                }
            }
            if (configViewController != nil) {
                
                if (![[vcsArray lastObject] isKindOfClass:[ZDHConfigViewController class]]) {
                    
                    [self popToViewController:configViewController animated:YES];
                }
            }else{
                
               configViewController = [[ZDHConfigViewController alloc]init];
               configViewController.currNavigationController = self;
               [self pushViewController:configViewController animated:YES];
            }
        }
    }
    // 登录成功后返回的通知
    else if ([notification.name isEqualToString:@"LoginSuccess"]){
        if (_isFirst) {
            _isFirst = NO;
        [self packUpHomeDropdoenButtonPressWithFlag:YES];
        
        ZDHUserViewController *userViewController = nil;
        NSMutableArray *vcsArray =  [NSMutableArray arrayWithArray:self.viewControllers];
        for (NSInteger i = 0; i < vcsArray.count; i ++) {
            
            if ([vcsArray[i] isKindOfClass:[ZDHUserViewController class]]) {
                userViewController = vcsArray[i];
            }
        }
        if (userViewController != nil) {
            
            if (![[vcsArray lastObject] isKindOfClass:[ZDHUserViewController class]]) {
                
                [self popToViewController:userViewController animated:YES];
            }
        }else{
            userViewController = [[ZDHUserViewController alloc]init];
            userViewController.currNavigationController = self;
            [self pushViewController:userViewController animated:YES];
        }
      }
    } else if ([notification.name isEqualToString:@"UIAlertView"]){
        
        [self pullDownPackUpWtih:NO];
    }
    else if ([notification.name isEqualToString:@"LoginCancel"]){
        
        [self popViewController];
    }
}
#pragma mark - Event response
//后退按钮
- (void)backButtonPressed:(UIButton *)btn{
    // 逐级返回按钮
    if (btn.tag == 5001) {
        
        [self packUpHomeDropdoenButtonPressWithFlag:YES];
        [self popViewControllerAnimated:YES];
    }
    // 返回主电子布按钮
    else{
        _brandReturnButton.hidden = YES;
        _listBackButton.hidden = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHUserParentViewController" object:self userInfo:@{@"selectedIndex":[NSNumber numberWithInt:1]}];
    }
}
// 退出登录后返回根控制器
- (void) logoutCurrentAccount{
    [self packUpHomeDropdoenButtonPressWithFlag:YES];
    [self popToRootViewControllerAnimated:YES];
}
- (void) packUpHomeDropdoenButtonPressWithFlag:(BOOL)flag{
    
    _homeDropDownButton.selected = NO;
    if (flag) {
        _homeDropDownButton.selected = NO;
        _homePullView.hidden = YES;
        for (UIButton *btn in _homePullView.subviews) {
            
            btn.hidden = YES;
        }
    }else{
        _homeDropDownButton.selected = YES;
        _homePullView.hidden = NO;
        for (UIButton *btn in _homePullView.subviews) {
            btn.hidden = NO;
        }
    }
}

- (void) popViewController{
    
    [self popToRootViewControllerAnimated:YES];
}

// 下拉按钮
- (void) dropDownClick:(UIButton *)btn{

    if (btn.tag == kScanButtonTag + 3) {
        [self packUpHomeDropdoenButtonPressWithFlag:btn.selected];
    }
    else if (btn.tag == kScanButtonTag + 4){
        
        if (btn.selected) {
            _classifyDropDownButton.selected = NO;
            [self pullDownPackUpWtih:NO];
        }
        else{
            [_classifyPullView getListData];
            _classifyDropDownButton.selected = YES;
            [self pullDownPackUpWtih:YES];
        }
    }
}

// 下拉和收起
- (void) pullDownPackUpWtih:(BOOL)flag{
    // 展开
    if (flag) {
        _classifyDropDownButton.selected = YES;
        [UIView animateWithDuration:0.3f animations:^{
            
            [_classifyPullView mas_updateConstraints:^(MASConstraintMaker *make){
                
                make.bottom.equalTo(_bar.mas_top).offset(SCREEN_MAX_Height - STA_HEIGHT);
                
            }];
            [_classifyPullView layoutIfNeeded];
        }];
    }
    // 收起
    else{
        _classifyDropDownButton.selected = NO;
        [UIView animateWithDuration:0.3f animations:^{
            
            [_classifyPullView mas_updateConstraints:^(MASConstraintMaker *make){
                
                make.bottom.equalTo(_bar.mas_top).offset(-STA_HEIGHT);
            }];
            [_classifyPullView layoutIfNeeded];
        }];
    }
}
// 扫描二维码
- (void) scanTowDimensionCodeClick:(UIButton *)btn{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TwoDimensionCode" object:self userInfo:nil];
}
// 搜索框的关键字
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    
    [theTextField resignFirstResponder];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"关键字" object:self userInfo:@{@"keyword":theTextField.text}];
    return YES;
}
#pragma mark - Network request
#pragma mark - Protocol methods

//UITextFieldDelegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _searchTextField) {
        
        ZDHSearchViewController *searchVC = [[ZDHSearchViewController alloc] init];
        searchVC.currNavigationController = self;
        [_searchTextField endEditing:YES];
        [self resignFirstResponder];
        [self pushViewController:searchVC animated:YES];
    }
}
#pragma mark - Other methods
//选择导航栏的模式
- (void)setNavigationBarMode:(navigationBarMode)mode{
    switch (mode) {
        case 0:
            [self useNavigationBarNormalMode];
            break;
        case 1:
            [self useNavigationBarDetailMode];
            break;
        case 2:
            [self useNavigationBarDIYMode];
            break;
        case 3:
            [self useNavigationProductListMode];
            break;
        case 4:
            [self useNavigationSearchListMode];
            break;
        case 5:
            [self useNavigationBarADVModel];
            break;
        default:
            break;
    }
}
//带搜索模式
- (void)useNavigationBarNormalMode{
    _titleView.hidden = NO;
    _searchImageView.hidden = NO;
    _searchTextField.hidden = NO;
    _scanButton.hidden = NO;
    _listBackButton.hidden = YES;
    _labelImageView.hidden = YES;
    _detailTitleLabel.hidden = YES;
    _productTextField.hidden = YES;
    _searchScanButton.hidden =  YES;
    _classifyDropDownButton.hidden = YES;
    _homeDropDownButton.hidden = YES;
    _brandReturnButton.hidden = YES;
    [_productTextField resignFirstResponder];
    //放大镜
    [_searchImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(19);
    }];
}
//可后退模式
- (void)useNavigationBarDetailMode{
    
    _labelImageView.hidden = YES;
    _detailTitleLabel.hidden = NO;
    _listBackButton.hidden = NO;
    _titleView.hidden = YES;
    _searchImageView.hidden = YES;
    _searchTextField.hidden = YES;
    _scanButton.hidden = YES;
    _productTextField.hidden = YES;
    _searchScanButton.hidden =  YES;
    
    _classifyDropDownButton.hidden = NO;
    _homeDropDownButton.hidden = NO;
    _homepPageView.hidden = YES;
    _brandReturnButton.hidden = YES;
    [_productTextField resignFirstResponder];
}
// 广告的模式
- (void)useNavigationBarADVModel{
    
    _labelImageView.hidden = YES;
    _detailTitleLabel.hidden = YES;
    _listBackButton.hidden = NO;
    _titleView.hidden = NO;
    _searchImageView.hidden = YES;
    _searchTextField.hidden = YES;
    _scanButton.hidden = YES;
    _productTextField.hidden = YES;
    _searchScanButton.hidden =  YES;
    
    _classifyDropDownButton.hidden = NO;
    _homeDropDownButton.hidden = NO;
    _homepPageView.hidden = YES;
    _brandReturnButton.hidden = YES;
    [_productTextField resignFirstResponder];
}

//DIY模式
- (void)useNavigationBarDIYMode{
    _labelImageView.hidden = YES;
    _detailTitleLabel.hidden = NO;
    _listBackButton.hidden = NO;
    _titleView.hidden = YES;
    _searchImageView.hidden = YES;
    _searchTextField.hidden = YES;
    _scanButton.hidden = YES;
    _productTextField.hidden = YES;
    _searchScanButton.hidden =  YES;
    
    _classifyDropDownButton.hidden = NO;
    _homeDropDownButton.hidden = NO;
    _brandReturnButton.hidden = YES;
    _homepPageView.hidden = YES;
    [_productTextField resignFirstResponder];
}
//产品列表模式
- (void)useNavigationProductListMode{
    _titleView.hidden = YES;
    _searchImageView.hidden = NO;
    _searchTextField.hidden = YES;
    _scanButton.hidden = YES;
    _labelImageView.hidden = YES;
    _listBackButton.hidden = NO;
    _detailTitleLabel.hidden = NO;
    _productTextField.hidden = NO;
    _searchScanButton.hidden =  YES;
    
    _classifyDropDownButton.hidden = NO;
    _homeDropDownButton.hidden = NO;
    _homepPageView.hidden = YES;
    _brandReturnButton.hidden = YES;
    //放大镜
    [_searchImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(104/2);
    }];
}
// 搜索分类列表模式
- (void)useNavigationSearchListMode{
    
    _titleView.hidden = YES;
    _searchImageView.hidden = NO;
    _searchTextField.hidden = YES;
    _scanButton.hidden = YES;
    _labelImageView.hidden = YES;
    _listBackButton.hidden = NO;
    _detailTitleLabel.hidden = NO;
    _productTextField.hidden = NO;
    _searchScanButton.hidden = NO;
    _classifyDropDownButton.hidden = NO;
    _homeDropDownButton.hidden = NO;
    _homepPageView.hidden = YES;
    _brandReturnButton.hidden = YES;
    //放大镜
    [_searchImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(104/2);
    }];
}

- (void)setDetailTitleLabelWithString:(NSString *)titleName{
    
    _detailTitleLabel.text = titleName;
}
- (void)hideNavigationBar{
    
    _bar.hidden = YES;
}
- (void)showNavigationBar{
    // 搜索框
    _searchTextField.hidden        = YES;
    // 扫描按钮
    _scanButton.hidden             = YES;
    // 搜索框放大镜
    _searchImageView.hidden        = YES;
    // 产品搜索框
    _productTextField.hidden       = YES;
    // 搜索二维码扫描
    _searchScanButton.hidden       = YES;
    _bar.hidden = NO;
    // 顶部四个按钮
    _homepPageView.hidden          = NO;
    // 返回按钮
    _listBackButton.hidden         = YES;
    // 分类下拉按钮
    _classifyDropDownButton.hidden = YES;
    // 四个按钮下拉
    _homeDropDownButton.hidden     = YES;
    // 志达主图标
    _titleView.hidden              = NO;
    // 左边志达图标
    _labelImageView.hidden         = YES;
    // 不同界面的标题
    _detailTitleLabel.hidden       = YES;
    // 默认隐藏电子布返回到主电子布列
    _brandReturnButton.hidden      = YES;
}
// 显示或者隐藏电子布
- (void) showBrandBackButtonWithFlag:(BOOL)flag{
    
    if (flag) {
        
        _brandReturnButton.hidden  = NO;
        _listBackButton.hidden     = YES;
    }
    else{
        
        _brandReturnButton.hidden  = YES;
        _listBackButton.hidden     = NO;
    }
}

@end
