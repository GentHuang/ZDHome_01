//
//  ZDHListView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHListView : UIView
//停止全部任务
- (void)cancelAllDownload;
////解压过程
//- (void)isUnpackZIP;
- (void)isUnpackZIP:(NSString*)string;
@end
