//
//  ZDHClothDetailHeaderCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHClothDetailHeaderCell : UITableViewCell
//刷新Cell
- (void)reloadCellWithString:(NSString *)string;
//刷新Cell
- (void)reloadCellWithString:(NSString *)string with:(NSString*)titleString;

@end
