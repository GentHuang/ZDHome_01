//
//  ZDHLIstViewSceneViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHLIstViewSceneViewModel.h"
#import "AFNetworking.h"
//Model
#import "ZDHListViewSceneModel.h"
@interface ZDHLIstViewSceneViewModel()
@property (assign, nonatomic) int requestCount;
@end
@implementation ZDHLIstViewSceneViewModel
//转换数据和获取包大小
- (void)transfromDataWith:(NSArray *)modelArray{
    //清空数据
    _titleArray = [NSMutableArray array];
    _sizeArray = [NSMutableArray array];
    _downloadArray = [NSMutableArray array];
    //转换数据
    for (ZDHListViewSceneModel *sceneModel in modelArray) {
        [_titleArray addObject:sceneModel.name];
        float size = [sceneModel.size floatValue]/1024.0;
        [_sizeArray addObject:[NSString stringWithFormat:@"%.02fMB",size]];
        [_downloadArray addObject:sceneModel.downurl];
    }
}
//获取包大小
- (void)getRealSize:(NSArray *)urlArray success:(ResultBlock)successBlock{
    //清空数据
    _realSizeArray = [NSMutableArray array];
    for (NSString *urlString in urlArray) {
        [_realSizeArray addObject:urlString];
    }
    //网络请求计数
    _requestCount = 0;
    //下载队列
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    __block long long ZIPSize;
    NSLog(@"连接 %@",urlArray);
   //测试需求在链接添加端口8000
    for (NSString *url in urlArray) {// (NSString *url in urlArray)
    //转换成网址的格式（原URL带中文）
        
//        NSMutableString *urlString = (NSMutableString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,NULL,NULL,kCFStringEncodingUTF8));
        
       NSString *urlString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,NULL,NULL,kCFStringEncodingUTF8));
        //测试版   - - -  正式版记得删除
//        [urlString insertString:@":8000" atIndex:22];
       urlString = [urlString stringByReplacingOccurrencesOfString:@"/uploadfiles"withString:@":8000/uploadfiles"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"HEAD"];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             ZIPSize = [operation.response expectedContentLength];
             _requestCount ++;
             //排序
             for (NSString *urlString in urlArray) {
                 if ([url isEqualToString:urlString]) {
                     int index = (int)[urlArray indexOfObject:urlString];
                     _realSizeArray[index] = [NSNumber numberWithLongLong:ZIPSize];
                     break;
                 }
             }
             //队列满了就弹出
             if ((_requestCount+2) == urlArray.count) {
                 successBlock(_realSizeArray,nil);
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             NSLog(@"Error: %@", error);
         }];
        [operationQueue addOperation:operation];
    }
    
    
}

#pragma mark myMethod
////获取包大小
//- (void)getRealSize:(NSArray *)urlArray success:(ResultBlock)successBlock fail:(ResultBlock)failBlock{
//    //清空数据
//    _realSizeArray = [NSMutableArray array];
//    for (NSString *urlString in urlArray) {
//        [_realSizeArray addObject:urlString];
//    }
//    //网络请求计数
//    _requestCount = 0;
//    //下载队列
//    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
//    __block long long ZIPSize;
//    for (NSString *url in urlArray) {
//        //转换成网址的格式（原URL带中文）
//        NSMutableString *urlString = (NSMutableString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,NULL,NULL,kCFStringEncodingUTF8));
//        
//        [urlString insertString:@":8000" atIndex:22];
//
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//        [request setHTTPMethod:@"HEAD"];
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//         {
//             ZIPSize = [operation.response expectedContentLength];
//             _requestCount ++;
//             //排序
//             for (NSString *urlString in urlArray) {
//                 if ([url isEqualToString:urlString]) {
//                     int index = (int)[urlArray indexOfObject:urlString];
//                     _realSizeArray[index] = [NSNumber numberWithLongLong:ZIPSize];
//                     break;
//                 }
//             }
//             //队列满了就弹出
//             if (_requestCount == urlArray.count) {
//                 successBlock(_realSizeArray,nil);
//             }
//         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             NSLog(@"Error: %@", error);
//         }];
//        failBlock(nil,nil);
//        [operationQueue addOperation:operation];
//    }
//}

@end
