//
//  ZDHUserProductListViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/30.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHUserProductListViewControllerViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataSpaceArray;
@property (strong, nonatomic) NSMutableArray *dataItemInfoArray;
//获取清单列表
- (void)getDataWithPlanID:(NSString *)planID success:(SuccessBlock)success fail:(FailBlock)fail;
@end
