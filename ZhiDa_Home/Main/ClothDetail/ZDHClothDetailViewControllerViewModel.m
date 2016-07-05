//
//  ZDHClothDetailViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHClothDetailViewControllerViewModel.h"
//Model
#import "ZDHClothDetailViewControllerModel.h"
#import "ZDHClothDetailViewControllerClothModel.h"
#import "ZDHClothDetailViewControllerFirstPageModel.h"
#import "ZDHClothDetailViewControllerFirstPageClothListModel.h"

// 用途icon
#import "ZDHClothUseIconModel.h"
#import "ZDHClothIconGettyPelistbyClothIdModel.h"
@interface ZDHClothDetailViewControllerViewModel()
@property (assign, nonatomic) BOOL isDownload;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSMutableArray *localFilePathArray;
@property (strong, nonatomic) NSMutableArray *localFileNameArray;
@property (strong, nonatomic) NSFileManager *fileManager;
//布板的名称
@property (strong, nonatomic) NSString *titleName;
@end

@implementation ZDHClothDetailViewControllerViewModel
- (instancetype)init{
    if (self = [super init]) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}
//首页获取布料详情，先获取所有布料信息
- (void)getFirstPageDataWithCID:(NSString *)CID  withTitleName:(NSString*)titleName success:(SuccessBlock)success fail:(FailBlock)fail{
    //如果有本地下载则直接获取
    if ([self getPathFileImageAndClothIDWithID:CID]) {
        _titleName = titleName;
        if ([self GetALLInfoLocalClothDetailWithPathFileWt:CID withTitleName:titleName]) {
            success(nil);
            return;
        }
    }
    //组建请求地址
    NSString *urlString = [NSString stringWithFormat:kClothDetailListAPI,CID];
//    NSLog(@"布详情页连接3333------》%@", urlString);
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //初始化
        _dataFirstPageIDArray = [NSMutableArray array];
        _dataFirstPageImageArray = [NSMutableArray array];
        _dataFirstPageNameArray = [NSMutableArray array];
        
        NSArray *responseArray = responseObject;
        ZDHClothDetailViewControllerFirstPageModel *vcModel = [[ZDHClothDetailViewControllerFirstPageModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHClothDetailViewControllerFirstPageClothListModel *listModel in vcModel.cloth_list) {
            //获取首页布料详情信息
            [_dataFirstPageIDArray addObject:listModel.id_conflict];
            [_dataFirstPageImageArray addObject:listModel.cloth_img];
            [_dataFirstPageNameArray addObject:listModel.name];
        }
        //检测是否下载完成
        if (_dataFirstPageImageArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        if ([self checkIfExistInLocalWithCID:CID]) {
            //离线下载
            [self getFirstPageAllImageFromLocal];
            success(nil);
        }else{
            fail(nil);
        }
    }];
}
//根据CID获取布料详情
- (void)getDataWithCID:(NSString *)CID success:(SuccessBlock)success fail:(FailBlock)fail{
    
    //判断是否有离线下载信息
    if ([self getLocalCorrespondingClothInfoWithClothID:CID]) {
        success(nil);
        return;
    }
    
    //组建请求地址
    NSString *urlString = [NSString stringWithFormat:kClothDetailTypeAPI,CID];
//    NSLog(@"布详情1111-----》%@",urlString);
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        //初始化
        _dataDetailArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHClothDetailViewControllerModel *vcModel = [[ZDHClothDetailViewControllerModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHClothDetailViewControllerClothModel *clothModel in vcModel.cloth) {
            //获取布料详情
            [_dataDetailArray addObject:clothModel];
        }
        if (_dataDetailArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        if (_isDownload) {
            //离线下载
            [self getFirstPageModelFromLocalWithCID:CID];
            success(nil);
        }else{
            fail(nil);
        }
    }];
}

