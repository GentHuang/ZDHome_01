//
//  ZDHTabBarViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controllers
#import "ZDHTabBarViewController.h"
#import "ZDHNavigationController.h"
//Libs
#import "Masonry.h"
//临时
#import "ZDHUser.h"
//Macros
#define kRightButtonTag 2000
#define kButtonWidth 64
@interface ZDHTabBarViewController ()<UITabBarControllerDelegate>
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) NSArray *buttonNorName;
@property (strong, nonatomic) NSArray *buttonSelName;
//临时
@property (strong, nonatomic) ZDHUser *user;
@end
@implementation ZDHTabBarViewController
#pragma mark - Init methods
- (void)initData{
    _buttonNorName = @[[UIImage imageNamed:@"btn_home_nor"],[UIImage imageNamed:@"btn_product_nor"],[UIImage imageNamed:@"btn_user_nor"],[UIImage imageNamed:@"btn_config_nor"]];
    _buttonSelName = @[[UIImage imageNamed:@"btn_home_sel"],[UIImage imageNamed:@"btn_product_sel"],[UIImage imageNamed:@"btn_user_sel"],[UIImage imageNamed:@"btn_config_sel"]];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createTabBar];
        [self setSubViewsLayout];
        [self notificationRecieve];
        //临时
        _user = [ZDHUser getCurrUser];
    }
    return self;
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Getters and setters
- (void)createTabBar{
    //创建TabBar
    self.tabBar.hidden = YES;
    _rightView = [[UIView alloc] init];
    _rightView.hidden = YES;
    _rightView.backgroundColor = [UIColor clearColor];
    _rightView.userInteractionEnabled = YES;
    [self.view addSubview:_rightView];
}
- (void)setSubViewsLayout{
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@STA_HEIGHT);
        make.left.equalTo(@747);
        make.width.equalTo(@(kButtonWidth*4));
        make.height.equalTo(@NAV_HEIGHT);
    }];
    //创建TabBar
    for (int i = 0; i < 4; i ++) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setBackgroundImage:_buttonNorName[i] forState:UIControlStateNormal];
        [rightButton setBackgroundImage:_buttonSelName[i] forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTag:(i+kRightButtonTag)];
        if (i == 0) {
            rightButton.selected = YES;
        }
        [_rightView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@(i*kButtonWidth));
            make.width.equalTo(@kButtonWidth);
            make.bottom.equalTo(@0);
        }];
    }
}

#pragma mark - Event response
//点击按钮
- (void)rightButtonPressed:(UIButton *)button{
    
    int selectedIndex = (int)(button.tag - kRightButtonTag);
    NSString *islog = [_user.logStatus valueForKey:@"isLogin"];
    if (selectedIndex == 0 || selectedIndex == 1 || selectedIndex == 3) {
        
        for (int i = 0; i < 4; i ++) {
            
            UIButton *tmpButton = (UIButton *)[self.view viewWithTag:(i+kRightButtonTag)];
            tmpButton.selected = NO;
        }
        self.selectedIndex = button.tag - kRightButtonTag;
        [self popToRootViewController];
        button.selected = YES;
    }else if (selectedIndex == 2 && ([islog isEqualToString:@"NO"]||islog ==nil)) { //添加首次安装的时候，要跳转登陆
        //发出登录通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginRequest" object:self userInfo:nil];
    }else{
        
        self.selectedIndex = 2;
        for (int i = 0; i < 4; i ++) {
            UIButton *tmpButton = (UIButton *)[self.view viewWithTag:(i+kRightButtonTag)];
            tmpButton.selected = NO;
        }
        UIButton *tmpButton = (UIButton *)[self.view viewWithTag:(2+kRightButtonTag)];
        tmpButton.selected = YES;
    }
}
//接收通知
- (void)notificationRecieve{
    //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notitficationResponse:) name:@"LoginSuccess" object:nil];
}
//通知反馈
- (void)notitficationResponse:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"LoginSuccess"]) {
        self.selectedIndex = 2;
        for (int i = 0; i < 4; i ++) {
            UIButton *tmpButton = (UIButton *)[self.view viewWithTag:(i+kRightButtonTag)];
            tmpButton.selected = NO;
        }
        UIButton *tmpButton = (UIButton *)[self.view viewWithTag:(2+kRightButtonTag)];
        tmpButton.selected = YES;
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//隐藏TabBar
- (void)hideTabBar{
    _rightView.hidden = YES;
}
//显示TabBar
- (void)showTabBar{
    _rightView.hidden = NO;
}
//用户退出
- (void)logoutAction{
    
    self.selectedIndex = 0;
    for (int i = 0; i < 4; i ++) {
        UIButton *tmpButton = (UIButton *)[self.view viewWithTag:(i+kRightButtonTag)];
        tmpButton.selected = NO;
    }
    UIButton *tmpButton = (UIButton *)[self.view viewWithTag:(0+kRightButtonTag)];
    tmpButton.selected = YES;
}
//跳转到首页
- (void)popToRootViewController{
    
    ZDHNavigationController *vc = (ZDHNavigationController *)[self selectedViewController];
    [vc popToRootViewControllerAnimated:YES];
}



@end
