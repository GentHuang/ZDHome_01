//
//  ZDHLoginViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHLoginViewModel : NSObject
@property (strong, nonatomic) NSString *error_;
@property (strong, nonatomic) NSString *hint;
@property (strong, nonatomic) NSMutableArray *loginresult;
@property (strong, nonatomic) NSString *result;

@end
