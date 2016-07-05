//
//  ZDHProductCenterZhiDaViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHProductCenterZhiDaViewControllerViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataYearListArray;

@property (strong, nonatomic) NSMutableArray *dataTypeIdArray;
@property (strong, nonatomic) NSMutableArray *dataTypeTextArray;

@property (strong, nonatomic) NSMutableArray *dataThemeImageArray;
@property (strong, nonatomic) NSMutableArray *dataThemeIDArray;
@property (strong, nonatomic) NSMutableArray *dataThemeTitleArray;
//获取顶部年份
- (void)getYearListSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//根据年份获取图片数据
- (void)getDataWithYear:(NSString *)year success:(SuccessBlock)success fail:(FailBlock)fail;
@end
