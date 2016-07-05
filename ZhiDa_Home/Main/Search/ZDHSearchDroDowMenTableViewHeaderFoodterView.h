//
//  ZDHSearchDroDowMenTableViewHeaderFoodterView.h
//  下拉菜单Demo
//
//  Created by apple on 16/3/10.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHSearchDroDowMenTableViewHeaderFoodterView : UITableViewHeaderFooterView

// 组头的标识
@property (assign,nonatomic) int sectionIndex;
// 创建组头
+ (instancetype) headerViewWithTableView:(UITableView *)tableView;
// 添加组头文字
- (void) loadTitleText:(NSString *)title;
// 保证转状态
- (void) showSectionOpenflag:(NSString *) flag;

@end
