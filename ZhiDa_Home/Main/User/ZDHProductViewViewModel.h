//
//  ZDHProductViewViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHProductViewViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataListArray;
//根据MemberID 获取商品订单列表
- (void)getProductListWithMemberID:(NSString *)memberID page:(NSInteger)page success:(SuccessBlock)success fail:(FailBlock)fail;
@end
