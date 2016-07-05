//
//  ZDHNewsViewControllerInfoModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHNewsViewControllerInfoModel : NSObject
@property (strong, nonatomic) NSString *error_;
@property (strong, nonatomic) NSString *hint;
@property (strong, nonatomic) NSMutableArray *news_list;
@property (strong, nonatomic) NSString *news_news;
@property (strong, nonatomic) NSString *news_search;
@property (strong, nonatomic) NSString *type_list;
@end
