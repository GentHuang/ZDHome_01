//
//  ZDHProductCenterOtherViewControllerMyTestViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 16/1/27.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHProductCenterOtherViewControllerAddNewViewModel : NSObject

//存储所有头标题的数组
@property (nonatomic, strong) NSMutableArray *dataTitleModelArray;
@property (nonatomic, strong) NSMutableArray *dataTitileArray;
//存储对应title的滚动视图
@property (nonatomic, strong) NSMutableArray *dataScrollModelArray;
//网络获取的图片
@property (nonatomic, strong) NSMutableArray *dataScrollImageArray;
//本地滚动视图
@property (nonatomic, strong) NSMutableArray *dataScrollLocalImageArray;
//右边滚动小视图
@property (nonatomic, strong) NSMutableArray *dataSingleImageArray;
//右边滚动小视图ID
@property (nonatomic, strong) NSMutableArray *dataSingleLocalIDaray;
//本地的图片的ID
@property (nonatomic, strong) NSMutableArray *dataLocalIDArray;
//产品介绍
@property (nonatomic, strong) NSMutableArray *dataProductIntroArray;
//存储每个滚动视图图片的小滚动视图
@property (nonatomic, strong) NSMutableArray *dataSmallScollModelArray;

//获取当页面所有的信息
- (void)getAllTitleDataWith:(NSString *)ID success:(SuccessBlock)success fail:(FailBlock)fail;

//根据title名字拿到对应的底部滚动视图
- (void)getBottomScrollImageWithTitleSelectedIndex:(int)selected success:(SuccessBlock)success fail:(FailBlock)fail;

//根据点击底部滚动视图的位置 只 获取右上角滚动小图
- (void)getSingleRightViewWithScrollSelectedIndex:(int)selected success:(SuccessBlock)success fail:(FailBlock)fail;

#pragma mark  获取本地的图片
- (void)getLocalDataWithTitle:(NSString *)titleName;
//根据产品ID获取单品列表
- (void)getLocalDataWithPID:(NSString *)pid;

@end
