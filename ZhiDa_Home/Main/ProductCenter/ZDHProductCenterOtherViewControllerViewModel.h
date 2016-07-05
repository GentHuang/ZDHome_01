//
//  ZDHProductCenterOtherViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHProductCenterOtherViewControllerViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataTitleArray;
@property (strong, nonatomic) NSMutableArray *dataAllItemArray;
@property (strong, nonatomic) NSMutableArray *dataItemArray;
@property (strong, nonatomic) NSMutableArray *dataImageArray;
@property (strong, nonatomic) NSMutableArray *dataSingleImageArray;
@property (strong, nonatomic) NSMutableArray *dataSingleIDArray;
@property (strong, nonatomic) NSMutableArray *dataLocalIDArray;

//-------add--------
@property (strong, nonatomic) NSMutableArray *dataNewSingleImageArray;
@property (strong, nonatomic) NSMutableArray *dataNewSingleIDArray;

//获取所有数据
- (void)getAllDataWith:(NSString *)ID success:(SuccessBlock)success fail:(FailBlock)fail;
//根据Title获取数据
- (void)getDataWithTitle:(NSString *)title dataArray:(NSArray *)dataArray;
//根据产品ID获取单品列表
- (void)getDataWithPID:(NSString *)pid success:(SuccessBlock)success fail:(FailBlock)fail;
@end
