//
//  ZDHSearchViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHSearchViewControllerViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataListArray;
@property (strong, nonatomic) NSMutableArray *dataHotArray;
//------商品分类
@property (strong, nonatomic) NSMutableArray *dataProdutArray;
@property (strong, nonatomic) NSString *dataProdutIDString;
//获取搜索列表
- (void)getSearchListSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//获取热门搜索
- (void)getHotWordSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//获取商品分类
- (void)getSearchPruductCategorySuccess:(SuccessBlock)success fail:(FailBlock)fail;
//根据商品分类返回商品分类ID
- (void)transfromProductTypeWithTypeString:(NSString *)typeString;
@end
