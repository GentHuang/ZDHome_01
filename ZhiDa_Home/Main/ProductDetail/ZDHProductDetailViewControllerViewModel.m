//
//  ZDHProductDetailViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductDetailViewControllerViewModel.h"
//Model
#import "ZDHProductDetailViewModel.h"
#import "ZDHProductDetailViewProductModel.h"
#import "ZDHAllSingleModel.h"
#import "ZDHAllSingleProinfoModel.h"
@implementation ZDHProductDetailViewControllerViewModel
//根据产品ID获取详情
- (void)getDataWithPID:(NSString *)PID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataProductArray = [NSMutableArray array];
    //组建下载地址
    NSString *urlString = [NSString stringWithFormat:kSingleDetailAPI,PID];
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHProductDetailViewModel *vcModel = [[ZDHProductDetailViewModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHProductDetailViewProductModel *productModel in vcModel.product) {
            //获取产品详情
            [_dataProductArray addObject:productModel];
            //获取顶部标题信息
            if([productModel.protype isEqualToString:@"窗帘"]){
                _titleButtonNameArray = [NSMutableArray arrayWithObjects:@"脱底图",@"局部图",@"场景图",@"款式图", nil];
                _dataTopTitleArray = [NSMutableArray arrayWithObjects:productModel.bottomimg,productModel.partimgone_app,productModel.sceneimgone_app,productModel.styleimg, nil];
            }
            else{
                _titleButtonNameArray = [NSMutableArray arrayWithObjects:@"脱底图",@"局部图",@"场景图",@"尺寸图", nil];
                _dataTopTitleArray = [NSMutableArray arrayWithObjects:productModel.bottomimg,productModel.partimgone_app,productModel.sceneimgone_app,productModel.sizeimg, nil];
            }
            //获取pronumber
            _pronumber = productModel.pronumber;
        }
        if (_dataProductArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        
        fail(nil);
    }];
}
//根据产品ID和Pronumber获取相关单品
- (void)getAboutSingleWithPID:(NSString *)PID pronumber:(NSString *)pronumber success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataAboutSingleIDArray = [NSMutableArray array];
    _dataAboutSingleImageArray = [NSMutableArray array];
    //组建下载地址
    NSString *urlString = [NSString stringWithFormat:kAllSingleAPI,PID,pronumber];
    //--------------------如果url有中文字符，需要转码----------------------
    for (int i=0 ; i <[urlString length]; i++) {
        NSString *subString = [urlString substringWithRange:NSMakeRange(i, 1)];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            //    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlString,NULL,NULL,kCFStringEncodingUTF8));
            break;
        }
    }
    //----------------------------------------------------------------
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHAllSingleModel *vcModel = [[ZDHAllSingleModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHAllSingleProinfoModel *infoModel in vcModel.proinfo) {
            //获取所有相关单品信息
            [_dataAboutSingleIDArray addObject:infoModel.id_conflict];
            [_dataAboutSingleImageArray addObject:infoModel.imgurl];
        }
        if (_dataAboutSingleImageArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
//根据产品ID获取推荐组合
- (void)getAboutProductWithPID:(NSString *)PID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataAboutProductIDArray = [NSMutableArray array];
    _dataAboutProductImageArray = [NSMutableArray array];
    //组建下载地址
    NSString *urlString = [NSString stringWithFormat:kRecommendAPI,PID];
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHAllSingleModel *vcModel = [[ZDHAllSingleModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHAllSingleProinfoModel *infoModel in vcModel.proinfo) {
            //获取所有相关单品信息
            [_dataAboutProductIDArray addObject:infoModel.id_conflict];
            [_dataAboutProductImageArray addObject:infoModel.imgurl];
        }
        if (_dataAboutProductImageArray.count > 0) {
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
