//
//  ZDHProductListViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductListViewControllerViewModel.h"
//Model
#import "ZDHProductListViewControllerModel.h"
#import "ZDHProductListViewControllerSearchProductModel.h"
#import "ZDHSearchViewControllerListModel.h"
#import "ZDHSearchViewControllerListNewsSearchModel.h"
#import "ZDHSearchViewControllerNewListModel.h"
#import "ZDHSearchViewControllerNewListProtypelistModel.h"
@implementation ZDHProductListViewControllerViewModel
//获取搜索产品列表
- (void)getProductListWithKeyWord:(NSString *)keyword brand:(NSString *)brand type:(NSString *)type space:(NSString *)space style:(NSString *)style success:(SuccessBlock)success fail:(FailBlock)fail{
    
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kGetSearchProListAPI,brand,style,space,type,keyword];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //初始化
        _dataProListArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHProductListViewControllerModel *vcModel = [[ZDHProductListViewControllerModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHProductListViewControllerSearchProductModel *proModel in vcModel.search_product) {
            //获取产品列表信息
            [_dataProListArray addObject:proModel];
        }
        if (_dataProListArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {

        fail(nil);
    }];
}

// 获取顶部按钮数据
- (void) getProductListWithKeyWord:(NSString *)keyword brand:(NSString *)brand type:(NSString *)type space:(NSString *)space style:(NSString *)style order:(NSString *)order clothid:(NSString *)clothId success:(SuccessBlock)success fail:(FailBlock)fail{
    
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kGetSearchClassifyAPI,brand,style,space,type,keyword,order,clothId];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //初始化
        _dataProListArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHProductListViewControllerModel *vcModel = [[ZDHProductListViewControllerModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHProductListViewControllerSearchProductModel *proModel in vcModel.search_product) {
            //获取产品列表信息
            [_dataProListArray addObject:proModel];
        }
        if (_dataProListArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {

        fail(nil);
    }];
}

// 获取左边下拉选择栏第三级的数据
- (void) getProductListWithKeyWord:(NSString *)keyword brand:(NSString *)brand type:(NSString *)type space:(NSString *)space style:(NSString *)style secondtype:(NSString *)secondtype success:(SuccessBlock)success fail:(FailBlock)fail{
    
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kGetSearchThirdCellAPI,brand,style,space,type,secondtype,keyword];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        //初始化
        _dataProListArray = [NSMutableArray array];
        ZDHProductListViewControllerModel *vcModel = [[ZDHProductListViewControllerModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHProductListViewControllerSearchProductModel *proModel in vcModel.search_product) {
            //获取产品列表信息
            [_dataProListArray addObject:proModel];
        }
        if (_dataProListArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        
        fail(nil);
    }];
}


//获取左边下拉搜索列表
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

        fail(nil);
    }];
}

//获取商品分类右边下拉
- (void)getSearchPruductCategorySuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:kGetSearchProductAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        
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
        fail(nil);
    }];
}

@end
