//
//  ZDHLIstViewCellStatus.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHLIstViewCellStatus : NSObject
@property (assign, nonatomic) BOOL isStart;
@property (assign, nonatomic) BOOL isStop;
@property (assign, nonatomic) BOOL isContinue;
@property (assign, nonatomic) BOOL isFinish;
@property (assign, nonatomic) BOOL isDownloading;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) CGFloat progress;
//@property (assign, nonatomic) long long progress;
//开始下载
- (void)setIsStart;
//暂停下载
- (void)setIsStop;
//继续下载
- (void)setisContinue;
//下载完成
- (void)setisFinish;
@end
