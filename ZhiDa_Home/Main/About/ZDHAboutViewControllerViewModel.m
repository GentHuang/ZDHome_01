//
//  ZDHAboutViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/3.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHAboutViewControllerViewModel.h"
//Model
#import "ZDHAboutViewControllerModel.h"

@implementation ZDHAboutViewControllerViewModel
//获取关于志达的信息
- (void)getAboutSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataAboutArray = [NSMutableArray array];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:kGetAboutAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHAboutViewControllerModel *vcModel = [[ZDHAboutViewControllerModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        [_dataAboutArray addObject:vcModel];
        if (_dataAboutArray.count > 0) {
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
