//
//  ZDHProductDetailDescCellImageView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductDetailCommenCell : UICollectionViewCell
//选择状态
- (void)setIsSelected:(BOOL)status;
//下载图片
- (void)reloadImageView:(NSString *)imageString;
//开始下载
- (void)startDownload;
//停止下载
- (void)stopDownload;
@end
