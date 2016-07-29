//
//  ZDHMyOrderViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHMyOrderViewOrderViewModel.h"
//Model
#import "ZDHMyOrderViewOrderModel.h"
#import "ZDHMyOrderViewOrderBespokeListModel.h"
#import "ZDHMyOrderViewOrderDetailModel.h"
#import "ZDHMyOrderViewOrderDetailBespokeDetailModel.h"
#import "ZDHMyOrderViewOrderDetailBespokeDetailOpinionModel.h"
#import "ZDHMyOrderViewOrderDetailResponseModel.h"
#import "ZDHMyOrderViewOrderDetailResponseBespokePoinionModel.h"

@implementation ZDHMyOrderViewOrderViewModel
//获取预约单列表
- (void)getOrderListWithMemberid:(NSString *)memberID page:(NSInteger)page success:(SuccessBlock)success fail:(FailBlock)fail{
    if (page == 1) {
        //初始化数据
        _dataOrderListArray = [NSMutableArray array];
    }
    //组建请求字符串
    NSString *urlString = nil;
    if ([_searchSizeString isEqualToString:@"1000"]) {
        urlString = [NSString stringWithFormat:kGetOrderListAPI,memberID,_searchSizeString,[NSString stringWithFormat:@"%ld",(long)page]];
    }else {
    
    urlString = [NSString stringWithFormat:kGetOrderListAPI,memberID,@"5",[NSString stringWithFormat:@"%ld",(long)page]];
    
    }
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHMyOrderViewOrderModel *vcModel = [[ZDHMyOrderViewOrderModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHMyOrderViewOrderBespokeListModel *listModel in vcModel.bespoke_list) {
            //获取所有预约单列表信息
            [_dataOrderListArray addObject:listModel];
        }
        //检测是否下载成功
        if (_dataOrderListArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
//获取预约详情
- (void)getOrderDetailWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataDetailArray = [NSMutableArray array];
    _dataOpinionArray = [NSMutableArray array];
    //组建请求字符串
    NSString *urlString = [NSString stringWithFormat:kGetOrderDetailAPI,orderID];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHMyOrderViewOrderDetailModel *vcModel = [[ZDHMyOrderViewOrderDetailModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        ZDHMyOrderViewOrderDetailBespokeDetailModel *detailModel = vcModel.bespoke_detail;
        //客户详情
        [_dataDetailArray addObject:detailModel];
        for (ZDHMyOrderViewOrderDetailBespokeDetailOpinionModel *opinionModel in detailModel.opinion) {
            //客户意见
            [_dataOpinionArray addObject:opinionModel];
        }
        //测试是否下载完成
        if (_dataDetailArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
//获取预约详情反馈
- (void)getOrderResponseWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataResponseArray = [NSMutableArray array];
    //组建请求字符串
    NSString *urlString = [NSString stringWithFormat:kGetOrderResponseAPI,orderID];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHMyOrderViewOrderDetailResponseModel *vcModel = [[ZDHMyOrderViewOrderDetailResponseModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHMyOrderViewOrderDetailResponseBespokePoinionModel *opModel in vcModel.bespoke_poinion) {
            //预约详情反馈
            [_dataResponseArray addObject:opModel];
        }
        //测试是否下载完成
        if (_dataResponseArray.count > 0) {
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
