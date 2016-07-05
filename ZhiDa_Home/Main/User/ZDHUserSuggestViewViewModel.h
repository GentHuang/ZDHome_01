//
//  ZDHUserSuggestViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHUserSuggestViewViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataOpinionTimeArray;
@property (strong, nonatomic) NSMutableArray *dataOpinionNameArray;
@property (strong, nonatomic) NSMutableArray *dataOpinionContentArray;

//根据OrderID获取中途意见
- (void)getDataWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail;
@end
