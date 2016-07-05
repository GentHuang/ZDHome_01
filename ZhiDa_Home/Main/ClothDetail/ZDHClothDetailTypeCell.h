//
//  ZDHClothDetailTypeCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHClothDetailTypeCell : UITableViewCell
// 返回按钮
@property (copy, nonatomic)  ButtonBlock useIconButton;
//刷新图片
- (void)reloadCellImageView:(NSArray *)array idArray:(NSArray *)idArray selectedID:(NSString *)ID;
//刷新Label
- (void) reloadDescLabelWithArray:(NSArray *)array;
- (void) reloadDistributeWithLableTitle:(NSString *)labelTitle;
// 刷新用途iCon
- (void)reflashClothUseWithArray:(NSMutableArray *)modelArray;
@end
