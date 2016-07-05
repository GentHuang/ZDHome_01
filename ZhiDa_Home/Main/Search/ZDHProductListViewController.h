//
//  ZDHProductListViewController.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHParentViewController.h"

@class ZDHTabBarViewController;

@interface ZDHProductListViewController : ZDHParentViewController
@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *style;
@property (strong, nonatomic) NSString *space;
@property (strong, nonatomic) NSString *type;
// 顶部按钮
@property (copy, nonatomic) NSString *order;

// 布详情的名称
@property (strong, nonatomic) NSString *clothTitle;
// 获取商品的三级分类id
@property (strong, nonatomic) NSString *secondType;

// 商品分类
@property (strong, nonatomic) NSMutableArray *productArray;
// 商品筛选
@property (strong, nonatomic) NSMutableArray *goodsArray;
// 商品筛选id
@property (strong, nonatomic) NSMutableArray *selectedIdArray;
// 商品分类id
@property (copy, nonatomic) NSString *selectedClassify;
//
@property (copy, nonatomic) NSString *leftButtonTitle;


@end
