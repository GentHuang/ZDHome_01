//
//  ZDHProductCenterOtherViewControllerMyTestViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 16/1/27.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDHProductCenterOtherViewControllerAddNewViewModel.h"
#import "ZDHProductCenterOtherViewControllerModel.h"
#import "ZDHProductCenterOtherViewControllerSpaceModel.h"
#import "ZDHProductCenterOtherViewControllerSpaceItemModel.h"
#import "ZDHProductCenterOtherViewControllerListProductModel.h"

@interface ZDHProductCenterOtherViewControllerAddNewViewModel()
@property (assign, nonatomic) BOOL isLoacal;
@property (strong, nonatomic) NSString *otherFileName;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *secondFilePath;
@property (strong, nonatomic) NSString *thirdFilePath;
@property (strong, nonatomic) NSString *fourFilePath;
@property (strong, nonatomic) NSFileManager *fileManager;
@end

@implementation ZDHProductCenterOtherViewControllerAddNewViewModel

- (instancetype)init {
    if (self = [super init]) {
        //初始化文件管理者
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}
//获取当页面所有的信息
- (void)getAllTitleDataWith:(NSString *)ID success:(SuccessBlock)success fail:(FailBlock)fail {
    
    //初始化数组
    _dataTitileArray = [NSMutableArray array];
    _dataTitleModelArray = [NSMutableArray array];
    //判断是否存在本地文件
    _isLoacal = [self checkIfExistInLocalWithID:ID];
    if (_isLoacal) {
        //已经离线下载了
        [self getTitleArrayFromLocal];
        if(_dataTitileArray.count>0){
           success(nil);
           return;
        }
    }
    NSString *urlString;
    if ([ID isEqualToString:@"luolande"] || [ID isEqualToString:@"maqiduo"]) {
        urlString = [NSString stringWithFormat:kMNameAPI,ID];
    }else{
        urlString = [NSString stringWithFormat:kOtherViewAPI,ID];
    }
    
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //存储最外层模型
        ZDHProductCenterOtherViewControllerModel *outerModel = [[ZDHProductCenterOtherViewControllerModel alloc]init];
        [outerModel setValuesForKeysWithDictionary:[responseObject firstObject]];
        for (ZDHProductCenterOtherViewControllerSpaceModel *spaceModel  in outerModel.space) {
            
            //把所有的title都存储进数组
            [ _dataTitleModelArray addObject:spaceModel];
            [_dataTitileArray addObject:spaceModel.title];
        }
        if (_dataTitileArray.count>0) {
            success(nil);
        }
        else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"网络出错了%@",error);
        fail(nil);
    }];
}
//根据title名字拿到对应的底部滚动视图
- (void)getBottomScrollImageWithTitleSelectedIndex:(int)selected success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化数组
    _dataScrollModelArray = [NSMutableArray array];
    _dataProductIntroArray  = [NSMutableArray array];
    _dataScrollImageArray = [NSMutableArray array];
    //遍历title数组
    ZDHProductCenterOtherViewControllerSpaceModel *titleModel = _dataTitleModelArray[selected];
    for (ZDHProductCenterOtherViewControllerSpaceItemModel *ItemModel in titleModel.spaceitem) {
        [_dataScrollModelArray addObject:ItemModel];
        [_dataProductIntroArray addObject:ItemModel.intro];
        [_dataScrollImageArray addObject:ItemModel.spaceimg];
    }
    if (_dataScrollModelArray.count>0) {
        success(nil);
    }else
        fail(nil);
}
//根据点击底部滚动视图的位置 只 获取右上角滚动小图
- (void)getSingleRightViewWithScrollSelectedIndex:(int)selected success:(SuccessBlock)success fail:(FailBlock)fail{
    
    //初始化数组
    _dataSingleImageArray = [NSMutableArray array];
    _dataSmallScollModelArray =[NSMutableArray array];
    ZDHProductCenterOtherViewControllerSpaceItemModel *ItemModel =_dataScrollModelArray[selected];
    
    for (ZDHProductCenterOtherViewControllerListProductModel *productModel in ItemModel.aboutproduct) {
        [_dataSmallScollModelArray addObject:productModel];
        [_dataSingleImageArray addObject:productModel.bottomimg];
    }
    if (_dataSingleImageArray.count>0) {
        success(nil);
    }else{
        fail(nil);
    }
}
#pragma mark  获取本地下载的文件夹信息

