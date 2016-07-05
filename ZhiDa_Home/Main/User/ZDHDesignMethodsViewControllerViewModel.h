//
//  ZDHDesignMethodsViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/30.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHDesignMethodsViewControllerViewModel : NSObject
@property (strong, nonatomic) NSArray *dataImageArray;
@property (strong, nonatomic) NSString *contentString;
@property (strong, nonatomic) NSMutableArray *dataTitleArray;
@property (strong, nonatomic) NSMutableArray *dataItemIDArray;
//获取设计方案详情
- (void)getDesignMethodWithPlanID:(NSString *)planID itemID:(NSString *)itemID success:(SuccessBlock)success fail:(FailBlock)fail;
@end
