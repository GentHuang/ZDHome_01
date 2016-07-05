//
//  ZDHSearchDropdownMenuCellCell.h
//  ZhiDa_Home
//
//  Created by apple on 16/3/15.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHSearchDropdownMenuCellCell : UITableViewCell

// 刷新cell
- (void) loadCellCellTitle:(NSString *)titleString;
// 创建cell
+ (instancetype)cellCellWithTableView:(UITableView *)tableView;
@end
