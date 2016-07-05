//
//  ZDHProductDetailDescCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/15.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductDetailDescCell : UITableViewCell
//刷新Cell的内容
- (void)reloadDescCellWithWidth:(CGFloat)width content:(NSString *)content;
@end
