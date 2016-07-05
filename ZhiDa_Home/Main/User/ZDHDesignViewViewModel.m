//
//  ZDHDesignViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDesignViewViewModel.h"
//Model
#import "ZDHDesignViewListModel.h"
#import "ZDHDesignViewListDesignListModel.h"
#import "ZDHDesignViewMethodListModel.h"
#import "ZDHDesignViewMethodListDesignplanListModel.h"

@implementation ZDHDesignViewViewModel
//根据MemberID获取设计列表
- (void)getListWithMemberID:(NSString *)memberID page:(NSInteger)page  success:(SuccessBlock)success fail:(FailBlock)fail{
    if (page==1) {
        //初始化数据
        _dataListArray = [NSMutableArray array];
    }
    //初始化数据
//    _dataListArray = [NSMutableArray array];
    //组建请求字符串
    NSString *urlString = [NSString stringWithFormat:kGetDesignListAPI,memberID,(long)page];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHDesignViewListModel *vcModel = [[ZDHDesignViewListModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHDesignViewListDesignListModel *listModel in vcModel.desgin_list) {
            //获取设计列表信息
            [_dataListArray addObject:listModel];
        }
        //检测是否下载成功
        if (_dataListArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        fail(nil);
    }];
}
//根据MemberID获取设计方案列表
- (void)getMethodListWithMemberID:(NSString *)memberID page:(NSInteger)page success:(SuccessBlock)success fail:(FailBlock)fail{
    if (page==1) {
        //初始化数据
        _dataMethodListArray = [NSMutableArray array];
    }
    //初始化数据
//    _dataMethodListArray = [NSMutableArray array];
    //组建请求字符串
    NSString *urlString = [NSString stringWithFormat:kGetDesignMethodListAPI,memberID,(long)page];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHDesignViewMethodListModel *vcModel = [[ZDHDesignViewMethodListModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHDesignViewMethodListDesignplanListModel *listModel in vcModel.designplan_list) {
            //获取设计方案列表信息
            [_dataMethodListArray addObject:listModel];
        }
        //检测是否下载成功
        if (_dataMethodListArray.count > 0) {
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
