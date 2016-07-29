//
//  ZDHMyOrderViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZDHMyOrderViewOrderViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataOrderListArray;
@property (strong, nonatomic) NSMutableArray *dataDetailArray;
@property (strong, nonatomic) NSMutableArray *dataOpinionArray;
@property (strong, nonatomic) NSMutableArray *dataResponseArray;

//搜索标志
@property (copy, nonatomic) NSString *searchSizeString;

//获取预约单列表
- (void)getOrderListWithMemberid:(NSString *)memberID page:(NSInteger)page success:(SuccessBlock)success fail:(FailBlock)fail;
//获取预约详情
- (void)getOrderDetailWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail;
//获取预约详情反馈
- (void)getOrderResponseWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail;
@end
