//
//  ZDHClothesTopViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHClothesTopViewModel : NSObject

@property (nonatomic, strong) NSString *error_;

@property (nonatomic, copy) NSString *hint;

@property (nonatomic, strong) NSMutableArray *tyle_list;

@property (nonatomic, copy) NSMutableArray *clothlist_list;

@end

