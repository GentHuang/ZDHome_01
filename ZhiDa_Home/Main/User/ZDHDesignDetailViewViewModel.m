//
//  ZDHDesignDetailViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDesignDetailViewViewModel.h"
//Model
#import "ZDHDesignDetailViewModel.h"
#import "ZDHDesignDetailViewDesignDetailModel.h"
#import "ZDHDesignDetailViewDesignDetailPlanitemModel.h"
#import "ZDHDesignDetailViewDesignDetailAboutproductModel.h"

@implementation ZDHDesignDetailViewViewModel
//根据OrderID获取设计详情
- (void)getDetailWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataDetailArray = [NSMutableArray array];
    _dataAboutArray = [NSMutableArray array];
    _dataItemArray = [NSMutableArray array];
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kGetDesignDetailAPI,orderID];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHDesignDetailViewModel *vcModel = [[ZDHDesignDetailViewModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        ZDHDesignDetailViewDesignDetailModel *detailModel = vcModel.design_detail;
        //设计单详情
        [_dataDetailArray addObject:detailModel];
        for (ZDHDesignDetailViewDesignDetailAboutproductModel *aboutModel in detailModel.aboutproduct) {
            //偏好产品
            [_dataAboutArray addObject:aboutModel];
        }
        ZDHDesignDetailViewDesignDetailPlanitemModel *itemModel = detailModel.planitem;
        //设计方案
        [_dataItemArray addObject:itemModel];
        //检测是否下载成功
        if (_dataDetailArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        fail(nil);
    }];
}
@end
