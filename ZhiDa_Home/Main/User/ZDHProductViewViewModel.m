//
//  ZDHProductViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductViewViewModel.h"
//Model
#import "ZDHProductViewModel.h"
#import "ZDHProductViewShopListModel.h"
@implementation ZDHProductViewViewModel
//根据MemberID 获取商品订单列表
- (void)getProductListWithMemberID:(NSString *)memberID page:(NSInteger)page success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    if(page==1){
        _dataListArray = [NSMutableArray array];
    }
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kGetProductListAPI,memberID,(long)page];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHProductViewModel *vcModel = [[ZDHProductViewModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHProductViewShopListModel *listModel in vcModel.shop_list) {
            //获取商品订单列表
            [_dataListArray addObject:listModel];
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
@end
