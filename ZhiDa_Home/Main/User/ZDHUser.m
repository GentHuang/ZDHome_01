//
//  ZDHUser.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUser.h"

@implementation ZDHUser
+ (id)getCurrUser{
    static ZDHUser *dc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dc = [[ZDHUser alloc] init];
    });
    return dc;
}
//登录成功
- (void)loginSuccess{
    [_logStatus setObject:@"YES" forKey:@"isLogin"];
}
//退出登录
- (void)logoutSuccess{
    [_logStatus setObject:@"NO" forKey:@"isLogin"];
}
//检测登录状态
- (void)setLogStatus{
    _logStatus = [NSUserDefaults standardUserDefaults];
    if ([[_logStatus valueForKey:@"isLogin"] isEqualToString:@"YES"]) {
        //已经登录
        //获取用户信息
        [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHSellMan class] success:^(NSMutableArray *resultArray) {
            //获取成功
            ZDHSellMan *sellMan = (ZDHSellMan *)[resultArray firstObject];
            [ZDHSellMan shareInstance].sellManName = sellMan.sellManName;
            [ZDHSellMan shareInstance].sellManID = sellMan.sellManID;
//            NSLog(@"%@",sellMan.sellManID);
        } fail:^(NSError *error) {
            //获取失败
        }];
    }else{
        //尚未登录
        //删除用户信息
        [[FMDBManager sharedInstace] deleteModelAllInDatabase:[ZDHSellMan class]];
    }
}
@end
