//
//  ZDHSellMan.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHSellMan : NSObject
@property (strong, nonatomic) NSString *sellManID;
@property (strong, nonatomic) NSString *sellManName;
@property (strong, nonatomic) NSString *realName;//真是姓名
+ (ZDHSellMan *)shareInstance;
@end
