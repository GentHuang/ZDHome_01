//
//  ZDHAllSingleModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHAllSingleModel : NSObject

@property (nonatomic, assign) NSString *error_;

@property (nonatomic, copy) NSString *product;

@property (nonatomic, copy) NSString *proimg;

@property (nonatomic, copy) NSString *procloth;

@property (nonatomic, strong) NSMutableArray *proinfo;

@property (nonatomic, copy) NSString *procolor;

@property (nonatomic, copy) NSString *hint;

@end

