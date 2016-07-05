//
//  ZDHNetworkManager.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface ZDHNetworkManager : NSObject
//获取下载管理者
+ (AFHTTPRequestOperationManager *)sharedManager;
@end
