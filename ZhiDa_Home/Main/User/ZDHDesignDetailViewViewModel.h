//
//  ZDHDesignDetailViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHDesignDetailViewViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataDetailArray;
@property (strong, nonatomic) NSMutableArray *dataAboutArray;
@property (strong, nonatomic) NSMutableArray *dataItemArray;

//根据OrderID获取设计详情
- (void)getDetailWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail;
@end
