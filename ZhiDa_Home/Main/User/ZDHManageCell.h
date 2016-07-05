//
//  ZDHManageCell.h
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

//typedef enum{
//    kUnDownloadMode,
//    kisDownloadMode
//}CellMode;
@interface ZDHManageCell : UITableViewCell
@property (strong, nonatomic) UIButton *updateButton;
@property (strong, nonatomic) UIButton *deleteButton;
//Block回调
@property (copy, nonatomic) ButtonBlock buttonBlock;
//刷新
- (void)reloadCellTitle:(NSString *)title size:(NSString *)size;
//是否可以更新
//- (void)canUpdata:(BOOL)canUpdata;
- (void)canUpdata:(NSString*)canUpdata;
//刷新进度条
- (void)reloadProgressView:(CGFloat)progress isDownload:(BOOL)isDownloading;
//设置Cell的模式
- (void)setCellMode:(CellMode)mode;
@end
