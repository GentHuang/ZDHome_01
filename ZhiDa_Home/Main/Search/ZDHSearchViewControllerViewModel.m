//
//  ZDHSearchViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHSearchViewControllerViewModel.h"
//Model
#import "ZDHSearchViewControllerListModel.h"
#import "ZDHSearchViewControllerListNewsSearchModel.h"
#import "ZDHSearchViewControllerListNewsSearchSearchTModel.h"
#import "ZDHSearchViewControllerHotWordModel.h"
#import "ZDHSearchViewControllerHotWordHotsearchWordModel.h"

#import "ZDHSearchViewControllerNewListModel.h"
#import "ZDHSearchViewControllerNewListProtypelistModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel.h"


@implementation ZDHSearchViewControllerViewModel
//获取搜索列表
- (void)getSearchListSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:kGetSearchListAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //初始化
        _dataListArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHSearchViewControllerListModel *vcModel = [[ZDHSearchViewControllerListModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHSearchViewControllerListNewsSearchModel *searchModel in vcModel.news_search) {
            //获取搜索列表信息
            [_dataListArray addObject:searchModel];
        }
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
//获取热门搜索
- (void)getHotWordSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataHotArray = [NSMutableArray array];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:kGetSearchHotWordAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        
        NSArray *responseArray = responseObject;
//        NSLog(@"------>search = %@",kGetSearchHotWordAPI);
        ZDHSearchViewControllerHotWordModel *vcModel = [[ZDHSearchViewControllerHotWordModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHSearchViewControllerHotWordHotsearchWordModel *wordModel in vcModel.hotsearch_word) {
            //获取热门搜索
            [_dataHotArray addObject:wordModel];
        }
        if (_dataHotArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}

//获取商品分类
- (void)getSearchPruductCategorySuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:kGetSearchProductAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        
//        NSLog(@"----->产品列表%@",kGetSearchProductAPI);
        //初始化
        _dataProdutArray = [NSMutableArray array];
        //获取数据
        NSArray *responseArray = responseObject;
        ZDHSearchViewControllerNewListModel *vcModel = [[ZDHSearchViewControllerNewListModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHSearchViewControllerNewListProtypelistModel *listModel in vcModel.protypelist) {
            [_dataProdutArray addObject:listModel];
        }
        if (_dataProdutArray.count > 0) {
            //获取成功
            success(nil);
        }else{
            //获取失败
            fail(nil);
        }
        
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
//根据商品分类返回商品分类ID
- (void)transfromProductTypeWithTypeString:(NSString *)typeString{
    _dataProdutIDString = @"";
    for (ZDHSearchViewControllerNewListProtypelistModel *listModel in _dataProdutArray) {
        for (ZDHSearchViewControllerNewListProtypelistChindtypeModel *typeModel in listModel.chindtype) {
            if ([typeModel.typename_conflict isEqualToString:typeString]) {
                _dataProdutIDString = typeModel.typeid_conflict;
            }
        }
    }
}
@end
