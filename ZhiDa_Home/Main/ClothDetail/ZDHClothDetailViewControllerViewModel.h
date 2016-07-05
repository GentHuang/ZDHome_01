//
//  ZDHClothDetailViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHClothDetailViewControllerViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataFirstPageIDArray;
@property (strong, nonatomic) NSMutableArray *dataFirstPageImageArray;
@property (strong, nonatomic) NSMutableArray *dataFirstPageNameArray;
@property (strong, nonatomic) NSMutableArray *dataDetailArray;
@property (strong, nonatomic) NSMutableArray *dataAboutImageArray;
@property (strong, nonatomic) NSMutableArray *dataAboutIDArray;
@property (strong, nonatomic) NSMutableArray *dataAboutNameArray;
// 装在用途icon的model
@property (strong, nonatomic) NSMutableArray *dataUseIconArray;
@property (strong, nonatomic) NSMutableArray *dataUseIconUrlArray;

// 

//add
@property (strong, nonatomic) NSMutableArray *dataPathArray;
//获取本地详情信息
@property (strong, nonatomic) NSMutableArray *dataLocalAllInfoArray;
//对应的每个布的信息
@property (strong, nonatomic) NSMutableArray *dataLocalCorredpondingArray;
//图片字典 找出相关产品的图片
@property (strong, nonatomic) NSDictionary *LocalAllImageDict;

//首页获取布料详情，先获取所有布料信息
- (void)getFirstPageDataWithCID:(NSString *)CID  withTitleName:(NSString*)titleName success:(SuccessBlock)success fail:(FailBlock)fail;// withTitleName:(NSString*)titleName
//根据CID获取布料详情
- (void)getDataWithCID:(NSString *)CID success:(SuccessBlock)success fail:(FailBlock)fail;
//根据CID获取相关布料
- (void)getAboutClothWithCID:(NSString *)CID success:(SuccessBlock)success fail:(FailBlock)fail;
// 获取布用途icon
- (void) getClothUseIconWithClothId:(NSString *)clothid success:(SuccessBlock)success fail:(FailBlock)fail;
@end
