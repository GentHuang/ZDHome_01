//
//  ZDHUserClothesViewFirstModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHUserClothesViewFirstModel : NSObject

@property (nonatomic, assign) NSInteger error_;

@property (nonatomic, copy) NSString *hint;

@property (nonatomic, copy) NSString *tyle_list;

@property (nonatomic, strong) NSMutableArray *clothlist_list;

@property (strong ,nonatomic)  NSArray *year_list;

@end

