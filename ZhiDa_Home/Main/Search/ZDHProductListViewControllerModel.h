//
//  ZDHProductListViewControllerModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHProductListViewControllerModel : NSObject
@property (strong, nonatomic) NSString *aboutinfo;
@property (strong, nonatomic) NSString *error_;
@property (strong, nonatomic) NSString *hint;
@property (strong, nonatomic) NSString *search_keywork;
@property (strong, nonatomic) NSString *hotsearch_word;
@property (strong, nonatomic) NSMutableArray *search_product;
@end
