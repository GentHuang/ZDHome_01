//
//  ZDHProductListViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHProductListViewControllerViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataProListArray;
@property (strong, nonatomic) NSMutableArray *dataListArray;
@property (strong, nonatomic) NSMutableArray *dataProdutArray;
//获取搜索产品列表
- (void)getProductListWithKeyWord:(NSString *)keyword brand:(NSString *)brand type:(NSString *)type space:(NSString *)space style:(NSString *)style success:(SuccessBlock)success fail:(FailBlock)fail;
// 获取顶部搜索列表
- (void) getProductListWithKeyWord:(NSString *)keyword brand:(NSString *)brand type:(NSString *)type space:(NSString *)space style:(NSString *)style order:(NSString *)order success:(SuccessBlock)success fail:(FailBlock)fail;
// 获取左边下拉选择栏第三级的数据
- (void) getProductListWithKeyWord:(NSString *)keyword brand:(NSString *)brand type:(NSString *)type space:(NSString *)space style:(NSString *)style secondtype:(NSString *)secondtype success:(SuccessBlock)success fail:(FailBlock)fail;

//获取左边下拉搜索列表
- (void)getSearchListSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//获取商品分类右边下拉
- (void)getSearchPruductCategorySuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 获取顶部按钮数据
- (void) getProductListWithKeyWord:(NSString *)keyword brand:(NSString *)brand type:(NSString *)type space:(NSString *)space style:(NSString *)style order:(NSString *)order clothid:(NSString *)clothId success:(SuccessBlock)success fail:(FailBlock)fail;
@end
