//
//  ZDHNetworkManager.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHNetworkManager.h"
@implementation ZDHNetworkManager
//获取下载管理者
+ (AFHTTPRequestOperationManager *)sharedManager{
    static AFHTTPRequestOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    });
    return manager;
}
@end
