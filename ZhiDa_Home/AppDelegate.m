//
//  AppDelegate.m
//  ZhiDa_Home
//
//  Created by 软碟技术 on 14-11-10.
//  Copyright (c) 2014年 软碟技术. All rights reserved.
//

#import "AppDelegate.h"
// Controller
#import "ZDHHomePageViewController.h"
#import "ZDHProductCenterViewController.h"
#import "ZDHNavigationController.h"
#import "ZDHConfigViewController.h"
#import "ZDHUserViewController.h"
#import "ZDHParentViewController.h"
//View
#import "ZDHLoginView.h"
#import "ZDHForgetPSWView.h"
#import "ZDHChangePSWView.h"
#import "ZDHLogView.h"
#import "ZDHResponseView.h"
#import "ZDHUserSuggestView.h"
//Lib
#import "Masonry.h"
//临时
#import "ZDHUser.h"
// 百度统计
#import "BaiduMobStat.h"
// 友盟统计
#import "MobClick.h"
// 获取更新信息
#import "ZDHAppUpdateViewModel.h"
#import "ZDHAppUpdateModel.h"
// ZDHVersionUpdateAlertView
#import "ZDHVersionUpdateAlertView.h"


@interface AppDelegate()<UITabBarControllerDelegate,ZDHVersionUpdateAlertViewDelegate>
@property (strong, nonatomic) ZDHLoginView *loginView;
@property (strong, nonatomic) ZDHForgetPSWView *forgetView;
@property (strong, nonatomic) ZDHChangePSWView *changeView;
@property (strong, nonatomic) ZDHLogView *logView;
@property (strong, nonatomic) ZDHResponseView *resView;
@property (strong, nonatomic) ZDHUserSuggestView *suggestView;
@property (strong, nonatomic) ZDHNavigationController *homePageNVC;
//临时
@property (strong, nonatomic) ZDHUser *user;
@property (strong, nonatomic) NSDate *RecordBackgroundDate;
@property (strong, nonatomic) ZDHAppUpdateViewModel *ViewModel;
@property (strong, nonatomic) NSString *updateUrl;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self updateAppChek];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //家居首页
    ZDHHomePageViewController *homePageVC = [[ZDHHomePageViewController alloc] init];
    homePageVC.appDelegate = self;
    _homePageNVC = [[ZDHNavigationController alloc] initWithRootViewController:homePageVC];
    homePageVC.currNavigationController = _homePageNVC;
    //接收通知
    [self notificationRecieve];
    //登录状态
    _user = [ZDHUser getCurrUser];
    [_user setLogStatus];

    self.window.rootViewController = _homePageNVC;
    [self.window makeKeyAndVisible];
// 添加百度统计
    BaiduMobStat *stateTracker = [BaiduMobStat defaultStat];
    stateTracker.monitorStrategy = BaiduMobStatMonitorStrategyAll;
    [stateTracker startWithAppId:kBDAnalyticsAppKey];
//  友盟统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:kUMAnalyticsAppKey reportPolicy:BATCH channelId:@""];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
//----------------添加------------------------------------
    //获取退回后台的时间
    _RecordBackgroundDate = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
    //保存到沙盒中
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setValue:_RecordBackgroundDate forKey:@"RecordBackgroundDate"];
    [userdefaults synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//-----------------添加-----------------------------------
    //获取即将进入前台的时间
    NSDate *getForegroundDate = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
    //取出保存的时间
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"RecordBackgroundDate"];
    //计算时间间隔
    NSTimeInterval num = [getForegroundDate timeIntervalSinceDate:date];
    //设置最小时间间隔,单位秒,设计为20分钟- - >客户需求改为3个小时  PS: 也不知道行不行
    int  intervalTime = 60*180;
    if (num>intervalTime) {
        //退出登录
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutRequest" object:self];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //退出登录
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutRequest" object:self];
}

#pragma mark - Event response
//接收通知
- (void)notificationRecieve{
    //接收通知
    //登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotificationResponse:) name:@"LoginRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotificationResponse:) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotificationResponse:) name:@"LoginCancel" object:nil];
    //忘记密码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forgetNotificationResponse:) name:@"ForgetRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forgetNotificationResponse:) name:@"ForgetCancel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forgetNotificationResponse:) name:@"ForgetCommit" object:nil];
    //修改密码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePSWnotificationResponse:) name:@"ChangePSW" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePSWnotificationResponse:) name:@"ChangeSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePSWnotificationResponse:) name:@"ChangeCancel" object:nil];
    //退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotificationResponse:) name:@"LogoutRequest" object:nil];
    //详细日志
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logNotificationResponse:) name:@"ZDHLogView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logNotificationResponse:) name:@"ZDHLogViewCancel" object:nil];
    //客户反馈
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseNotificationResponse:) name:@"ZDHResponseView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseNotificationResponse:) name:@"ZDHResponseViewCancel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseNotificationResponse:) name:@"ZDHResponseViewCommit" object:nil];
    //中途意见
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suggestNotificationResponse:) name:@"ZDHUserSuggestView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suggestNotificationResponse:) name:@"ZDHUserSuggestViewCancel" object:nil];
}
//登录通知反馈
- (void)loginNotificationResponse:(NSNotification *)notitfication{
    if ([notitfication.name isEqualToString:@"LoginRequest"]) {
        
        _loginView = [[ZDHLoginView alloc] init];
        [self.window addSubview:_loginView];
        [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.equalTo(0);
            make.top.equalTo(STA_HEIGHT);
        }];
    }else if([notitfication.name isEqualToString:@"LoginSuccess"]){
        [_loginView removeFromSuperview];
        [_user loginSuccess];
    }else if([notitfication.name isEqualToString:@"LoginCancel"]){
        [_loginView removeFromSuperview];
    }
}
//忘记密码通知反馈
- (void)forgetNotificationResponse:(NSNotification *)notitfication{
    if([notitfication.name isEqualToString:@"ForgetRequest"]){
        [_loginView removeFromSuperview];
        _forgetView = [[ZDHForgetPSWView alloc] init];
        [self.window addSubview:_forgetView];
        [_forgetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.equalTo(0);
            make.top.equalTo(STA_HEIGHT);
        }];
    }else if([notitfication.name isEqualToString:@"ForgetCancel"] ){
        [_forgetView removeFromSuperview];
    }
