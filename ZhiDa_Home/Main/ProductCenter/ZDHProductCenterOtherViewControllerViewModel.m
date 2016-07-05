//
//  ZDHProductCenterOtherViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductCenterOtherViewControllerViewModel.h"
//Model
#import "ZDHProductCenterOtherViewControllerModel.h"
#import "ZDHProductCenterOtherViewControllerSpaceModel.h"
#import "ZDHProductCenterOtherViewControllerSpaceItemModel.h"
#import "ZDHProductCenterOtherViewControllerListModel.h"
#import "ZDHProductCenterOtherViewControllerListProductModel.h"
//add
#import "ZDHProductCenterOtherViewControllerListProductModel.h"

@interface ZDHProductCenterOtherViewControllerViewModel()
@property (assign, nonatomic) BOOL isLoacal;
@property (strong, nonatomic) NSString *otherFileName;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *secondFilePath;
@property (strong, nonatomic) NSString *thirdFilePath;
@property (strong, nonatomic) NSFileManager *fileManager;
@end

@implementation ZDHProductCenterOtherViewControllerViewModel
- (instancetype)init{
    if (self = [super init]) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}
//根据ID获取所有数据
- (void)getAllDataWith:(NSString *)ID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataAllItemArray = [NSMutableArray array];
    _dataTitleArray = [NSMutableArray array];
    
    //-------add single图片的数组---------
    _dataNewSingleImageArray = [NSMutableArray array];
    _dataNewSingleIDArray    = [NSMutableArray array];
    
    //检测本地是否已经下载
    _isLoacal = [self checkIfExistInLocalWithID:ID];
    if (_isLoacal) {
        //已经离线下载
        [self getTitleArrayFromLocal];
        success(nil);
        return;
    }
    //组建请求地址
    NSString *urlString;
    if ([ID isEqualToString:@"luolande"] || [ID isEqualToString:@"maqiduo"]) {
        urlString = [NSString stringWithFormat:kMNameAPI,ID];
    }else{
        urlString = [NSString stringWithFormat:kOtherViewAPI,ID];
    }
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *itemArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHProductCenterOtherViewControllerModel *vcModel = [[ZDHProductCenterOtherViewControllerModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHProductCenterOtherViewControllerSpaceModel *spaceModel in vcModel.space) {
            //顶部标题
            spaceModel.tid = ID;
            [titleArray addObject:spaceModel.title];
            //存入数据库
            [[FMDBManager sharedInstace] creatTable:spaceModel];
            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:spaceModel];
            for (ZDHProductCenterOtherViewControllerSpaceItemModel *itemModel in spaceModel.spaceitem) {
                //详情数据
                itemModel.title = spaceModel.title;
                itemModel.tid = ID;
                [itemArray addObject:itemModel];
                //----------------------add----------------------------
                NSMutableArray *ImageArray = [NSMutableArray array];
                NSMutableArray *IDArray = [NSMutableArray array];
                for (ZDHProductCenterOtherViewControllerListProductModel *aboutproductModel in itemModel.aboutproduct) {
                    //保存图片地址
                    [ImageArray addObject:aboutproductModel.bottomimg];
                    //图片ID
                    [IDArray addObject:aboutproductModel.id_conflict];
                }
                //保存图片地址
                [_dataNewSingleImageArray addObject:ImageArray];
                //图片ID
                [_dataNewSingleIDArray addObject:IDArray];
            }
        }
        //检测是否下载成功
        if (itemArray.count > 0) {
            _dataAllItemArray = itemArray;
            _dataTitleArray = titleArray;
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
//根据Title获取数据
- (void)getDataWithTitle:(NSString *)title dataArray:(NSArray *)dataArray{
    //初始化
    _dataItemArray = [NSMutableArray array];
    _dataImageArray = [NSMutableArray array];
    _dataLocalIDArray = [NSMutableArray array];
    if (_isLoacal) {
        //已经离线下载
        //根据Title获取第三层文件夹地址
        _thirdFilePath = [NSString stringWithFormat:@"%@/%@",_secondFilePath,title];
        NSArray *imageArray = [_fileManager subpathsAtPath:_thirdFilePath];
        //获取所有的图片和ID信息
        for (NSString *imageString in imageArray) {
            NSString *lastString = [imageString substringFromIndex:(imageString.length - 3)];
            if ([lastString isEqualToString:@"jpg"]) {
                NSString *addString = [NSString stringWithFormat:@"%@/%@",_thirdFilePath,imageString];
                UIImage *allImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:addString]];
                //图片
                [_dataImageArray addObject:allImage];
                //ID
                NSString *localString = [imageString substringToIndex:(imageString.length - 4)];
                [_dataLocalIDArray addObject:localString];
                //Item
                for (ZDHProductCenterOtherViewControllerSpaceItemModel *itemModel in dataArray) {
                    if ([itemModel.title isEqualToString:title]) {
                        [_dataItemArray addObject:itemModel];
                    }
                }
            }
        }
    }else{
        //未离线下载
        NSMutableArray *itemArray = [NSMutableArray array];
        NSMutableArray *imageArray = [NSMutableArray array];
        for (ZDHProductCenterOtherViewControllerSpaceItemModel *itemModel in dataArray) {
            if ([itemModel.title isEqualToString:title]) {
                [itemArray addObject:itemModel];
                [imageArray addObject:itemModel.spaceimg];
            }
        }
        if (itemArray.count > 0) {
            _dataImageArray = imageArray;
            _dataItemArray = itemArray;
        }
    }
}

