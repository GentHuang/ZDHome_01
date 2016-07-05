//
//  ZDHDesignDetailDownCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHDesignDetailDownCell : UITableViewCell
@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) NSString *planID;
//刷新图片
- (void)reloadCellWithImage:(NSString *)imageString;
@end
