//
//  ZDHUserParentViewController.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controllers
#import "ZDHParentViewController.h"
@interface ZDHUserParentViewController : ZDHParentViewController
@property (strong, nonatomic) UITableView *leftTableView;
- (void)createUI;
- (void)setSubViewLayout;
//刷新数据
- (void)reloadData;
@end
