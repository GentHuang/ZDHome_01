//
//  ZDHHomePageViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/16.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHHomePageViewControllerViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataDIYImageArray;
@property (strong, nonatomic) NSMutableArray *dataDIYIDArray;
// DIY标题名字
@property (strong, nonatomic) NSMutableArray *dataDIYNameArray;
@property (strong, nonatomic) NSMutableArray *dataDesignerImageArray;
@property (strong, nonatomic) NSMutableArray *dataDesignerNameArray;
@property (strong, nonatomic) NSMutableArray *dataDesignerIntroArray;
@property (strong, nonatomic) NSMutableArray *dataHotImageArray;
@property (strong, nonatomic) NSMutableArray *dataHotTitleArray;
@property (strong, nonatomic) NSMutableArray *dataHotIDArray;
@property (strong, nonatomic) NSMutableArray *dataHotDescArray;
@property (strong, nonatomic) NSString *groupID;

//头部滚动视图
@property (strong, nonatomic) NSMutableArray *dataHearScrollImageArray;
@property (strong, nonatomic) NSMutableArray *dataHearScrollUrlArray;

//获取DIY信息
- (void)getDIYDataSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//获取设计师信息
- (void)getDesignerDataSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//根据GroupID获取热门产品
- (void)getHotDataWithGroupID:(NSString *)groupID success:(SuccessBlock)success fail:(FailBlock)fail;

//获取头部滚动视图图片
- (void)getHearScrollImageDataSuccess:(SuccessBlock)success fail:(FailBlock)fail;
@end
