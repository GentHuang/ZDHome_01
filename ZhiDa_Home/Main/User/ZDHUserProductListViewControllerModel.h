//
//  ZDHUserProductListViewControllerModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/30.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDHUserProductListViewControllerItemproinfoModel.h"

@interface ZDHUserProductListViewControllerModel : NSObject
@property (strong, nonatomic) NSString *addresult;
@property (strong, nonatomic) NSString *bespoke_detail;
@property (strong, nonatomic) NSString *bespoke_list;
@property (strong, nonatomic) NSString *desgin_list;
@property (strong, nonatomic) NSString *design_detail;
@property (strong, nonatomic) NSString *designplan_iteminfo;
@property (strong, nonatomic) ZDHUserProductListViewControllerItemproinfoModel *designplan_itemproinfo;
@property (strong, nonatomic) NSString *designplan_list;
@property (strong, nonatomic) NSString *error_;
@property (strong, nonatomic) NSString *hint;
@property (strong, nonatomic) NSString *order_logs;
@property (strong, nonatomic) NSString *order_opinions;
@property (strong, nonatomic) NSString *shop_detail;
@property (strong, nonatomic) NSString *shop_list;
@end
