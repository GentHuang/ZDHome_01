//
//  ZDHResponseViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHResponseViewViewModel.h"
//Model
#import "ZDHResponseViewModel.h"
#import "ZDHResponseViewAddresultModel.h"

@implementation ZDHResponseViewViewModel
//发送反馈
- (void)sendResponseWithSellManID:(NSString *)sellManID orderID:(NSString *)orderID remarks:(NSString *)remarks success:(SuccessBlock)success fail:(FailBlock)fail{
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kSendResponseAPI,sellManID,orderID,remarks];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //发送反馈
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHResponseViewModel *vcModel = [[ZDHResponseViewModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        ZDHResponseViewAddresultModel *resultModel = vcModel.addresult;
        _dataMSGString = resultModel.msg;
        //检查是否发送成功
        if ([resultModel.code isEqualToString:@"fail"]) {
            fail(nil);
        }else{
            success(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        fail(nil);
    }];
}
@end
