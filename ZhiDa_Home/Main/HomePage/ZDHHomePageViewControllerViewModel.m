//
//  ZDHHomePageViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/16.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHHomePageViewControllerViewModel.h"
//Model
#import "ZDHHomePageViewControllerDIYModel.h"
#import "ZDHHomePageViewControllerDIYHotdiyModel.h"
#import "ZDHHomePageViewControllerDesignerModel.h"
#import "ZDHHomePageViewControllerDesignerListModel.h"
#import "ZDHHomePageViewControllerHotModel.h"
#import "ZDHHomePageViewControllerHotHotproductModel.h"
//add
#import "ZDHHomePageViewControllerHearScrollModel.h"
#import "ZDHHomePageViewControllerHearScrollBrannerModel.h"

@implementation ZDHHomePageViewControllerViewModel
//获取DIY信息
- (void)getDIYDataSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:kDIYHomePageAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //初始化
        _dataDIYIDArray = [NSMutableArray array];
        _dataDIYImageArray = [NSMutableArray array];
        _dataDIYNameArray = [NSMutableArray array];
        
        NSMutableArray *IDArray = [NSMutableArray array];
        NSMutableArray *ImageArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHHomePageViewControllerDIYModel *diyModel = [[ZDHHomePageViewControllerDIYModel alloc] init];
        [diyModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHHomePageViewControllerDIYHotdiyModel *hotDiyModel in diyModel.hotdiy) {
            //DIY数据
            //
            if (hotDiyModel.aboutid) {
                [IDArray addObject:hotDiyModel.aboutid];
            }else{
                [IDArray addObject:hotDiyModel.id_conflict];
            }
            [ImageArray addObject:hotDiyModel.smallimg];
            [_dataDIYNameArray addObject:hotDiyModel.title];
            //存进数据库
            [[FMDBManager sharedInstace] creatTable:hotDiyModel];
            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:hotDiyModel];
        }
        //检测是否下载成功
        if (ImageArray.count > 0) {
            _dataDIYImageArray = ImageArray;
            _dataDIYIDArray = IDArray;
            success(nil);
        }else{
            //下载失败就从数据库取出旧数据
            [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHHomePageViewControllerDIYHotdiyModel class] success:^(NSMutableArray *resultArray) {
                //取出成功
                for (ZDHHomePageViewControllerDIYHotdiyModel *hotDiyModel in resultArray) {
                    //DIY数据
                    [_dataDIYIDArray addObject:hotDiyModel.id_conflict];
                    [_dataDIYImageArray addObject:hotDiyModel.smallimg];
                    [_dataDIYNameArray addObject:hotDiyModel.title];
                }
                if (_dataDIYImageArray.count > 0) {
                    success(nil);
                }
            } fail:^(NSError *error) {
                //取出失败
                fail(nil);
            }];
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        //下载失败就从数据库取出旧数据
        [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHHomePageViewControllerDIYHotdiyModel class] success:^(NSMutableArray *resultArray) {
            //取出成功
            for (ZDHHomePageViewControllerDIYHotdiyModel *hotDiyModel in resultArray) {
                //DIY数据
                [_dataDIYIDArray addObject:hotDiyModel.id_conflict];
                [_dataDIYImageArray addObject:hotDiyModel.smallimg];
            }
            if (_dataDIYImageArray.count > 0) {
                success(nil);
            }
        } fail:^(NSError *error) {
            //取出失败
            fail(nil);
        }];
    }];
}
//获取设计师信息
- (void)getDesignerDataSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:kDesignerHomePageAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //初始化
        _dataDesignerImageArray = [NSMutableArray array];
        _dataDesignerIntroArray = [NSMutableArray array];
        _dataDesignerNameArray = [NSMutableArray array];
        
        NSMutableArray *nameArray = [NSMutableArray array];
        NSMutableArray *imageArray = [NSMutableArray array];
        NSMutableArray *introArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHHomePageViewControllerDesignerModel *diyModel = [[ZDHHomePageViewControllerDesignerModel alloc] init];
        [diyModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHHomePageViewControllerDesignerListModel *listModel in diyModel.designteam_list) {
            //获取设计师信息
            [nameArray addObject:listModel.title];
            [imageArray addObject:listModel.smallimg];
            [introArray addObject:listModel.job];
            //存入数据库
            [[FMDBManager sharedInstace] creatTable:listModel];
            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:listModel];
        }
        if (introArray.count > 0) {
            _dataDesignerImageArray = imageArray;
            _dataDesignerIntroArray = introArray;
            _dataDesignerNameArray = nameArray;
            success(nil);
        }else{
            //下载失败就从数据库取出旧数据
            [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHHomePageViewControllerDesignerListModel class] success:^(NSMutableArray *resultArray) {
                //取出成功
                for (ZDHHomePageViewControllerDesignerListModel *listModel in resultArray) {
                    //获取设计师信息
                    [_dataDesignerNameArray addObject:listModel.title];
                    [_dataDesignerImageArray addObject:listModel.smallimg];
                    [_dataDesignerIntroArray addObject:listModel.job];
                }
                if (_dataDesignerImageArray.count > 0) {
                    success(nil);
                }
            } fail:^(NSError *error) {
                //取出失败
                fail(nil);
            }];
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        //下载失败就从数据库取出旧数据
        [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHHomePageViewControllerDesignerListModel class] success:^(NSMutableArray *resultArray) {
            //取出成功
            for (ZDHHomePageViewControllerDesignerListModel *listModel in resultArray) {
                //获取设计师信息
                [_dataDesignerNameArray addObject:listModel.title];
                [_dataDesignerImageArray addObject:listModel.smallimg];
                [_dataDesignerIntroArray addObject:listModel.job];
            }
            if (_dataDesignerImageArray.count > 0) {
                success(nil);
            }
        } fail:^(NSError *error) {
            //取出失败
            fail(nil);
        }];
    }];
}
//根据GroupID获取热门产品
- (void)getHotDataWithGroupID:(NSString *)groupID success:(SuccessBlock)success fail:(FailBlock)fail{
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kGetHotAPI,groupID];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {

        NSMutableArray *imageArray = [NSMutableArray array];
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *descArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHHomePageViewControllerHotModel *vcModel = [[ZDHHomePageViewControllerHotModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHHomePageViewControllerHotHotproductModel *hotModel in vcModel.hotproduct) {
            //获取热门产品
            _groupID = hotModel.groupid;
            hotModel.curGroupid = groupID;
            [imageArray addObject:hotModel.proimg];
            [titleArray addObject:hotModel.proname];
            [descArray addObject:hotModel.proremarks];
            
            //存入数据库
            [[FMDBManager sharedInstace] creatTable:hotModel];
            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:hotModel];
        }
        if (imageArray.count > 0) {
            //初始化
            _dataHotIDArray = [NSMutableArray array];
            _dataHotImageArray = [NSMutableArray array];
            _dataHotTitleArray = [NSMutableArray array];
            _dataHotDescArray = [NSMutableArray array];
            for (ZDHHomePageViewControllerHotHotproductModel *hotModel in vcModel.hotproduct) {
               if(![hotModel.aboutproduct isEqualToString:@""]){
                  [_dataHotIDArray addObject:hotModel.aboutproduct];
               }
             }
            
            _dataHotImageArray = imageArray;
            _dataHotTitleArray = titleArray;
            _dataHotDescArray = descArray;
            success(nil);
        }else{
            //获取数据为零的时候，从新赋值
            _groupID = @"";
            //下载失败就从数据库取出旧数据
            [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHHomePageViewControllerHotHotproductModel class] withDic:@{@"curGroupid":groupID} success:^(NSMutableArray *resultArray) {
                if(resultArray.count > 0){
                    
                    _dataHotImageArray = [NSMutableArray array];
                    _dataHotTitleArray = [NSMutableArray array];
                    _dataHotDescArray = [NSMutableArray array];
                }
                //取出成功
                for (ZDHHomePageViewControllerHotHotproductModel *hotModel in resultArray) {
                    [_dataHotImageArray addObject:hotModel.proimg];
                    [_dataHotTitleArray addObject:hotModel.proname];
                    [_dataHotDescArray addObject:hotModel.proremarks];
                }
                for (ZDHHomePageViewControllerHotHotproductModel *hotModel in resultArray) {
                    if(![hotModel.aboutproduct isEqualToString:@""]){
                        [_dataHotIDArray addObject:hotModel.aboutproduct];
                    }
                }
                if (_dataHotImageArray.count > 0) {
                    success(nil);
                }
            } fail:^(NSError *error) {
                //取出失败
                fail(nil);
            }];
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        //下载失败就从数据库取出旧数据
        [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHHomePageViewControllerHotHotproductModel class] withDic:@{@"curGroupid":groupID} success:^(NSMutableArray *resultArray) {
            //取出成功
            for (ZDHHomePageViewControllerHotHotproductModel *hotModel in resultArray) {
                [_dataHotImageArray addObject:hotModel.proimg];
                [_dataHotTitleArray addObject:hotModel.proname];
                [_dataHotDescArray addObject:hotModel.proremarks];
            }
            if (_dataHotImageArray.count > 0) {
                success(nil);
            }
        } fail:^(NSError *error) {
            //取出失败
            fail(nil);
        }];
    }];
}
//获取头部滚动视图图片
- (void)getHearScrollImageDataSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    
    [[ZDHNetworkManager sharedManager] GET:KGetHomePageHearScrollImage parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        _dataHearScrollImageArray = [NSMutableArray array];
        _dataHearScrollUrlArray = [NSMutableArray array];
        ZDHHomePageViewControllerHearScrollModel *scrollModel = [[ZDHHomePageViewControllerHearScrollModel alloc]init];
        //存入字典
        [scrollModel setValuesForKeysWithDictionary:[responseObject firstObject]];
        for (ZDHHomePageViewControllerHearScrollBrannerModel *brannerModel in scrollModel.banner_list) {
            [_dataHearScrollImageArray addObject:brannerModel.imgurl];
            [_dataHearScrollUrlArray addObject:brannerModel.link];
           
        }
        if (_dataHearScrollImageArray.count>0) {
            success(nil);
        }        
    } failure:^ void(AFHTTPRequestOperation * opertation, NSError * error) {
        //获取失败
        fail(nil);
    }];
}
@end
