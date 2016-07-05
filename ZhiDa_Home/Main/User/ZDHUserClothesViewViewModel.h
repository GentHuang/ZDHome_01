//
//  ZDHUserClothesViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHUserClothesViewViewModel : NSObject
@property (strong, nonatomic) NSArray *dataClothTitleArray;

@property (strong, nonatomic) NSMutableArray *dataClothIDArray;
@property (strong, nonatomic) NSMutableArray *dataClothListIDArray;
@property (strong, nonatomic) NSMutableArray *dataClothListImageArray;
@property (strong, nonatomic) NSMutableArray *dataClothListNameArray;



//---------add-------
//存储所有文件路径
@property (strong,nonatomic) NSMutableArray *dataClothFilePathArray;
//存储离线下载ID
@property (strong, nonatomic) NSMutableArray *dataClothLocalIDArray;
//离线下载名称
@property (strong, nonatomic) NSMutableArray *dataClothLocalNameArray;
//存储首页图片的字典
@property (strong, nonatomic) NSMutableDictionary *ImageAllDict;
//base路径
@property (strong, nonatomic) NSMutableArray *dataBasePathArray;


//获取布料头部
- (void)getClothTitleSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//获取布料首页信息
- (void)getClothFirstPageSuccess:(SuccessBlock)success fail:(FailBlock)fail;

//根据年份获取布料信息
- (void)getClothInfoWithYear:(NSString*)stringYear Success:(SuccessBlock)success fail:(FailBlock)fail;

//根据TypeID获取其他布料的列表
- (void)getDataWithTypeID:(NSString *)typeID withTitleName:(NSString*)titlName success:(SuccessBlock)success fail:(FailBlock)fail;
//根据关键字获取布料搜索列表
- (void)getClothSearchListWithKeyword:(NSString *)keyword success:(SuccessBlock)success fail:(FailBlock)fail;
@end
