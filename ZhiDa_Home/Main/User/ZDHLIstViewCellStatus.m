//
//  ZDHLIstViewCellStatus.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHLIstViewCellStatus.h"

@implementation ZDHLIstViewCellStatus
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
//开始下载
- (void)setIsStart{
    _isStart = YES;
    _isStop = NO;
    _isContinue = NO;
    _isFinish = NO;
}
//暂停下载
- (void)setIsStop{
    _isStart = NO;
    _isStop = YES;
    _isContinue = NO;
    _isFinish = NO;
}
//继续下载
- (void)setisContinue{
    _isStart = NO;
    _isStop = NO;
    _isContinue = YES;
    _isFinish = NO;
}
//下载完成
- (void)setisFinish{
    _isStart = NO;
    _isStop = NO;
    _isContinue = NO;
    _isFinish = YES;
}
@end
