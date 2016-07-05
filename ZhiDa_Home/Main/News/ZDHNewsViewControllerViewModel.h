//
//  ZDHNewsViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHNewsViewControllerViewModel : NSObject
@property (strong, nonatomic) NSString *newsID;
@property (strong, nonatomic) NSMutableArray *dataTitleArray;
@property (strong, nonatomic) NSMutableArray *dataTitleIDArray;
@property (strong, nonatomic) NSMutableArray *dataNewsInfoArray;
@property (strong, nonatomic) NSMutableArray *dataNewsNIDArray;
@property (strong, nonatomic) NSMutableArray *dataNewsDetailArray;
@property (strong, nonatomic) NSMutableArray *dataDetailArray;
@property (copy, nonatomic) SuccessBlock detailSuccess;
//获取内部资讯头部
- (void)getIntetNewsTitleSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//根据NID数组获取资讯详情
- (void)getNewsDetailWithNIDArray:(NSArray *)nidArray;
//根据Tid获取资讯简介
- (void)getNewsInfoWithTID:(NSString *)tid success:(SuccessBlock)success fail:(FailBlock)fail;
@end