//根据产品ID获取单品列表
- (void)getDataWithPID:(NSString *)pid success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataSingleImageArray = [[NSMutableArray alloc] init];
    _dataSingleIDArray = [[NSMutableArray alloc] init];
    if (_isLoacal) {
        //已经离线下载
        //先查找所在文件夹
        NSString *fourthFilePath = [NSString stringWithFormat:@"%@/%@_single",_thirdFilePath,pid];
        NSArray *imageArray = [_fileManager subpathsAtPath:fourthFilePath];
        //获取所有单品的图片
        for (NSString *imageString in imageArray) {
            NSString *addString = [NSString stringWithFormat:@"%@/%@",fourthFilePath,imageString];
            UIImage *allImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:addString]];
            //图片
            [_dataSingleImageArray addObject:allImage];
            //-------------------add-----------------
            //切割字符串 获取下载图片的ID
            NSArray *stringArray = [imageString componentsSeparatedByString:@"."];
            [_dataSingleIDArray addObject:[stringArray firstObject]];
        }
        success(nil);
        return;
    }
    //从网络下载
    //组建请求地址
    NSString *urlString = [NSString stringWithFormat:kSingleListAPI,pid];
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSMutableArray *imageArray = [NSMutableArray array];
        NSMutableArray *idArray = [NSMutableArray array];
        NSArray *dataArray = responseObject;
        ZDHProductCenterOtherViewControllerListModel *listModel = [[ZDHProductCenterOtherViewControllerListModel alloc] init];
        [listModel setValuesForKeysWithDictionary:[dataArray firstObject]];
        for (ZDHProductCenterOtherViewControllerListProductModel *productModel in listModel.product_list) {
            //单品列表
            productModel.pid = pid;
            [imageArray addObject:productModel.bottomimg];
            [idArray addObject:productModel.id_conflict];
        }
        //检测是否下载成功
        if (imageArray.count > 0) {
            _dataSingleImageArray = imageArray;
            _dataSingleIDArray = idArray;
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}

