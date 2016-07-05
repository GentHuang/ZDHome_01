//
//  ZDHDIYDetailViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/13.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHDIYDetailViewControllerViewModel : NSObject
@property (strong, nonatomic) NSString *backgroundImageString;
@property (strong, nonatomic) NSString *olddiyproid;
// 默认组合DIY组合
@property (strong, nonatomic) NSMutableArray *dataDiyproArray;

@property (strong, nonatomic) NSMutableArray *dataProTitleArray;
@property (strong, nonatomic) NSMutableArray *dataProImageArray;
@property (strong, nonatomic) NSMutableArray *dataProIDArray;

@property (strong, nonatomic) NSMutableArray *dataTypeIDArray;
@property (strong, nonatomic) NSMutableArray *dataTypeTitleArray;

@property (strong, nonatomic) NSMutableArray *dataChangeArray;
@property (strong, nonatomic) NSMutableArray *dataChangeImageArray;
@property (strong, nonatomic) NSMutableArray *dataChangeTitleArray;
@property (strong, nonatomic) NSMutableArray *dataChangeIDArray;
//对应每一张图片的ID
@property (strong, nonatomic) NSMutableArray *dataEveryImageIDArray;
@property (strong, nonatomic) NSMutableArray *dataUpImageArray;
// 保存默认图片
@property (strong, nonatomic) NSMutableArray *storeImageArray;
@property (copy, nonatomic) NSString *updateImageView;

//获取DIY详细数据
- (void)getDataWithID:(NSString *)ID success:(SuccessBlock)success fail:(FailBlock)fail;
//获取所有产品替换的信息
- (void)getDataWIthTypeIDArray:(NSArray *)idArray ID:(NSString *)ID success:(SuccessBlock)success fail:(FailBlock)fail;
//根据类型获取产品替换信息
- (void)getDataWithProType:(NSString *)protype changeArray:(NSArray *)changeArray;
//根据替换产品的ID，所处分类的Index，组合ID，获取图片
- (void)getDataWithPID:(NSString *)pid typeIndex:(NSInteger)typeIndex olddiyproid:(NSString *)olddiyproid success:(SuccessBlock)success fail:(FailBlock)fail;
@end
