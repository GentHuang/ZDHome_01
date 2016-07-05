//
//  ZDHDownloadTopView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHDownloadTopView : UIView


//解压过程中不能切换管理界面
- (void)iSUnpackZIPNotSwitch;
//解压完成才可切换
- (void)iSFinishZIP;
@end
