//
//  ZDHSearchViewControllerListModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHSearchViewControllerListModel : NSObject
@property (strong, nonatomic) NSString *error_;
@property (strong, nonatomic) NSString *hint;
@property (strong, nonatomic) NSString *news_list;
@property (strong, nonatomic) NSString *news_news;
@property (strong, nonatomic) NSMutableArray *news_search;
@property (strong, nonatomic) NSString *type_list;
@end
