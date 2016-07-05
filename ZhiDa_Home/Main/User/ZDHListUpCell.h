//
//  ZDHListUpCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kStartDownloadMode,
    kStopDownloadMode,
    kFinishDownloadMode,
    kContinueDownloadMode
}CellMode;
typedef enum{
    kUpCellType,
    kDownCellType
}CellType;
@interface ZDHListUpCell : UITableViewCell
//下载按钮
@property (strong, nonatomic) UIButton *rightButton;
//展开按钮
@property (strong, nonatomic) UIButton *spreadButton;
//按钮回调
@property (copy, nonatomic) ButtonBlock buttonBlock;
@property (copy, nonatomic) ButtonBlock spreadButtonBlock;
//刷新
- (void)reloadCellTitle:(NSString *)title size:(NSString *)size;
//设置Cell的模式
- (void)setCellMode:(CellMode)mode;
//选择Cell的类型
- (void)setCellType:(CellType)type;
//刷新进度条
- (void)reloadProgressView:(CGFloat)progress isDownload:(BOOL)isDownloading;

//
//提示更新图标
@property (strong, nonatomic) UILabel *promptLabel;
@end
