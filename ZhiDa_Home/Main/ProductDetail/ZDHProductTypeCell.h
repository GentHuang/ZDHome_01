//
//  ZDHProductTypeDescCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductTypeCell : UITableViewCell
//刷新图片
- (void)reloadCellImageView:(NSArray *)array pidArray:(NSArray *)pidArray selectedPid:(NSString *)pid;
//刷新文字
- (void)reloadCellContent:(NSArray *)contentArray;
@end
