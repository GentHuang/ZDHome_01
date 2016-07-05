//
//  ZDHScreenSecondCell.h
//  下拉菜单Demo
//
//  Created by apple on 16/3/14.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHScreenSecondCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
// 添加标题
- (void) loadTitilzWithString:(NSString *)titleString;
// 改变字体与选择
- (void) titleColorSelected:(BOOL)flag;

@end