- (void) getClothUseIconWithClothId:(NSString *)clothid success:(SuccessBlock)success fail:(FailBlock)fail{
    
    _dataUseIconArray = [NSMutableArray array];
    _dataUseIconUrlArray = [NSMutableArray array];
    NSString *iconUrl = [NSString stringWithFormat:kClothUseIconAPI,clothid];
    
    [[ZDHNetworkManager sharedManager] GET:iconUrl parameters:nil success:^void(AFHTTPRequestOperation *operation,id responseObject){
    
        NSDictionary *dic = [responseObject firstObject];
        ZDHClothUseIconModel *useIconModel = [[ZDHClothUseIconModel alloc]init];
        [useIconModel setValuesForKeysWithDictionary:dic];
        for (ZDHClothIconGettyPelistbyClothIdModel  *pelistbyClothIdModel in useIconModel.gettypelistbyclothid) {
            
            [_dataUseIconArray addObject:pelistbyClothIdModel];
            [_dataUseIconUrlArray addObject:pelistbyClothIdModel.icon];
        }
        
        if (_dataUseIconArray.count > 0) {
            
            success(nil);
        }
        else{
            
             fail(nil);
        }
    
    } failure:^void(AFHTTPRequestOperation *operation, NSError *error){
    
        fail(nil);
    }];
    
    
}

