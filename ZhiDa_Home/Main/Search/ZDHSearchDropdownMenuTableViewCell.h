//
//  ZDHSearchDropdownMenuTableViewCell.h
//  下拉菜单Demo
//
//  Created by apple on 16/3/10.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHSearchDropdownMenuTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void) loadCellTitleString:(NSString *)titleString;
- (void) showSelectedImage:(BOOL) selectedTag;
// 在cell 上添加按钮
- (void) goodsClassifyButtonWithArray:(NSMutableArray *)classifyArray;
@end
