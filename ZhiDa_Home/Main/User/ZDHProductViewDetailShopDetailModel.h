//
//  ZDHProductViewDetailShopDetailModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHProductViewDetailShopDetailModel : NSObject
@property (strong, nonatomic) NSString *adddate;
@property (strong, nonatomic) NSString *addman;
@property (strong, nonatomic) NSString *checkman;
@property (strong, nonatomic) NSString *checktime;
@property (strong, nonatomic) NSMutableArray *curtainlist;
@property (strong, nonatomic) NSMutableArray *expresslist;
@property (strong, nonatomic) NSMutableArray *furniturelist;
@property (strong, nonatomic) NSString *orderid;
@property (strong, nonatomic) NSString *ordertype;
@property (strong, nonatomic) NSMutableArray *otherlist;
@property (strong, nonatomic) NSString *recheckman;
@property (strong, nonatomic) NSString *rechecktime;//添加属性
@property (strong, nonatomic) NSString *remarks;
@property (strong, nonatomic) NSString *shipmentdate;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *store;
//添加的字段
@property (strong, nonatomic) NSString *feedback;
@property (strong, nonatomic) NSString *checkmanname;
@end
