//
//  ZDHUser.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZDHUser : NSObject
//临时
@property (strong, nonatomic) NSUserDefaults *logStatus;
//获取当前用户
+ (id)getCurrUser;
//初始化
- (void)setLogStatus;
//登录成功
- (void)loginSuccess;
//退出登录
- (void)logoutSuccess;
@end
