//
//  ZDHNavigationController.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZDHTabBarViewController;
//导航栏的模式
typedef enum{
    kNavigationBarNormalMode,
    kNavigationBarDetailMode,
    kNavigationBarDIYMode,
    kNavigationProductListModel,
    kNavigationSearchListMode,
    useNavigationBarADVModel
}navigationBarMode;
@interface ZDHNavigationController : UINavigationController

@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UITextField *productTextField;
// 电子布板返回按钮
@property (strong, nonatomic) UIButton *brandReturnButton;

@property (strong, nonatomic) UINavigationBar *bar;
//设置导航栏的样式
- (void)setNavigationBarMode:(navigationBarMode)mode;
//设置导航栏的TitleName
- (void)setDetailTitleLabelWithString:(NSString *)titleName;
//隐藏导航栏
- (void)hideNavigationBar;
//显示导航栏
- (void)showNavigationBar;
// 退出登录后返回根控制器
- (void) logoutCurrentAccount;
// 显示或者隐藏电子布
- (void) showBrandBackButtonWithFlag:(BOOL)flag;
@end
