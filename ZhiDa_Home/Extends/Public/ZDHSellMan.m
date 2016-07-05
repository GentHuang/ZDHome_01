//
//  ZDHSellMan.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHSellMan.h"

@implementation ZDHSellMan
+ (ZDHSellMan *)shareInstance{
    static ZDHSellMan *sellMan = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sellMan = [[ZDHSellMan alloc] init];
    });
    return sellMan;
}
@end
