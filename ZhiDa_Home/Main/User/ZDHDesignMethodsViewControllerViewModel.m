//
//  ZDHDesignMethodsViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/30.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDesignMethodsViewControllerViewModel.h"
//Model
#import "ZDHDesignMethodsViewControllerModel.h"
#import "ZDHDesignMethodsViewControllerDesignplanIteminfoModel.h"
#import "ZDHDesignMethodsViewControllerDesignplanIteminfoListModel.h"
@implementation ZDHDesignMethodsViewControllerViewModel
//获取设计方案详情
- (void)getDesignMethodWithPlanID:(NSString *)planID itemID:(NSString *)itemID success:(SuccessBlock)success fail:(FailBlock)fail{
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kGetDesignMethodAPI,planID,itemID];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //初始化
        _dataTitleArray = [NSMutableArray array];
        _dataImageArray = [NSArray array];
        _dataItemIDArray = [NSMutableArray array];
        
        NSArray *responseArray = responseObject;
        ZDHDesignMethodsViewControllerModel *vcModel = [[ZDHDesignMethodsViewControllerModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        ZDHDesignMethodsViewControllerDesignplanIteminfoModel *infoModel = vcModel.designplan_iteminfo;
        //获取当前空间的所有图片
        _dataImageArray = [infoModel.imglist componentsSeparatedByString:@"$$$"];
        _contentString = infoModel.remarks;
        for (ZDHDesignMethodsViewControllerDesignplanIteminfoListModel *listModel in infoModel.spacelist) {
            //空间名称
            [_dataTitleArray addObject:listModel.spacename];
            //空间ID
            [_dataItemIDArray addObject:listModel.itemid];
        }
        if (_dataTitleArray.count > 2) {
            
            NSLog(@"%@",infoModel);
        }
        if (_dataTitleArray.count > 0) {
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