//-------------------点击提交，发送一个请求----------------------------
    else if([notitfication.name isEqualToString:@"ForgetCommit"]){
        
        [_forgetView ForgetPSWCommitEmail:notitfication success:^(NSMutableArray *resultArray) {
            //反馈成功
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:_forgetView.statusMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alView show];
            [_forgetView removeFromSuperview];
        } fail:^(NSError *error) {
            //反馈失败
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:_forgetView.statusMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alView show];
        }];
    }
}
//修改密码通知反馈
- (void)changePSWnotificationResponse:(NSNotification *)notitfication{
    if ([notitfication.name isEqualToString:@"ChangePSW"]){
        //修改密码
        _changeView = [[ZDHChangePSWView alloc] init];
        [self.window addSubview:_changeView];
        [_changeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.equalTo(0);
            make.top.equalTo(STA_HEIGHT);
        }];
    }else if([notitfication.name isEqualToString:@"ChangeCancel"]){
        //点击取消
        [_changeView removeFromSuperview];
    }else if([notitfication.name isEqualToString:@"ChangeSuccess"]){
        //修改成功
        [_changeView removeFromSuperview];
        [_user logoutSuccess];
        [_tabBarVC logoutAction];
        //显示登录界面
        _loginView = [[ZDHLoginView alloc] init];
        [self.window addSubview:_loginView];
        [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.equalTo(0);
            make.top.equalTo(STA_HEIGHT);
        }];
    }
}
//退出登录通知反馈
- (void)logoutNotificationResponse:(NSNotification *)notitfication{
    if([notitfication.name isEqualToString:@"LogoutRequest"]){
        [_user logoutSuccess];
        UIAlertView *logoutAL = [[UIAlertView alloc] initWithTitle:nil message:@"用户已退出" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [logoutAL show];
        [_homePageNVC logoutCurrentAccount];
    }
}
//详细日志通知反馈
- (void)logNotificationResponse:(NSNotification *)notitfication{
    if([notitfication.name isEqualToString:@"ZDHLogView"]){
        _logView = [[ZDHLogView alloc] init];
        _logView.orderID = [notitfication.userInfo valueForKey:@"orderID"];
        [self.window addSubview:_logView];
        [_logView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.equalTo(0);
            make.top.equalTo(STA_HEIGHT);
        }];
    }else if([notitfication.name isEqualToString:@"ZDHLogViewCancel"]){
        [_logView removeFromSuperview];
    }
}
//客户反馈通知反馈
- (void)responseNotificationResponse:(NSNotification *)notitfication{
    if([notitfication.name isEqualToString:@"ZDHResponseView"]){
        _resView = [[ZDHResponseView alloc] init];
        _resView.orderID = [notitfication.userInfo valueForKey:@"orderID"];
        [self.window addSubview:_resView];
        [_resView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.equalTo(0);
            make.top.equalTo(STA_HEIGHT);
        }];
    }else if([notitfication.name isEqualToString:@"ZDHResponseViewCancel"]){
        [_resView removeFromSuperview];
    }else if([notitfication.name isEqualToString:@"ZDHResponseViewCommit"]){
        [_resView removeFromSuperview];
    }
}
//中途意见
- (void)suggestNotificationResponse:(NSNotification *)notification{
    if([notification.name isEqualToString:@"ZDHUserSuggestView"]){
        _suggestView = [[ZDHUserSuggestView alloc] init];
        _suggestView.orderID = [notification.userInfo valueForKey:@"orderID"];
        [self.window addSubview:_suggestView];
        [_suggestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.equalTo(0);
            make.top.equalTo(STA_HEIGHT);
        }];
    }else if([notification.name isEqualToString:@"ZDHUserSuggestViewCancel"]){
        [_suggestView removeFromSuperview];
    }
}
#pragma mark - Protocol methods
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    ZDHNavigationController *currVC = (ZDHNavigationController *)viewController;
    [currVC popToRootViewControllerAnimated:YES];
}
// app更新提醒
- (void) updateAppChek{
    
    self.ViewModel = [[ZDHAppUpdateViewModel alloc]init];
    __block ZDHAppUpdateViewModel *vcViewModel = _ViewModel;
    __block AppDelegate *appDelegate = self;
    [_ViewModel getAppUpdateDataSuccess:^(NSMutableArray *array){
        
        ZDHAppUpdateModel *updateModel = [vcViewModel.updateModelArray firstObject];
        if ([updateModel.flowstate isEqualToString:@"99"]) {
            
            NSString *nowVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *newVersion = [updateModel.title substringFromIndex:1];
            appDelegate.updateUrl = updateModel.downlink;
            if(![nowVersion isEqualToString:newVersion]){
                
                ZDHVersionUpdateAlertView *updateAlertView = [[ZDHVersionUpdateAlertView alloc]initWithTitle:updateModel.title updateContent:updateModel.content delegate:self];
                [updateAlertView show];
            }
        }
    } fail:^(NSError *error){
        
        
    }];
}
- (void) alertViewToAppStoreUpdateApp{
//    [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", @"991665037"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
}


@end
