//
//  ZDHScreenViewCell.h
//  TableView二级联动Demo
//
//  Created by apple on 16/3/11.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHScreenViewCell : UITableViewCell

// 创建cell
+ (instancetype) cellScreenViewCellWithTableView:(UITableView *)tableView;
// 添加lable的标题
- (void) titleLableWithString:(NSString *)titleString;
// 刷新商品分类
- (void) loadGoodsTitle:(NSString *)goodsString;

// 改变字体颜色
- (void) changeCellTitleColorWithFlag:(BOOL) flag;
@end
