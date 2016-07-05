//
//  ZDHLogViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHLogViewViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataLogNameArray;
@property (strong, nonatomic) NSMutableArray *dataLogOperationArray;
@property (strong, nonatomic) NSMutableArray *dataLogDateArray;

//根据orderID获取日志
- (void)getLogInfoWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail;
@end
