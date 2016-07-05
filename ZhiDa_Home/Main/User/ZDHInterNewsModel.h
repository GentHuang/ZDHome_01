//
//  ZDHInterNewsModel.h
//  ZhiDa_Home
//
//  Created by 曾梓麟 on 15/9/4.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZDHInterNewsModel : NSObject

@property (nonatomic, strong) NSMutableArray *news_news;

@property (nonatomic, assign) NSString *error_;

@property (nonatomic, copy) NSString *hint;

@property (nonatomic, copy) NSString *type_list;

@property (nonatomic, copy) NSString *news_list;

@property (nonatomic, copy) NSString *news_search;

@end

