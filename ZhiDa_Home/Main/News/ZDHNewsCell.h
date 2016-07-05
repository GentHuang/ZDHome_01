//
//  ZDHNewsCell.h
//  ZhiDa_Home
//
//  Created by 曾梓麟 on 15/9/5.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHNewsCell : UITableViewCell
//刷新标题
- (void)reloadTitle:(NSString *)title;
//刷新日期
- (void)reloadPubdate:(NSString *)date;
@end
