//
//  ZDHTabBarViewController.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZDHTabBarViewController : UITabBarController
//隐藏TabBar
- (void)hideTabBar;
//显示TabBar
- (void)showTabBar;
//用户退出
- (void)logoutAction;
@end
