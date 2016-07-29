//
//  ZDHLIstViewCellViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHLIstViewCellViewModel.h"
#import "AFNetworking.h"
//Model
#import "ZDHListViewSceneModel.h"
#import "ZDHListViewClothesModel.h"
#import "Main.h"
@interface ZDHLIstViewCellViewModel()
@property (strong, nonatomic) NSArray *sceneArray;
@property (strong, nonatomic) NSArray *clothesArray;
@property (nonatomic, strong) NSFileManager *manager;
//下载队列
@property (strong, nonatomic) NSMutableArray *downloadArray;
@property (strong, nonatomic) NSMutableArray *downloadTitleArray;
//已经下载了多少
@property (nonatomic, assign) long long downloadSizeBytes;

//存储管理列表模型
@property (nonatomic,strong) NSArray *manageDownloadModelArray;;
@end

@implementation ZDHLIstViewCellViewModel
//初始化
- (instancetype)init{
    if (self = [super init]) {
        //下载队列
        _downloadArray = [NSMutableArray array];
        _downloadTitleArray = [NSMutableArray array];
        //文件管理
        _manager = [[NSFileManager alloc] init];
    }
    return self;
}
#pragma mark -CellStatus
//初始化SceneCell状态
- (void)storedDataWithSceneArray:(NSArray *)sceneArray realSizeArray:(NSArray *)array{
    _sceneArray = sceneArray;
    if (!_sceneCellStatusArray) {
        //首次创建
        _sceneCellStatusArray = [NSMutableArray array];
        for (int i = 0; i < sceneArray.count; i ++) {
            //按钮状态
            ZDHLIstViewCellStatus *cellStatus = [[ZDHLIstViewCellStatus alloc] init];
            cellStatus.isDownloading = NO;
            [cellStatus setIsStart];
            //进度条状态
            ZDHListViewSceneModel *sceneModel = sceneArray[i];
            CGFloat localSize = (CGFloat)[self checkFileSize:sceneModel.name];
            CGFloat ZIPSize = [array[i] floatValue];
            cellStatus.progress = localSize/ZIPSize;
            BOOL isDir = YES;
            if ([_manager fileExistsAtPath:[self getUnZipPath:sceneModel.name] isDirectory:&isDir]) {
                cellStatus.progress = 1;
            }
            cellStatus.title = sceneModel.name;
            [_sceneCellStatusArray addObject:cellStatus];
        }
    }else{
        //已存在状态信息
        for (int i = 0; i < _sceneCellStatusArray.count; i ++) {
            ZDHLIstViewCellStatus *cellStatus = _sceneCellStatusArray[i];
            if (!cellStatus.isDownloading) {
                //正在下载中的cell状态不变
                //进度条状态
                ZDHListViewSceneModel *sceneModel = sceneArray[i];
                CGFloat localSize = (CGFloat)[self checkFileSize:sceneModel.name];
                CGFloat ZIPSize = [array[i] floatValue];
                cellStatus.progress = localSize/ZIPSize;
                BOOL isDir = YES;
                if ([_manager fileExistsAtPath:[self getUnZipPath:sceneModel.name] isDirectory:&isDir]) {
                    cellStatus.progress = 1;
                }else if (cellStatus.progress == 0){
                    [cellStatus setIsStart];
                }
            }
        }
    }
}
//初始化ClothesCell状态
- (void)storedDataWithClothesArray:(NSArray *)clothesArray realSizeArray:(NSArray *)array{
    _clothesArray = clothesArray;
    if (!_clothesCellStatusArray) {
        //首次创建
        _clothesCellStatusArray = [NSMutableArray array];
        for (int i = 0; i < clothesArray.count; i ++) {
            //按钮状态
            ZDHLIstViewCellStatus *cellStatus = [[ZDHLIstViewCellStatus alloc] init];
            cellStatus.isDownloading = NO;
            [cellStatus setIsStart];
            //进度条状态
            ZDHListViewClothesModel *clothesModel = clothesArray[i];
            CGFloat localSize = (CGFloat)[self checkFileSize:clothesModel.name];
            CGFloat ZIPSize = [array[i] floatValue];
            cellStatus.progress = localSize/ZIPSize;
            BOOL isDir = YES;
            if ([_manager fileExistsAtPath:[self getUnZipPath:clothesModel.name] isDirectory:&isDir]) {
                cellStatus.progress = 1;
            }
            cellStatus.title = clothesModel.name;
            [_clothesCellStatusArray addObject:cellStatus];
        }
    }else{
        //已存在状态信息
        for (int i = 0; i < _clothesCellStatusArray.count; i ++) {
            ZDHLIstViewCellStatus *cellStatus = _clothesCellStatusArray[i];
            if (!cellStatus.isDownloading) {
                //正在下载中的cell状态不变
                //进度条状态
                ZDHListViewClothesModel *clothesModel = clothesArray[i];
                CGFloat localSize = (CGFloat)[self checkFileSize:clothesModel.name];
                CGFloat ZIPSize = [array[i] floatValue];
                cellStatus.progress = localSize/ZIPSize;
                BOOL isDir = YES;
                if ([_manager fileExistsAtPath:[self getUnZipPath:clothesModel.name] isDirectory:&isDir]) {
                    cellStatus.progress = 1;
                }else if (cellStatus.progress == 0){
                    [cellStatus setIsStart];
                }
            }
        }
    }
}
//返回Button状态
- (int)getButtonStatus:(ZDHLIstViewCellStatus *)cellStatus{
    if (cellStatus.isStart) {
        return 0;
    }else if(cellStatus.isStop){
        return 1;
    }else if(cellStatus.isContinue){
        return 3;
    }else{
        return 2;
    }
}
//返回下载进度
- (CGFloat)getProgress:(ZDHLIstViewCellStatus *)cellStatus{
    return cellStatus.progress;
}
//返回是否正在下载中
- (BOOL)getIsDownloading:(ZDHLIstViewCellStatus *)cellStatus{
    return cellStatus.isDownloading;
}
#pragma mark -Download
//下载的路径
- (NSString *)getDownloadPath:(NSString *)titleText{
    return [DownloadPath stringByAppendingFormat:@"/%@.zip",titleText];
}
// 检查文件的大小
- (long long)checkFileSize:(NSString *)titleText{
    long long fileSize = 0;
    if ([_manager fileExistsAtPath:[self getDownloadPath:titleText]]){
        //读取文件大小
        NSDictionary *attributes = [_manager attributesOfItemAtPath:[self getDownloadPath:titleText] error:nil];
        fileSize = [attributes fileSize];
    }
    return fileSize;
}

