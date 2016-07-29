//
//  ZDHLIstViewClothesViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHLIstViewClothesViewModel.h"
#import "AFNetworking.h"
//Model
#import "ZDHListViewClothesModel.h"
@interface ZDHLIstViewClothesViewModel()<NSURLConnectionDataDelegate>
@property (assign, nonatomic) int requestCount;
@end

@implementation ZDHLIstViewClothesViewModel
//转换数据和获取包大小
- (void)transfromDataWith:(NSArray *)modelArray{
    //清空数据
    _titleArray = [NSMutableArray array];
    _sizeArray = [NSMutableArray array];
    _downloadArray = [NSMutableArray array];
    //转换数据
    for (ZDHListViewClothesModel *clothesModel in modelArray) {
        [_titleArray addObject:clothesModel.name];
        float size = [clothesModel.size floatValue]/1024.0;
        [_sizeArray addObject:[NSString stringWithFormat:@"%.02fMB",size]];
        [_downloadArray addObject:clothesModel.downurl];
    }
}
//获取包大小
- (void)getRealSize:(NSArray *)urlArray success:(ResultBlock)successBlock{
    //清空数据
    _requestCount = 0;
    _realSizeArray = [NSMutableArray array];
    for (NSString *urlString in urlArray) {
        [_realSizeArray addObject:urlString];
    }
    //下载队列
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    //    __block NSInteger ZIPSize;
    __block long long ZIPSize;
    for (NSString *url in urlArray) {
        //转换成网址的格式（原URL带中文）
        NSString *urlString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,NULL,NULL,kCFStringEncodingUTF8));
        
        //测试版   - - -  正式版记得删除
//        [urlString insertString:@":8000" atIndex:22];
       urlString = [urlString stringByReplacingOccurrencesOfString:@"/uploadfiles"withString:@":8000/uploadfiles"];

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"HEAD"];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             ZIPSize = operation.response.expectedContentLength;
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
             if (_requestCount == urlArray.count) {
                 successBlock(_realSizeArray,nil);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             NSLog(@"Error: %@", error);
         }];
        [operationQueue addOperation:operation];
    }
}
@end

