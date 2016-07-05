//
//  ZDHProductViewDetailViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHProductViewDetailViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataDetailArray;
@property (strong, nonatomic) NSMutableArray *dataExpresslistArray;
@property (strong, nonatomic) NSMutableArray *dataOtherlistArray;
@property (strong, nonatomic) NSMutableArray *dataCurtainlistArray;
@property (strong, nonatomic) NSMutableArray *dataFurniturelistArray;
@property (strong, nonatomic) NSMutableArray *dataMaxHeightArray;
@property (strong, nonatomic) NSString *statusString;
//根据OrderID获取订单详情
- (void)getProductDetailWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail;
//返回窗帘的行高
- (void)getMaxLineHeighWithDataArray:(NSArray *)dataArray;
@end