//根据ID从本地检测是否已经下载离线包
- (BOOL)checkIfExistInLocalWithID:(NSString *)ID{
    //组建文件夹地址 (获取沙盒路径)
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
//    _dataTitileArray = [NSMutableArray array];
    //获取第一层文件夹名字
    NSMutableArray * firstFileList = [[NSMutableArray alloc] initWithArray:[_fileManager contentsOfDirectoryAtPath:_filePath error:nil]];
    //如果有隐藏的文件夹,就去掉隐藏的文件夹
    if([firstFileList containsObject:@".DS_Store"]){
        [firstFileList removeObject:@".DS_Store"];
    }
    for (NSString *fileName in firstFileList){
        //获取第二层文件夹地址
        if (firstFileList.count > 1) {
            //其他产品详情
            if ([fileName isEqualToString:_otherFileName]) {
                _secondFilePath = [NSString stringWithFormat:@"%@/%@",_filePath,_otherFileName];
                NSArray * secondFileList = [[NSArray alloc] initWithArray:[_fileManager contentsOfDirectoryAtPath:_secondFilePath error:nil]];
                for (NSString *title in secondFileList) {
                    //获取顶部栏信息
                    [_dataTitileArray addObject:title];
                }
            }
        }else{
            //罗兰德 玛奇朵
            _secondFilePath = [NSString stringWithFormat:@"%@/%@",_filePath,fileName];
            NSArray * secondFileList = [[NSArray alloc] initWithArray:[_fileManager contentsOfDirectoryAtPath:_secondFilePath error:nil]];
            for (NSString *title in secondFileList) {
                //获取顶部栏信息
                [_dataTitileArray addObject:title];
            }
        }
    }
    
    if([_dataTitileArray containsObject:@".DS_Store"]){
        [_dataTitileArray removeObject:@".DS_Store"];
    }
}
- (void)getLocalDataWithTitle:(NSString *)title {
    //初始化存储本地底部滚动视图的数组
    _dataScrollLocalImageArray = [NSMutableArray array];
    //存储ID
    _dataLocalIDArray = [NSMutableArray array];
    //已经离线下载
    if (_isLoacal) {
        //已经离线下载
        //根据Title获取第三层文件夹地址
        _thirdFilePath = [NSString stringWithFormat:@"%@/%@",_secondFilePath,title];
//        NSArray *imageArray = [_fileManager subpathsAtPath:_thirdFilePath];
        NSArray *imageArray = [_fileManager contentsOfDirectoryAtPath:_thirdFilePath error:nil];
        //获取所有的图片和ID信息
        for (NSString *imageString in imageArray) {
//            NSString *lastString = [imageString substringFromIndex:(imageString.length - 3)];
//            if ([lastString isEqualToString:@"jpg"]) {
//                NSString *addString = [NSString stringWithFormat:@"%@/%@",_thirdFilePath,imageString];
//                UIImage *allImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:addString]];
//                //底部滚动视图片和大图
//                [_dataScrollLocalImageArray addObject:allImage];
//                //ID
//                NSString *localString = [imageString substringToIndex:(imageString.length - 4)];
//                //存储图片的ID
//                [_dataLocalIDArray addObject:localString];
//            }
            //-------add ---------
            if ([self iSIDNumber:imageString]) {
                //拼接路径
                NSString *lastpathString = [NSString stringWithFormat:@"%@/%@",_thirdFilePath,imageString];
                
                NSArray *imageArray2 = [_fileManager contentsOfDirectoryAtPath:lastpathString error:nil];
                _fourFilePath = lastpathString;
                for (NSString *imageLastString in imageArray2) {
                    //提取文件名字
                    NSString *ImageNameString = [imageLastString substringFromIndex:(imageLastString.length - 3)];
                    
                    if ([ImageNameString isEqualToString:@"jpg"]) {
                        NSString *ImagePathString = [NSString stringWithFormat:@"%@/%@",lastpathString,imageLastString];
                        UIImage *allImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:ImagePathString]];
                        //底部滚动视图片和大图
                        [_dataScrollLocalImageArray addObject:allImage];
                        //ID
                        NSString *localString = [imageLastString substringToIndex:(imageLastString.length - 4)];
                        //存储图片的ID
                        [_dataLocalIDArray addObject:localString];
                    }
                    
                }
                
            }
            
        }
        
    }
}
//根据产品外层ID获取本地single图片和每张小图的ID
- (void)getLocalDataWithPID:(NSString *)pid{
    //初始化
   //右边上图小滚动视图
    _dataSingleImageArray = [NSMutableArray array];
    _dataSingleLocalIDaray = [NSMutableArray array];
    if (_isLoacal) {
        //已经离线下载
        //先查找所在文件夹
        NSString *fifthFilePath = [NSString stringWithFormat:@"%@/%@/%@_single",_thirdFilePath,pid,pid];//
        NSArray *imageArray = [_fileManager subpathsAtPath:fifthFilePath];
        //获取所有单品的图片
        for (NSString *imageString in imageArray) {
            NSString *addString = [NSString stringWithFormat:@"%@/%@",fifthFilePath,imageString];
            UIImage *allImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:addString]];
            //图片
            [_dataSingleImageArray addObject:allImage];
            //切割字符串 获取下载图片的ID
            NSArray *stringArray = [imageString componentsSeparatedByString:@"."];
            [_dataSingleLocalIDaray addObject:[stringArray firstObject]];
        }
    }
}
- (BOOL)iSIDNumber:(NSString*)patten{
    
    //数字
    NSString *phoneNum = @"^[0-9]*$";
    //创建正则表达式
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:phoneNum options:0 error:nil];
    //测试字符串
    NSArray *results = [regex matchesInString:patten options:0 range:NSMakeRange(0, patten.length)];
    
    return results.count>0;
}

@end
