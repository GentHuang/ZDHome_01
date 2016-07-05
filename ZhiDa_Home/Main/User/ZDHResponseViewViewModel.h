//
//  ZDHResponseViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHResponseViewViewModel : NSObject
@property (strong, nonatomic) NSString *dataMSGString;
//发送反馈
- (void)sendResponseWithSellManID:(NSString *)sellManID orderID:(NSString *)orderID remarks:(NSString *)remarks success:(SuccessBlock)success fail:(FailBlock)fail;
@end
