//
//  ZDHSearchDropdownMenuView.h
//  下拉菜单Demo
//
//  Created by apple on 16/3/10.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHSearchDropdownMenuView : UIView

@property (strong, nonatomic) UITableView *tableViewMenu;
// 获取组头标题
@property (strong, nonatomic) NSMutableArray *sectionArray;
// 获取cell的数组类
@property (strong, nonatomic) NSMutableArray *menuArray;
// 分类id
@property (copy, nonatomic) NSString *typeIdString;
// 打开和收起菜单栏
-(void) showMenuBarWithFlag:(BOOL)flag withArray:(NSMutableArray *)array withID:(NSString *)sendID;
//// 更新tableView以及标识数组
- (void) reloadTableView:(NSMutableArray *)array;
@end
