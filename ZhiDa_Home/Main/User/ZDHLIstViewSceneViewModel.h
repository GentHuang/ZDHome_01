//
//  ZDHLIstViewSceneViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHLIstViewSceneViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) NSMutableArray *sizeArray;
@property (strong, nonatomic) NSMutableArray *downloadArray;
@property (strong, nonatomic) NSMutableArray *realSizeArray;
//转换数据和获取包大小
- (void)transfromDataWith:(NSArray *)modelArray;
//获取包大小
- (void)getRealSize:(NSArray *)urlArray success:(ResultBlock)successBlock;

//获取包大小，添加如果获取失败返回一个空值
//- (void)getRealSize:(NSArray *)urlArray success:(ResultBlock)successBlock fail:(ResultBlock)failBlock;

@end
