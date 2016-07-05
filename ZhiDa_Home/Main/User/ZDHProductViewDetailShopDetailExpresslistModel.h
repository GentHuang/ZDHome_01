//
//  ZDHProductViewDetailShopDetailExpresslistModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDHProductViewDetailShopDetailExpresslistErpexpressinfoModel.h"
@interface ZDHProductViewDetailShopDetailExpresslistModel : NSObject
@property (strong, nonatomic) ZDHProductViewDetailShopDetailExpresslistErpexpressinfoModel *erpexpressinfo;
@property (strong, nonatomic) NSString *erpnumber;
@property (strong, nonatomic) NSString *expressnumber;
@property (strong, nonatomic) NSString *exptype;
@end
