//
//  ZDHListViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHListViewViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *sceneArray;
@property (strong, nonatomic) NSMutableArray *clothesArray;
//add
@property (strong, nonatomic) NSMutableArray *allpacksArray;
@property (strong, nonatomic) NSMutableArray *clothAllpacksArray;

//获取空间下载列表
- (void)getSceneDownloadListWithUrlSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//获取布板下载列表
- (void)getClothesDownloadListSuccess:(SuccessBlock)success fail:(FailBlock)fail;
@end
