//
//  ZDHProductCenterZhiDaViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductCenterZhiDaViewControllerViewModel.h"
//Model
#import "ZDHProductCenterZhiDaViewModel.h"
#import "ZDHProductCenterZhiDaViewThemeModel.h"
#import "ZDHProductCenterZhiDaViewThemeimgModel.h"
#import "ZDHProductCenterZhiDaViewThemeimgThemeModel.h"

@interface ZDHProductCenterZhiDaViewControllerViewModel()
@property (assign, nonatomic) BOOL isLoacal;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSMutableArray *localFilePathArray;
@property (strong, nonatomic) NSMutableArray *localFileNameArray;
@property (strong, nonatomic) NSFileManager *fileManager;
//保存风格名字和ID的字典
@property (strong, nonatomic) NSMutableDictionary *titleTypeAndIdDic;
@end

@implementation ZDHProductCenterZhiDaViewControllerViewModel
- (instancetype)init{
    if (self = [super init]) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}
//获取顶部风格
- (void)getYearListSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    
    //---------------
    _dataTypeIdArray =[NSMutableArray array];
    _dataTypeTextArray = [NSMutableArray arrayWithObjects:@"全部风格", nil];
    
    //    _isLoacal = [self checkIfExistInLocal];
    //    if (_isLoacal) {
    //        success(nil);
    //        return ;
    //    }else{
    //        fail(nil);
    //    }
    
    //--------------
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:kZhiDaYearAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:@"全部风格", nil];
        NSMutableArray *dataTextArray = [NSMutableArray arrayWithObjects:@"全部风格", nil];
        NSArray *responseArray = responseObject;
        ZDHProductCenterZhiDaViewModel *vcModel = [[ZDHProductCenterZhiDaViewModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHProductCenterZhiDaViewThemeModel *themeModel in vcModel.themeyear) {
            //获取所有风格
            [dataArray addObject:themeModel.id_conflic];
            [dataTextArray addObject:themeModel.text];
            //            //存入数据库
            //            [[FMDBManager sharedInstace] creatTable:themeModel];
            //            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:themeModel];
        }
        //检测下载是否成功
        if (dataArray.count > 0) {
            _dataTypeIdArray = dataArray;
            _dataTypeTextArray = dataTextArray;
            //把ID和名字保存
            _titleTypeAndIdDic =[[NSMutableDictionary alloc]initWithObjects:_dataTypeTextArray forKeys:_dataTypeIdArray];
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        //检测本地是否存在
        _isLoacal = [self checkIfExistInLocal];
        if (_isLoacal) {
            success(nil);
        }else{
            fail(nil);
        }
    }];
}
//根据年份获取图片数据
- (void)getDataWithYear:(NSString *)year success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataThemeImageArray = [NSMutableArray array];
    _dataThemeIDArray = [NSMutableArray array];
    _dataThemeTitleArray = [NSMutableArray array];
    //组建字符串(当字符串中还有中文)
    if ([year isEqualToString:@"所有"]) {
        year = @"";
    }
    //    //如果是所有则从网络获取优先从本地获取
    if(![year isEqualToString:@"所有"]&&![year isEqualToString:@""]){
    
        if ([self checkIfExistInLocalWithYear:year]) {
            [self loadDataFromLocalWithYear:year];
            if (_dataThemeImageArray.count>0) {//_dataThemeImageArray
                success(nil);
                    return;
            }
    
        }
    }
    NSString *urlString = [NSString stringWithFormat:kZhiDaImageAPI,year];
    //    NSLog(@"urlString ----->%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        
        NSMutableArray *themeImageArray = [NSMutableArray array];
        NSMutableArray *themeIDArray = [NSMutableArray array];
        NSMutableArray *themeTitleArray = [NSMutableArray array];
        
        NSArray *responseArray = responseObject;
        //        NSLog(@"返回的数据----->%@",responseObject);
        ZDHProductCenterZhiDaViewThemeimgModel *vcModel = [[ZDHProductCenterZhiDaViewThemeimgModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHProductCenterZhiDaViewThemeimgThemeModel *themeModel in vcModel.theme) {
            //获取所有图片详情
            [themeImageArray addObject:themeModel.themeimg];
            [themeIDArray addObject:themeModel.id_conflict];
            [themeTitleArray addObject:themeModel.title];
            themeModel.year = year;
            //            //存入数据库
            //            [[FMDBManager sharedInstace] creatTable:themeModel];
            //            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:themeModel];
        }
        //检测下载是否成功
        if (themeImageArray.count > 0) {
            _dataThemeIDArray = themeIDArray;
            _dataThemeImageArray = themeImageArray;
            _dataThemeTitleArray = themeTitleArray;
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        //网络获取失败则从本地获取
        if ([self checkIfExistInLocalWithYear:year]) {
            [self loadDataFromLocalWithYear:year];
            if (_dataThemeImageArray.count>0) {//_dataThemeImageArray
                success(nil);
                return;
            }
        }
        fail(nil);
    }];
}
//从本地检测是否已经下载离线包
- (BOOL)checkIfExistInLocal{
    //初始化数据
    _localFilePathArray = [NSMutableArray array];
    _localFileNameArray = [NSMutableArray array];
    //组建文件夹地址
    _filePath = DownloadPath;
    _dataTypeIdArray =[NSMutableArray arrayWithObjects:@"全部风格", nil];
    _dataTypeTextArray = [NSMutableArray arrayWithObjects:@"全部风格", nil];
    
    BOOL isDirExist = NO;
    //查找文件夹
    NSArray *fileArray = [_fileManager contentsOfDirectoryAtPath:_filePath error:nil];
    for (NSString *titleName in fileArray) {
        NSRange titleRange = [titleName rangeOfString:@"志达家居布艺"];
        if (titleRange.location != NSNotFound) {
            //已经存在的Title
            NSString *title = [titleName substringFromIndex:7];//(titleName.length - 4)
            
            NSString *fileFirstPath = [NSString stringWithFormat:@"%@/%@",_filePath,titleName];
            NSArray *firstPathArray = [_fileManager contentsOfDirectoryAtPath:fileFirstPath error:nil];
            for (NSString *stringPath in firstPathArray) {
                if ([stringPath rangeOfString:@"志达家居布艺"].location!= NSNotFound) {
                    
                    NSString *fileSecondPath = [NSString stringWithFormat:@"%@/%@",fileFirstPath,stringPath];
                    [_localFilePathArray addObject:fileSecondPath];
                    [_localFileNameArray addObject:title];
                    //获取本地的风格类型
                    [_dataTypeTextArray addObject:title];
                    //风格类型ID
                    NSString *IDString = [stringPath substringFromIndex:([stringPath rangeOfString:@"_"].location+1)];
                    [_dataTypeIdArray addObject:IDString];
                }
            }
        }
    }
    if (_dataTypeTextArray.count>0) {
        isDirExist = YES;
    }
    
    return isDirExist;
}
//根据年份检测本地是否有对应的离线包
- (BOOL)checkIfExistInLocalWithYear:(NSString *)year{
    //初始化数据
    _localFilePathArray = [NSMutableArray array];
    _localFileNameArray = [NSMutableArray array];
    //组建文件夹地址
    _filePath = DownloadPath;
    BOOL isDirExist = NO;
    
    //如果传入的是ID则取出相应的title
    if([self iSIDNumber:year]&&![year isEqualToString:@""]){
        year = [_titleTypeAndIdDic objectForKey:year];
    }else if(year==nil){
        
        year=[NSString stringWithFormat:@""];
        
    }
    //查找文件夹
    NSArray *fileArray = [_fileManager contentsOfDirectoryAtPath:_filePath error:nil];
    if ([year isEqualToString:@""]) {
        //搜索全部风格
        NSArray *fileArray = [_fileManager contentsOfDirectoryAtPath:_filePath error:nil];
        for (NSString *titleName in fileArray) {
            NSRange titleRange = [titleName rangeOfString:@"志达家居布艺"];
            if (titleRange.location != NSNotFound) {
                //提取存在的Title
                NSString *title = [titleName substringFromIndex:7];//(titleName.length - 4)];
                //拼接路径
                NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@",_filePath,titleName,titleName];
                //存储所有风格的路径
                [_localFilePathArray addObject:filePath];
                [_localFileNameArray addObject:title];
            }
        }
    }else{
        //搜索特定风格
        for (NSString *titleName in fileArray) {
            
            if ([titleName isEqualToString:[NSString stringWithFormat:@"志达家居布艺_%@",year]]) {
                //获取文件夹 直接拼接
                NSString *fileFirstPath = [NSString stringWithFormat:@"%@/%@/%@",_filePath,titleName,titleName];
                //文件下面的子文件
                //NSArray *firstPathArray = [_fileManager contentsOfDirectoryAtPath:fileFirstPath error:nil];
                
                [_localFilePathArray addObject:fileFirstPath];
                [_localFileNameArray addObject:titleName];
                break;
            }
            
        }
        
    }
    
    if (_localFilePathArray.count>0) {
        isDirExist = YES;
    }
    return isDirExist;
}
//根据年份从本地获取数据
- (void)loadDataFromLocalWithYear:(NSString *)year{
    //如果传入的是ID则取出相应的title
    if([self iSIDNumber:year]&&![year isEqualToString:@""]){
        year = [_titleTypeAndIdDic objectForKey:year];
    }else if(year==nil){
        
        year=[NSString stringWithFormat:@""];
        
    }
    
    if ([year isEqualToString:@""]) {
        //获取所有信息
        for (NSString *filePath in _localFilePathArray) {
            NSArray *secondFileArray = [_fileManager contentsOfDirectoryAtPath:filePath error:nil];
            for (NSString *fileName in secondFileArray) {
                NSString *path = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
                //图片
                if ([[fileName substringFromIndex:(fileName.length - 3)] isEqualToString:@"jpg"]) {
                    [_dataThemeImageArray addObject:[[UIImage alloc] initWithContentsOfFile:path]];
                    
                    NSRange range = [fileName rangeOfString:@"_"];
                    NSString *string = [fileName substringFromIndex:(range.location+1)];
                    NSRange range2 =[string rangeOfString:@"."];
                    NSString *titleName = [string substringToIndex:range2.location];
                    //title
                    [_dataThemeTitleArray addObject:titleName];
                    //ID
                    //                    range = [fileName rangeOfString:@"_"];
                    NSString *ID = [fileName substringToIndex:(range.location)];
                    [_dataThemeIDArray addObject:ID];
                }
            }
        }
    }else{
        //获取对应风格的信息
        NSString *filePath;
        for (NSString *fileName in _localFileNameArray) {
            if ([fileName rangeOfString:year].location !=NSNotFound) {
                filePath = [_localFilePathArray objectAtIndex:[_localFileNameArray indexOfObject:fileName]];
                break;
            }
            
        }
        NSArray *secondFileArray = [_fileManager contentsOfDirectoryAtPath:filePath error:nil];
        
        for (NSString *fileName in secondFileArray) {
            NSString *path = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
            //图片
            if ([[fileName substringFromIndex:(fileName.length - 3)] isEqualToString:@"jpg"]) {
                [_dataThemeImageArray addObject:[[UIImage alloc] initWithContentsOfFile:path]];
                //标题
                NSRange range = [fileName rangeOfString:@"_"];
                NSString *string = [fileName substringFromIndex:(range.location+1)];
                NSRange range2 =[string rangeOfString:@"."];
                NSString *titleName = [string substringToIndex:range2.location];
                
                [_dataThemeTitleArray addObject:titleName];
                //ID
                range = [fileName rangeOfString:@"_"];
                NSString *ID = [fileName substringToIndex:(range.location)];
                [_dataThemeIDArray addObject:ID];
            }
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
