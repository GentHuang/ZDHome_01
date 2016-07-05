//
//  ZDHUserSuggestViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserSuggestViewViewModel.h"
//Model
#import "ZDHUserSuggestViewModel.h"
#import "ZDHUserSuggestViewOrderOpinionsModel.h"

@implementation ZDHUserSuggestViewViewModel
//根据OrderID获取中途意见
- (void)getDataWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataOpinionNameArray = [NSMutableArray array];
    _dataOpinionContentArray = [NSMutableArray array];
    _dataOpinionTimeArray = [NSMutableArray array];
    //组建zifuchuan
    NSString *urlString = [NSString stringWithFormat:kGetSuggestAPI,orderID];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHUserSuggestViewModel *vcModel = [[ZDHUserSuggestViewModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHUserSuggestViewOrderOpinionsModel *opModel in vcModel.order_opinions) {
            //获取中途意见
            [_dataOpinionTimeArray addObject:opModel.addtime];
            [_dataOpinionContentArray addObject:opModel.remarks];
            [_dataOpinionNameArray addObject:opModel.addman];

        }
        //检测是否下载完成
        if (_dataOpinionNameArray.count > 0) {
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
