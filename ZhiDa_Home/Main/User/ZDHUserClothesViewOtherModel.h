//
//  ZDHUserClothesViewOtherModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHUserClothesViewOtherModel : NSObject

@property (nonatomic, strong) NSMutableArray *cloth_list;

@property (nonatomic, copy) NSString *product_list;

@property (nonatomic, copy) NSString *cloth;

@property (nonatomic, assign) NSInteger error_;

@property (nonatomic, copy) NSString *hint;

@end