//寻找对应的operation
- (AFHTTPRequestOperation *)getOperation:(NSString *)urlString{
    for (AFHTTPRequestOperation *operation in _downloadArray) {
        NSString *url = [operation.userInfo valueForKey:@"urlString"];
        if ([urlString isEqualToString:url]) {
            return operation;
        }
    }
    return nil;
}

//放进下载队列
- (void)getIntoDownloadQueue:(NSString *)url titleText:(NSString *)titleText{
    NSLog(@"下载队列URl ----》%@",url);
    //转换成网址的格式（原URL带中文）
    _downloadSizeBytes = 0;
    NSString *urlString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,NULL,NULL,kCFStringEncodingUTF8));
    
    //测试版   - - -  正式版记得删除
//    [urlString insertString:@":8000" atIndex:22];
   urlString = [urlString stringByReplacingOccurrencesOfString:@"/uploadfiles"withString:@":8000/uploadfiles"];

    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    _downloadSizeBytes = [self checkFileSize:titleText];
    //告诉服务器从哪开始下载
    if (_downloadSizeBytes != 0) {
        
        [request setValue:[NSString stringWithFormat:@"bytes=%qu-",_downloadSizeBytes] forHTTPHeaderField:@"Range"];
    }
    //不使用缓存，避免断点续传出现问题
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    //删除所有的响应缓存，避免有错误的响应被缓存导致响应出错
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //开始发送请求
    AFHTTPRequestOperation *downlaodOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [downlaodOperation setValue:@0 forKey:@"totalBytesRead"];
    //下载的路径
    downlaodOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:[self getDownloadPath:titleText] append:YES];
    //标识下载任务
    downlaodOperation.userInfo = @{@"urlString":url};
    if (_downloadArray.count == 0) {
        [_downloadArray addObject:downlaodOperation];
        [_downloadTitleArray addObject:titleText];
        [self startDownload:_downloadArray[0] titleText:_downloadTitleArray[0]];
    }else{
        [_downloadArray addObject:downlaodOperation];
        [_downloadTitleArray addObject:titleText];
    }
}
//开始下载
- (void)startDownload:(AFHTTPRequestOperation *)operation titleText:(NSString *)titleText{
    //获取正在下载的URL
    NSString *urlString = [operation.userInfo valueForKey:@"urlString"];
    //进度的回调
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //计算进度
        CGFloat progess = (CGFloat)(totalBytesRead + _downloadSizeBytes) / (totalBytesExpectedToRead + _downloadSizeBytes);
        self.processBlock(progess,urlString);
    }];
    //完成回调
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [operation cancel];
        [self popFromDownloadArray:operation titleText:titleText];
        [self unZipFile:titleText];
        [self modifiedCellStatusWhenDownloadFinish:titleText];
        [self saveDownloadCellWhenDownloadFinish:titleText];
