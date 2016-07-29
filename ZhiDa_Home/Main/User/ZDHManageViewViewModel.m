//
//  ZDHManageViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHManageViewViewModel.h"
//Model
#import "ZDHListViewModel.h"
#import "ZDHListViewSceneModel.h"
#import "ZDHListViewClothesModel.h"

@interface ZDHManageViewViewModel()
//@property (strong, nonatomic) NSFileManager *manager;
@end

@implementation ZDHManageViewViewModel
//初始化
- (instancetype)init{
    if (self = [super init]) {
        _manager = [[NSFileManager alloc] init];
    }
    return self;
}
//获取下载文件列表
- (void)getDowloadedFileList{
    //清空数据
    _titleArray = [NSMutableArray array];
    _sizeArray = [NSMutableArray array];
    NSArray *fileList = [_manager contentsOfDirectoryAtPath:[self getStorePath] error:nil];
    BOOL isDownloadFile;
    BOOL isDir;
    for (NSString *fileName in fileList) {
        // 判断路径是否存在同时isDir是否为文件夹
        isDownloadFile = [_manager fileExistsAtPath:[self getUnZipPath:fileName] isDirectory:&isDir];
        if (isDownloadFile && isDir) {
            [_titleArray addObject:fileName];
            float size = [self folderSizeAtPath:[self getUnZipPath:fileName]];
            NSString *sizeString = [NSString stringWithFormat:@"%.02fMB",size];
            [_sizeArray addObject:sizeString];
        }
    }
}
//获取存储文件的地址
- (NSString *)getStorePath{
    NSLog(@"文件保存的位置----->%@",DownloadPath);
    return DownloadPath;
}
//获取文件地址
- (NSString *)getUnZipPath:(NSString *)titleText{
    return [DownloadPath stringByAppendingFormat:@"/%@",titleText];
}
//遍历文件夹获得文件夹大小，返回多少M
- (float )folderSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
//单个文件的大小
- (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//删除文件
- (void)deleteFile:(NSString *)title{
//    [self ]
    [_manager removeItemAtPath:[self getUnZipPath:title] error:nil];
}
//获取空间下载列表
- (void)getSceneDownloadListWithUrlSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化数据
    _sceneArray = [NSMutableArray array];
    //获取数据
    [[ZDHNetworkManager sharedManager] GET:kSceneDownloadListAPI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ZDHListViewModel *viewModel = [[ZDHListViewModel alloc] init];
        [viewModel setValuesForKeysWithDictionary:responseObject];
        for (ZDHListViewSceneModel *sceneModel in viewModel.scene) {
            [_sceneArray addObject:sceneModel];
        }
        if (_sceneArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(nil);
    }];
}
//获取布板下载列表
- (void)getClothesDownloadListSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化数据
    _clothesArray = [NSMutableArray array];
    //获取数据
    [[ZDHNetworkManager sharedManager] GET:kClothesDownloadListAPI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ZDHListViewModel *viewModel = [[ZDHListViewModel alloc] init];
        [viewModel setValuesForKeysWithDictionary:responseObject];
        for (ZDHListViewClothesModel *clothModel in viewModel.cloths) {
            [_clothesArray addObject:clothModel];
        }
        if (_clothesArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        fail(nil);
    }];
}
//获取已下载的列表
- (void)getUpdataListSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化数据
    _canUpdataModelArr = [NSMutableArray array];
    _dataModelFromNetArr = [NSMutableArray array];
    _DownloadUrlArr = [NSMutableArray array];
    __block BOOL isScene = NO;
    __block BOOL isCloth = NO;
    //从数据库获取已下载的列表
    [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHListViewSceneModel class] success:^(NSMutableArray *resultArray) {
        //获取成功
        for (ZDHListViewSceneModel *allModel in resultArray) {
            if (_sceneArray.count > 0) {
                for (ZDHListViewSceneModel *sceneModel in _sceneArray) {
                    if([allModel.name isEqualToString:sceneModel.name]){
                        //存储网络和数据库获取的模型数据
                        [_canUpdataModelArr addObject:allModel];
                        [_dataModelFromNetArr addObject:sceneModel];
                        //下载URL
                        [_DownloadUrlArr addObject:sceneModel.downurl];
                    }
                }
            }
        }
        isScene = YES;
        if (isScene && isCloth) {
            success(nil);
        }
    } fail:^(NSError *error) {
        //获取失败
        isScene = YES;
        if (isScene && isCloth) {
            fail(nil);
        }
    }];
    
    [[FMDBManager sharedInstace] selectModelArrayInDatabase:[ZDHListViewClothesModel class] success:^(NSMutableArray *resultArray) {
        //获取成功
        for (ZDHListViewClothesModel *allModel in resultArray) {
            //把字符串存入数组
            [_iSButtonCanClikArr addObject:@"no"];
            //把字符串存入数组
            if (_clothesArray.count > 0) {
                for (ZDHListViewClothesModel *clothModel in _clothesArray) {
                    //取出管理列表的模型以及下载链接
                    if([allModel.name isEqualToString:clothModel.name]){
                        //存储网络和数据库获取的模型数据
                        [_canUpdataModelArr addObject:allModel];
                        [_dataModelFromNetArr addObject:clothModel];
                        //下载URL
                        [_DownloadUrlArr addObject:clothModel.downurl];
                    }
                }
            }
        }
        isCloth = YES;
        if (isScene && isCloth) {
            success(nil);
        }
    } fail:^(NSError *error) {
        //获取失败
        isCloth = YES;
        if (isScene && isCloth) {
            fail(nil);
        }
        
    }];
}
//判断Cell是否可以更新
- (void)judgeCelliSCanUpdate{
    //存储是否可更新
    _iSButtonCanClikArr = [NSMutableArray array];
    int i = 0;
    for (ZDHListViewClothesModel *allModel in _canUpdataModelArr) {
       [_iSButtonCanClikArr addObject:@"no"];
        for (ZDHListViewClothesModel *model in _dataModelFromNetArr) {
            if ([allModel.name isEqualToString:model.name]&&[allModel.byte floatValue] < [model.byte floatValue]) {
//                NSLog(@"%@ == %@",allModel.name,model.name);NSLog(@"%f   %f",[allModel.byte floatValue] ,[model.byte floatValue]);
                //如果满足可更新，存入“yes”
                [_iSButtonCanClikArr replaceObjectAtIndex:i withObject:@"yes"];
            }
        }
        i++;
    }
}

@end
