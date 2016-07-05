//
//  ZDHProductCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductCell : UITableViewCell
@property (strong, nonatomic) NSString *orderID;
//刷新列表
- (void)reloadCellWithArray:(NSArray *)dataArray;
@end