//根据CID获取相关布料
- (void)getAboutClothWithCID:(NSString *)CID success:(SuccessBlock)success fail:(FailBlock)fail{
    
    //判断本地是否下载有
    if ([self getLocalAboutClothWithCID:CID]) {
        success(nil);
        return;
    }
    //初始化
    _dataAboutIDArray = [NSMutableArray array];
    _dataAboutImageArray = [NSMutableArray array];
    _dataAboutNameArray = [NSMutableArray array];
    
    //组建请求地址
    NSString *urlString = [NSString stringWithFormat:kClothDetailTypeOtherAPI,CID];
//    NSLog(@"布详情222-----》%@",urlString);
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHClothDetailViewControllerFirstPageModel *vcModel = [[ZDHClothDetailViewControllerFirstPageModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHClothDetailViewControllerFirstPageClothListModel *listModel in vcModel.cloth_list) {
            //获取相关布料列表
            [_dataAboutIDArray addObject:listModel.id_conflict];
            [_dataAboutImageArray addObject:listModel.cloth_img];
            [_dataAboutNameArray addObject:listModel.name];
        }
        //检测是否下载完成
        if (_dataAboutImageArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        fail(nil);
    }];
}
//判断首页是否已经下载离线包
- (BOOL)checkIfExistInLocalWithCID:(NSString *)CID{
    //组建文件夹地址
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    _filePath = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preferences"];
    _isDownload = NO;
    //查找文件夹
    NSArray *fileArray = [_fileManager contentsOfDirectoryAtPath:_filePath error:nil];
    for (NSString *titleName in fileArray) {
        NSRange range = [titleName rangeOfString:@"布板"];
        if (range.location != NSNotFound) {
            NSArray *clothArray = [_fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",_filePath,titleName] error:nil];
            for (NSString *clothName in clothArray) {
                NSArray *imageArray = [_fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@/%@",_filePath,titleName,clothName] error:nil];
                for (NSString *imageName in imageArray) {
                    if ([imageName isEqualToString:CID]) {
                        _isDownload = YES;
                        _filePath = [NSString stringWithFormat:@"%@/%@/%@/%@",_filePath,titleName,clothName,imageName];
                        break;
                    }
                }
            }
        }
    }
    //    [self checkIfExistInLocal];
    //    [self getPathFileWithClothID:CID];
    
    return _isDownload;
}
#pragma mark  读取本地下载的图片和ID信息的路径
//----------------------------------------------------------------------
//判断是否已经下载离线包 并存储所有离线包的路径
- (void)checkIfExistInLocalWithCloth{
    //组建文件夹地址
    _filePath = DownloadPath;
    //查找文件夹
    NSArray *fileArray = [_fileManager contentsOfDirectoryAtPath:_filePath error:nil];
    //拼接路径字符串
    NSString *AllNamepath = [NSString string];
    //初始化路径 存储所有路径
    _dataPathArray = [NSMutableArray array];
    //拼接路径字符串
    for (NSString *titleName in fileArray) {
        NSRange range = [titleName rangeOfString:@"布板"];
        if (range.location != NSNotFound) {
            NSArray *baseFileArray = [_fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",DownloadPath,titleName] error:nil];
            for (NSString *baseName in baseFileArray) {
                //存储所有路径
                if (![baseName isEqualToString:@"base"]&&![baseName isEqualToString:@".DS_Store"]) {
                    AllNamepath = [NSString stringWithFormat:@"%@/%@/%@",DownloadPath,titleName,baseName];
                    NSArray *fileTestArray = [_fileManager contentsOfDirectoryAtPath:AllNamepath error:nil];//标题下面的字文件
                    //取出隐藏的文件
                    for (int i = 0; i<fileTestArray.count; i++) {
                        if (![fileTestArray[i] isEqualToString:@".DS_Store"]) {//有隐藏文件夹去除
                            NSString *AllNameIDpath =[NSString stringWithFormat:@"%@/%@",AllNamepath,fileTestArray[i]];
                            [_dataPathArray addObject:AllNameIDpath ];
                        }
                    }
                }
            }
        }
    }
}
//根据ID 获取离线下载的布（底部Collection图片和ID）
- (BOOL)getPathFileImageAndClothIDWithID:(NSString*)stringID {
    //获取路径
    [self checkIfExistInLocalWithCloth];
    //文件是否存在
    BOOL isClothExist = NO;
    //重新初始化数组
    _dataFirstPageIDArray = [NSMutableArray array];
    _dataFirstPageImageArray = [NSMutableArray array];
    //    _dataFirstPageNameArray = [NSMutableArray array];
    //
    //    _LocalAllImageDict = [NSMutableDictionary dictionary];
    //根据ID找到路径
    for (NSString *pathString in _dataPathArray) {
        if ([pathString rangeOfString:stringID].location !=NSNotFound) {
            
            NSArray *fileClothArray = [_fileManager contentsOfDirectoryAtPath:pathString error:nil];
            
            for (NSString *fileName in fileClothArray) {
                if ([[fileName substringFromIndex:(fileName.length-3)] isEqualToString:@"jpg"]) {
                    //图片
                    NSString *addString = [NSString stringWithFormat:@"%@/%@",pathString,fileName];
                    UIImage *allImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:addString]];
                    NSArray *imageArray = [fileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
                    //存储图片
                    [_dataFirstPageImageArray addObject:allImage];
                    //ID
                    [_dataFirstPageIDArray addObject:[imageArray firstObject]];
                    
                    
                }
            }
        }
    }
    //存入字典 便于后续取出
    //    [_LocalAllImageDict setValue:_dataFirstPageImageArray forKey:_dataFirstPageIDArray];
    _LocalAllImageDict = [[NSDictionary alloc]initWithObjects:_dataFirstPageImageArray forKeys:_dataFirstPageIDArray];
    
    if (_dataFirstPageImageArray.count>0) {
        isClothExist = YES;
    }
    //    NSLog(@"获取图片=%@",_dataFirstPageImageArray);
    return isClothExist;
}
#pragma mark  本地JSON内容
//读取对应布板的json内容  包括名字 以及对每一块布的描述
- (BOOL)GetALLInfoLocalClothDetailWithPathFileWt:(NSString*)clothNameStringID withTitleName:(NSString*)titlname{
    //是否存在
    BOOL isDownloadClothPlate = NO;
    //初始化数组
    _dataLocalAllInfoArray = [NSMutableArray array];
    //存储名字
    _dataFirstPageNameArray = [NSMutableArray array];
    //路径后缀
    NSString *pathName = [NSString stringWithFormat:@"%@.json",titlname];
    //根据ID 提取路径
    for (NSString *JsonFilePath in _dataPathArray) {
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
                [_dataLocalAllInfoArray addObject:ClothPlateModel];
                //取出名字
                [_dataFirstPageNameArray addObject:ClothPlateModel.name];
            }
            if(_dataLocalAllInfoArray.count>0){
                isDownloadClothPlate = YES;
            }
        }
    }
    //    NSLog(@"外层的信息 %@",_dataLocalAllInfoArray);
    return isDownloadClothPlate;
}
//根据对应的ID获取详细信息
- (BOOL)getLocalCorrespondingClothInfoWithClothID:(NSString*)stringID {
    //详情描述存在
    BOOL isExistDetailInfo = NO;
    //初始化数组
    _dataDetailArray = [NSMutableArray array];
    
    for (ZDHClothDetailViewControllerClothModel *ClothPlateModel  in _dataLocalAllInfoArray) {
        if ([ClothPlateModel.id_conflict isEqualToString:stringID]) {
            [_dataDetailArray addObject:ClothPlateModel];
            break;
        }
    }
    if (_dataDetailArray.count>0) {
        isExistDetailInfo =YES;
    }
    //    NSLog(@"对应布的信息 ==  %@",_dataDetailArray);
    return isExistDetailInfo;
}
//相关产品
- (BOOL)getLocalAboutClothWithCID:(NSString*)CID {
    //相关产品是否离线下载
    BOOL  isExistAboutCloth = NO;
    //初始化数组
    _dataAboutIDArray = [NSMutableArray array];
    _dataAboutImageArray = [NSMutableArray array];
    _dataAboutNameArray = [NSMutableArray array];
    for (ZDHClothDetailViewControllerClothModel *ClothPlateModel  in _dataLocalAllInfoArray) {
        if ([ClothPlateModel.id_conflict isEqualToString:CID]) {
            for (ZDHClothDetailViewClothPlateModel *plateModel in ClothPlateModel.aboutbuban) {
                [_dataAboutNameArray addObject:plateModel.name];
                [_dataAboutIDArray addObject:plateModel.id_conflict];
            }
        }
    }
    //取出图片
    for (NSString *IDString in _dataAboutIDArray) {
        UIImage *image = (UIImage*)[_LocalAllImageDict objectForKey:IDString];
        [_dataAboutImageArray addObject:image?image:@""];//找不到图片存入一张空的
    }
    if (_dataAboutIDArray.count>0) {
        isExistAboutCloth = YES;
    }
    
    return isExistAboutCloth;
}
//----------------------前人的方法--------------------------
//从本地获取图片,图片名称,图片ID
- (void)getFirstPageAllImageFromLocal{
    if (_isDownload) {
        NSArray *fileArray = [_fileManager contentsOfDirectoryAtPath:_filePath error:nil];
        for (NSString *fileName in fileArray) {
            if ([[fileName substringFromIndex:(fileName.length-3)] isEqualToString:@"jpg"]) {
                //图片
                NSString *addString = [NSString stringWithFormat:@"%@/%@",_filePath,fileName];
                UIImage *allImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:addString]];
                [_dataFirstPageImageArray addObject:allImage];
                //ID
                NSArray *imageArray = [fileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_."]];
                [_dataFirstPageIDArray addObject:imageArray[0]];
            }
        }
    }
}
//从本地获取Model
- (void)getFirstPageModelFromLocalWithCID:(NSString *)CID{
    for (NSString *cid in _dataFirstPageIDArray) {
        if ([cid isEqualToString:CID]) {
            ZDHClothDetailViewControllerClothModel *listModel = [[ZDHClothDetailViewControllerClothModel alloc] init];
            listModel.cloth_img = [_dataFirstPageImageArray objectAtIndex:[_dataFirstPageIDArray indexOfObject:cid]];
            listModel.cloth_color = @"";
            listModel.cloth_direction = @"";
            listModel.cloth_number = @"";
            listModel.cloth_status = @"";
            listModel.cloth_use = @"";
            listModel.cloth_way = @"";
            listModel.cloth_width = @"";
            listModel.clothdensity = @"";
            listModel.intro = @"";
            listModel.name = @"";
            listModel.part = @"";
            [_dataDetailArray addObject:listModel];
        }
    }
    NSLog(@"%@",CID);
}
//----------------------end--------------------------
@end
