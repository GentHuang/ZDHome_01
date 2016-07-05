//
//  ZDHDesignDetailUpCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHDesignDetailUpCell : UITableViewCell
//加载基本信息
- (void)reloadCellWithArray:(NSArray *)dataArray;
// 加载偏好产品
- (void)loadAboutProductWithImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray;
@end
