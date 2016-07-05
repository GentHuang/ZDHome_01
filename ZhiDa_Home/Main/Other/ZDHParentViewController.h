//
//  ZDHParentViewController.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ZDHNavigationController.h"
#import "ZDHTabBarViewController.h"
@interface ZDHParentViewController : UIViewController

@property (strong, nonatomic) ZDHNavigationController *currNavigationController;
@property (strong, nonatomic) ZDHTabBarViewController *currTabarController;
@property (strong, nonatomic) AppDelegate *appDelegate;
- (void)createSuperUI;
- (void)setSuperSubViewLayout;
@end
