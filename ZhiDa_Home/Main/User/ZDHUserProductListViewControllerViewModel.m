//
//  ZDHUserProductListViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/30.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserProductListViewControllerViewModel.h"
//Model
#import "ZDHUserProductListViewControllerModel.h"
#import "ZDHUserProductListViewControllerItemproinfoModel.h"
#import "ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel.h"
#import "ZDHUserProductListViewControllerItemproinfoSpaceproinfoProdetailModel.h"

@implementation ZDHUserProductListViewControllerViewModel
//获取清单列表
- (void)getDataWithPlanID:(NSString *)planID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataSpaceArray = [NSMutableArray array];
    _dataItemInfoArray = [NSMutableArray array];
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kGetDesignMethodProListAPI,planID];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHUserProductListViewControllerModel *vcModel = [[ZDHUserProductListViewControllerModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        ZDHUserProductListViewControllerItemproinfoModel *infoModel = vcModel.designplan_itemproinfo;
        [_dataItemInfoArray addObject:infoModel];
        for (ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel *spaceModel in infoModel.spaceproinfo) {
            //获取所有的清单信息
            [_dataSpaceArray addObject:spaceModel];
        }
        if (_dataSpaceArray.count > 0) {
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