//        NSLog(@"下载完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [operation cancel];
        if (_downloadArray.count > 0) {
            [_downloadArray removeAllObjects];
            [_downloadTitleArray removeAllObjects];
        }
        //发出下载出错的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHLIstViewCellViewModel" object:self userInfo:@{@"title":titleText}];
//        NSLog(@"下载出错%@",error);
    }];
    //开始下载
    [operation start];
}
//暂停下载
- (void)pauseDownload:(NSString *)urlString{
    //暂停
    if (_downloadArray.count > 0) {
        AFHTTPRequestOperation *operation = [self getOperation:urlString];
        [operation pause];
        int index = (int)[_downloadArray indexOfObject:operation];
        if (index >= 0) {
            [self popFromDownloadArray:_downloadArray[index] titleText:_downloadTitleArray[index]];
        }
    }
}
//弹出下载队列
- (void)popFromDownloadArray:(AFHTTPRequestOperation *)operation titleText:(NSString *)titleText{
    if (_downloadArray.count == 1) {
        [_downloadArray removeAllObjects];
        [_downloadTitleArray removeAllObjects];
    }else{
        if (operation == _downloadArray[0]) {
            [self startDownload:_downloadArray[1] titleText:_downloadTitleArray[1]];
        }
        int index = (int)[_downloadArray indexOfObject:operation];
        [_downloadArray removeObject:_downloadArray[index]];
        [_downloadTitleArray removeObject:_downloadTitleArray[index]];
    }
}
//解压缩文件路径
- (NSString *)getUnZipPath:(NSString *)title{
    return [DownloadPath stringByAppendingFormat:@"/%@",title];
}
//解压缩文件
- (void)unZipFile:(NSString *)title{
    NSString *zipPath = [self getDownloadPath:title];
    NSString *destinationPath = [self getUnZipPath:title];
    //文件解压放在子线程 避免卡线程
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
//        [Main unzipFileAtPath:zipPath toDestination:destinationPath overwrite:YES password:nil error:nil delegate:nil progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
//            
////            NSLog(@"%ld %ld %ld %ld",entryNumber,total,zipInfo.compressed_size,zipInfo.uncompressed_size);
//            
//        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
//            [self deleteZipFile:title];
//        }];
//    }];
//    
//    [queue addOperation:blockOperation];
   //解压过程中
    if(self.FinisUpZIP){
    self.FinisUpZIP(@"no");
    }
    //GCD
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue1, ^{
        [Main unzipFileAtPath:zipPath toDestination:destinationPath overwrite:YES password:nil error:nil delegate:nil progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
            
        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            [self deleteZipFile:title];
            if(self.FinisUpZIP){
              self.FinisUpZIP(@"yes");
            }
        }];
    });
}
//下载完成后需要改变cellStatus
- (void)modifiedCellStatusWhenDownloadFinish:(NSString *)title{
    for (ZDHLIstViewCellStatus *cellStatus in _sceneCellStatusArray) {
        if ([cellStatus.title isEqualToString:title]) {
            cellStatus.isDownloading = NO;
        }
    }
    for (ZDHLIstViewCellStatus *cellStatus in _clothesCellStatusArray) {
        if ([cellStatus.title isEqualToString:title]) {
            cellStatus.isDownloading = NO;
        }
    }
    //----------------------------添加---------------------------------------
    for (ZDHLIstViewCellStatus *cellStatus in _cellStatusArray) {
        if ([cellStatus.title isEqualToString:title]) {
            cellStatus.isDownloading = NO;
        }
    }
}
//将完成下载的Cell存入数据库
- (void)saveDownloadCellWhenDownloadFinish:(NSString *)title{
    for (ZDHListViewSceneModel *cellModel in _sceneArray) {
        if ([cellModel.name isEqualToString:title]) {
            [[FMDBManager sharedInstace] creatTable:cellModel];
            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:cellModel];
        }
    }
    for (ZDHListViewClothesModel *cellModel in _clothesArray) {
        if ([cellModel.name isEqualToString:title]) {
            [[FMDBManager sharedInstace] creatTable:cellModel];
            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:cellModel];
        }
    }
    //更新数据库
    if ((_sceneArray.count==0||_clothesArray.count==0)) {
        for (ZDHListViewClothesModel *cellModel in _manageDownloadModelArray) {
            if ([cellModel.name isEqualToString:title]) {
                [[FMDBManager sharedInstace] creatTable:cellModel];
                [[FMDBManager sharedInstace] update: @"ZDHListViewClothesModel" WithSetValue:@{@"byte":cellModel.byte} withWhere:@{@"downurl":cellModel.downurl}];
            }
        }
        for (ZDHListViewSceneModel *sceneModel in _manageDownloadModelArray) {
            if ([sceneModel.name isEqualToString:title]) {
                [[FMDBManager sharedInstace] creatTable:sceneModel];
                [[FMDBManager sharedInstace] update: @"ZDHListViewSceneModel" WithSetValue:@{@"byte":sceneModel.byte} withWhere:@{@"downurl":sceneModel.downurl}];
            }
        }
    }
}
//停止全部任务
- (void)cancelAllDownload{
    for (AFHTTPRequestOperation *operation in _downloadArray) {
        [operation pause];
    }
}
//删除压缩包
- (void)deleteZipFile:(NSString *)title{
    if ([_manager removeItemAtPath:[self getDownloadPath:title] error:nil]) {
//        NSLog(@"文件解压缩成功，压缩文件已删除");
    }
}
#pragma mark  ----- Add my Method ---------
- (void)storedDataWith:(NSArray *)DownloadModelArray withNetModel:(NSArray*)NetDownloadModelArray{
    _manageDownloadModelArray = NetDownloadModelArray;
    //1.首次创建 2.__cellStatusArray存在长度为零 3.添加新的下载cell到管理列表时候
    if (!_cellStatusArray||_cellStatusArray.count==0||(_cellStatusArray.count>0 &&_cellStatusArray.count<DownloadModelArray.count)) {
        //首次创建
        _cellStatusArray = [NSMutableArray array];
        for (int i = 0; i < DownloadModelArray.count; i ++) {
            //按钮状态
            ZDHLIstViewCellStatus *cellStatus = [[ZDHLIstViewCellStatus alloc] init];
            cellStatus.isDownloading = NO;
            [cellStatus setIsStart];
            ZDHListViewClothesModel *clotesModel =DownloadModelArray[i];
            //进度条状态
            CGFloat localSize = (CGFloat)[self checkFileSize:clotesModel.name];
            CGFloat ZIPSize = [clotesModel.size floatValue];
            cellStatus.progress = localSize/(ZIPSize*1024);
            cellStatus.title = clotesModel.name;
            [_cellStatusArray addObject:cellStatus];
            //如果有cell添加到管理列表，暂停所有当前下载的任务
            if(_cellStatusArray>0)
               {
                   //暂停所有下载
                   [self cancelAllDownload];
               }
        }
    }else{
        //已存在状态信息
        for (int i = 0; i < DownloadModelArray.count; i ++) {
            ZDHLIstViewCellStatus *cellStatus = _cellStatusArray[i];
            if (!cellStatus.isDownloading) {
                //正在下载中的cell状态不变
                //进度条状态
                ZDHListViewClothesModel *clotesModel =DownloadModelArray[i];
                CGFloat localSize = (CGFloat)[self checkFileSize:clotesModel.name];
                CGFloat ZIPSize = [clotesModel.size floatValue];
                cellStatus.progress = localSize/(ZIPSize*1024);
                if(cellStatus.progress==0){
                    [cellStatus setIsStart];
                }
            }
        }
    }
}
//删除数据库对应的实体
- (void)removeObjectWithName:(NSString*)title{
    [[FMDBManager sharedInstace]deleteModelInDatabase:[ZDHListViewClothesModel class] withDic:@{@"name":title}];
    [[FMDBManager sharedInstace]deleteModelInDatabase:[ZDHListViewSceneModel class] withDic:@{@"name":title}];
//    NSLog(@"删除成功%@~~~",title);
}
@end
