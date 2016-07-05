//
//  ZDHDIYDetailViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/13.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDIYDetailViewControllerViewModel.h"
//Model
#import "ZDHDIYDetailViewControllerModel.h"
#import "ZDHDIYDetailViewControllerDiyDetailModel.h"
#import "ZDHDIYDetailViewControllerDiyDetailDiyproListModel.h"
#import "ZDHDIYDetailViewControllerDiyDetailProListModel.h"
#import "ZDHDIYDetailViewControllerDiyDetailTypeListModel.h"
#import "ZDHDIYDetailViewControllerChangeListModel.h"
#import "ZDHDIYDetailViewControllerChangeListDiyProbytypeListModel.h"
#import "ZDHDIYDetailViewControllerPressModel.h"
#import "ZDHDIYDetailViewControllerPressDiyGetdiyproModel.h"
#import "ZDHDIYDetailViewControllerPressDiyGetdiyproProListModel.h"

@implementation ZDHDIYDetailViewControllerViewModel

- (instancetype) init{
    
    if (self = [super init]) {
        
        _storeImageArray = [NSMutableArray array];
    }
    return self;
}

//获取DIY详细数据
- (void)getDataWithID:(NSString *)ID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataDiyproArray = [NSMutableArray array];
    _dataProImageArray = [NSMutableArray array];
    _dataProTitleArray = [NSMutableArray array];
    _dataProIDArray = [NSMutableArray array];
    _dataTypeIDArray = [NSMutableArray array];
    _dataTypeTitleArray = [NSMutableArray array];
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kDIYDetailAPI,ID];
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        
        NSArray *responseArray = responseObject;
        ZDHDIYDetailViewControllerModel *vcModel = [[ZDHDIYDetailViewControllerModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        ZDHDIYDetailViewControllerDiyDetailModel *detailModel = vcModel.diy_detail;
        //加载背景大图
        _backgroundImageString = detailModel.appimg;
        //加载默认的替换序列
        _olddiyproid = detailModel.hiddiyproid;
        
        for (ZDHDIYDetailViewControllerDiyDetailDiyproListModel *diyproModel in detailModel.diypro_list) {
            
            //家居DIY产品组合
            [_dataDiyproArray addObject:diyproModel];
        }
        
        for (ZDHDIYDetailViewControllerDiyDetailProListModel *prolistModel in detailModel.pro_list) {
            //产品清单
            // 图片
            [_dataProImageArray addObject:prolistModel.bottomimg];
            // 风格+名字
            [_dataProTitleArray addObject:prolistModel.proname];
            // id
            [_dataProIDArray addObject:prolistModel.proid];
            
        }
        for (ZDHDIYDetailViewControllerDiyDetailTypeListModel *typelistModel in detailModel.type_list) {
            //产品替换--分类
            [_dataTypeIDArray addObject:typelistModel.typeid_conflict];
            [_dataTypeTitleArray addObject:typelistModel.title];
        }
        if (_backgroundImageString.length > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        fail(nil);
    }];
}
//获取所有产品替换的信息
/**
 *窗帘：http://183.238.196.216:8088/diy.ashx?m=diy_diyprobytype&id=13&protype=101001002
 *床： http://183.238.196.216:8088/diy.ashx?m=diy_diyprobytype&id=13&protype=101001019004
 *柜： http://183.238.196.216:8088/diy.ashx?m=diy_diyprobytype&id=13&protype=101001021003
 */
- (void)getDataWIthTypeIDArray:(NSArray *)idArray ID:(NSString *)ID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataChangeArray = [NSMutableArray array];
    //下载数据
    for (int i = 0; i < idArray.count; i ++) {
        //组建字符串
        NSString *urlString = [NSString stringWithFormat:kDIYChangeListAPI,ID,idArray[i]];
        //下载数据
        [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
            
            NSArray *responseArray = responseObject;
            ZDHDIYDetailViewControllerChangeListModel *changeModel = [[ZDHDIYDetailViewControllerChangeListModel alloc] init];
            [changeModel setValuesForKeysWithDictionary:[responseArray firstObject]];
            
            for (ZDHDIYDetailViewControllerChangeListDiyProbytypeListModel *listModel in changeModel.diyProbytype_List) {
                
                //产品替换信息
                [_dataChangeArray addObject:listModel];
            }
            //检测是否请求成功
            if (_dataChangeArray.count > 0) {
                success(nil);
            }else{
                fail(nil);
            }
        } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//            NSLog(@"%@",error);
            fail(nil);
        }];
    }
}
//根据类型获取产品替换信息
- (void)getDataWithProType:(NSString *)protype changeArray:(NSArray *)changeArray{
    //初始化
    _dataChangeImageArray = [NSMutableArray array];
    _dataChangeTitleArray = [NSMutableArray array];
    _dataChangeIDArray = [NSMutableArray array];
    //对应每一张图片的ID
    _dataEveryImageIDArray = [NSMutableArray array];
    //产品替换小图和标题
    for (ZDHDIYDetailViewControllerChangeListDiyProbytypeListModel *listModel in changeArray) {
        if ([listModel.ProType isEqualToString:protype]) {
            [_dataChangeImageArray addObject:listModel.Bottomimg];
            [_dataChangeTitleArray addObject:listModel.ProName];
            [_dataChangeIDArray addObject:listModel.id_conflict];
            
            //************  在这里添加替换图片的 ID  ****************
            if (listModel.proid) {
                [_dataEveryImageIDArray addObject:listModel.proid];
            }
        }
    }
}
//根据替换产品的ID，所处分类的Index，组合ID，获取图片
- (void)getDataWithPID:(NSString *)pid typeIndex:(NSInteger)typeIndex olddiyproid:(NSString *)olddiyproid success:(SuccessBlock)success fail:(FailBlock)fail{
    if (pid != nil) {
        //初始化
        _dataUpImageArray = [NSMutableArray array];
        //组建字符串（转换中文字符）
        NSString *urlString = [NSString stringWithFormat:kDIYPressedAPI,pid,[NSString stringWithFormat:@"%ld",(long)typeIndex],olddiyproid];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //下载数据
        [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
            
            NSArray *responseArray = responseObject;
            ZDHDIYDetailViewControllerPressModel *pressModel = [[ZDHDIYDetailViewControllerPressModel alloc] init];
            [pressModel setValuesForKeysWithDictionary:[responseArray firstObject]];
            ZDHDIYDetailViewControllerPressDiyGetdiyproModel *proModel = pressModel.diy_getdiypro;
            //获取新的替换序列
            _olddiyproid = proModel.newhidproid;
            [_dataUpImageArray addObject:proModel.appimg];
            _updateImageView = proModel.appimg;
            if (_dataUpImageArray.count > 0) {
                success(nil);
            }else{
                fail(nil);
            }
        } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//            NSLog(@"%@",error);
            fail(nil);
        }];
    }
}
@end
