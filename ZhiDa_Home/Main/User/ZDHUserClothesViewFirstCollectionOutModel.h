//
//  ZDHUserClothesViewFirstCollectionOutModel.h
//  ZhiDa_Home
//
//  Created by apple on 16/3/13.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDHUserClothesViewFirstClothesListCollectionModel.h"

@interface ZDHUserClothesViewFirstCollectionOutModel : NSObject
//存储collection数据源
@property (strong ,nonatomic)  NSMutableArray *clothlist_list;
@property (strong ,nonatomic)  NSString *error_;
@property (strong ,nonatomic)  NSString *hint;
@property (strong ,nonatomic)  NSString *tyle_list;
@property (strong ,nonatomic)  NSArray *year_list;
@end
