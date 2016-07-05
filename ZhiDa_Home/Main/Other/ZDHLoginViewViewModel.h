//
//  ZDHLoginViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHLoginViewViewModel : NSObject
//用户登录
- (void)getLoginWithName:(NSString *)name PSW:(NSString *)psw Success:(SuccessBlock)success fail:(FailBlock)fail;
@end
