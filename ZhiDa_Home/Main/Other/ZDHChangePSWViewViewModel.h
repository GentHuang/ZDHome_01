//
//  ZDHChangePSWViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHChangePSWViewViewModel : NSObject
//修改密码
- (void)changePSWWithName:(NSString *)name psw:(NSString *)psw newpsd:(NSString *)newpsd success:(SuccessBlock)success fail:(FailBlock)fail;
@end
