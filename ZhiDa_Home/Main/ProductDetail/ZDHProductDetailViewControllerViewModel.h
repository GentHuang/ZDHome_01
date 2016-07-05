//
//  ZDHProductDetailViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHProductDetailViewControllerViewModel : NSObject
@property (strong, nonatomic) NSString *pronumber;
@property (strong, nonatomic) NSMutableArray *dataProductArray;
@property (strong, nonatomic) NSMutableArray *dataTopTitleArray;
@property (strong, nonatomic) NSMutableArray *dataAboutSingleImageArray;
@property (strong, nonatomic) NSMutableArray *dataAboutSingleIDArray;
@property (strong, nonatomic) NSMutableArray *dataAboutProductImageArray;
@property (strong, nonatomic) NSMutableArray *dataAboutProductIDArray;
// 获取顶部的文案
@property (strong, nonatomic) NSMutableArray *titleButtonNameArray;
//根据产品ID获取详情
- (void)getDataWithPID:(NSString *)PID success:(SuccessBlock)success fail:(FailBlock)fail;
//根据产品ID和Pronumber获取相关单品
- (void)getAboutSingleWithPID:(NSString *)PID pronumber:(NSString *)pronumber success:(SuccessBlock)success fail:(FailBlock)fail;
//根据产品ID获取推荐组合
- (void)getAboutProductWithPID:(NSString *)PID success:(SuccessBlock)success fail:(FailBlock)fail;
@end
