//
//  ZDHDIYListViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHDIYListViewControllerViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataSpaceTitleArray;
@property (strong, nonatomic) NSMutableArray *dataSpaceIDArray;
@property (strong, nonatomic) NSMutableArray *dataStyleTitleArray;
@property (strong, nonatomic) NSMutableArray *dataStyleIDArray;
@property (strong, nonatomic) NSMutableArray *dataListArray;
//获取风格头部
- (void)getStyleTitleSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//获取空间头部
- (void)getSpaceTitleSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//根据所选的空间和风格获取列表
- (void)getListWithSpaceIndex:(int)spaceIndex styleIndex:(int)styleIndex success:(SuccessBlock)success fail:(FailBlock)fail;
@end
