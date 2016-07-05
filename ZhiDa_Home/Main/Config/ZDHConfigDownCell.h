//
//  ZDHConfigDownCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kImageMode,
    kVersionMode
}CellMode;
@interface ZDHConfigDownCell : UITableViewCell
//设置Title
- (void)setTitle:(NSString *)name;
//设置VersionLabel
- (void)setVersionLabelWithString:(NSString *)version;
//设置模式
- (void)setCellMode:(CellMode)mode;
@end
