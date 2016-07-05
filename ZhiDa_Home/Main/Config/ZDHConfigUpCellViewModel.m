//
//  ZDHConfigUpCellViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHConfigUpCellViewModel.h"
#import "SDImageCache.h"

@implementation ZDHConfigUpCellViewModel
//初始化
- (instancetype)init{
    if (self = [super init]) {
        [self getCacheSize];
    }
    return self;
}
//获取缓存大小
- (void)getCacheSize{
    NSInteger size = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    _sizeString = [NSString stringWithFormat:@"%ld",(long)size];
}
//删除缓存
- (void)clearCache{
    [[SDImageCache sharedImageCache] clearDisk];
}
@end
