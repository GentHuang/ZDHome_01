//
//  ZDHUserClothesViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserClothesViewViewModel.h"
//Model
#import "ZDHClothesTopViewModel.h"
//替换
#import "ZDHClothesTopViewYearModel.h"
//存储离线下载的信息model
#import "ZDHClothDetailViewControllerClothModel.h"

#import "ZDHClothesTopViewTypeListModel.h"
#import "ZDHUserClothesViewFirstModel.h"
#import "ZDHUserClothesViewFirstClothesListModel.h"
#import "ZDHUserClothesViewOtherModel.h"
#import "ZDHUserClothesViewOtherClothListModel.h"
@interface ZDHUserClothesViewViewModel()
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSMutableArray *localFilePathArray;
@property (strong, nonatomic) NSMutableArray *localFileNameArray;
@property (strong, nonatomic) NSFileManager *fileManager;
@end
@implementation ZDHUserClothesViewViewModel
- (instancetype)init{
    if (self = [super init]) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}
//获取布料头部
- (void)getClothTitleSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataClothIDArray = [NSMutableArray array];
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:KClothesTopViewYearAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //        NSLog(@"原来的头部链接%@",kClothesTopViewAPI);
        NSArray *dataArray = responseObject;
        NSMutableArray *idArray = [NSMutableArray array];
        ZDHClothesTopViewYearModel *TopViewmodel = [[ZDHClothesTopViewYearModel alloc]init];
        [TopViewmodel setValuesForKeysWithDictionary:[dataArray firstObject]];
        
        //检测是否下载成功
        if (TopViewmodel.year_list.count > 0) {
            _dataClothTitleArray = [NSArray arrayWithArray:TopViewmodel.year_list];
            _dataClothIDArray = idArray;
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        if([self getLocalTitleYear]){
            success(nil);
        }
        fail(nil);
    }];
}
//获取布料首页所有信息
- (void)getClothFirstPageSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataClothListIDArray = [NSMutableArray array];
    _dataClothListNameArray = [NSMutableArray array];
    _dataClothListImageArray = [NSMutableArray array];
    //检查是否已经离线下载
    //    if ([self checkIfExistInLocal]) {
    //        //从本地获取数据
    //        [self getFirstPageAllImageFromLocal];
    //        //获取本地数据
    //        [self getDataWithLocalFile];
    //
    //        success(nil);
    //        return;
    //    }
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:kClothesFirstAllPageAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //        NSLog(@"原来客户要求的首页列表链接%@",kClothesFirstPageAPI);
        NSMutableArray *idArray = [NSMutableArray array];
        NSMutableArray *imageArray = [NSMutableArray array];
        NSMutableArray *nameArray = [NSMutableArray array];
        NSArray *dataArray = responseObject;
        ZDHUserClothesViewFirstModel *vcModel = [[ZDHUserClothesViewFirstModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[dataArray firstObject]];
        for (ZDHUserClothesViewFirstClothesListModel *listModel in vcModel.clothlist_list) {
            //添加布料列表信息
            [idArray addObject:listModel.id_conflict];
            [imageArray addObject:listModel.imgurl];
            [nameArray addObject:listModel.name];
        }
        //检测是否下载完成
        if (imageArray.count > 0 && _dataClothListImageArray.count != imageArray.count) {
            _dataClothListIDArray = idArray;
            _dataClothListImageArray = imageArray;
            _dataClothListNameArray = nameArray;
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        
        if ([self checkIfExistInLocal]) {
            //从本地获取数据
            [self getFirstPageAllImageFromLocal];
            //获取本地数据
            [self getDataWithLocalFile];
            
            success(nil);
            
        }
        fail(nil);
    }];
}
#pragma mark  根据年份获取信息
//根据年份获取布料信息
- (void)getClothInfoWithYear:(NSString*)stringYear Success:(SuccessBlock)success fail:(FailBlock)fail{
    //检查是否已经离线下载
    //    if ([self getDataWithTitilYearName:stringYear]) {
    //        success(nil);
    //        return;
    //    }
    //拼接Url
    NSString *urlString = [NSString stringWithFormat:kClothesFirstAllPageAPI@"%@",stringYear];
    
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        
        //检查是否已经离线下载
        if ([self getDataWithTitilYearName:stringYear]) {
            if ([self checkIfExistInLocal]) {
                //从本地获取数据
                [self getFirstPageAllImageFromLocal];
                //获取本地数据
                //                [self getDataWithLocalFile];
            }
            
            success(nil);
            return;
        }
        _dataClothListIDArray = [NSMutableArray array];
        _dataClothListNameArray = [NSMutableArray array];
        _dataClothListImageArray = [NSMutableArray array];
        
        NSArray *dataArray = responseObject;
        ZDHUserClothesViewFirstModel *vcModel = [[ZDHUserClothesViewFirstModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[dataArray firstObject]];
        for (ZDHUserClothesViewFirstClothesListModel *listModel in vcModel.clothlist_list) {
            //添加布料列表信息
            [_dataClothListIDArray addObject:listModel.id_conflict];
            [_dataClothListImageArray addObject:listModel.imgurl];
            [_dataClothListNameArray addObject:listModel.name];
        }
        //检测是否下载完成
        if (_dataClothListImageArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
        //优先获取离线的
        //        if ([self getDataWithTitilYearName:stringYear]) {
        //            success(nil);
        //        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        
        if ([self getDataWithTitilYearName:stringYear]) {
            success(nil);
        }
        
        fail(nil);
    }];
}

