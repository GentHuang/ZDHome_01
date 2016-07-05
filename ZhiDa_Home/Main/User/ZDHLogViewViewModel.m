//
//  ZDHLogViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHLogViewViewModel.h"
//Model
#import "ZDHLogViewModel.h"
#import "ZDHLogViewOrderLogsModel.h"

#define TESTNET @"http://zhidaapi.toprand.com.cn/business.ashx?m=bespoke_log&orderid=%@"

@implementation ZDHLogViewViewModel
//根据orderID获取日志
- (void)getLogInfoWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化数据
    _dataLogNameArray = [NSMutableArray array];
    _dataLogDateArray = [NSMutableArray array];
    _dataLogOperationArray = [NSMutableArray array];
    
    NSArray *stringArr = [orderID componentsSeparatedByString:@" "];
    NSString *urlString = [NSString string];
    //组建请求地址
//    NSString *urlString = [NSString stringWithFormat:kGetLogInfoAPI,orderID];
    if ([[stringArr firstObject] isEqualToString:@"预约"]) {
        
        urlString = [NSString stringWithFormat:kGetBespokeLogInfoAPI,[stringArr lastObject]];
        
    }else if([[stringArr firstObject] isEqualToString:@"商品"])
    {
       urlString = [NSString stringWithFormat:kGetShopLogInfoAPI,[stringArr lastObject]];
        
    }else if([[stringArr firstObject] isEqualToString:@"设计"])
    {
         urlString = [NSString stringWithFormat:kGetDesinLogInfoAPI,[stringArr lastObject]];
    }
   
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHLogViewModel *vcModel = [[ZDHLogViewModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHLogViewOrderLogsModel *logModel in vcModel.order_logs) {
            //获取所有日志消息
            [_dataLogNameArray addObject:logModel.addman];
            [_dataLogDateArray addObject:logModel.addtime];
            [_dataLogOperationArray addObject:logModel.remarks];
        }
        //检测是否存在日志
        if (_dataLogNameArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
@end
