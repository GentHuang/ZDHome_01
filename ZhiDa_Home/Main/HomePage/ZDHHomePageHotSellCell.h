//
//  ZDHHomePageHotCellCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHHomePageHotSellCell : UITableViewCell
//刷新图片
- (void)reloadImageView:(NSArray *)imageArray;
//刷新标题和简介
- (void)reloadTitle:(NSArray *)title desc:(NSArray *)desc;
//开始读取
- (void)startLoading;
//读取结束
- (void)stopLoading;
@end
