//
//  ZDHDIYListViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDIYListViewControllerViewModel.h"
//Model
#import "ZDHDIYListViewControllerSpaceModel.h"
#import "ZDHDIYListViewControllerSpaceTypeListModel.h"
#import "ZDHDIYListViewControllerStyleModel.h"
#import "ZDHDIYListViewControllerStyleTypeListModel.h"
#import "ZDHDIYListViewControllerListModel.h"
#import "ZDHDIYListViewControllerListDiyListModel.h"
@implementation ZDHDIYListViewControllerViewModel
//获取空间头部
- (void)getSpaceTitleSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataSpaceTitleArray = [NSMutableArray array];
    _dataSpaceIDArray = [NSMutableArray array];
//A    //先从数据库获取数据
//    [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHDIYListViewControllerSpaceTypeListModel class] success:^(NSMutableArray *resultArray) {
//        //获取成功
//        for (ZDHDIYListViewControllerSpaceTypeListModel *listModel in resultArray) {
//            //空间头部
//            [_dataSpaceTitleArray addObject:listModel.title];
//            [_dataSpaceIDArray addObject:listModel.typeid_conflict];
//        }
//        if (_dataSpaceTitleArray.count > 0) {
//            success(nil);
//        }
//    } fail:^(NSError *error) {
//       //获取失败
//    }];
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:kDIYSpaceTitleAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *idArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHDIYListViewControllerSpaceModel *spaceModel = [[ZDHDIYListViewControllerSpaceModel alloc] init];
        [spaceModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHDIYListViewControllerSpaceTypeListModel *listModel in spaceModel.type_list) {
            //空间头部
            [titleArray addObject:listModel.title];
            [idArray addObject:listModel.typeid_conflict];
//            //存入数据库
//            [[FMDBManager sharedInstace] creatTable:listModel];
//            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:listModel];
        }
        //检测是否下载完成
        if (titleArray.count > 0) {
            _dataSpaceTitleArray = titleArray;
            _dataSpaceIDArray = idArray;
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
//获取风格头部
- (void)getStyleTitleSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataStyleTitleArray = [NSMutableArray array];
    _dataStyleIDArray = [NSMutableArray array];
//    //先从数据库获取数据
//    [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHDIYListViewControllerStyleTypeListModel class] success:^(NSMutableArray *resultArray) {
//        //获取成功
//        for (ZDHDIYListViewControllerStyleTypeListModel *listModel in resultArray) {
//            //空间头部
//            [_dataStyleTitleArray addObject:listModel.title];
//            [_dataStyleIDArray addObject:listModel.typeid_conflict];
//        }
//        if (_dataStyleTitleArray.count > 0) {
//            success(nil);
//        }
//    } fail:^(NSError *error) {
//        //获取失败
//    }];
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:kDIYStyleTitleAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *idArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHDIYListViewControllerStyleModel *spaceModel = [[ZDHDIYListViewControllerStyleModel alloc] init];
        [spaceModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHDIYListViewControllerStyleTypeListModel *listModel in spaceModel.type_list) {
            //风格头部
            [titleArray addObject:listModel.title];
            [idArray addObject:listModel.typeid_conflict];
//            //存入数据库
//            [[FMDBManager sharedInstace] creatTable:listModel];
//            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:listModel];
        }
        //检测是否下载完成
        if (titleArray.count > 0) {
            _dataStyleTitleArray = titleArray;
            _dataStyleIDArray = idArray;
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
//根据所选的空间和风格获取列表
- (void)getListWithSpaceIndex:(int)spaceIndex styleIndex:(int)styleIndex success:(SuccessBlock)success fail:(FailBlock)fail{
    
    //组建字符串
    NSString *space;
    if (spaceIndex == 9999) {
        space = @"";
    }else{
        space = _dataSpaceIDArray[spaceIndex];
    }
    NSString *style;
    if (styleIndex == 9999) {
        style = @"";
    }else{
        style = _dataStyleIDArray[styleIndex];
    }
    NSString *urlString = [NSString stringWithFormat:kDIYListAPI,space,style];
//    //先从数据库获取数据
//    [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHDIYListViewControllerListDiyListModel class] withDic:@{@"space":space,@"style":style} success:^(NSMutableArray *resultArray) {
//       //取出成功
//        for (ZDHDIYListViewControllerListDiyListModel *listModel in resultArray) {
//            //列表信息
//            [_dataListArray addObject:listModel];
//        }
//        if (_dataListArray.count > 0) {
//            success(nil);
//        }
//    } fail:^(NSError *error) {
//        //取出失败
//    }];
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //初始化
        _dataListArray = [NSMutableArray array];
        NSMutableArray *listArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHDIYListViewControllerListModel *vcModel = [[ZDHDIYListViewControllerListModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHDIYListViewControllerListDiyListModel *listModel in vcModel.diy_list) {
            listModel.space = space;
            listModel.style = style;
            //列表信息
            [listArray addObject:listModel];
//            //存入数据库
//            [[FMDBManager sharedInstace] creatTable:listModel];
//            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:listModel];
        }
        if (listArray.count > 0) {
            _dataListArray = listArray;
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