//根据ID从本地检测是否已经下载离线包
- (BOOL)checkIfExistInLocalWithID:(NSString *)ID{
    //组建文件夹地址
    NSMutableString *paths = DownloadPath;
    BOOL isDirExist = NO;
    //查找文件夹
    if ([ID isEqualToString:@"luolande"]) {
        //罗兰德
        _filePath = [paths stringByAppendingString:@"/罗兰德"];
        BOOL isDir = YES;
        isDirExist = [_fileManager fileExistsAtPath:_filePath isDirectory:&isDir];
    }else if([ID isEqualToString:@"maqiduo"]){
        //玛奇朵
        _filePath = [paths stringByAppendingString:@"/玛奇朵"];
        BOOL isDir = YES;
        isDirExist = [_fileManager fileExistsAtPath:_filePath isDirectory:&isDir];
    }else{
        //其他详情
        _filePath = DownloadPath;
        NSArray *firstFileList = [[NSArray alloc] initWithArray:[_fileManager contentsOfDirectoryAtPath:_filePath error:nil]];
        for (NSString *fileName in firstFileList){
            NSString *filePath = [paths stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",fileName,fileName]];
            NSArray *secondFileList = [[NSArray alloc] initWithArray:[_fileManager contentsOfDirectoryAtPath:filePath error:nil]];
            for (NSString *secondFileName in secondFileList) {
                if ([secondFileName isEqualToString:ID]) {
                    _filePath = filePath;
                    _otherFileName = secondFileName;
                    isDirExist = YES;
                    break;
                }
            }
        }
    }
    return isDirExist;
}
//根据从本地获取顶部栏信息
- (void)getTitleArrayFromLocal{
    //初始化
    _dataTitleArray = [NSMutableArray array];
    //获取第一层文件夹名字
    NSMutableArray * firstFileList = [[NSMutableArray alloc] initWithArray:[_fileManager contentsOfDirectoryAtPath:_filePath error:nil]];
    //--------------add----------------------
    //如果有隐藏的文件夹,就去掉隐藏的文件夹
    if([firstFileList containsObject:@".DS_Store"]){
        [firstFileList removeObject:@".DS_Store"];
    }
    //---------------------------------------
    for (NSString *fileName in firstFileList){
        //获取第二层文件夹地址
        if (firstFileList.count > 1) {
            //其他产品详情
            if ([fileName isEqualToString:_otherFileName]) {
                _secondFilePath = [NSString stringWithFormat:@"%@/%@",_filePath,_otherFileName];
                NSArray * secondFileList = [[NSArray alloc] initWithArray:[_fileManager contentsOfDirectoryAtPath:_secondFilePath error:nil]];
                for (NSString *title in secondFileList) {
                    //获取顶部栏信息
                    [_dataTitleArray addObject:title];
                }
            }
           } else{
                //罗兰德 玛奇朵
                _secondFilePath = [NSString stringWithFormat:@"%@/%@",_filePath,fileName];
                NSArray * secondFileList = [[NSArray alloc] initWithArray:[_fileManager contentsOfDirectoryAtPath:_secondFilePath error:nil]];
                for (NSString *title in secondFileList) {
                    //获取顶部栏信息
                    [_dataTitleArray addObject:title];
                }
            }
        }
}
//- (void)getDataWithPID:(NSString *)pid success:(SuccessBlock)success fail:(FailBlock)fail{
//    //初始化
////    _dataSingleImageArray = [[NSMutableArray alloc] init];
////    _dataSingleIDArray = [[NSMutableArray alloc] init];
//    if (_isLoacal) {
//        //已经离线下载
//        //先查找所在文件夹
//        NSString *fourthFilePath = [NSString stringWithFormat:@"%@/%@_single",_thirdFilePath,pid];
//        NSArray *imageArray = [_fileManager subpathsAtPath:fourthFilePath];
//        //获取所有单品的图片
//        for (NSString *imageString in imageArray) {
//            NSString *addString = [NSString stringWithFormat:@"%@/%@",fourthFilePath,imageString];
//            UIImage *allImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:addString]];
//            //图片
//            [_dataNewSingleImageArray addObject:allImage];
//        }
//        success(nil);
//        return;
//    }
//}
@end
