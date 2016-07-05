//
//  ZDHGroupViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/17.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHGroupViewControllerViewModel.h"
//Model
#import "ZDHGroupViewControllerBannerModel.h"
#import "ZDHGroupViewControllerBannerDesignteamBannerModel.h"
#import "ZDHGroupViewControllerMainDesignerModel.h"
#import "ZDHGroupViewControllerMainDesignerTopModel.h"
#import "ZDHGroupViewControllerDesignerGroupModel.h"
#import "ZDHGroupViewControllerDesignerGroupListModel.h"

@implementation ZDHGroupViewControllerViewModel
//获取Banner
- (void)getBannerSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:kDesignerBannerAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHGroupViewControllerBannerModel *vcModel = [[ZDHGroupViewControllerBannerModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        ZDHGroupViewControllerBannerDesignteamBannerModel *bannerModel = vcModel.designteam_banner;
        //获取banner
        _dataBannerString = bannerModel.banner;
        if (_dataBannerString.length > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
//获取首席设计师信息
- (void)getMainDesignerSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:kDesignerTopAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHGroupViewControllerMainDesignerModel *vcModel = [[ZDHGroupViewControllerMainDesignerModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        ZDHGroupViewControllerMainDesignerTopModel *topModel = vcModel.designteam_top1;
        //获取信息
        _dataMainImageString = topModel.smallimg;
        _dataMainNameString = topModel.title;
        _dataMainJobString = topModel.job;
        _dataMainIntroString = topModel.intro;
        //检测是否下载完成
        if (_dataMainNameString.length > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
//获取设计师团队信息
- (void)getDesignerGroupSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataGroupImageArray = [NSMutableArray array];
    _dataGroupNameArray = [NSMutableArray array];
    _dataGroupJobArray = [NSMutableArray array];
    _dataGroupIntroArray = [NSMutableArray array];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:kDesignerGroupAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHGroupViewControllerDesignerGroupModel *vcModel = [[ZDHGroupViewControllerDesignerGroupModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHGroupViewControllerDesignerGroupListModel *listModel in vcModel.designteam_list) {
            //设计师团队信息
            [_dataGroupImageArray addObject:listModel.smallimg];
            [_dataGroupNameArray addObject:listModel.title];
            [_dataGroupJobArray addObject:listModel.job];
            [_dataGroupIntroArray addObject:listModel.intro];
        }
        //检测是否下载完成
        if (_dataGroupImageArray.count > 0) {
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
