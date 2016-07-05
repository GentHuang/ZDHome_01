//
//  ZDHProductDetailViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZDHProductDetailViewModel : NSObject
@property (nonatomic, assign) NSString *error_;

@property (nonatomic, strong) NSMutableArray *product;

@property (nonatomic, copy) NSString *proimg;

@property (nonatomic, copy) NSString *procloth;

@property (nonatomic, copy) NSString *proinfo;

@property (nonatomic, copy) NSString *procolor;

@property (nonatomic, copy) NSString *hint;

@end