//根据TypeID获取其他布料的列表
- (void)getDataWithTypeID:(NSString *)typeID withTitleName:(NSString*)titlName success:(SuccessBlock)success fail:(FailBlock)fail{
    
    //检查是否已经离线下载
    if ([self getCLothPlateWithClothID:typeID]) {
        //从本地获取数据
        if ([self getALLInfoLocalClothDetailwithTitleName:titlName]) {
            success(nil);
            return;
        }
    }
    //网络请求
    //创建请求列表
    NSString *urlString = [NSString stringWithFormat:kClothesPlatePageAPI,typeID];// kClothesOtherPageAPI
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        
        //初始化
        _dataClothListIDArray = [NSMutableArray array];
        _dataClothListNameArray = [NSMutableArray array];
        _dataClothListImageArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHUserClothesViewOtherModel *vcModel = [[ZDHUserClothesViewOtherModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHUserClothesViewOtherClothListModel *listModel in vcModel.cloth_list) {
            //获取其他布料列表信息
            listModel.typeID = typeID;
            [_dataClothListIDArray addObject:listModel.id_conflict];
            [_dataClothListImageArray addObject:listModel.cloth_img];
            [_dataClothListNameArray addObject:listModel.name];
        }
        //检测是否下载完成
        if (_dataClothListImageArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        //检查是否已经离线下载
        if ([self getCLothPlateWithClothID:typeID]) {
            //从本地获取数据
            if ([self getALLInfoLocalClothDetailwithTitleName:titlName]) {
                success(nil);
                
            }
        }
        fail(nil);
    }];
}
//根据关键字获取布料搜索列表
- (void)getClothSearchListWithKeyword:(NSString *)keyword success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataClothListIDArray = [NSMutableArray array];
    _dataClothListNameArray = [NSMutableArray array];
    _dataClothListImageArray = [NSMutableArray array];
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kGetSearchClothListAPI,keyword];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHUserClothesViewOtherModel *vcModel = [[ZDHUserClothesViewOtherModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHUserClothesViewOtherClothListModel *listModel in vcModel.cloth_list) {
            //获取搜索布料列表信息
            [_dataClothListIDArray addObject:listModel.id_conflict];
            [_dataClothListImageArray addObject:listModel.cloth_img];
            [_dataClothListNameArray addObject:listModel.name];
        }
        if (_dataClothListImageArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
#pragma mark 离线下载包
//判断首页是否已经下载离线包  获取布板的路径
- (BOOL)checkIfExistInLocal{
    //组建文件夹地址
    _filePath = DownloadPath;
    BOOL isDirExist = NO;
    //查找文件夹
    NSArray *fileArray = [_fileManager contentsOfDirectoryAtPath:_filePath error:nil];
    //拼接路径字符串
    NSString *AllNamepath = [NSString string];
    //初始化路径
    _dataClothFilePathArray = [NSMutableArray array];
    //基本包路径
    _dataBasePathArray = [NSMutableArray array];
    //拼接路径字符串
    for (NSString *titleName in fileArray) {
        NSRange range = [titleName rangeOfString:@"布板"];
        if (range.location != NSNotFound) {
            NSArray *baseFileArray = [_fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",DownloadPath,titleName] error:nil];
            for (NSString *baseName in baseFileArray) {
                NSRange baseRange = [baseName rangeOfString:@"base"];
                if (baseRange.location != NSNotFound) {
                    isDirExist = YES;
                    _filePath = [NSString stringWithFormat:@"%@/%@/%@/%@",DownloadPath,titleName,baseName,baseName];
                    [_dataBasePathArray addObject:_filePath];
                }
                //存储所有路径
                if (![baseName isEqualToString:@"base"]&&![baseName isEqualToString:@".DS_Store"]) {
                    AllNamepath = [NSString stringWithFormat:@"%@/%@/%@",DownloadPath,titleName,baseName];
                    NSArray *fileTestArray = [_fileManager contentsOfDirectoryAtPath:AllNamepath error:nil];//标题下面的字文件
                    //取出隐藏的文件
                    for (int i = 0; i<fileTestArray.count; i++) {
                        if (![fileTestArray[i] isEqualToString:@".DS_Store"]) {//有隐藏文件夹去除
                            NSString *AllNameIDpath =[NSString stringWithFormat:@"%@/%@",AllNamepath,fileTestArray[i]];
                            [_dataClothFilePathArray addObject:AllNameIDpath ];
                        }
                    }
                }
            }
        }
    }
    //        NSLog(@"路径====  %@",_dataClothFilePathArray);
    return isDirExist;
}
//title年份
- (BOOL)getLocalTitleYear {
    BOOL isExistYear = NO;
    //年份
    NSMutableArray * dataClothTitleYearArray = [NSMutableArray array];
    //查找文件夹
    NSArray *fileArray = [_fileManager contentsOfDirectoryAtPath:DownloadPath error:nil];
    for (NSString *titleName in fileArray) {
        NSRange range = [titleName rangeOfString:@"布板"];
        if (range.location != NSNotFound) {
            NSString *year = [titleName substringToIndex:4];
            //存储年份
            [dataClothTitleYearArray addObject:year];
        }
    }
    if (dataClothTitleYearArray.count>0) {
        isExistYear = YES;
        _dataClothTitleArray = [NSArray arrayWithArray:dataClothTitleYearArray];
    }
    return isExistYear;
}

//从本地获取布板的所有图片
- (void)getFirstPageAllImageFromLocal{
    //存储图片的字典
    _ImageAllDict = [NSMutableDictionary dictionary];
    for ( NSString *pathString in _dataBasePathArray ) {
        NSArray *fileArray = [_fileManager contentsOfDirectoryAtPath:pathString error:nil];
        for (NSString *fileName in fileArray) {
            if ([[fileName substringFromIndex:(fileName.length-3)] isEqualToString:@"jpg"]) {
                //图片
                NSString *addString = [NSString stringWithFormat:@"%@/%@",pathString,fileName];
                UIImage *allImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:addString]];
                //ID
                NSArray *imageArray = [fileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_."]];
                [_ImageAllDict setObject:allImage forKey:[imageArray firstObject]];
            }
        }
    }
    //    NSLog(@"===字典%@",_ImageAllDict);
}
//获取所有离线下载布板 的ID 和名字
- (void)getDataWithLocalFile{
    //初始化
    _dataClothListIDArray = [NSMutableArray array];
    _dataClothListNameArray = [NSMutableArray array];
    
    //查找文件夹
    NSArray *fileArray = [_fileManager contentsOfDirectoryAtPath:DownloadPath error:nil];
    for (NSString *titleName in fileArray) {
        NSRange range = [titleName rangeOfString:@"布板"];
        if (range.location != NSNotFound) {
            //文件夹地址
            _filePath = DownloadPath;
            NSArray *baseFileArray = [_fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",_filePath,titleName] error:nil];
            //拼接路径字符串
            NSString *AllNamepath = [NSString string];
            //所有的名字
            NSMutableArray *nameArray= [NSMutableArray arrayWithArray:baseFileArray];
            [nameArray removeObject:@"base"];
            [nameArray removeObject:@".DS_Store"];
            //存储ID
            NSMutableArray *NameOfIDArray = [NSMutableArray array];
            for(NSString *titleALLName in nameArray){//标题名字
                if (![titleALLName isEqualToString:@"base"]&&![titleALLName isEqualToString:@".DS_Store"]) {
                    AllNamepath = [NSString stringWithFormat:@"%@/%@/%@",DownloadPath,titleName,titleALLName];
                    NSArray *fileNameArray = [_fileManager contentsOfDirectoryAtPath:AllNamepath error:nil];//标题下面的字文件
                    //取出隐藏的文件
                    for (int i = 0; i<fileNameArray.count; i++) {
                        if ([self iSIDNumber:fileNameArray[i]]) {//存储ID 正则表达式判断为纯数字
                            [NameOfIDArray addObject:fileNameArray[i]];
                        }
                    }
                }
            }
            //存储所有的ID和名字
            [_dataClothListNameArray addObjectsFromArray:nameArray];
            [_dataClothListIDArray addObjectsFromArray:NameOfIDArray];
            
            //            NSLog(@"名字=%@   ID= %@",_dataClothListNameArray,_dataClothListIDArray);
        }
    }
    
}
//根据年份获取离线下载的布板
- (BOOL)getDataWithTitilYearName:(NSString*)yearString {
    
    //判断是否下载有了
    BOOL isDownload = NO;
    //初始化数组
    _dataClothListIDArray = [NSMutableArray array];
    _dataClothListNameArray = [NSMutableArray array];
    //重新初始化图片数组
    _dataClothListImageArray = [NSMutableArray array];
    NSArray *fileArray = [_fileManager contentsOfDirectoryAtPath:DownloadPath error:nil];
    for (NSString *titleName in fileArray) {
        
        if ([titleName rangeOfString:@"布板"].location != NSNotFound) {//取出布板的信息
            
            //与年份一样
            if ([titleName rangeOfString:yearString].location!= NSNotFound) {
                //组建文件夹地址
                _filePath = DownloadPath;
                NSArray *baseFileArray = [_fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",_filePath,titleName] error:nil];
                //拼接路径字符串
                NSString *AllNamepath = [NSString string];
                //所有的名字
                NSMutableArray *nameArray= [NSMutableArray arrayWithArray:baseFileArray];
                [nameArray removeObject:@"base"];
                [nameArray removeObject:@".DS_Store"];
                //存储ID
                NSMutableArray *NameOfIDArray = [NSMutableArray array];
                for(NSString *titleALLName in nameArray){//标题名字
                    if (![titleALLName isEqualToString:@"base"]&&![titleALLName isEqualToString:@".DS_Store"]) {
                        AllNamepath = [NSString stringWithFormat:@"%@/%@/%@",DownloadPath,titleName,titleALLName];
                        
                        NSArray *fileTestArray = [_fileManager contentsOfDirectoryAtPath:AllNamepath error:nil];//标题下面的字文件
                        //取出隐藏的文件
                        for (int i = 0; i<fileTestArray.count; i++) {
                            if ([self iSIDNumber:fileTestArray[i]]) {//有隐藏文件夹去除
                                [NameOfIDArray addObject:fileTestArray[i]];
                            }
                        }
                    }
                }
                //存储所有的ID和名字
                [_dataClothListNameArray addObjectsFromArray:nameArray];
                [_dataClothListIDArray addObjectsFromArray:NameOfIDArray];
                if (_dataClothListNameArray.count>0) {
                    isDownload =YES;
                }
                //                NSLog(@"名字=%@",_dataClothListNameArray);
            }
        }
    }
    return isDownload;
}
#pragma mark ---离线下载 布的信息:图片 、ID 、 名称
//根据ID 获取离线下载的布列表
- (BOOL)getCLothPlateWithClothID:(NSString*)stringID {
    
    //先取出存储数据的路径
    [self checkIfExistInLocal];
    
    //判断是否下载
    BOOL isDownloadPlate =NO;
    //重新初始化数组
    _dataClothListIDArray = [NSMutableArray array];
    _dataClothListNameArray = [NSMutableArray array];
    _dataClothListImageArray = [NSMutableArray array];
    //根据ID找到路径
    for (NSString *pathString in _dataClothFilePathArray) {
        if ([pathString rangeOfString:stringID].location !=NSNotFound) {
            
            NSArray *fileClothArray = [_fileManager contentsOfDirectoryAtPath:pathString error:nil];
            
            for (NSString *fileName in fileClothArray) {
                if ([[fileName substringFromIndex:(fileName.length-3)] isEqualToString:@"jpg"]) {
                    //图片
                    NSString *addString = [NSString stringWithFormat:@"%@/%@",pathString,fileName];
                    UIImage *allImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:addString]];
                    NSArray *imageArray = [fileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
                    //存储图片
                    [_dataClothListImageArray addObject:allImage];
                    //ID
                    [_dataClothListIDArray addObject:[imageArray firstObject]];
                }
            }
        }
    }
    if (_dataClothListIDArray.count>0) {
        isDownloadPlate = YES;
    }
    return isDownloadPlate;
}

//读取对应布板的json内容  包括名字 以及对每一块布的描述
- (BOOL)getALLInfoLocalClothDetailwithTitleName:(NSString*)titlname{
    //是否存在
    BOOL isDownloadClothPlate = NO;
    //初始化数组
    _dataClothListNameArray = [NSMutableArray array];
    //路径后缀
    NSString *pathName = [NSString stringWithFormat:@"%@.json",titlname];
    //根据ID 提取路径
    for (NSString *JsonFilePath in _dataClothFilePathArray) {
        if ([JsonFilePath rangeOfString:pathName].location !=NSNotFound) {
            //            NSLog(@"路径==== %@",JsonFilePath);
            //   转换二进制流
            NSData *Alldata = [NSData dataWithContentsOfFile:JsonFilePath];
            //存进字典
            NSDictionary *allInfoDict = [NSJSONSerialization JSONObjectWithData:Alldata options:NSJSONReadingMutableContainers error:nil];
            //解析数据
            for (NSDictionary *dict in allInfoDict) {
                ZDHClothDetailViewControllerClothModel *ClothPlateModel = [[ZDHClothDetailViewControllerClothModel alloc]init];
                [ClothPlateModel setValuesForKeysWithDictionary:dict];
                //                [_dataLocalAllInfoArray addObject:ClothPlateModel];
                //取出布的名字
                [_dataClothListNameArray addObject:ClothPlateModel.name];
            }
            if(_dataClothListNameArray.count>0){
                isDownloadClothPlate = YES;
            }
        }
    }
    //        NSLog(@"外层的信息 %@",_dataClothListNameArray);
    return isDownloadClothPlate;
}
#pragma mark  正则表达式 判断是是否是ID(数字)
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
