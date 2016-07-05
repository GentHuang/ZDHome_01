//
//  ZDHManageViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHManageViewViewModel : NSObject
//增加给外部引用文件管理
@property (strong, nonatomic) NSFileManager *manager;

@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) NSMutableArray *sizeArray;
@property (strong, nonatomic) NSMutableArray *sceneArray;
@property (strong, nonatomic) NSMutableArray *clothesArray;

//存储可以下载的model
@property (strong, nonatomic) NSMutableArray *canUpdataModelArr;
@property (strong, nonatomic) NSMutableArray *dataModelFromNetArr;
//存储更新按钮是否可点击
@property (strong, nonatomic) NSMutableArray *iSButtonCanClikArr;
//存储下载的URL
@property (strong, nonatomic) NSMutableArray *DownloadUrlArr;

//获取空间下载列表
- (void)getSceneDownloadListWithUrlSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//获取布板下载列表
- (void)getClothesDownloadListSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//获取下载文件列表
- (void)getDowloadedFileList;
//删除文件
- (void)deleteFile:(NSString *)title;
//获取更新列表
- (void)getUpdataListSuccess:(SuccessBlock)success fail:(FailBlock)fail;

//判断Cell是否可以更新
- (void)judgeCelliSCanUpdate;
@end
