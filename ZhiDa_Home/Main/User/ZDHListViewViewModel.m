//
//  ZDHListViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHListViewViewModel.h"
#import "ZDHNetworkManager.h"
//Model
#import "ZDHListViewModel.h"
#import "ZDHListViewSceneModel.h"
#import "ZDHListViewClothesModel.h"
@implementation ZDHListViewViewModel
//获取空间下载列表
- (void)getSceneDownloadListWithUrlSuccess:(SuccessBlock)success fail:(FailBlock)fail{

//    NSLog(@"志达==%@  %@",kSceneDownloadListAPI,kClothesDownloadListAPI);
    //获取数据
    [[ZDHNetworkManager sharedManager] GET:kSceneDownloadListAPI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"空间----->%@",kSceneDownloadListAPI);
        //初始化数据
        _sceneArray = [NSMutableArray array];
        //压缩包描述
        _allpacksArray = [NSMutableArray array];
        
        ZDHListViewModel *viewModel = [[ZDHListViewModel alloc] init];
        [viewModel setValuesForKeysWithDictionary:responseObject];
        for (ZDHListViewSceneModel *sceneModel in viewModel.scene) {
            [_sceneArray addObject:sceneModel];
            //add
            [_allpacksArray addObject:sceneModel.allpacks];
        }
        if (_sceneArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        NSLog(@"网络出错咯%@",error);
        fail(nil);
    }];
}
//获取布板下载列表
- (void)getClothesDownloadListSuccess:(SuccessBlock)success fail:(FailBlock)fail{

    //获取数据
    [[ZDHNetworkManager sharedManager] GET:kClothesDownloadListAPI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"布板下载----->%@",kClothesDownloadListAPI);
        //初始化数据
        _clothesArray = [NSMutableArray array];
        _clothAllpacksArray = [NSMutableArray array];
        
        ZDHListViewModel *viewModel = [[ZDHListViewModel alloc] init];
        [viewModel setValuesForKeysWithDictionary:responseObject];
        for (ZDHListViewClothesModel *clothModel in viewModel.cloths) {
            [_clothesArray addObject:clothModel];
            //add
            [_clothAllpacksArray addObject:clothModel.allpacks];

        }
        if (_clothesArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"网络出错咯%@",error);
        fail(nil);
    }];
}
@end
