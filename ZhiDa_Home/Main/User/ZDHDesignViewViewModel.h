//
//  ZDHDesignViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHDesignViewViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataListArray;
@property (strong, nonatomic) NSMutableArray *dataMethodListArray;
//根据MemberID获取设计列表
- (void)getListWithMemberID:(NSString *)memberID page:(NSInteger)page  success:(SuccessBlock)success fail:(FailBlock)fail;
//根据MemberID获取设计方案列表
- (void)getMethodListWithMemberID:(NSString *)memberID page:(NSInteger)page success:(SuccessBlock)success fail:(FailBlock)fail;
@end
